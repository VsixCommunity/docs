---
title: Working with the debugger
description: Tips for checking debug state and reacting to debugger events.
date: 2024-12-15
---

Here's a collection of small code samples on different ways to work with the debugger.

## [Check if debugging](#check-if-debugging)
Quickly determine whether the debugger is currently attached.

```csharp
bool isDebugging = await VS.Debugger.IsDebuggingAsync();
```

## [Get the debug mode](#get-the-debug-mode)
Get the specific mode the debugger is in â€” not debugging, at a breakpoint, or running.

```csharp
var mode = await VS.Debugger.GetDebugModeAsync();

switch (mode)
{
    case Community.VisualStudio.Toolkit.Debugger.DebugMode.NotDebugging:
        // Design mode â€” no debugger attached
        break;
    case Community.VisualStudio.Toolkit.Debugger.DebugMode.AtBreakpoint:
        // Stopped at a breakpoint
        break;
    case Community.VisualStudio.Toolkit.Debugger.DebugMode.Running:
        // Debugger is attached and running
        break;
}
```

## [Listen for debug mode changes](#listen-for-debug-mode-changes)
React when the debugger starts, stops, or hits a breakpoint.

```csharp
VS.Events.DebuggerEvents.EnterRunMode += () =>
{
    // Debugging started or resumed
};

VS.Events.DebuggerEvents.EnterBreakMode += () =>
{
    // Hit a breakpoint
};

VS.Events.DebuggerEvents.EnterDesignMode += () =>
{
    // Debugging stopped
};
```

See the [Working with events](events.html) page for all available event types.
