---
title: Error List integration
description: A recipe for how to add custom errors and warnings to the Visual Studio Error List.
date: 2024-12-15
---

The Error List is one of Visual Studio's most prominent tool windows. Extensions can push custom errors, warnings, and messages into it using the toolkit's `TableDataSource` and `ErrorListItem` classes â€” no raw `ITableDataSource` or `ITableEntry` implementation needed.

## [Create a TableDataSource](#create-a-tabledatasource)
The `TableDataSource` is the bridge between your extension and the Error List. Create one and give it a unique name (typically your extension name).

```csharp
TableDataSource _errorList = new TableDataSource("MyExtension");
```

You only need one instance per extension. It's common to create it once in your package or a singleton helper class.

## [Add errors to the Error List](#add-errors-to-the-error-list)
Create `ErrorListItem` objects and pass them to `AddErrors`. Each item needs at least a `FileName` and a `Message`.

```csharp
var errors = new List<ErrorListItem>
{
    new ErrorListItem
    {
        ProjectName = "MyProject",
        FileName = @"C:\repos\MyProject\Program.cs",
        Line = 10,
        Column = 5,
        Message = "Missing semicolon",
        ErrorCode = "EXT001",
        Severity = __VSERRORCATEGORY.EC_ERROR,
        BuildTool = "MyExtension"
    },
    new ErrorListItem
    {
        ProjectName = "MyProject",
        FileName = @"C:\repos\MyProject\Program.cs",
        Line = 25,
        Message = "Unused variable 'x'",
        ErrorCode = "EXT002",
        Severity = __VSERRORCATEGORY.EC_WARNING,
        BuildTool = "MyExtension"
    }
};

_errorList.AddErrors(errors);
```

The `Severity` property controls the icon and how the item shows up when filtering the Error List:

- `__VSERRORCATEGORY.EC_ERROR` â€” Error (red)
- `__VSERRORCATEGORY.EC_WARNING` â€” Warning (yellow)
- `__VSERRORCATEGORY.EC_MESSAGE` â€” Message (blue)

> **Tip:** Setting the `Line` and `Column` properties makes the entry clickable â€” double-clicking navigates to that location in the editor.

## [Clear errors](#clear-errors)
Remove all previously added errors when they are no longer relevant (for example, after a successful re-validation).

```csharp
_errorList.CleanAllErrors();
```

## [Putting it all together](#putting-it-all-together)
Here's a typical pattern where errors are refreshed every time a document is saved:

```csharp
[Command(PackageIds.ValidateCommand)]
internal sealed class ValidateCommand : BaseCommand<ValidateCommand>
{
    private static readonly TableDataSource _errorList = new("MyExtension");

    protected override async Task InitializeCompletedAsync()
    {
        VS.Events.DocumentEvents.Saved += OnDocumentSaved;
    }

    private void OnDocumentSaved(string filePath)
    {
        _errorList.CleanAllErrors();

        IEnumerable<ErrorListItem> errors = ValidateFile(filePath);
        _errorList.AddErrors(errors);
    }

    private static IEnumerable<ErrorListItem> ValidateFile(string filePath)
    {
        // Your validation logic here
        yield break;
    }

    protected override Task ExecuteAsync(OleMenuCmdEventArgs e)
    {
        return Task.CompletedTask;
    }
}
```

## [ErrorListItem properties](#errorlistitem-properties)

**ProjectName** (string) â€” Project name shown in the Error List.

**FileName** (string) â€” Full path to the file. Required for clickable navigation.

**Line** (int) â€” 0-based line number.

**Column** (int) â€” 0-based column number.

**Message** (string) â€” The error/warning message text.

**ErrorCode** (string) â€” Short error code (e.g. "EXT001").

**ErrorCodeToolTip** (string) â€” Tooltip shown when hovering the error code.

**ErrorCategory** (string) â€” Category string.

**Severity** (__VSERRORCATEGORY) â€” Error, Warning, or Message.

**HelpLink** (string) â€” URL for the help link.

**BuildTool** (string) â€” Name of the tool that generated the error.

**Icon** (ImageMoniker) â€” Custom icon moniker.
