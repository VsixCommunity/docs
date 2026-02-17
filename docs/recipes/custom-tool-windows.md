---
title: Build custom tool windows
description: A recipe for how to add custom tool windows to Visual Studio
date: 2021-10-12
---

Custom tool windows are great options for adding complex UI to Visual Studio.

<div class="video-container">
<iframe src="https://www.youtube-nocookie.com/embed/E71vJjOEH4g?list=PLReL099Y5nRdz9jvxuy_LgHFKowkx8tS4&color=white" title="YouTube video player" allowfullscreen></iframe>
</div>

A tool window is a window that can be moved around and docked just like the Solution Explorer, Error List, and other well-known tool windows. A tool window consists of an outer shell provided by Visual Studio and a custom inner UI control, which is usually a XAML `<usercontrol>`, provided by the extension.

> To create a new extension with a tool window, create a new project using the **VSIX Project w/Tool Window (Community)** template and skip the rest of this recipe. See [getting started](../getting-started/your-first-extension.html) for more info.

Adding a tool window to an existing extension requires 4 simple steps:

1. Create a tool window outer shell class
2. Add a XAML `<usercontrol>` to the tool window
3. Register the tool window
4. Create a command to show the tool window

Let's start with step 1.

## [Create the tool window](#create-the-tool-window)
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

public class MyToolWindow : BaseToolWindow<MyToolWindow>
{
    public override string GetTitle(int toolWindowId) => "My Tool Window";

    public override Type PaneType => typeof(Pane);

    public override async Task<FrameworkElement> CreateAsync(int toolWindowId, CancellationToken cancellationToken)
    {
        await Task.Delay(2000); // Long running async task
        return new MyUserControl();
    }

    // Give this a new unique guid
    [Guid("d3b3ebd9-87d1-41cd-bf84-268d88953417")] 
    internal class Pane : ToolWindowPane
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

## [Add the XAML user control](#add-the-xaml-user-control)
It can be any XAML with its code-behind class, so here's a simple example of a `<usercontrol>` containing a single button:

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
             Name="MyToolWindow">
    <Grid>
        <StackPanel Orientation="Vertical">
            <Label Margin="10" HorizontalAlignment="Center">My Window</Label>
            <Button Content="Click me!" Click="button1_Click" Width="120" Height="80" Name="button1"/>
        </StackPanel>
    </Grid>
</UserControl>
```

Now we have our tool window class that returns our custom control. The next step is to register our tool window with Visual Studio.

## [Register the tool window](#register-the-tool-window)
Registering the tool window means that we are telling Visual Studio about its existence and how to instantiate it. We do that from our package class using the `[ProvideToolWindow]` attribute.

```csharp
[ProvideToolWindow(typeof(MyToolWindow.Pane))]
public sealed class MyPackage : ToolkitPackage
{
     protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
     {
         this.RegisterToolWindows();
     }
}
```

> Note that the package class must inherit from the `ToolkitPackage` and not from `Package` or `AsyncPackage`.

You can specify what style the tool window should have and where it should show up by default. The following example shows that the tool window should be placed in the same docking container as Solution Explorer in a linked style.

```csharp
[ProvideToolWindow(typeof(MyToolWindow.Pane), Style = VsDockStyle.Linked, Window = WindowGuids.SolutionExplorer)]
```

To make the tool window visible by default, you can specify its visibility in different UI contexts using the `[ProvideToolWindowVisibility]` attribute.

```csharp
[ProvideToolWindowVisibility(typeof(MyToolWindow.Pane), VSConstants.UICONTEXT.NoSolution_string)]
```

## [Command to show the tool window](#command-to-show-the-tool-window)
This is the same as any other command, and you can see how to add one in the [Menus & Commands recipe](menus-buttons-commands.html).

The command handler class that shows the tool window will look something like this:

```csharp
using Community.VisualStudio.Toolkit;
using Microsoft.VisualStudio.Shell;
using Task = System.Threading.Tasks.Task;

[Command(PackageIds.RunnerWindow)]
internal sealed class MyToolWindowCommand : BaseCommand<MyToolWindowCommand>
{
    protected override async Task ExecuteAsync(OleMenuCmdEventArgs e) =>
        await MyToolWindow.ShowAsync();
}
```

The command placement for tool windows is usually under **View -> Other Windows** in the main menu.

That's it. Congratulations, you've now created your custom tool window.

## [Add a toolbar to the tool window](#add-a-toolbar-to-the-tool-window)


> **Note: This will be easier once: 'Add a Toolbar to the Tool Window' is part of the [VsixCommunity/Community.VisualStudio.Toolkit](https://github.com/VsixCommunity/Community.VisualStudio.Toolkit)** 


Add, 

```csharp
ToolWindowMessenger toolWindowMessenger = await Package.GetServiceAsync<ToolWindowMessenger, ToolWindowMessenger>(); 
```


to  the MyToolWindow.cs class in the Task:


```<language>
public override async Task<FrameworkElement> CreateAsync(int toolWindowId, CancellationToken cancellationToken)
```

In the return line update return type to:

```csharp
return new MyUserControl(toolWindowMessenger);
```

In the Pane class add the toolbar:

```csharp
ToolBar = new CommandID(PackageGuids.HelpExplorer, PackageIds.TWindowToolbar);
```


#### MyToolWindow.cs class: Example:
Complete Class example.


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

public class MyToolWindow : BaseToolWindow<MyToolWindow>
{
    public override string GetTitle(int toolWindowId) => "My Tool Window";

    public override Type PaneType => typeof(Pane);

    public override async Task<FrameworkElement> CreateAsync(int toolWindowId, CancellationToken cancellationToken)
    {
        ToolWindowMessenger toolWindowMessenger = await Package.GetServiceAsync<ToolWindowMessenger, ToolWindowMessenger>();
        await Task.Delay(2000); // Long running async task
        return new MyUserControl(toolWindowMessenger);
    }

    // Give this a new unique guid
    [Guid("d3b3ebd9-87d1-41cd-bf84-268d88953417")] 
    internal class Pane : ToolWindowPane
    {
        public Pane()
        {
            // Set an image icon for the tool window
            BitmapImageMoniker = KnownMonikers.StatusInformation;
            ToolBar = new CommandID(PackageGuids.HelpExplorer, PackageIds.TWindowToolbar);
        }
    }
}
```
Add a public variable to the MyToolWindowControl.xaml.cs:

```csharp
public ToolWindowMessenger ToolWindowMessenger = null;

```
In the MyToolWindowControl.xaml.cs class, update the class constructor input parameter for ToolWindowMessenger:

```csharp
public MyToolWindowControl(ToolWindowMessenger toolWindowMessenger)
```

In the MyToolWindowControl.xaml.cs classconstructor also add add check for passed in parameter == null and add event to watch for:

```csharp
if (toolWindowMessenger == null)
{
    toolWindowMessenger = new ToolWindowMessenger();
}
    ToolWindowMessenger = toolWindowMessenger;
    toolWindowMessenger.MessageReceived += OnMessageReceived;
```

Add a private void OnMessageReceived(object sender, string e) event handler to MyToolWindowControl.xaml.cs class:

```csharp
private void OnMessageReceived(object sender, string e)
{
    ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        switch (e)
        {
            case "CommandButton1 Message":
                await [method1 to call in MyToolWindowControl.xaml.cs class];
                break;
            case "CommandButton2 Message":
                await [method2 to call in MyToolWindowControl.xaml.cs class];
                break;
            default:
                break;
        }
    }).FireAndForget();
}
```

To your ToolWindow project add new ToolWindowMessenger.cs class and update the public class ToolWindowMessenger as follows:

```csharp
    public class ToolWindowMessenger
    {
        public void Send(string message)
        {
            // The tooolbar button will call this method.
            // The tool window has added an event handler
            MessageReceived?.Invoke(this, message);
        }
        public event EventHandler<string> MessageReceived;
    }
```

In the project folder add a new Item: Select 'Extensibility' under 'Visual C# Items', and then 'Command (Cummunity)' Give the Command the name CommandButton1 and click Add.

Note: Repeat this process for each button you want in the Toolbar inside the ToolWindow.

The results should look similar to this:

```csharp
    [Command("<insert guid from .vsct file>", 0x0100)]
    internal sealed class CommandButton1 : BaseCommand<CommandButton1>
    {
        protected override async Task ExecuteAsync(OleMenuCmdEventArgs e)
        {
            await VS.MessageBox.ShowWarningAsync("CommandButton1", "Button clicked");
        }
    }

```
Now replace the the above line: 

```csharp
[Command("<insert guid from .vsct file>", 0x0100)] 

```
with (Note: Get the PackageIds from the extension projects VSCommandTable.vsct file)

```csharp
[Command(PackageIds.MyCommandButton1CommandId)]

```
Replace line:

```csharp
await VS.MessageBox.ShowWarningAsync("CommandButton1", "Button clicked");

```
with:

```csharp
await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
    {
        await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
        ToolWindowMessenger messenger = await Package.GetServiceAsync<ToolWindowMessenger, ToolWindowMessenger>();
        messenger.Send("CommandButton1 Message");
    }).FireAndForget();
```

In you [projectname]Package.cs class Register you ProvideService:

```csharp
[ProvideService(typeof(ToolWindowMessenger), IsAsyncQueryable = true)]
```

Add the Service to the class construtor:

```csharp
AddService(typeof(ToolWindowMessenger), (_, _, _) => Task.FromResult<object>(new ToolWindowMessenger()));
await this.RegisterCommandsAsync();
this.RegisterToolWindows();

```

Mow edit you VSCommandTable.vsct

Under Symbols\IDSymbol secion, add at least three items:

1. The ToolBar name and value (i.e  name="TWindowToolbar" value="0x1000")
2. The ToolBarGroup name and value (i.e name="TWindowToolbarGroup" value="0x1050")
3. The CommandButton1 name and value (name="CommandButton1" value="0x0111")

```xml
   <Symbols>
    <GuidSymbol name="MyToolWindowSample" value="{3fe2213e-0041-46e6-93bb-7db123589c7e}">
        <IDSymbol name="MyCommand" value="0x0100" />
        <IDSymbol name="TWindowToolbar" value="0x1000" />
        <IDSymbol name="TWindowToolbarGroup" value="0x1050" />
        <IDSymbol name="CommandButton1" value="0x0111" />
    </GuidSymbol>
  </Symbols>
```

Now under the Commands package section add Menus element and Menu elements:

```xml
<Menus>
    <Menu guid="MyToolWindowSample" id="TWindowToolbar" type="ToolWindowToolbar">
    <CommandFlag>DefaultDocked</CommandFlag>
    <Strings>
        <ButtonText>Tool Window Toolbar</ButtonText>
    </Strings>
    </Menu>
</Menus>
```

Now between Menus element and Buttons element add Goups element:

```xml
<Groups>
    <Group guid="MyToolWindowSample" id="TWindowToolbarGroup" priority="0x0000">
    <Parent guid="MyToolWindowSample" id="TWindowToolbar" />
    </Group>
</Groups>

```

Now in the Buttons element add new button element for your command:

```xml
<Button guid="MyToolWindowSample" id="CommandButton1" priority="0x0001" type="Button">
<Parent guid="MyToolWindowSample" id="TWindowToolbarGroup"/>
<Icon guid="ImageCatalogGuid" id="DynamicDiscoveryDocument"/>
<CommandFlag>IconIsMoniker</CommandFlag>
<!--<CommandFlag>IconAndText</CommandFlag>-->
<Strings>
    <ButtonText>ComamndButton1 Text</ButtonText>
</Strings>
</Button>
```

In the Button element you added change the Icon id to what ever VS Icon Moniker you want to use. 
VS IntelliSense should provide you a list while you edit. Or you can install [KnowMonikers Explorer 2022](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.KnownMonikersExplorer2022)

## [Get the source code](#get-the-source-code)
You can find the source code for this recipe in the [samples repository](https://github.com/VsixCommunity/Samples/tree/master/ToolWindow).
