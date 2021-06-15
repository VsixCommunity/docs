---
title: Menus & commands
description: A walkthrough of the menu and command system in Visual Studio
date: 2021-5-24
---

Commands are most often used as buttons in menus around Visual Studio. To create a command requires two steps:

1. Define the command
2. Handle the click/invocation

## [Define the command](#define-the-command)
Every button in every menu is a command. To add a command to your extension, you must define it in the .vsct file first. It could look something like this:

```xml
<Buttons>
  <Button guid="MyPackage" id="MyCommand" priority="0x0105" type="Button">
    <Parent guid="VSMainMenu" id="View.DevWindowsGroup.OtherWindows.Group1"/>
    <Icon guid="ImageCatalogGuid" id="StatusInformation" />
    <CommandFlag>IconIsMoniker</CommandFlag>
    <Strings>
      <ButtonText>R&amp;unner Window</ButtonText>
    </Strings>
  </Button>
</Buttons>
```

This button is placed in the parent group located in the **View -> Other Windows** menu as specified in the `Parent` element.

You can now run the extension now to see if the command shows up in the right location and menu.

## [Handle the click/invocations](#handle-the-click)
Once the button is defined, we need to handle what happens when it is invoked. We do that in a C# class that looks like this:

```csharp
[Command("489ba882-f600-4c8b-89db-eb366a4ee3b3", 0x0100)]
public class MyCommand : BaseCommand<TestCommand>
{
    protected override Task ExecuteAsync(OleMenuCmdEventArgs e)
    {
        // Do something
    }
}
```

Make sure to call it from your `Package` class's `InitializeAsync` method.

```csharp
protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
{
    await JoinableTaskFactory.SwitchToMainThreadAsync(cancellationToken);

    await MyCommand.InitializeAsync(this);
 }    
```

The command Guid and ID must match the guid/id pair from `Button` element in the .vsct file

## [Additional resources](#additional-resources)

* [Visual Studio Command Table (.Vsct) Files](https://docs.microsoft.com/visualstudio/extensibility/internals/visual-studio-command-table-dot-vsct-files)
