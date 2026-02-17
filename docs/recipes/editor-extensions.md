---
title: Editor extensions
description: A recipe for building editor features like syntax highlighting, brace matching, outlining, and more using MEF base classes.
date: 2024-12-15
---

The Community Toolkit provides a set of MEF base classes that make it easy to add language editor features to Visual Studio. These base classes handle all the plumbing so you only have to implement your language-specific logic.

## [Overview of the token-based approach](#overview)
Most editor features in the toolkit are built around a **tokenizer** pattern:

1. You define a set of **token types** (keywords, strings, comments, etc.)
2. You implement a **tokenizer** that parses each line into tokens
3. You plug the tokenizer into one or more **base classes** for syntax highlighting, error squiggles, outlining, etc.

## [Define your token types](#define-tokens)
Start by defining an enum (or bool set) for the token types your language supports. Each token type can later be mapped to a classification (color), an error, or a collapsible region.

```csharp
public enum MyTokenType
{
    Keyword,
    String,
    Comment,
    Identifier,
    Operator,
    Error
}
```

## [Implement the tokenizer](#implement-tokenizer)
Inherit from `TokenTaggerBase<T>` where T is your token type. The `TokenizeAsync` method receives a line of text and must return a list of `ITagSpan<TokenTag<T>>` describing the tokens on that line.

```csharp
using Community.VisualStudio.Toolkit;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Tagging;

internal class MyTokenTagger : TokenTaggerBase<MyTokenType>
{
    protected override Task TokenizeAsync()
    {
        // Loop through each line and add tags
        foreach (ITextSnapshotLine line in Lines)
        {
            string text = line.GetText();
            // Your parsing logic — for each token found:
            // AddTag(new TagSpan<TokenTag<MyTokenType>>(
            //     new SnapshotSpan(line.Snapshot, line.Start + startIndex, length),
            //     new TokenTag<MyTokenType>(MyTokenType.Keyword)));
        }

        return Task.CompletedTask;
    }
}
```

## [Syntax highlighting](#syntax-highlighting)
Use `TokenClassificationTaggerBase<T>` to map your token types to Visual Studio classification types (colors). This is how you get syntax coloring for your language.

```csharp
using System.ComponentModel.Composition;
using Community.VisualStudio.Toolkit;
using Microsoft.VisualStudio.Text.Classification;
using Microsoft.VisualStudio.Utilities;

[Export(typeof(ITaggerProvider))]
[ContentType("myLanguage")]
[TagType(typeof(IClassificationTag))]
public class MyClassificationTagger : TokenClassificationTaggerBase<MyTokenType>
{
    public override Dictionary<MyTokenType, string> ClassificationMap { get; } = new()
    {
        { MyTokenType.Keyword, PredefinedClassificationTypeNames.Keyword },
        { MyTokenType.String, PredefinedClassificationTypeNames.String },
        { MyTokenType.Comment, PredefinedClassificationTypeNames.Comment },
        { MyTokenType.Identifier, PredefinedClassificationTypeNames.Identifier },
    };
}
```

## [Error squiggles](#error-squiggles)
Use `TokenErrorTaggerBase<T>` to show red/green squiggly underlines on tokens that represent errors. Return `true` from `IsErrorToken` for each token type that should show a squiggle.

```csharp
[Export(typeof(ITaggerProvider))]
[ContentType("myLanguage")]
[TagType(typeof(IErrorTag))]
public class MyErrorTagger : TokenErrorTaggerBase<MyTokenType>
{
    protected override bool IsErrorToken(MyTokenType tokenType) =>
        tokenType == MyTokenType.Error;
}
```

## [Outlining / code folding](#outlining)
Use `TokenOutliningTaggerBase<T>` to add collapsible regions. You specify which token types start and end a region.

```csharp
[Export(typeof(ITaggerProvider))]
[ContentType("myLanguage")]
[TagType(typeof(IOutliningRegionTag))]
public class MyOutliningTagger : TokenOutliningTaggerBase<MyTokenType>
{
    // Tokens that open a new collapsible region
    public override MyTokenType OutlineStart => MyTokenType.Keyword;

    // Tokens that close a collapsible region
    public override MyTokenType OutlineEnd => MyTokenType.Keyword;
}
```

## [Brace matching](#brace-matching)
Use `BraceMatchingBase` to highlight matching pairs of braces, brackets, or parentheses when the caret is on one of them.

```csharp
[Export(typeof(ITaggerProvider))]
[ContentType("myLanguage")]
[TagType(typeof(ITextMarkerTag))]
public class MyBraceMatching : BraceMatchingBase
{
    // Define the brace pairs
    public override IEnumerable<(char open, char close)> BracePairs { get; } = new[]
    {
        ('{', '}'),
        ('(', ')'),
        ('[', ']'),
    };
}
```

## [Brace completion](#brace-completion)
Use `BraceCompletionBase` to automatically insert closing braces when the user types an opening one.

```csharp
[Export(typeof(IBraceCompletionSessionProvider))]
[ContentType("myLanguage")]
[BracePair('{', '}')]
[BracePair('(', ')')]
[BracePair('[', ']')]
public class MyBraceCompletion : BraceCompletionBase
{
}
```

## [Same-word highlighting](#same-word-highlighting)
Use `SameWordHighlighterBase` to highlight all occurrences of the word under the caret. No configuration needed — just export it for your content type.

```csharp
[Export(typeof(IViewTaggerProvider))]
[ContentType("myLanguage")]
[TagType(typeof(TextMarkerTag))]
public class MySameWordHighlighter : SameWordHighlighterBase
{
}
```

## [Quick Info (tooltips)](#quick-info)
Use `TokenQuickInfoBase<T>` to show tooltip information when the user hovers over a token.

```csharp
[Export(typeof(IAsyncQuickInfoSourceProvider))]
[ContentType("myLanguage")]
public class MyQuickInfo : TokenQuickInfoBase<MyTokenType>
{
    protected override Task<object> GetTooltipAsync(MyTokenType tokenType, SnapshotSpan span)
    {
        string text = span.GetText();

        return tokenType switch
        {
            MyTokenType.Keyword => Task.FromResult<object>($"Keyword: {text}"),
            MyTokenType.Identifier => Task.FromResult<object>($"Identifier: {text}"),
            _ => Task.FromResult<object>(null)
        };
    }
}
```

## [Register your content type](#register-content-type)
All the above classes reference a `ContentType`. You must define and register it so Visual Studio knows which files get your editor features.

```csharp
public static class MyLanguageContentType
{
    public const string Name = "myLanguage";

    [Export]
    [Name(Name)]
    [BaseDefinition("code")]
    public static ContentTypeDefinition ContentTypeDefinition => null;

    [Export]
    [ContentType(Name)]
    [FileExtension(".mylang")]
    public static FileExtensionToContentTypeDefinition FileExtensionDefinition => null;
}
```

## [Additional resources](#additional-resources)
* The [Walkthrough: Create a Language Editor](Walkthrough-Create-Language-Editor.html) recipe shows a complete end-to-end example
* The [Community Toolkit demo extension](https://github.com/VsixCommunity/Community.VisualStudio.Toolkit/tree/master/demo/VSSDK.TestExtension) has working samples of these base classes
