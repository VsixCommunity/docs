---
title: Working with windows
description: Tips for finding, showing, and manipulating tool and document windows.
date: 2025-07-17
---

Here's a collection of code samples for working with Visual Studio tool windows and document windows.

## [Get the active window](#get-active-window)

Get the currently focused window frame:

```csharp
WindowFrame frame = await VS.Windows.GetCurrentWindowAsync();
if (frame != null)
{
    string caption = frame.Caption;
}
```

## [Find a document window](#find-document-window)

Find the window frame for a specific open file:

```csharp
WindowFrame frame = await VS.Windows.FindDocumentWindowAsync(@"C:\src\MyFile.cs");
if (frame != null)
{
    frame.Show();
}
```

Returns `null` if the file is not currently open.

## [Find a tool window by GUID](#find-tool-window)

Find an existing tool window using a GUID from the `WindowGuids` class:

```csharp
Guid errorListGuid = Guid.Parse(WindowGuids.ErrorList);
WindowFrame frame = await VS.Windows.FindWindowAsync(errorListGuid);
```

## [Show a tool window](#show-tool-window)

Show a built-in tool window by GUID. If it doesn't exist yet, it will be created:

```csharp
Guid outputGuid = Guid.Parse(WindowGuids.OutputWindow);
WindowFrame frame = await VS.Windows.ShowToolWindowAsync(outputGuid);
```

Or use `FindOrShowToolWindowAsync` to find an existing window or create and show it if needed:

```csharp
Guid solExpGuid = Guid.Parse(WindowGuids.SolutionExplorer);
WindowFrame frame = await VS.Windows.FindOrShowToolWindowAsync(solExpGuid);
```

## [Common tool window GUIDs](#common-guids)

The `WindowGuids` class provides GUIDs for well-known Visual Studio windows:

| Window | GUID constant |
|--------|--------------|
| Solution Explorer | `WindowGuids.SolutionExplorer` |
| Error List | `WindowGuids.ErrorList` |
| Output Window | `WindowGuids.OutputWindow` |
| Properties | `WindowGuids.PropertiesWindow` |
| Task List | `WindowGuids.TaskList` |

Explore all available constants in `Community.VisualStudio.Toolkit.WindowGuids`.

## [Enumerate all open windows](#enumerate-windows)

Get all open tool windows, document windows, or both:

```csharp
// All tool windows
IEnumerable<WindowFrame> tools = await VS.Windows.GetAllToolWindowsAsync();

// All document windows
IEnumerable<WindowFrame> documents = await VS.Windows.GetAllDocumentWindowsAsync();

// Both
IEnumerable<WindowFrame> all = await VS.Windows.GetAllWindowsAsync();

foreach (WindowFrame frame in all)
{
    string caption = frame.Caption;
}
```

## [Working with the Output Window](#output-window)

Create a custom Output Window pane and write to it:

```csharp
OutputWindowPane pane = await VS.Windows.CreateOutputWindowPaneAsync("My Extension");
await pane.WriteLineAsync("Extension initialized successfully.");
```

Get one of the built-in panes:

```csharp
OutputWindowPane generalPane = await VS.Windows.GetOutputWindowPaneAsync(
    Windows.VSOutputWindowPane.General);
await generalPane.WriteLineAsync("Hello from the General pane.");
```

## [Show a WPF dialog](#show-dialog)

Display a WPF `Window` as a VS-parented modal dialog:

```csharp
var dialog = new MyWpfDialog();
await VS.Windows.ShowDialogAsync(dialog, WindowStartupLocation.CenterOwner);
```

## [Get the Solution Explorer window](#solution-explorer)

The toolkit provides a typed wrapper for the Solution Explorer:

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();
```

See the [Solution Explorer recipe](../recipes/solution-explorer.html) for more operations.

## [Additional resources](#additional-resources)

* [Custom tool windows recipe](../recipes/custom-tool-windows.html) — create your own dockable tool windows
* [Notifications recipe](../recipes/notifications.html) — Info Bars, message boxes, and Output Window messages
