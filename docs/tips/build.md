---
title: Working with builds
description: Tips for working with builds.
date: 2021-6-15
---

Here's a collection of small code samples on different ways to work with builds.

## [Build solution](#build-solution)
To build the entire solution, call the `BuildAsync()` method.

```csharp
DTE2 dte = await VS.GetDTEAsync();
bool buildSucceeded = await dte.Solution?.BuildAsync();
```

## [Build project](#build-project)
If you're not in an async context, use the synchronous way to build the project.

```csharp
using EnvDTE;

...

vsBuildState state = project.Build(waitForBuildToFinish = true);
```

## [Build project async](#build-project-async)
For async contexts, this is an easy way to build the project.

```csharp
using EnvDTE;

...

bool buildSucceeded = await project.BuildAsync();
```

## [Set build property](#set-build-property)
Shows how to set a build property on the `Project`.

```csharp
using EnvDTE;

...

bool succeeded = await project.TrySetBuildPropertyAsync("propertyName", "value");
```

## [Get build property](#get-build-property)
Shows how to get a build property on the `Project`.

```csharp
using EnvDTE;

...

string? value = await project.GetBuildPropertyAsync("propertyName");
```
