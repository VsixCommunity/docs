---
title: Get the tools
description: A list of tools you need to write Visual Studio extensions and how to install them.
date: 2021-10-12
---

To write extensions you have to install the extensibility workload. That's technically all you need, but this set of documentation make use of the community driven extension called *Extensibility Essentials*. Each version of Visual Studio has its own version: [Extensibility Essentials2019](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.ExtensibilityEssentials2019) or [Extensibility Essentials2022](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.ExtensibilityEssentials2022).  

<div class="video-container">
<iframe src="https://www.youtube-nocookie.com/embed/_3j18YsyXGM?list=PLReL099Y5nRdz9jvxuy_LgHFKowkx8tS4&color=white" title="YouTube video player" allowfullscreen></iframe>
</div>

## [Install extensibility workload](#install-extensibility-workload)

Open the *Visual Studio Installer* from **Tools -> Get Tools and Features...** top menu inside Visual Studio and make sure to install the *Visual Studio extension development* workload found toward the bottom.

![VS Installer showing the extensibility workload](../assets/img/vs-installer.png)

## [Install Extensibility Essentials](#install-extensibility-essentials)
Install the *Extensibility Essentials* by going to **Extensions -> Manage Extensions** and search for *extensibility*.

* For Visual Studio 2019 install [Extensibility Essentials2019](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.ExtensibilityEssentials2019)
* For Visual Studio 2022 install [Extensibility Essentials2022](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.ExtensibilityEssentials2022)

![Install Extensibility Essentials from the Extension Manager dialog](../assets/img/install-ext-essentials.png)

That's it, you are now ready to start developing [your first extension](your-first-extension.md).
