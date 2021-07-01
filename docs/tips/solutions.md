---
title: Working with solutions
description: Tips for working with solutions.
date: 2021-6-30
---

Here's a collection of small code samples on different ways to work with solutions.

## [Solution events](#solution-events)
Listen to any solution event.

```csharp
VS.Events.SolutionEvents.OnAfterOpenProject += OnAfterOpenProject;

...

private void OnAfterOpenProject(object sender, OpenProjectEventArgs e)
{
    // Handle the event
}
```

## [Is a solution open?](#is-a-solution-open)
Check if a solution is currently open or opening.

```csharp

bool isOpen = await VS.Solution.IsOpenAsync();
bool isOpening = await VS.Solution.IsOpeningAsync();
```

## [Get all projects in solution](#get-all-projects-in-solution)
Get a list of all projects in the solution.

```csharp
var projects = await VS.Solution.GetAllProjectsAsync();
```
