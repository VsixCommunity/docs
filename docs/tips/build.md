---
title: Working with builds
description: Tips for working with builds.
date: 2021-8-12
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
Project project = await VS.Solutions.GetActiveProjectAsync();
await project.BuildAsync(BuildAction.Rebuild);
```

## [Pack project](#pack-project)
SDK style .NET projects can be packed by executiong Visual Studio's built in command. See [#318](https://github.com/VsixCommunity/Community.VisualStudio.Toolkit/issues/318).
```csharp
await Package.JoinableTaskFactory.SwitchToMainThreadAsync(Package.DisposalToken);
await VS.Commands.ExecuteAsync("Build.Packselection");
```

## [Set build property](#set-build-property)
Shows how to set a build property on the project.

```csharp
Project project = await VS.Solutions.GetActiveProjectAsync();
bool succeeded = await project.TrySetAttributeAsync("propertyName", "value");
```

## [Get build property](#get-build-property)
Shows how to get a build property of any project or project item.

```csharp
Project item = await VS.Solutions.GetActiveProjectAsync();
string value = await item.GetAttributeAsync("propertyName");
```
