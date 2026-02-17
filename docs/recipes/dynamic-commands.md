---
title: Dynamic commands
description: A recipe for creating dynamic menu items that change at runtime.
date: 2025-07-17
---

Dynamic commands create menu items on the fly based on runtime data. Unlike regular commands that have a fixed set of buttons, dynamic commands generate one menu item per data item â€” perfect for "recent files" lists, open-document pickers, or any contextual menu that changes over time.

The toolkit provides `BaseDynamicCommand<TCommand, TItem>` to make this easy.

## [Define the command in .vsct](#define-the-command-in-vsct)

A dynamic command is defined just like a regular button, but with the `DynamicItemStart` flag. This tells Visual Studio that the button is the anchor for a list of dynamic items.

```xml
<Buttons>
  <Button guid="MyPackage" id="DynamicCommand" priority="0x0100" type="Button">
    <Parent guid="MyPackage" id="MyMenuGroup" />
    <CommandFlag>DynamicItemStart</CommandFlag>
    <CommandFlag>DynamicVisibility</CommandFlag>
    <Strings>
      <ButtonText>Dynamic Item</ButtonText>
    </Strings>
  </Button>
</Buttons>
```

> **Important:** The command IDs that follow your button ID must be left unassigned. Visual Studio uses those sequential IDs for each dynamic item.

## [Implement the command class](#implement-the-command-class)

Create a class that inherits from `BaseDynamicCommand<TCommand, TItem>` where `TItem` is the data type you want each menu item to represent.

You must override three methods:

1. `GetItems()` â€” return the list of items to create menu entries for.
2. `BeforeQueryStatus(...)` â€” set the text and visibility of each menu item.
3. `ExecuteAsync(...)` or `Execute(...)` â€” handle the click on a dynamic item.

```csharp
[Command("489ba882-f600-4c8b-89db-eb366a4ee3b3", 0x0100)]
public class RecentItemsCommand : BaseDynamicCommand<RecentItemsCommand, string>
{
    protected override IReadOnlyList<string> GetItems()
    {
        // Return whatever data should generate menu items.
        return new[] { "Alpha", "Beta", "Gamma" };
    }

    protected override void BeforeQueryStatus(OleMenuCommand menuItem, EventArgs e, string item)
    {
        // Set the text that appears in the menu for this item.
        menuItem.Text = item;
    }

    protected override async Task ExecuteAsync(OleMenuCmdEventArgs e, string item)
    {
        await VS.MessageBox.ShowAsync($"You clicked: {item}");
    }
}
```

Register the command the same way as any other command:

```csharp
protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
{
    await this.RegisterCommandsAsync();
}
```

## [How it works](#how-it-works)

When the menu opens, Visual Studio calls `GetItems()` to fetch the current list. It then creates one menu entry per item and calls `BeforeQueryStatus` for each, so you can set the text, icon, enabled state, or visibility. When the user clicks an entry, `ExecuteAsync` (or `Execute`) is invoked with the corresponding item.

## [Using complex data types](#using-complex-data-types)

The generic `TItem` parameter can be any type. For example, you could use a model class:

```csharp
public class RecentFile
{
    public string FilePath { get; set; }
    public DateTime LastOpened { get; set; }
}

[Command("489ba882-f600-4c8b-89db-eb366a4ee3b3", 0x0200)]
public class RecentFilesCommand : BaseDynamicCommand<RecentFilesCommand, RecentFile>
{
    protected override IReadOnlyList<RecentFile> GetItems()
    {
        return MySettings.GetRecentFiles();
    }

    protected override void BeforeQueryStatus(OleMenuCommand menuItem, EventArgs e, RecentFile item)
    {
        menuItem.Text = Path.GetFileName(item.FilePath);
    }

    protected override async Task ExecuteAsync(OleMenuCmdEventArgs e, RecentFile item)
    {
        await VS.Documents.OpenAsync(item.FilePath);
    }
}
```

## [Additional resources](#additional-resources)

* [Menus & commands recipe](menus-buttons-commands.html) â€” regular (non-dynamic) commands
* [Visual Studio Command Table (.Vsct) Files](https://docs.microsoft.com/visualstudio/extensibility/internals/visual-studio-command-table-dot-vsct-files)
