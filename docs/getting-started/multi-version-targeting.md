---
title: Multi-version targeting
description: How to choose the right toolkit package and target multiple Visual Studio versions.
date: 2025-07-17
---

The Community Visual Studio Toolkit ships as several NuGet packages, each targeting a different minimum Visual Studio version. Picking the right one determines which versions of Visual Studio can run your extension.

## [Available packages](#available-packages)

| NuGet package | Minimum VS version | VS range |
|---------------|-------------------|----------|
| `Community.VisualStudio.Toolkit.17` | Visual Studio 2022 (17.0) | 2022, 2026, and later |
| `Community.VisualStudio.Toolkit.16` | Visual Studio 2019 (16.0) | 2019, 2022, 2026, and later |
| `Community.VisualStudio.Toolkit.15` | Visual Studio 2017 (15.0) | 2017, 2019, 2022, 2026, and later |
| `Community.VisualStudio.Toolkit.14` | Visual Studio 2015 (14.0) | 2015, 2017, 2019, 2022, 2026, and later |

> **Note:** Visual Studio 2026 continues to use the 17.x version line, so the `.17` package covers both VS 2022 and VS 2026.

> **Recommendation:** If you only need to support Visual Studio 2022 and later, use `Community.VisualStudio.Toolkit.17`. It provides the cleanest experience and access to the latest APIs.

## [Choosing your target](#choosing-your-target)

Ask yourself: *What is the oldest version of Visual Studio my users need?*

- **VS 2022 / 2026 only** — Use the `.17` package. Both VS 2022 and VS 2026 share the 17.x version line and are 64-bit.
- **VS 2019 + 2022 + 2026** — Use the `.16` package. Your extension will work in all three, but you won't have access to VS 2022-only APIs.
- **VS 2017 and later** — Use the `.15` package.
- **VS 2015 and later** — Use the `.14` package.

## [Install the package](#install-the-package)

Install the package matching your target:

```
dotnet add package Community.VisualStudio.Toolkit.17
```

Or via the NuGet Package Manager in Visual Studio, search for `Community.VisualStudio.Toolkit` and pick the version matching your target.

## [VSSDK version alignment](#vssdk-version-alignment)

Your `Microsoft.VSSDK.BuildTools` and `Microsoft.VisualStudio.SDK` package versions should match the Visual Studio version you're targeting:

| Target VS | VSSDK.BuildTools | VisualStudio.SDK |
|-----------|-----------------|-----------------|
| 2022 | 17.x | 17.x |
| 2019 | 16.x | 16.x |
| 2017 | 15.x | 15.x |

Make sure your `.vsixmanifest` declares the correct `InstallationTarget` version range:

```xml
<Installation>
  <InstallationTarget Id="Microsoft.VisualStudio.Community"
                      Version="[17.0, 18.0)" />
</Installation>
```

## [Supporting both VS 2019 and VS 2022](#supporting-both-vs-2019-and-vs-2022)

VS 2022 moved to 64-bit, which means a single `.vsix` cannot target both VS 2019 (32-bit) and VS 2022 (64-bit). If you need to support both:

1. Use the `.16` toolkit package.
2. Create **two VSIX projects** in your solution - one for VS 2019, one for VS 2022.
3. Share code via a shared project or class library.
4. Each VSIX project references the appropriate `Microsoft.VisualStudio.SDK` version.
5. Publish them as separate extensions on the Marketplace, or use the same extension ID with different version ranges in the `.vsixmanifest`.

## [API differences between versions](#api-differences-between-versions)

Most toolkit APIs work identically across all versions. However, some features are only available in newer packages:

- The `.17` package can use APIs introduced in VS 2022 (e.g., newer editor APIs).
- The `.14`/`.15`/`.16` packages are limited to APIs available in those older VS versions.

The toolkit uses `#if` directives internally to handle version differences, so you generally don't need to worry about it - just choose your minimum version and the toolkit handles the rest.

## [Additional resources](#additional-resources)

* [Get the tools](get-the-tools.html) - setting up your development environment
* [Your first extension](your-first-extension.html) - creating a new extension project
