---
title: Working with services
description: Tips for retrieving Visual Studio services using the toolkit.
date: 2024-12-15
---

Visual Studio exposes functionality through services. The toolkit provides several ways to retrieve them, from simple one-liners to full dependency injection.

## [VS.Services — pre-wired service accessors](#vs-services)
The toolkit pre-wires the most commonly needed VS services through `VS.Services`. Each method returns the service asynchronously, already cast to the correct interface.

```csharp
IVsSolution solution = await VS.Services.GetSolutionAsync();
IVsShell shell = await VS.Services.GetShellAsync();
IVsUIShell uiShell = await VS.Services.GetUIShellAsync();
IVsStatusbar statusBar = await VS.Services.GetStatusBarAsync();
IVsOutputWindow outputWindow = await VS.Services.GetOutputWindowAsync();
IVsDebugger debugger = await VS.Services.GetDebuggerAsync();
IVsSolutionBuildManager buildManager = await VS.Services.GetSolutionBuildManagerAsync();
IVsRunningDocumentTable rdt = await VS.Services.GetRunningDocumentTableAsync();
IComponentModel2 componentModel = await VS.Services.GetComponentModelAsync();
IVsActivityLog activityLog = await VS.Services.GetActivityLogAsync();
```

> **Tip:** Explore `VS.Services.` in IntelliSense to discover all available pre-wired services.

## [Get any global service](#get-any-service)
For services not exposed through `VS.Services`, use the generic `VS.GetServiceAsync` or `VS.GetRequiredServiceAsync` methods. These work the same way as `AsyncPackage.GetServiceAsync` but can be called from anywhere.

```csharp
// Returns null if the service is not available
IVsImageService2? imageService = await VS.GetServiceAsync<SVsImageService, IVsImageService2>();

// Throws if the service is not available
IVsImageService2 imageService = await VS.GetRequiredServiceAsync<SVsImageService, IVsImageService2>();
```

The first type parameter is the **service type** (the SVs* registration type). The second is the **interface** you want to cast it to.

For synchronous access on the UI thread, use `VS.GetRequiredService`:

```csharp
ThreadHelper.ThrowIfNotOnUIThread();
IVsShell shell = VS.GetRequiredService<SVsShell, IVsShell>();
```

## [Get MEF services](#get-mef-services)
MEF (Managed Extensibility Framework) services come from the component model catalog, not the global service provider. The toolkit wraps this with `VS.GetMefServiceAsync` and `VS.GetMefService`.

```csharp
// Async version
IVsEditorAdaptersFactoryService editorAdapters = await VS.GetMefServiceAsync<IVsEditorAdaptersFactoryService>();

// Synchronous version (must be on UI thread)
ThreadHelper.ThrowIfNotOnUIThread();
IContentTypeRegistryService contentTypeRegistry = VS.GetMefService<IContentTypeRegistryService>();
```

## [When to use which](#when-to-use-which)

**Use `VS.Services.GetXxxAsync()`** when the service you need is one of the pre-wired ones. Least code, best discoverability.

**Use `VS.GetRequiredServiceAsync<S, I>()`** when you need a global VS service that isn't pre-wired. This is the async equivalent of calling `GetService(typeof(SVsXxx))`.

**Use `VS.GetMefServiceAsync<I>()`** when you need an editor or component model service. These live in the MEF catalog, not the global service provider.

## [Dependency injection](#dependency-injection)
For extensions that prefer constructor injection over static service locators, the community provides a companion package:

[Community.VisualStudio.Toolkit.DependencyInjection](https://github.com/VsixCommunity/Community.VisualStudio.Toolkit.DependencyInjection)

Install it from NuGet:

```
dotnet add package Community.VisualStudio.Toolkit.DependencyInjection
```

It adds an `IServiceCollection`-based DI container that integrates with the toolkit's package and command infrastructure, letting you inject services into commands, tool windows, and other components.
