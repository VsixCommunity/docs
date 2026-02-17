---
title: Working with the shell
description: Tips for working with the Visual Studio shell.
date: 2024-12-15
---

Here's a collection of small code samples on different ways to work with the Visual Studio shell.

## [Get the Visual Studio version](#get-the-visual-studio-version)
Retrieve the current version of Visual Studio.

```csharp
Version? version = await VS.Shell.GetVsVersionAsync();
// e.g. 17.8.34330.188
```

## [Get command-line arguments](#get-command-line-arguments)
Read the value of a command-line argument passed to `devenv.exe`.

```csharp
string value = await VS.Shell.TryGetCommandLineArgumentAsync("MySwitch");
```

## [Restart Visual Studio](#restart-visual-studio)
Restart the IDE programmatically, for example after installing a component.

```csharp
// Restart in the same mode (normal or elevated)
await VS.Shell.RestartAsync();

// Force restart as elevated (admin)
await VS.Shell.RestartAsync(forceElevated: true);
```

## [Shell events](#shell-events)
Listen for Visual Studio lifecycle changes.

```csharp
VS.Events.ShellEvents.ShellAvailable += () =>
{
    // VS is fully initialized and interactive
};

VS.Events.ShellEvents.ShutdownStarted += () =>
{
    // VS is beginning to shut down â€” clean up resources
};

VS.Events.ShellEvents.EnvironmentColorChanged += () =>
{
    // The user switched the color theme
};
```

See the [Working with events](events.html) page for all available event types.
