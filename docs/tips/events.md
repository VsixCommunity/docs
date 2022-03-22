---
title: Working with events
description: Tips for working with events.
date: 2021-6-30
---

Here's a collection of small code samples on different ways to listen to events.

# [IVsRunningDocTableEvents Interface](#IVsRunningDocTableEvents-Interface)

Implements methods that fire in response to changes to documents in the Running Document Table (RDT).


Microsoft docs: [IVsRunningDocTableEvents Interface](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents?view=visualstudiosdk-2022)

<!--TOC-->
- [IVsRunningDocTableEvents Code Samples](#ivsrunningdoctableevents-code-samples)
  - [OnAfterFirstDocumentLock](#onafterfirstdocumentlock)
  - [OnBeforeLastDocumentUnlock](#onbeforelastdocumentunlock)
  - [OnAfterSave](#onaftersave)
  - [OnAfterAttributeChange](#onafterattributechange)
  - [OnBeforeDocumentWindowShow](#onbeforedocumentwindowshow)
  - [OnAfterDocumentWindowHide](#onafterdocumentwindowhide)
<!--/TOC-->


# IVsRunningDocTableEvents Code Samples

You must have a using statement for:

``` CSharp
using Microsoft.VisualStudio.Shell.Interop;
```

In the class where you want to handle the eventsm you must implament the interface: [IVsRunningDocTableEvents](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents?view=visualstudiosdk-2022)

``` CSharp
internal class Pane : ToolWindowPane, IVsRunningDocTableEvents
{
...
}
```

## OnAfterFirstDocumentLock

[OnAfterFirstDocumentLock](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents.onafterfirstdocumentlock?view=visualstudiosdk-2022) is called after application of the first lock of the specified type to the specified document in the Running Document Table (RDT).

``` CSharp
public:
 int OnAfterFirstDocumentLock(unsigned int docCookie, unsigned int dwRDTLockType, unsigned int dwReadLocksRemaining, unsigned int dwEditLocksRemaining);
 ```

``` CSharp
[MethodImpl(MethodImplOptions.PreserveSig | MethodImplOptions.InternalCall)]
int OnAfterFirstDocumentLock([In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSCOOKIE")] uint docCookie, [In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSRDTFLAGS")] uint dwRDTLockType, [In][ComAliasName("Microsoft.VisualStudio.OLE.Interop.DWORD")] uint dwReadLocksRemaining, [In][ComAliasName("Microsoft.VisualStudio.OLE.Interop.DWORD")] uint dwEditLocksRemaining);
```

 Code Sample from: [Walkthrough-Create-Language-Editor](https://www.vsixcookbook.com/recipes/Walkthrough-Create-Language-Editor.html)

``` CSharp
public int OnAfterFirstDocumentLock(uint docCookie, uint dwRDTLockType, uint dwReadLocksRemaining, uint dwEditLocksRemaining)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        try
        {
            var activeItem = await VS.Solutions.GetActiveItemAsync();
            if (activeItem != null)
            {
                //Your code here.
            }
        }
        catch (Exception)
        {
            //Your exception code here.
        }
    }).FireAndForget();
    return VSConstants.S_OK;
}
```


## OnBeforeLastDocumentUnlock


[OnBeforeLastDocumentUnlock](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents.onbeforelastdocumentunlock?view=visualstudiosdk-2022) is called before releasing the last lock of the specified type on the specified document in the Running Document Table (RDT).

``` CSharp
public:
 int OnBeforeLastDocumentUnlock(unsigned int docCookie, unsigned int dwRDTLockType, unsigned int dwReadLocksRemaining, unsigned int dwEditLocksRemaining);
 ```

 ``` CSharp
[MethodImpl(MethodImplOptions.PreserveSig | MethodImplOptions.InternalCall)]
int OnBeforeLastDocumentUnlock([In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSCOOKIE")] uint docCookie, [In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSRDTFLAGS")] uint dwRDTLockType, [In][ComAliasName("Microsoft.VisualStudio.OLE.Interop.DWORD")] uint dwReadLocksRemaining, [In][ComAliasName("Microsoft.VisualStudio.OLE.Interop.DWORD")] uint dwEditLocksRemaining);
```
Code Sample from: [Walkthrough-Create-Language-Editor](https://www.vsixcookbook.com/recipes/Walkthrough-Create-Language-Editor.html)
``` CSharp
public int OnBeforeLastDocumentUnlock(uint docCookie, uint dwRDTLockType, uint dwReadLocksRemaining, uint dwEditLocksRemaining)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        try
        {
            var activeItem = await VS.Solutions.GetActiveItemAsync();
            if (activeItem != null)
            {
                //Your coe here.
            }
        }
        catch (Exception)
        {
            //Your exception code here.
        }
    }).FireAndForget();
    return VSConstants.S_OK;
}
```

## OnAfterSave


[OnAfterSave](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents.onaftersave?view=visualstudiosdk-2022) is called after saving a document in the Running Document Table (RDT).

``` CSharp
public:
 int OnAfterSave(unsigned int docCookie);
 ```

 ``` CSharp
[MethodImpl(MethodImplOptions.PreserveSig | MethodImplOptions.InternalCall)]
int OnAfterSave([In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSCOOKIE")] uint docCookie);
```

Code Sample from: [Walkthrough-Create-Language-Editor](https://www.vsixcookbook.com/recipes/Walkthrough-Create-Language-Editor.html)
``` CSharp
public int OnAfterSave(uint docCookie)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        try
        {
            var activeItem = await VS.Solutions.GetActiveItemAsync();
            if (activeItem != null)
            {
                //Your code here.
            }
        }
        catch (Exception)
        { 
            //Your exception code here.
        }
    }).FireAndForget();

    return VSConstants.S_OK;
}
```

## OnAfterAttributeChange

[OnAfterAttributeChange](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents.onafterattributechange?view=visualstudiosdk-2022) is called after a change in an attribute of a document in the Running Document Table (RDT).

``` CSharp
public:
 int OnAfterAttributeChange(unsigned int docCookie, unsigned int grfAttribs);
```

``` CSharp
[MethodImpl(MethodImplOptions.PreserveSig | MethodImplOptions.InternalCall)]
int OnAfterAttributeChange([In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSCOOKIE")] uint docCookie, [In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSRDTATTRIB")] uint grfAttribs);
```

Code Sample from: [Walkthrough-Create-Language-Editor](https://www.vsixcookbook.com/recipes/Walkthrough-Create-Language-Editor.html)
``` CSharp
public int OnAfterAttributeChange(uint docCookie, uint grfAttribs)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        try
        {
            var activeItem = await VS.Solutions.GetActiveItemAsync();
            if (activeItem != null)
            {
                //Your code here.
            }
        }
        catch (Exception)
        {
            //Your exception code here.
        }
    }).FireAndForget();

    return VSConstants.S_OK;
}
```

## OnBeforeDocumentWindowShow

[OnBeforeDocumentWindowShow](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents.onbeforedocumentwindowshow?view=visualstudiosdk-2022) is called before displaying a document window.

``` CSharp
public:
 int OnBeforeDocumentWindowShow(unsigned int docCookie, int fFirstShow, Microsoft::VisualStudio::Shell::Interop::IVsWindowFrame ^ pFrame);
 ```

 ``` CSharp
[MethodImpl(MethodImplOptions.PreserveSig | MethodImplOptions.InternalCall)]
int OnBeforeDocumentWindowShow([In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSCOOKIE")] uint docCookie, [In][ComAliasName("Microsoft.VisualStudio.OLE.Interop.BOOL")] int fFirstShow, [In][MarshalAs(UnmanagedType.Interface)] IVsWindowFrame pFrame);
```

Code Sample from: [Walkthrough-Create-Language-Editor](https://www.vsixcookbook.com/recipes/Walkthrough-Create-Language-Editor.html)
``` CSharp
public int OnBeforeDocumentWindowShow(uint docCookie, int fFirstShow, IVsWindowFrame pFrame)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
        var activeItem = await VS.Solutions.GetActiveItemAsync();
        win = VsShellUtilities.GetWindowObject(pFrame);
        string currentFilePath = win.Document.Path;
        string currentFileTitle = win.Document.Name;
        string currentFileFullPath = System.IO.Path.Combine(currentFilePath, currentFileTitle);
        if (pFrame != null && currentFileTitle.EndsWith(Constants.LinqExt))
        {
            ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
            {
                await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
                Project project = await VS.Solutions.GetActiveProjectAsync();
                if (project != null)
                {
                    XDocument xdoc = XDocument.Load(project.FullPath);
                    try
                    {
                        xdoc = RemoveEmptyItemGroupNode(xdoc);
                        xdoc.Save(project.FullPath);
                        await project.SaveAsync();
                        xdoc = XDocument.Load(project.FullPath);
                    }
                    catch (Exception)
                    { }
                    if (ItemGroupExists(xdoc, Constants.ProjectItemGroup, Constants.ProjectCompile))
                    {
                        try
                        {
                            if (CompileItemExists(xdoc, currentFileTitle))
                            {
                                xdoc = UpdateItemGroupItem(xdoc, currentFileTitle, currentFileFullPath);
                            }
                            else if (ItemGroupExists(xdoc, Constants.ProjectItemGroup, Constants.ProjectNone))
                            {
                                try
                                {
                                    if (NoneCompileItemExists(xdoc, currentFileTitle))
                                    {
                                        xdoc = UpdateItemGroupItem(xdoc, currentFileTitle, currentFileFullPath);
                                    }
                                    else
                                    {
                                        xdoc = CreateNewCompileItem(xdoc, currentFileFullPath);
                                    }
                                    xdoc.Save(project.FullPath);
                                    await project.SaveAsync();
                                    xdoc = XDocument.Load(project.FullPath);
                                }
                                catch (Exception)
                                { }
                            }
                            else
                            {
                                xdoc = CreateNewCompileItem(xdoc, currentFileFullPath);
                            }
                            xdoc.Save(project.FullPath);
                            await project.SaveAsync();
                            xdoc = XDocument.Load(project.FullPath);
                        }
                        catch (Exception)
                        { }
                    }
                    else if (ItemGroupExists(xdoc, Constants.ProjectItemGroup, Constants.ProjectNone))
                    {
                        try
                        {
                            if (NoneCompileItemExists(xdoc, currentFileTitle))
                            {
                                xdoc = UpdateItemGroupItem(xdoc, currentFileTitle, currentFileFullPath);
                            }
                            else
                            {
                                xdoc = CreateNewCompileItem(xdoc, currentFileFullPath);
                            }
                            xdoc.Save(project.FullPath);
                            await project.SaveAsync();
                            xdoc = XDocument.Load(project.FullPath);
                        }
                        catch (Exception)
                        { }
                    }
                    else
                    {
                        xdoc = CreateNewItemGroup(xdoc, currentFileFullPath);
                        xdoc.Save(project.FullPath);
                        await project.SaveAsync();
                    }
                }
            }).FireAndForget();
        }
    }).FireAndForget();
    return VSConstants.S_OK;
}
```

## OnAfterDocumentWindowHide

[OnAfterDocumentWindowHide](https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.shell.interop.ivsrunningdoctableevents.onafterdocumentwindowhide?view=visualstudiosdk-2022) is called after a document window is placed in the Hide state.

``` CSharp
public:
 int OnAfterDocumentWindowHide(unsigned int docCookie, Microsoft::VisualStudio::Shell::Interop::IVsWindowFrame ^ pFrame);
 ```

 ``` CSharp
[MethodImpl(MethodImplOptions.PreserveSig | MethodImplOptions.InternalCall)]
int OnAfterDocumentWindowHide([In][ComAliasName("Microsoft.VisualStudio.Shell.Interop.VSCOOKIE")] uint docCookie, [In][MarshalAs(UnmanagedType.Interface)] IVsWindowFrame pFrame);
```

Code Sample from: [Walkthrough-Create-Language-Editor](https://www.vsixcookbook.com/recipes/Walkthrough-Create-Language-Editor.html)

``` CSharp
public int OnAfterDocumentWindowHide(uint docCookie, IVsWindowFrame pFrame)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
        try
        {
            var activeItem = await VS.Solutions.GetActiveItemAsync();
            if (activeItem != null)
            {
                //(LinqToolWindowControl)this.Content).LinqlistBox.Items.Add($"OnAfterDocumentWindowHide: {activeItem.Name}");
            }
        }
        catch (Exception)
        { }
        try
        {
            var win = VsShellUtilities.GetWindowObject(pFrame);
            if (win != null)
            {
                //((LinqToolWindowControl)this.Content).LinqlistBox.Items.Add($"OnAfterDocumentWindowHide: {win.Caption}");
            }
        }
        catch (Exception)
        { }
        win = VsShellUtilities.GetWindowObject(pFrame);
        if (pFrame != null && win.Caption.EndsWith(Constants.LinqExt))
        {
            ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
            {
                await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
                Project project = await VS.Solutions.GetActiveProjectAsync();
                if (project != null)
                {
                    XDocument xdoc = XDocument.Load(project.FullPath);
                    try
                    {
                        xdoc = RemoveCompileItem(xdoc, win.Caption);
                        xdoc.Save(project.FullPath);
                    }
                    catch (Exception)
                    { }
                    try
                    {
                        xdoc = RemoveEmptyItemGroupNode(xdoc);
                        xdoc.Save(project.FullPath);
                    }
                    catch (Exception)
                    {
                    }
                    xdoc.Save(project.FullPath);
                    await project.SaveAsync();
                }
            }).FireAndForget();
        }
    }).FireAndForget();
    return VSConstants.S_OK;
}
```