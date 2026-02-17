---
title: Automated publishing
description: How to set up CI/CD pipelines to automatically build and publish your extension.
date: 2024-12-15
---

Automating the build and publish process for your extension saves time and ensures every release is consistent. This guide shows the recommended approach using GitHub Actions with community-maintained actions that handle version stamping, building, and publishing.

## [The publish manifest](#publish-manifest)
Create a `vs-publish.json` file in the root of your repo. This tells the Marketplace about your extension's metadata. For a VSIX extension, most identity fields come from the `.vsixmanifest` — you only need to set the `internalName`:

```json
{
  "$schema": "http://json.schemastore.org/vsix-publish",
  "categories": [ "other" ],
  "identity": {
    "internalName": "MyExtension"
  },
  "overview": "README.md",
  "publisher": "YourPublisherName",
  "repo": "https://github.com/YourName/MyExtension"
}
```

If your Marketplace listing includes images, add them to `assetFiles`:

```json
{
  "assetFiles": [
    {
      "pathOnDisk": "art/screenshot.png",
      "targetPath": "art/screenshot.png"
    }
  ]
}
```

> For full details on the manifest format, see [Publishing via command line](https://docs.microsoft.com/visualstudio/extensibility/walkthrough-publishing-a-visual-studio-extension-via-command-line) on Microsoft Learn.

## [Create a Personal Access Token](#create-pat)
You need a Personal Access Token (PAT) to authenticate with the Marketplace.

1. Go to [dev.azure.com](https://dev.azure.com) and sign in with the Microsoft account that owns your Marketplace publisher
2. Open **User Settings** → **Personal access tokens** → **New Token**
3. Set the organization to **All accessible organizations**
4. Under scopes, select **Marketplace → Manage**
5. Create the token and copy it immediately

In your GitHub repository, go to **Settings → Secrets and variables → Actions** and add the token as a secret named `VS_PUBLISHER_ACCESS_TOKEN`.

## [GitHub Actions workflow](#github-actions)
The recommended workflow uses two jobs: **build** (runs on every push/PR) and **publish** (runs only on push to master or manual dispatch). Publishing to the Marketplace happens when the commit message contains `[release]` or the workflow is triggered manually.

Create `.github/workflows/build.yaml`:

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: "Build"
permissions:
    actions: write
    contents: write

on:
    push:
        branches: [master]
    pull_request:
        branches: [master]
    workflow_dispatch:

jobs:
    build:
        outputs:
            version: ${{ steps.vsix_version.outputs.version-number }}
        name: Build
        runs-on: windows-latest
        env:
            Configuration: Release
            DeployExtension: False
            VsixManifestPath: src\source.extension.vsixmanifest
            VsixManifestSourcePath: src\source.extension.cs

        steps:
        - uses: actions/checkout@v4

        - name: Setup .NET build dependencies
          uses: timheuer/bootstrap-dotnet@v1
          with:
              nuget: 'false'
              sdk: 'false'
              msbuild: 'true'

        - name: Increment VSIX version
          id: vsix_version
          uses: timheuer/vsix-version-stamp@v2
          with:
              manifest-file: ${{ env.VsixManifestPath }}
              vsix-token-source-file: ${{ env.VsixManifestSourcePath }}

        - name: Build
          run: msbuild /v:m -restore /p:OutDir=\_built

        - name: Upload artifact
          uses: actions/upload-artifact@v4
          with:
              name: ${{ github.event.repository.name }}.vsix
              path: /_built/**/*.vsix

    publish:
        if: ${{ github.event_name == 'push' || github.event_name == 'workflow_dispatch' }}
        needs: build
        runs-on: windows-latest

        steps:
            - uses: actions/checkout@v4

            - name: Download Package artifact
              uses: actions/download-artifact@v4
              with:
                  name: ${{ github.event.repository.name }}.vsix

            - name: Upload to Open VSIX
              uses: timheuer/openvsixpublish@v1
              with:
                  vsix-file: ${{ github.event.repository.name }}.vsix

            - name: Publish extension to Marketplace
              if: ${{ github.event_name == 'workflow_dispatch' || contains(github.event.head_commit.message, '[release]') }}
              uses: cezarypiatek/VsixPublisherAction@1.0
              with:
                  extension-file: '${{ github.event.repository.name }}.vsix'
                  publish-manifest-file: 'vs-publish.json'
                  personal-access-code: ${{ secrets.VS_PUBLISHER_ACCESS_TOKEN }}

            - name: Tag and release
              if: ${{ github.event_name == 'workflow_dispatch' || contains(github.event.head_commit.message, '[release]') }}
              id: tag_release
              uses: softprops/action-gh-release@v2
              with:
                  body: release ${{ needs.build.outputs.version }}
                  generate_release_notes: true
                  tag_name: ${{ needs.build.outputs.version }}
                  files: |
                      **/*.vsix
```

## [How it works](#how-it-works)

The workflow has two jobs:

**Build** — runs on every push and PR to master. Restores, version-stamps, builds, and uploads the VSIX as an artifact.

**Publish** — runs only on push to master or manual dispatch. It always publishes to [Open VSIX Gallery](https://www.vsixgallery.com/) so nightly users get updates. When the commit message contains `[release]` (or on manual dispatch), it also publishes to the VS Marketplace and creates a tagged GitHub release.

### Key actions used

[timheuer/bootstrap-dotnet](https://github.com/timheuer/bootstrap-dotnet) — sets up MSBuild and .NET dependencies.

[timheuer/vsix-version-stamp](https://github.com/timheuer/vsix-version-stamp) — auto-increments the VSIX version based on the build number.

[timheuer/openvsixpublish](https://github.com/timheuer/openvsixpublish) — publishes to the Open VSIX Gallery.

[cezarypiatek/VsixPublisherAction](https://github.com/cezarypiatek/VsixPublisherAction) — wraps VsixPublisher.exe for Marketplace publishing.

[softprops/action-gh-release](https://github.com/softprops/action-gh-release) — creates a GitHub release with the VSIX attached.

### Publishing a release
To publish to the Marketplace, include `[release]` in your commit message:

```bash
git commit -m "Fix bug in outlining [release]"
git push
```

Or trigger the workflow manually from the **Actions** tab in GitHub.

## [Key tips](#key-tips)

**Set DeployExtension to False** in CI to prevent the build from trying to launch the VS experimental instance.

**Always sign your VSIX** — unsigned extensions don't auto-update for users. See the [publishing checklist](checklist.html).

**Keep PATs short-lived** — set an expiration and rotate regularly.

**Adjust the VsixManifestPath and VsixManifestSourcePath** env variables to match your project structure.

## [Additional resources](#additional-resources)
* [Publishing via command line](https://docs.microsoft.com/visualstudio/extensibility/walkthrough-publishing-a-visual-studio-extension-via-command-line) — full `VsixPublisher.exe` reference on Microsoft Learn
* [Marketplace publisher management](https://marketplace.visualstudio.com/manage) — manage your publisher and extensions
* [TomlEditor workflow](https://github.com/madskristensen/TomlEditor/blob/master/.github/workflows/build.yaml) — the real-world example this page is based on
