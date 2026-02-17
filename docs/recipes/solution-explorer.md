---
title: Solution Explorer integration
description: A recipe for interacting with the Solution Explorer window â€” selecting, expanding, filtering, and editing items.
date: 2025-07-17
---

The toolkit provides a typed `SolutionExplorerWindow` wrapper that lets you programmatically interact with Solution Explorer â€” select items, expand/collapse nodes, apply filters, and start label editing.

## [Get the Solution Explorer window](#get-the-solution-explorer-window)

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();
```

## [Get selected items](#get-selected-items)

Retrieve the items currently selected in Solution Explorer:

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();
IEnumerable<SolutionItem> selected = await solExp.GetSelectionAsync();

foreach (SolutionItem item in selected)
{
    await VS.MessageBox.ShowAsync($"Selected: {item.Name} ({item.Type})");
}
```

Each `SolutionItem` gives you the item's name, type (project, folder, file, etc.), full path, and access to its hierarchy.

## [Set the selection](#set-the-selection)

Select a specific item or multiple items:

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();

// Select a single item
SolutionItem project = await VS.Solutions.GetActiveProjectAsync();
solExp.SetSelection(project);

// Select multiple items
IEnumerable<SolutionItem> items = await GetMyItemsAsync();
solExp.SetSelection(items);
```

## [Expand and collapse nodes](#expand-and-collapse-nodes)

Expand a project or folder node in Solution Explorer:

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();
SolutionItem project = await VS.Solutions.GetActiveProjectAsync();

// Expand just this node
solExp.Expand(project, SolutionItemExpansionMode.Single);

// Expand this node and all descendants
solExp.Expand(project, SolutionItemExpansionMode.Recursive);

// Expand ancestors to reveal the item (without expanding the item itself)
solExp.Expand(project, SolutionItemExpansionMode.Ancestors);

// Collapse a node
solExp.Collapse(project);
```

The `SolutionItemExpansionMode` flags can be combined:

| Mode | Effect |
|------|--------|
| `Single` | Expand only the specified item |
| `Recursive` | Expand the item and all its descendants |
| `Ancestors` | Expand parent nodes to make the item visible |

## [Edit an item label](#edit-an-item-label)

Start an inline rename of an item:

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();
IEnumerable<SolutionItem> selected = await solExp.GetSelectionAsync();
SolutionItem item = selected.FirstOrDefault();

if (item != null)
{
    solExp.EditLabel(item);
}
```

## [Solution Explorer filters](#solution-explorer-filters)

Check if any filter is active, or if a specific filter is enabled:

```csharp
SolutionExplorerWindow solExp = await VS.Windows.GetSolutionExplorerWindowAsync();

// Is any filter active?
bool filtered = solExp.IsFilterEnabled();

// Is a specific filter active?
bool myFilter = solExp.IsFilterEnabled<MyCustomFilter>();

// Get the current filter
CommandID currentFilter = solExp.GetCurrentFilter();
```

Enable or disable filters:

```csharp
// Enable a custom filter
solExp.EnableFilter<MyCustomFilter>();

// Enable a filter by GUID and ID
solExp.EnableFilter(filterGroupGuid, filterId);

// Disable all filtering
solExp.DisableFilter();
```

## [Additional resources](#additional-resources)

* [Working with solutions](../tips/solutions.html) â€” enumerate projects and solution events
* [Working with projects](../tips/projects.html) â€” add files, inspect project types
