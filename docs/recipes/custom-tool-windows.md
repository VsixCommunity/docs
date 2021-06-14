---
title: Build custom tool windows
date: 2021-5-24
---

Custom tool windows are great options for adding complex UI to Visual Studio. A tool window is a window that can be moved around and docked just like the Solution Explorer, Error List, and other well-known tool windows. Any tool window consist of a outer shell that is provided by Visual Studio, and a custom inner UI control usually a XAML `<usercontrol>`.  

Adding a tool window requires 4 simple steps:

1. Create a tool window outer shell class
2. Add a XAML `<usercontrol>` to the tool window
3. Register the tool window
4. Create a command to show the tool window

Let's start with step 1.

## [Create the tool window](#create-tool-window)
Using the `BaseToolWindow<T>` generic base class, we are asked to provide a few basic pieces of information. We must specify the title of the tool window, create and return the XAML user control, and set the actual `ToolWindowPane` class used by Visual Studio to create the outer shell of the window.

```csharp
using System;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using Community.VisualStudio.Toolkit;
using EnvDTE80;
using Microsoft.VisualStudio.Imaging;
using Microsoft.VisualStudio.Shell;

public class MyWindow : BaseToolWindow<MyWindow>
{
    public override string GetTitle(int toolWindowId) => "My Window";

    public override Type PaneType => typeof(Pane);

    public override async Task<FrameworkElement> CreateAsync(int toolWindowId, CancellationToken cancellationToken)
    {
        await Task.Delay(2000); // Long running async task
        return new MyUserControl();
    }

    // Give this a new unique guid
    [Guid("d3b3ebd9-87d1-41cd-bf84-268d88953417")] 
    public class Pane : ToolWindowPane
    {
        public Pane()
        {
            // Set an image icon for the tool window
            BitmapImageMoniker = KnownMonikers.StatusInformation;
        }
    }
}
```

You must create an instance of your custom user control from the `CreateAsync(int, CancellationToken)` method, which is then automatically passed to the tool window shell when it is being created by Visual Studio.

But first, you must create the user control.

## [Add the XAML user control](#add-user-control)
It can be any XAML with its code-behind class, so here's a simple example of a `<usercontrol>` containing a single button as an example:

```xml
<UserControl x:Class="MyUserControl"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
             xmlns:toolkit="clr-namespace:Community.VisualStudio.Toolkit;assembly=Community.VisualStudio.Toolkit"
             mc:Ignorable="d"
             toolkit:Themes.UseVsTheme="True"
             d:DesignHeight="300" d:DesignWidth="300"
             Name="MyWindow">
    <Grid>
        <StackPanel Orientation="Vertical">
            <Label Margin="10" HorizontalAlignment="Center">My Window</Label>
            <Button Content="Click me!" Click="button1_Click" Width="120" Height="80" Name="button1"/>
        </StackPanel>
    </Grid>
</UserControl>
```

Now we have our tool window that returns our custom control, so now we need to register the window with Visual Studio.

## [Register the tool window](#register-tool-window)
Registering the tool window means that we are telling Visual Studio about its existence and how to instantiate it. We do that from our package class using the `[ProvideToolWindow]` attribute.

```csharp
[ProvideToolWindow(typeof(MyWindow.Pane))]
public sealed class MyPackage : ToolkitPackage
{
    ...
}
```

> Note that the package class must inherit from the `ToolkitPackage` and not from `Package` or `AsyncPackage`.

You can specify what style the tool window should have and where it should show up by default. The following example shows that the tool window should be placed in the same docking container as Solution Explorer in a linked style.

```csharp
[ProvideToolWindow(typeof(MyWindow.Pane), Style = VsDockStyle.Linked, Window = WindowGuids.SolutionExplorer)]
```

To make the tool window visible by default, you can specify its visibility in different UI contexts using the `[ProvideToolWindowVisibility]` attribute.

```csharp
[ProvideToolWindowVisibility(typeof(MyWindow.Pane), VSConstants.UICONTEXT.NoSolution_string)]
```

## [Command to show the tool window](#create-command)
This is the same as any other command, and you can see how to add one in the [Menus & Commands recipe](menus-buttons-commands.html).

The command handler class that shows the tool window will look something like this:

```csharp
using Community.VisualStudio.Toolkit;
using Microsoft.VisualStudio.Shell;
using Task = System.Threading.Tasks.Task;

[Command(PackageIds.RunnerWindow)]
internal sealed class MyWindowCommand : BaseCommand<MyWindowCommand>
{
    protected override async Task ExecuteAsync(OleMenuCmdEventArgs e) =>
        await MyWindow.ShowAsync();
}
```

The command placement for tool windows is usually under **View -> Other Windows** in the main menu.

That's it. Congratulations, you've now created your custom tool window.