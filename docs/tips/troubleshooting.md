---
title: Troubleshooting
description: Common issues, debugging tips, and FAQ for Visual Studio extension development.
date: 2025-07-17
---

A collection of solutions to common problems encountered when developing Visual Studio extensions.

## [Package did not load correctly](#package-did-not-load-correctly)

This is the most common error when developing extensions. It typically means your package class threw an exception during initialization.

**To diagnose:**

1. Check the **Activity Log** â€” open it at `%AppData%\Microsoft\VisualStudio\<version>\ActivityLog.xml` or launch VS with:

    ```
    devenv.exe /Log
    ```

2. Look for your package name in the log to find the exception details.

**Common causes:**

- A NuGet package or assembly reference is missing from the VSIX.
- The `InitializeAsync` method throws an unhandled exception.
- A `[ProvideService]`, `[ProvideToolWindow]`, or similar attribute references a type that can't be loaded.

## [Extension doesn't appear after building](#extension-doesnt-appear-after-building)

- Make sure your project is set to **deploy to the Experimental Instance**. Right-click the VSIX project â†’ Properties â†’ Debug, and verify the "Start external program" is set to `devenv.exe` with `/rootsuffix Exp`.
- Verify the `.vsixmanifest` has the correct `InstallationTarget` version range for the Visual Studio version you're running.
- Try **resetting the Experimental Instance** (see below).

## [Reset the Experimental Instance](#reset-the-experimental-instance)

The Experimental Instance stores extension installations separately from your main VS. If it gets corrupted, reset it:

```
devenv.exe /ResetSettings /rootsuffix Exp
```

Or use the **Reset the Visual Studio Experimental Instance** shortcut in the Start Menu (installed with the VS SDK workload).

Alternatively, delete the folder manually:

```
%LocalAppData%\Microsoft\VisualStudio\<version>Exp
```

## [Command doesn't show up in menus](#command-doesnt-show-up-in-menus)

- Verify the GUID and ID in your `[Command]` attribute match exactly with the `<Button>` element in the `.vsct` file.
- Make sure you call `await this.RegisterCommandsAsync()` in your package's `InitializeAsync`.
- Check that the parent group in the `.vsct` file is correct. Use the **Command Explorer** tool window (View â†’ Other Windows) to inspect the command table.
- If using `DynamicVisibility`, ensure your `BeforeQueryStatus` handler sets `Visible = true`.

## [Threading errors](#threading-errors)

Visual Studio has strict threading rules. Most VS services must be accessed on the **UI thread**.

**Symptoms:**

- `COMException` with `RPC_E_WRONG_THREAD`
- `InvalidOperationException: "The calling thread must be STA"`

**Solutions:**

- Switch to the UI thread before calling VS services:

    ```csharp
    await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
    ```

- Use the toolkit's async APIs (`VS.GetServiceAsync`, `VS.Documents.OpenAsync`, etc.) which handle thread switching for you.
- Never block the UI thread with `.Result` or `.Wait()` â€” use `async`/`await` instead.

## [MEF component not found](#mef-component-not-found)

If your MEF-exported component isn't being picked up:

- Ensure the class has the `[Export]` attribute with the correct contract type.
- Check that your assembly is included in the VSIX by verifying `IncludeAssemblyInVSIXContainer` is `true` in the `.csproj` (this is the default for VSIX projects).
- Clear the MEF cache:

    ```
    devenv.exe /UpdateConfiguration
    ```

    or delete the `ComponentModelCache` folder:

    ```
    %LocalAppData%\Microsoft\VisualStudio\<version>Exp\ComponentModelCache
    ```

## [Debugging tips](#debugging-tips)

### Attach to the Experimental Instance

When you press F5, Visual Studio launches the Experimental Instance with the debugger attached. If you need to attach manually:

1. Launch the Experimental Instance: `devenv.exe /rootsuffix Exp`
2. In your development VS instance, use **Debug â†’ Attach to Process** and select the `devenv.exe` process.

### Use the Activity Log

Write to the VS Activity Log for diagnostic purposes:

```csharp
IVsActivityLog log = await VS.Services.GetActivityLogAsync();
log.LogEntry(
    (uint)__ACTIVITYLOG_ENTRYTYPE.ALE_INFORMATION,
    "MyExtension",
    "Extension loaded successfully");
```

View the log at `%AppData%\Microsoft\VisualStudio\<version>\ActivityLog.xml`.

### Output Window logging

Write diagnostic messages to a custom Output Window pane:

```csharp
OutputWindowPane pane = await VS.Windows.CreateOutputWindowPaneAsync("My Extension");
await pane.WriteLineAsync("Diagnostic: command executed");
```

## [Build errors after updating packages](#build-errors-after-updating-packages)

After updating NuGet packages, you may see build errors related to missing types or ambiguous references:

- **Clean and rebuild** the solution.
- **Delete** the `bin`, `obj`, and `.vs` folders, then rebuild.
- Make sure your `Microsoft.VSSDK.BuildTools` version matches your target VS version (see [multi-version targeting](../getting-started/multi-version-targeting.html)).

## [Extension works in Experimental but not after install](#extension-works-in-experimental-but-not-after-install)

- Check that all dependencies are included in the VSIX. Open the `.vsix` file (it's a ZIP) and verify all required DLLs are present.
- Look for assembly binding failures in the Activity Log.
- Ensure the `InstallationTarget` in `.vsixmanifest` matches the VS version where you installed it.

## [Additional resources](#additional-resources)

* [Useful resources](../getting-started/useful-resources.html) â€” links to documentation and community help
* [Error handling recipe](../recipes/error-handling.html) â€” handle and log exceptions in your extension
