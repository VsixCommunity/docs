---
title: Create an extension pack
date: 2021-10-12
---

An Extension Pack is a set of extensions that can be installed together. Extension Packs enable you to easily share your favorite extensions with other users or bundle a set of extensions together for a particular scenario.

<div class="video-container">
<iframe src="https://www.youtube-nocookie.com/embed/fCQdqHTjGNM?list=PLReL099Y5nRdz9jvxuy_LgHFKowkx8tS4&color=white" title="YouTube video player" allowfullscreen></iframe>
</div>

## Create from project template
The Extension Pack project template creates an Extension Pack with set of extensions that can be installed together.

In the **New Project** dialog, search for "extension" and select **Extension Pack**. For Project name, type "Test Extension Pack". Select **Create**.

Visual Studio opens the project in Solution Explorer and opens the file **Extensions.vsext** in the editor.

```json
{
  "version": "1.0.0.0",
  "extensions": [
    {
      "vsixId": "OneDarkPro.e1e706e2-05d3-4da9-8754-652cd8ab65f4",
      "name": "One Dark Pro"
    },
    {
      "vsixId": "7fa839e2-b938-4b1c-9277-edaebe6fdeb5",
      "name": "Winter is Coming"
    }
  ]
}
```

## Add to existing extension
In the Solution Explorer, right-click the project node and select **Add > New Item**. Go to the **Visual C# Extensibility** node and select **Extension Pack**. Leave the default file name (ExtensionPack1.cs).

The .vsext file in the root of your project is what turns the project into an extension pack. Just make sure it's *Build Action* is set to *Content* and that *Include in VSIX* is set to *True* as shown below.

![Include in VSIX](../assets/img/include-in-vsix.png)
