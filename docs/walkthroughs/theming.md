---
title: Theming
description: How to properly theme tool windows and other XAML controls to match Visual Studio's color themes.
date: 2021-5-29
---

Whenever you are building any custom UI using WPF, you need to make sure it matches the theming of Visual Studio. That way your UI will look native and feel more like a natural part of Visual Studio.

There's an easy way to make sure that our UI's background colors, button styling, etc. matches that of Visual Studio's with a simple little trick.

## [WPF UserControl](#wpf-usercontrol)
Here's an example of a WPF `<UserControl>` that can be used directly inside a tool window.

```xml
<UserControl x:Class="TestExtension.RunnerWindowControl"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
             xmlns:toolkit="clr-namespace:Community.VisualStudio.Toolkit;assembly=Community.VisualStudio.Toolkit"
             toolkit:Themes.UseVsTheme="True"
             mc:Ignorable="d"
             d:DesignHeight="300" d:DesignWidth="300"
             Name="MyToolWindow">
```

Notice the `xmlns:toolkit` imported namespace and the `toolkit:Themes.UseVsTheme="True"` attribute. They will automatically apply the official styling for WPF controls that Visual Studio uses itself. We don't have to do anything else to get the styling applied.

An added benefit is that when the user changes the color theme from e.g. Light to Dark, then our UI will switch immediately as well without the need to reload.

## [DialogWindow control](#dialogwindow-control)
Visual Studio ships with a control we can use for custom windows, which is the `DialogWindow` control. It is recommended you use that for any dialog windows, but it can also be used inside tool windows.

It's very similar to other XAML window types.

```xml
<platform:DialogWindow 
    x:Class="TestExtension.ThemeWindowDialog"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008" 
    xmlns:platform="clr-namespace:Microsoft.VisualStudio.PlatformUI;assembly=Microsoft.VisualStudio.Shell.15.0"
    xmlns:toolkit="clr-namespace:Community.VisualStudio.Toolkit;assembly=Community.VisualStudio.Toolkit"
    xmlns:local="clr-namespace:TestExtension"
    mc:Ignorable="d" 
    Width="400"
    Height="600"
    d:DesignHeight="450" d:DesignWidth="800"
    d:DataContext="{d:DesignInstance Type={x:Type local:ThemeWindowDialogViewModel}, IsDesignTimeCreatable=False}"
    toolkit:Themes.UseVsTheme="{Binding UseVsTheme}"
    >
```

Notice the imported namespaces for both the toolkit and the platform.
