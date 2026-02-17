---
title: Working with events
description: Tips for working with events using the VS.Events helpers.
date: 2021-6-30
---

The Community Toolkit exposes all common Visual Studio events through `VS.Events`. Simply subscribe to any event with a single line - no COM interfaces or advise cookies needed.

## [Solution events](#solution-events)
React to solutions and projects being opened, closed, loaded, or renamed.

```csharp
VS.Events.SolutionEvents.OnAfterOpenSolution += solution =>
{
    // A solution was opened
};

VS.Events.SolutionEvents.OnAfterOpenProject += project =>
{
    // A project was loaded
};

VS.Events.SolutionEvents.OnBeforeCloseProject += project =>
{
    // A project is about to close
};

VS.Events.SolutionEvents.OnAfterBackgroundSolutionLoadComplete += () =>
{
    // All projects have finished loading (including background-loaded ones)
};
```

**Available events:** `OnBeforeOpenSolution`, `OnAfterOpenSolution`, `OnBeforeCloseSolution`, `OnAfterCloseSolution`, `OnAfterOpenProject`, `OnBeforeCloseProject`, `OnAfterLoadProject`, `OnBeforeUnloadProject`, `OnAfterRenameProject`, `OnAfterOpenFolder`, `OnBeforeCloseFolder`, `OnAfterCloseFolder`, `OnAfterMergeSolution`, `OnAfterBackgroundSolutionLoadComplete`

## [Build events](#build-events)
Listen for solution and individual project build/clean lifecycle events.

```csharp
VS.Events.BuildEvents.SolutionBuildStarted += (sender, args) =>
{
    // The solution build just kicked off
};

VS.Events.BuildEvents.ProjectBuildDone += args =>
{
    if (args.IsSuccessful)
    {
        // Project built successfully
    }
};

VS.Events.BuildEvents.SolutionBuildDone += succeeded =>
{
    // The entire solution build finished. succeeded = true/false
};
```

**Available events:** `SolutionBuildStarted`, `SolutionBuildDone`, `SolutionBuildCancelled`, `ProjectBuildStarted`, `ProjectBuildDone`, `ProjectCleanStarted`, `ProjectCleanDone`, `ProjectConfigurationChanged`, `SolutionConfigurationChanged`

## [Document events](#document-events)
Track documents being opened, saved, and closed without implementing any COM interfaces. The toolkit wraps `IVsRunningDocTableEvents` for you and handles the deduplication of events so they only fire once per action.

```csharp
VS.Events.DocumentEvents.Opened += filePath =>
{
    // A document was opened in the editor.
    // filePath is the full path of the document that was opened.
};

VS.Events.DocumentEvents.Closed += filePath =>
{
    // A document was closed.
    // filePath is the full path of the document that was closed.
};

VS.Events.DocumentEvents.Saved += filePath =>
{
    // A document was saved to disk.
};

VS.Events.DocumentEvents.BeforeDocumentWindowShow += docView =>
{
    // A document window is about to be shown.
    // Use docView.Document?.FilePath to get the file path.
};

VS.Events.DocumentEvents.AfterDocumentWindowHide += docView =>
{
    // A document window was hidden (e.g. another tab took focus).
};
```

> **Note:** The `Opened` and `Closed` events may also fire for project files, solution files, and special internal documents — not just files visible in the editor. If you only care about text editor files, check the file path or extension in your handler.

**Available events:** `Saved`, `Opened`, `Closed`, `BeforeDocumentWindowShow`, `AfterDocumentWindowHide`

## [Window events](#window-events)
Monitor window frame creation, destruction, visibility, and focus changes.

```csharp
VS.Events.WindowEvents.Created += frame =>
{
    // A new window frame was created
};

VS.Events.WindowEvents.ActiveFrameChanged += args =>
{
    // The active window changed from args.OldFrame to args.NewFrame
};

VS.Events.WindowEvents.FrameIsVisibleChanged += args =>
{
    // A frame's visibility changed: args.IsNewVisible
};
```

**Available events:** `Created`, `Destroyed`, `FrameIsVisibleChanged`, `FrameIsOnScreenChanged`, `ActiveFrameChanged`

## [Debugger events](#debugger-events)
React to the debugger starting, stopping, or hitting breakpoints.

```csharp
VS.Events.DebuggerEvents.EnterRunMode += () =>
{
    // Debugging started (or resumed from a breakpoint)
};

VS.Events.DebuggerEvents.EnterBreakMode += () =>
{
    // The debugger hit a breakpoint
};

VS.Events.DebuggerEvents.EnterDesignMode += () =>
{
    // Debugging stopped - back to design mode
};
```

**Available events:** `EnterRunMode`, `EnterBreakMode`, `EnterDesignMode`, `EnterEditAndContinueMode`

## [Selection events](#selection-events)
Know when the user selects a different item in Solution Explorer or changes UI context.

```csharp
VS.Events.SelectionEvents.SelectionChanged += (sender, args) =>
{
    SolutionItem from = args.From;
    SolutionItem to = args.To;
    // The selection changed from one item to another
};

VS.Events.SelectionEvents.UIContextChanged += (sender, args) =>
{
    bool isActive = args.IsActive;
    // A UI context was activated or deactivated
};
```

**Available events:** `SelectionChanged`, `UIContextChanged`

## [Project item events](#project-item-events)
Track files and folders being added, removed, or renamed within projects.

```csharp
VS.Events.ProjectItemsEvents.AfterAddProjectItems += items =>
{
    foreach (SolutionItem item in items)
    {
        // A file or folder was added to a project
    }
};

VS.Events.ProjectItemsEvents.AfterRemoveProjectItems += args =>
{
    // Files or folders were removed
};

VS.Events.ProjectItemsEvents.AfterRenameProjectItems += args =>
{
    // Files or folders were renamed
};
```

**Available events:** `AfterAddProjectItems`, `AfterRemoveProjectItems`, `AfterRenameProjectItems`

## [Shell events](#shell-events)
Listen for Visual Studio lifecycle and environment changes.

```csharp
VS.Events.ShellEvents.ShellAvailable += () =>
{
    // VS has finished initializing and is ready for interaction
};

VS.Events.ShellEvents.ShutdownStarted += () =>
{
    // VS is beginning to shut down
};

VS.Events.ShellEvents.EnvironmentColorChanged += () =>
{
    // The user changed the VS color theme
};
```

**Available events:** `ShellAvailable`, `ShutdownStarted`, `MainWindowVisibilityChanged`, `EnvironmentColorChanged`

## [Subscribing to events](#subscribing-to-events)
The best place to subscribe to events is in the `InitializeAsync` method of your package class.

```csharp
[PackageRegistration(UseManagedResourcesOnly = true, AllowsBackgroundLoading = true)]
[Guid(PackageGuids.MyPackageString)]
public sealed class MyPackage : ToolkitPackage
{
    protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
    {
        await JoinableTaskFactory.SwitchToMainThreadAsync(cancellationToken);

        VS.Events.DocumentEvents.Opened += OnDocumentOpened;
        VS.Events.DocumentEvents.Closed += OnDocumentClosed;
        VS.Events.DocumentEvents.Saved += OnDocumentSaved;
        VS.Events.SolutionEvents.OnAfterOpenSolution += OnSolutionOpened;
    }

    private void OnDocumentOpened(string filePath)
    {
        // Handle the document being opened
    }

    private void OnDocumentClosed(string filePath)
    {
        // Handle the document being closed
    }

    private void OnDocumentSaved(string filePath)
    {
        // Handle the document being saved
    }

    private void OnSolutionOpened(Solution solution)
    {
        // Handle the solution being opened
    }
}
```
