---
title: Working with projects
description: Tips for working with projects.
date: 2021-8-13
---

Here's a collection of small code samples on different ways to work with projects.

## [Get project from contained file](#get-project-from-file)
This is how to get the project from one if its files.

```csharp
 string fileName = "c:\\file\\in\\project.txt";
 File item = await File.FromFileAsync(fileName);
 Project project = item.ContainingProject;
```

## [Add files to project](#add-files-to-project)
Here's how to add files from disk to the project.

```csharp
Project project = await VS.Solutions.GetActiveProjectAsync();

var file1 = "c:\\file\\in\\project\\1.txt";
var file2 = "c:\\file\\in\\project\\2.txt";
var file3 = "c:\\file\\in\\project\\3.txt";

await project.AddExistingFilesAsync(file1, file2, file3);
```

## [Find type of project](#find-type-of-project)
Find out what type of project you're dealing with.

```csharp
bool isCsharp = await project.IsKindAsync(ProjectTypes.CSHARP);
```
