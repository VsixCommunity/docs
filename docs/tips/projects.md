---
title: Working with projects
description: Tips for working with projects.
date: 2021-6-15
---

Here's a collection of small code samples on different ways to work with projects.

## [Get project from contained file](#get-project-from-file)
This is how to get the project from one if its files.

```csharp
string fileName = "c:\\file\\in\\project.txt";
SolutionItem item = await SolutionItem.FromFileAsync(fileName);
SolutionItem project = Item?.FindParent(NodeType.Project);
```

## [Add files to project](#add-files-to-project)
Here's how to add files from disk to the project.

```csharp
SolutionItem project = VS.Solution.GetActiveProjectAsync()

string file1 = "c:\\file\\in\\project\\1.txt";
string file2 = "c:\\file\\in\\project\\2.txt";
string file3 = "c:\\file\\in\\project\\3.txt";

await project.AddItemsAsync(file1, file2, file3);
```

## [Find type of project](#find-type-of-project)
Find out what type of project you're dealing with.

```csharp
bool isCsharp = await project.IsKindAsync(ProjectTypes.CSHARP);
```
