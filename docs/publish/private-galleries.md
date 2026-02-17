---
title: Private extension galleries
description: Host your own private gallery of extensions for your organization or team.
date: 2025-07-17
---

A private gallery lets you distribute Visual Studio extensions within your team or organization without publishing them to the public Marketplace. Visual Studio can consume extension galleries through Atom feeds, which are simply XML files hosted on any web server or file share.

## [How it works](#how-it-works)

1. You build your `.vsix` files as normal.
2. You create an **Atom feed** (an XML file) that lists each extension with its download URL.
3. You host both the feed XML and the `.vsix` files on a web server, file share, or blob storage.
4. Users add the feed URL in **Extensions â†’ Manage Extensions â†’ Settings** (or your extension registers it automatically).

## [Create an Atom feed](#create-an-atom-feed)

The feed is a standard Atom XML file with Visual Studio-specific elements. Here's a minimal example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title type="text">My Company Extensions</title>
  <id>MyCompany-Extensions-Feed</id>
  <updated>2025-01-15T00:00:00Z</updated>

  <entry>
    <id>MyExtension.MyCompany.12345678-1234-1234-1234-123456789abc</id>
    <title type="text">My Extension</title>
    <summary type="text">A useful extension for our team.</summary>
    <updated>2025-01-15T00:00:00Z</updated>
    <author>
      <name>My Company</name>
    </author>
    <content type="application/octet-stream"
             src="https://myserver.example.com/extensions/MyExtension.vsix" />
    <Vsix xmlns="http://schemas.microsoft.com/developer/vsx-syndication-schema/2010"
          xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <Id>MyExtension.MyCompany.12345678-1234-1234-1234-123456789abc</Id>
      <Version>1.0.0</Version>
      <References />
    </Vsix>
  </entry>
</feed>
```

The `<content src="...">` attribute points to where the `.vsix` file can be downloaded. The `<Id>` in the `<Vsix>` element must match the ID in your extension's `.vsixmanifest`.

## [Host the feed](#host-the-feed)

You can host the feed and `.vsix` files anywhere that's reachable by your users:

- **Web server** â€” IIS, nginx, Azure App Service, etc.
- **Azure Blob Storage** â€” set the container to allow read access.
- **File share** â€” use a UNC path like `\\server\share\feed.xml`.
- **GitHub Pages** â€” host the XML and `.vsix` files in a repository.

## [Register the feed manually](#register-the-feed-manually)

Users can add your feed URL manually:

1. Open **Extensions â†’ Manage Extensions**.
2. Click **Change your Extensions and Updates settings** (gear icon) or go to **Tools â†’ Options â†’ Environment â†’ Extensions**.
3. Click **Add** under **Additional Extension Galleries**.
4. Enter the name and URL of your Atom feed.
5. Click **Apply**. The gallery now appears under the **Online** tab.

## [Register the feed from your extension](#register-the-feed-from-your-extension)

If you want your extension to automatically register a private gallery feed, use the `[ProvideGalleryFeed]` attribute on your package class:

```csharp
[ProvideGalleryFeed(
    "d7b5e149-3a12-4bc3-8210-1a234567890a",
    "My Company Extensions",
    "https://myserver.example.com/extensions/feed.xml")]
public sealed class MyPackage : ToolkitPackage
{
    // ...
}
```

The three parameters are:

| Parameter | Description |
|-----------|-------------|
| `guid` | A unique GUID for identifying this feed registration |
| `name` | The display name shown in the Extensions and Updates dialog |
| `url` | The absolute URL to the Atom feed XML |

Once installed, the feed will automatically appear in the user's gallery list.

## [Automating feed generation](#automating-feed-generation)

Writing Atom feed XML by hand is tedious. The open-source [Private Gallery Creator](https://github.com/madskristensen/PrivateGalleryCreator) tool automates this. Point it at a folder of `.vsix` files and it generates a ready-to-use Atom feed:

```
PrivateGalleryCreator.exe --input C:\extensions --output C:\gallery\feed.xml
```

It reads each `.vsixmanifest` automatically to extract the ID, version, name, and description, then produces a valid feed that Visual Studio can consume directly.

## [vsixgallery.com â€” a free public CI gallery](#vsixgallerycom-a-free-public-ci-gallery)

[vsixgallery.com](https://www.vsixgallery.com) is a free gallery service for open-source extension authors. It's designed for CI/CD workflows where you want to publish nightly or pre-release builds without going through the Marketplace review process.

To use it:

1. Build your `.vsix` in CI (GitHub Actions, Azure Pipelines, etc.).
2. Upload the `.vsix` to `vsixgallery.com` using a simple HTTP POST.
3. Users register the gallery feed URL in their Visual Studio to receive updates.

This is a great way to let early adopters test new versions of your extension before an official Marketplace release.

## [Additional resources](#additional-resources)

* [Private Gallery Creator](https://github.com/madskristensen/PrivateGalleryCreator) â€” open-source Atom feed generator
* [vsixgallery.com](https://www.vsixgallery.com) â€” free CI gallery for open-source extensions
* [Publishing to the Marketplace](marketplace.html) â€” for public extensions
* [Automated publishing](automated-publishing.html) â€” CI/CD for the public Marketplace
* [Private Galleries (VS SDK docs)](https://docs.microsoft.com/visualstudio/extensibility/private-galleries)
