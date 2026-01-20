# Naming Conventions

Understanding the naming patterns used in ARCUIComponents.

## Overview

ARCUIComponents follows a consistent naming convention to help developers distinguish between our components and native SwiftUI types. This guide explains when and why the `ARC` prefix is used.

## The ARC Prefix

The `ARC` prefix is reserved for **primary UI view components** that users directly use in their SwiftUI code. This prevents confusion with native SwiftUI components.

### Why Use a Prefix?

SwiftUI provides many built-in components with common names like `Menu`, `TabView`, and `Button`. Without a prefix, our components could clash with or be confused with these native types:

```swift
// Without prefix - confusing
Menu(...)        // Is this SwiftUI or ARCUIComponents?

// With prefix - clear
ARCMenu(...)     // Clearly from ARCUIComponents
```

## Components WITH ARC Prefix

Use components with the `ARC` prefix when you need the enhanced ARCUIComponents version:

### Main UI Views

| Component | Purpose |
|-----------|---------|
| ``ARCMenu`` | Enhanced menu with liquid glass effects |
| ``ARCFavoriteButton`` | Animated favorite/like button |
| ``ARCListCard`` | Styled list card component |
| ``ARCSearchButton`` | Search action button |
| ``ARCEmptyState`` | Empty state display |
| ``ARCThemedArtworkView`` | Themed placeholder artwork |
| ``ARCThemedLoaderView`` | Themed loading indicator |

### Component-Specific Types

Configuration and ViewModel types include the component name which already contains `ARC`:

```swift
// The component name provides the ARC prefix
ARCMenuConfiguration(...)
ARCMenuViewModel(...)
ARCFavoriteButtonConfiguration(...)
```

## Types WITHOUT ARC Prefix

Support types, protocols, modifiers, and shapes do NOT use the `ARC` prefix:

### Protocols

```swift
protocol ArtworkTypeProtocol { ... }
protocol LiquidGlassConfigurable { ... }
```

### Modifiers

Following SwiftUI's pattern where modifiers don't have prefixes:

```swift
ShimmerModifier
LiquidGlassModifier
```

### Shapes

Following SwiftUI's pattern (`Circle`, `Rectangle`, etc.):

```swift
HeartShape
```

### Support Types

Types that support components but aren't directly used in view hierarchies:

```swift
ArtworkTheme
ArtworkConfiguration
ArtworkAnimationType
DecorationElement
CircularDecoration
LinearDecoration
```

### Exceptions

Some core models that could conflict with Foundation/SwiftUI types are prefixed:

```swift
ARCBackgroundStyle  // Distinguishes from potential conflicts
ARCShadow           // Distinguishes from potential Shadow type
```

## Quick Reference

| Category | Prefix | Examples |
|----------|--------|----------|
| Main UI Views | `ARC` | `ARCMenu`, `ARCThemedArtworkView` |
| Configurations | Component name | `ARCMenuConfiguration` |
| ViewModels | Component name | `ARCMenuViewModel` |
| Showcases | `ARC` | `ARCMenuShowcase` |
| Protocols | None | `ArtworkTypeProtocol` |
| Modifiers | None | `ShimmerModifier` |
| Shapes | None | `HeartShape` |
| Support Types | None | `ArtworkTheme` |
| Core Models* | `ARC` | `ARCBackgroundStyle`, `ARCShadow` |

*Core models that could conflict with native types

## Decision Guide

When creating new components, follow this guide:

1. **Is it a primary UI View?** → Add `ARC` prefix
2. **Could it conflict with SwiftUI/Foundation?** → Add `ARC` prefix
3. **Is it a Configuration/ViewModel for an ARC component?** → Use component name (already contains `ARC`)
4. **Is it a protocol, modifier, shape, or helper?** → No prefix

## See Also

- <doc:GettingStarted>
- ``ARCThemedArtworkView``
- ``ArtworkTypeProtocol``
