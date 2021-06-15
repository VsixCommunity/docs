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
DTE2 dte = await VS.GetDTEAsync();
Project Project = dte.Solution?.FindProjectItem(fileName)?.ContainingProject;
```

## [Add files to project](#add-files-to-project)
Here's how to add files from disk to the `Project`.

```csharp
DTE2 dte = await VS.GetDTEAsync();
Project Project = dte.Solution?.FindProjectItem(fileName)?.ContainingProject;

if (project != null)
{
    string file1 = "c:\\file\\in\\project\\1.txt";
    string file2 = "c:\\file\\in\\project\\2.txt";
    string file3 = "c:\\file\\in\\project\\3.txt";
    await project.AddFilesToProjectAsync(file1, file2, file3);
}
```

## [Find type of project](#find-type-of-project)
Find out what type of `Project` you're dealing with.

```csharp
bool isCsharp = project.IsKind(ProjectTypes.CSHARP);
```
