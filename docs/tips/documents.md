---
title: Working with documents
description: Tips for opening, reading, editing, and monitoring text documents.
date: 2025-07-17
---

Here's a collection of code samples for working with text documents using the toolkit's `VS.Documents` API and the `DocumentView` class.

## [Open a document](#open-a-document)

Open a file in the editor and get a `DocumentView` back:

```csharp
DocumentView docView = await VS.Documents.OpenAsync(@"C:\src\MyFile.cs");
```

Open a file that belongs to a solution project (ensures correct project context):

```csharp
DocumentView docView = await VS.Documents.OpenViaProjectAsync(@"C:\src\MyFile.cs");
```

Open a file in the Preview Tab (provisional tab):

```csharp
DocumentView docView = await VS.Documents.OpenInPreviewTabAsync(@"C:\src\MyFile.cs");
```

## [Check if a file is open](#check-if-a-file-is-open)

```csharp
bool isOpen = await VS.Documents.IsOpenAsync(@"C:\src\MyFile.cs");
```

## [Get the active document](#get-the-active-document)

Get the `DocumentView` for the currently focused text editor:

```csharp
DocumentView docView = await VS.Documents.GetActiveDocumentViewAsync();
if (docView?.TextView == null) return; // not a text window
```

## [Get a document view for a specific file](#get-a-document-view-for-a-specific-file)

If a file is already open, retrieve its `DocumentView` without activating it:

```csharp
DocumentView docView = await VS.Documents.GetDocumentViewAsync(@"C:\src\MyFile.cs");
```

## [The DocumentView class](#the-documentview-class)

`DocumentView` is the toolkit's unified object for a text document in the editor. It provides:

| Property | Description |
|----------|-------------|
| `FilePath` | The absolute file path of the document |
| `TextView` | The `IWpfTextView` for the editor surface |
| `TextBuffer` | The `ITextBuffer` holding the document's text |
| `Document` | The `ITextDocument` (provides dirty tracking, encoding, etc.) |
| `WindowFrame` | The `WindowFrame` hosting the document |

## [Read text from a document](#read-text-from-a-document)

Use the `TextBuffer` to access all text or specific lines:

```csharp
DocumentView docView = await VS.Documents.GetActiveDocumentViewAsync();
if (docView?.TextBuffer == null) return;

// Get all text
string allText = docView.TextBuffer.CurrentSnapshot.GetText();

// Get a specific line
ITextSnapshotLine line = docView.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(0);
string firstLine = line.GetText();
```

## [Insert text at the caret](#insert-text-at-the-caret)

```csharp
DocumentView docView = await VS.Documents.GetActiveDocumentViewAsync();
if (docView?.TextView == null) return;

SnapshotPoint position = docView.TextView.Caret.Position.BufferPosition;
docView.TextBuffer?.Insert(position, "inserted text");
```

## [Replace text in a document](#replace-text-in-a-document)

Use an edit session on the text buffer for reliable replacements:

```csharp
DocumentView docView = await VS.Documents.GetActiveDocumentViewAsync();
if (docView?.TextBuffer == null) return;

using (ITextEdit edit = docView.TextBuffer.CreateEdit())
{
    ITextSnapshot snapshot = edit.Snapshot;

    // Replace first 10 characters
    edit.Replace(new Span(0, 10), "new text");

    // Delete a range
    edit.Delete(new Span(50, 5));

    edit.Apply();
}
```

## [Get the caret position and selection](#get-the-caret-position-and-selection)

```csharp
DocumentView docView = await VS.Documents.GetActiveDocumentViewAsync();
if (docView?.TextView == null) return;

// Caret position
SnapshotPoint caretPosition = docView.TextView.Caret.Position.BufferPosition;
int line = caretPosition.GetContainingLine().LineNumber;
int column = caretPosition.Position - caretPosition.GetContainingLine().Start.Position;

// Selected text
string selectedText = docView.TextView.Selection.StreamSelectionSpan
    .GetText();
```

## [Listen for document events](#listen-for-document-events)

The toolkit exposes document lifecycle events through `VS.Events.DocumentEvents`:

```csharp
VS.Events.DocumentEvents.Saved += OnDocumentSaved;
VS.Events.DocumentEvents.Opened += OnDocumentOpened;
VS.Events.DocumentEvents.Closed += OnDocumentClosed;
VS.Events.DocumentEvents.BeforeDocumentWindowShow += OnBeforeShow;
VS.Events.DocumentEvents.AfterDocumentWindowHide += OnAfterHide;

private void OnDocumentSaved(string filePath)
{
    // Called after a file is saved to disk
}

private void OnDocumentOpened(string filePath)
{
    // Called when a document is first opened for editing
}

private void OnDocumentClosed(string filePath)
{
    // Called when the last lock on a document is released
}

private void OnBeforeShow(DocumentView docView)
{
    // Called the first time a document window is shown
}

private void OnAfterHide(DocumentView docView)
{
    // Called after a document window is hidden
}
```

## [Additional resources](#additional-resources)

* [Working with files](files.html) - file icons, opening files, and Preview Tab tips
* [Working with events](events.html) - all event types available in the toolkit
