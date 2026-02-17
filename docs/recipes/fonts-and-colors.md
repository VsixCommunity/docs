---
title: Fonts & colors
description: A recipe for registering custom fonts and color categories that users can customize in Tools â†’ Options.
date: 2025-07-17
---

Extensions can register custom font and color categories that appear on the **Tools â†’ Options â†’ Environment â†’ Fonts and Colors** page. Users can then customize foreground, background, and font styles for each item your extension defines.

The toolkit wraps this with three building blocks:

1. **`BaseFontAndColorCategory<T>`** â€” defines a category with its default font and color items.
2. **`BaseFontAndColorProvider`** â€” discovers categories and serves them to Visual Studio.
3. **`VS.FontsAndColors`** â€” reads the user's configured colors at runtime.

## [Step 1 â€” Define a category](#step-1-define-a-category)

Create a class inheriting from `BaseFontAndColorCategory<T>`. Give it a unique `[Guid]`, a display `Name`, and one or more `ColorDefinition` properties.

```csharp
[Guid("e977c587-c06e-4c1d-8a3a-cbf9da1bdafa")]
public class MyColorCategory : BaseFontAndColorCategory<MyColorCategory>
{
    // Set the default font. Use FontDefinition.Automatic to
    // inherit the user's current editor font.
    public MyColorCategory() : base(new FontDefinition("Consolas", 10)) { }

    // This name appears in the category drop-down on the Fonts and Colors page.
    public override string Name => "My Extension Colors";

    public ColorDefinition Keyword { get; } = new(
        "Keyword",
        defaultForeground: VisualStudioColor.Indexed(COLORINDEX.CI_BLUE),
        defaultBackground: VisualStudioColor.Automatic()
    );

    public ColorDefinition Comment { get; } = new(
        "Comment",
        defaultForeground: VisualStudioColor.Indexed(COLORINDEX.CI_DARKGREEN),
        defaultBackground: VisualStudioColor.Automatic(),
        fontStyle: FontStyle.Italic
    );

    public ColorDefinition Error { get; } = new(
        "Error",
        defaultForeground: VisualStudioColor.Indexed(COLORINDEX.CI_RED),
        defaultBackground: VisualStudioColor.Automatic(),
        fontStyle: FontStyle.Bold
    );
}
```

Each `ColorDefinition` property is automatically discovered by the toolkit. The property name doesn't matter â€” it's the `name` parameter passed to the constructor that appears on the options page.

### Color values

Use the `VisualStudioColor` factory methods to specify colors:

| Method | Use when |
|--------|----------|
| `VisualStudioColor.Indexed(COLORINDEX.CI_*)` | Using a standard VS color index |
| `VisualStudioColor.VsColor(__VSSYSCOLOREX.VSCOLOR_*)` | Referencing a VS themed system color |
| `VisualStudioColor.Automatic()` | Letting VS choose based on the current theme |

### Color options

Control what the user can customize by passing `ColorOptions`:

```csharp
public ColorDefinition Literal { get; } = new(
    "Literal",
    defaultForeground: VisualStudioColor.Indexed(COLORINDEX.CI_MAROON),
    options: ColorOptions.AllowForegroundChange | ColorOptions.AllowBoldChange
);
```

## [Step 2 â€” Define a provider](#step-2-define-a-provider)

Create a class inheriting from `BaseFontAndColorProvider`. It needs its own `[Guid]`. The provider automatically discovers all `BaseFontAndColorCategory<T>` classes in the same assembly.

```csharp
[Guid("26442428-2cd7-4d79-8498-f9b14087ca50")]
public class MyFontAndColorProvider : BaseFontAndColorProvider { }
```

## [Step 3 â€” Register in the package](#step-3-register-in-the-package)

Add the `[ProvideFontsAndColors]` attribute to your package class and call `RegisterFontAndColorProvidersAsync()` during initialization.

```csharp
[PackageRegistration(UseManagedResourcesOnly = true, AllowsBackgroundLoading = true)]
[Guid(PackageGuids.MyPackageString)]
[ProvideFontsAndColors(typeof(MyFontAndColorProvider))]
public sealed class MyPackage : ToolkitPackage
{
    protected override async Task InitializeAsync(
        CancellationToken cancellationToken,
        IProgress<ServiceProgressData> progress)
    {
        await this.RegisterFontAndColorProvidersAsync();
    }
}
```

After rebuilding and launching the Experimental Instance, your category will appear in the **Fonts and Colors** drop-down.

## [Reading configured colors at runtime](#reading-configured-colors-at-runtime)

To use the colors the user has configured, call `VS.FontsAndColors.GetConfiguredFontAndColorsAsync<T>()`:

```csharp
ConfiguredFontAndColorSet config = await VS.FontsAndColors.GetConfiguredFontAndColorsAsync<MyColorCategory>();

// Read the current font
ConfiguredFont font = config.Font;
string fontFamily = font.FamilyName;
ushort fontSize = font.Size;

// Read a specific color
MyColorCategory category = MyColorCategory.Instance;
ConfiguredColor keywordColor = config.GetColor(category.Keyword);
System.Drawing.Color foreground = keywordColor.ForegroundColor;
System.Drawing.Color background = keywordColor.BackgroundColor;
```

The returned `ConfiguredFontAndColorSet` is live â€” it raises change notifications when the user modifies colors while your extension is running.

## [Listening for changes](#listening-for-changes)

The `ConfiguredFontAndColorSet` automatically updates when the user changes settings. You can react to those changes by checking the values whenever you need them, or by implementing a pattern that refreshes your UI in response:

```csharp
// The ConfiguredFontAndColorSet always reflects the latest user choices.
// Re-read colors whenever you need to repaint.
ConfiguredColor latest = config.GetColor(category.Keyword);
```

## [Additional resources](#additional-resources)

* [Theming recipe](theming.html) â€” using VS theme colors in tool window UI
* [Fonts and Colors Overview](https://docs.microsoft.com/visualstudio/extensibility/font-and-color-overview) â€” official VS SDK docs
