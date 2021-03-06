---
title: Working with solutions
description: Tips for working with solutions.
date: 2021-8-13
---

Here's a collection of small code samples on different ways to work with solutions.

## [Solution events](#solution-events)
Listen to any solution event.

```csharp
VS.Events.SolutionEvents.OnAfterOpenProject += OnAfterOpenProject;

...

private void OnAfterOpenProject(Project obj)
{
    // Handle the event
}
```

## [Is a solution open?](#is-a-solution-open)
Check if a solution is currently open or opening.

```csharp

bool isOpen = await VS.Solutions.IsOpenAsync();
bool isOpening = await VS.Solutions.IsOpeningAsync();
```

## [Get all projects in solution](#get-all-projects-in-solution)
Get a list of all projects in the solution.

```csharp
var projects = await VS.Solutions.GetAllProjectsAsync();
```
