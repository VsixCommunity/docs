---
title: Working with files
description: Tips for working with files.
date: 2021-6-15
---

## [Get active document](#get-active-document)
Get the current active document to manipulate the text or take other related actions.

```csharp
var doc = await VS.Editor.GetActiveTextDocumentAsync();
doc.Selection.Insert("some text"); // Inserts text at the caret or selection
```

For more advanced capabilities, grab the TextView and its TextBuffer like this:

```csharp
var view = await VS.Editor.GetCurrentWpfTextViewAsync();
var buffer = view.TextBuffer;
buffer.Insert(0, "some text"); // Inserts text at position 0
```

## [File icon associations](#file-icon-associations)
To associate an icon with a file extension in Solution Explorer, add the `[ProvideFileIcon()]` attribute to your package class.

```csharp
[ProvideFileIcon(".abc", "KnownMonikers.Reference")]
public sealed class MyPackage : ToolkitPackage
{
    ...
}
```

See the thousands of available icons in the `KnownMonikers` collection using the KnownMonikers Explorer tool window. Find it under **View -> Other Windows** in the main menu.

## [Open file](#open-file)
Use the `Microsoft.VisualStudio.Shell.VsShellUtilities` helper class.

```csharp
string filePath = "c:\\file.txt";
VsShellUtilities.OpenDocument(ServiceProvider.GlobalProvider, filePath);
```

## [Open file in Preview tab](#open-file-in-preview-tab)
The Preview tab, also known as the Provisional tab, is a temporary tab that opens on the right side of the document well. Open any file in the Preview tab like this:

```csharp
string fileName = "c:\\file.txt";
VS.Shell.OpenInPreviewTab(fileName);
```

## [Get file name from ITextBuffer](#get-file-name-from-textbuffer)
Use the extension method `buffer.GetFileName()` located in the `Microsoft.VisualStudio.Text` namespace.

```csharp
string fileName = buffer.GetFileName();
```
