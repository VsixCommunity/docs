---
title: Working with builds
description: Tips for working with builds.
date: 2021-6-15
---

Here's a collection of small code samples on different ways to work with builds.

## [Build solution](#build-solution)
To build the entire solution, call the `BuildAsync()` method.

```csharp
bool buildStarted = await VS.Build.BuildSolutionAsync(BuildAction.Build);
```

## [Build project](#build-project)
You can build any project by passing it to the method.

```csharp
SolutionItem project = await VS.Solution.GetActiveProjectAsync();
await VS.Build.BuildProjectAsync(project, BuildAction.Rebuild);
```

## [Set build property](#set-build-property)
Shows how to set a build property on the project.

```csharp
SolutionItem project = await VS.Solution.GetActiveProjectAsync();
bool succeeded = await project.TrySetAttributeAsync("propertyName", "value");
```

## [Get build property](#get-build-property)
Shows how to get a build property of any project or project item.

```csharp
SolutionItem item = await VS.Solution.GetActiveSolutionItemAsync();
string value = await item.GetAttributeAsync("propertyName");
```
