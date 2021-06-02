---
title: Useful resources
date: 2021-5-24
---

These resources can help you better navigate the world of Visual Studio extensibility.

## [Links](#links)
Here are some useful links to resources that can help you in your extension journey.

* [VSIX Community on GitHub](https://github.com/VsixCommunity)
* [VSIX Community Samples repo](https://github.com/VsixCommunity/Samples)
* [Official VS SDK documentation](https://docs.microsoft.com/visualstudio/extensibility/)
* [VS SDK Samples repo](https://github.com/Microsoft/VSSDK-Extensibility-Samples)
* [Extensibility chatroom on Gitter.im](https://gitter.im/Microsoft/extendvs)

## [Know how to search for help](#know-how-to-search-for-help)
Writing extensions is a bit of a niche activity so searching for help online doesn’t always return relevant results. However, there are ways we can optimize our search terms to generate better results.

Use the precise interface and class names as part of the search term
Try adding the words *VSIX*, *VSSDK* or *Visual Studio* to the search terms
Search directly on GitHub instead of Google/Bing when possible
Ask questions to other extenders on the [Gitter.im](https://gitter.im/Microsoft/extendvs) chatroom

## [Use open source as a learning tool](#use-open-source-as-a-learning-tool)
You probably have ideas about what you want your extension to do and how it should work. But what APIs should you use and how do you hook it all up correctly? These are difficult questions and a lot of people give up when these go unanswered.

A good way is to find extensions on the Marketplace that does similar things or uses similar elements as to what you want to do. Then find the source code for that extension and look at what they did and what APIs they used and go from there.

## [Glossary](#glossary)
To better understand this cookbook and being able to search for help online, having a shared vocabulary of extensibility terms is critical. Here's an alphabetical list of concepts and words that are important for extenders to know.

### [DTE](#dte)
*EnvDTE is an assembly-wrapped COM library containing the objects and members for Visual Studio core automation*. Or, an easy-to-use interface for interacting with Visual Studio.

### [Marketplace](#marketplace)
The [Visual Studio Marketplace](https://marketplace.visualstudio.com) is the public extension store used by extenders to share their extensions with the world. It's owned and maintained by Microsoft and is the only official extension marketplace.

### [MEF](#mef)
The Managed Extensibility Framework is used by several components inside Visual Studio - predominantly the editor. It's a different way to register extension points than a *Package*.

### [Package](#package)
Sometimes referred to as *Package class*. Its `InitializeAsync(...)` method is called by Visual Studio to initialize your extension. It's from here you add event listeners and register commands, tool windows, settings and other things. During compilation, the attributes on the *Package class* are used to generate a .pkgdef file, which is added to the extension automatically.

### [.pkgdef](#pkgdef)
This is a Package containing keys and values to be added to Visual Studio's private registry. You can either generate this file automatically from a Package class, or create the .pkgdef file manually and included it as an `<Asset>` in the .vsixmanifest file.

### [VSCT](#vsct)
The Visual Studio Command Table file. This is where menus, commands, and keybindings are declared.

### [VSIX](#vsix)
Refers to the file extension of a Visual Studio extension (.vsix) and also as a pseudonym for Visual Studio extensibility all up.

### [VSSDK](#vssdk)
This is short for the *Visual Studio SDK* which are the classes, services, and component that make up the public surface are of Visual Studio's extensibility API. It's usually used when referring to the [Microsoft.VisualStudio.SDK](https://www.nuget.org/packages/Microsoft.VisualStudio.SDK/) NuGet package.

### [UI Context](#ui-context)
TBD

### [TextBuffer](#textbuffer)
TBD

### [TextView](#textview)
TBD

Find more information in the [Visual Studio SDK Glossary](https://docs.microsoft.com/en-us/visualstudio/extensibility/visual-studio-sdk-glossary?view=vs-2019).
