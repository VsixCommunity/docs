---
title: Working with selection
description: Tips for working with the current selection and UI contexts.
date: 2024-12-15
---

Here's a collection of small code samples on different ways to work with selection and UI contexts.

## [Set a UI context](#set-a-ui-context)
UI contexts control the visibility and enabled state of commands and tool windows. You can activate or deactivate a custom UI context from code.

```csharp
// Activate a UI context by its GUID
await VS.Selection.SetUIContextAsync("your-guid-here", true);

// Deactivate it
await VS.Selection.SetUIContextAsync("your-guid-here", false);
```

## [Listen for selection changes](#listen-for-selection-changes)
React when the user selects a different item in Solution Explorer or other tool windows.

```csharp
VS.Events.SelectionEvents.SelectionChanged += (sender, args) =>
{
    SolutionItem? from = args.From;
    SolutionItem? to = args.To;

    if (to != null)
    {
        // The user selected a new item
    }
};
```

## [Listen for UI context changes](#listen-for-ui-context-changes)
Know when a UI context is activated or deactivated (e.g. when a solution opens or a specific editor gains focus).

```csharp
VS.Events.SelectionEvents.UIContextChanged += (sender, args) =>
{
    bool isActive = args.IsActive;
    // A UI context changed its active state
};
```

See the [Working with events](events.html) page for all available event types.
