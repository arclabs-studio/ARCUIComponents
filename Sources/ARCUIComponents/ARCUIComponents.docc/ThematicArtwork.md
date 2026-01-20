# ThematicArtwork

Customizable themed visual components for placeholders and loading indicators.

## Overview

ThematicArtwork provides a unified system for creating themed visual components that can be used as placeholders, loading indicators, or decorative elements. The system supports multiple categories (food, books) with various styles within each category.

## Features

- **Unified API**: Single component with type-based customization
- **Multiple Categories**: Food and Book themed artworks
- **4 Animation Types**: Spin, pulse, shimmer, and breathe
- **Auto Configuration**: Automatic shape configuration based on type
- **Accessibility**: Full VoiceOver support for loaders
- **Swift 6 Ready**: Full Sendable compliance

## Basic Usage

```swift
import ARCUIComponents

struct ContentView: View {
    var body: some View {
        // Food artwork (circular)
        ThemedArtworkView(type: .food(.pizza))
            .frame(width: 150, height: 150)

        // Book artwork (book proportions)
        ThemedArtworkView(type: .book(.romance))
            .frame(width: 120, height: 180)
    }
}
```

## Artwork Types

### Food Category

```swift
// Pizza - Italian themed with toppings
ThemedArtworkView(type: .food(.pizza))

// Sushi - Japanese themed with nigiri
ThemedArtworkView(type: .food(.sushi))

// Taco - Mexican themed with toppings
ThemedArtworkView(type: .food(.taco))
```

### Book Category

```swift
// Noir - Dark detective theme
ThemedArtworkView(type: .book(.noir))

// Romance - Pink hearts theme
ThemedArtworkView(type: .book(.romance))

// Horror - Spooky green/red theme
ThemedArtworkView(type: .book(.horror))
```

## Animations

### Animation Types

```swift
// Spinning animation (default)
ThemedArtworkView(
    type: .food(.pizza),
    isAnimating: true,
    animationType: .spin
)

// Pulse animation
ThemedArtworkView(
    type: .food(.sushi),
    isAnimating: true,
    animationType: .pulse
)

// Shimmer effect
ThemedArtworkView(
    type: .book(.romance),
    isAnimating: true,
    animationType: .shimmer
)

// Breathing animation
ThemedArtworkView(
    type: .book(.horror),
    isAnimating: true,
    animationType: .breathe
)
```

### Animation Duration

```swift
ThemedArtworkView(
    type: .food(.pizza),
    isAnimating: true,
    animationType: .spin,
    animationDuration: 0.8  // Faster spin
)
```

## Loaders

Use `ThemedLoaderView` for loading indicators:

```swift
// Simple loader
ThemedLoaderView(type: .food(.pizza), size: 64)

// Custom animation
ThemedLoaderView(
    type: .food(.sushi),
    size: 80,
    animationType: .pulse,
    accessibilityLabel: "Loading menu"
)

// Book loader
ThemedLoaderView(type: .book(.romance), size: 60)
```

### Loader Sizes

| Size | Use Case |
|------|----------|
| 32pt | Inline, compact |
| 48pt | List items |
| 64pt | Default, general use |
| 80pt | Prominent, empty states |

## Configuration

### Custom Configuration

```swift
// Override recommended configuration
ThemedArtworkView(
    type: .food(.pizza),
    configuration: .card  // Use card instead of circular
)
```

### Available Configurations

| Configuration | Shape | Aspect Ratio | Use Case |
|---------------|-------|--------------|----------|
| `.circular` | Circle | 1:1 | Food artworks |
| `.book` | Rounded Rect | 0.65:1 | Book covers |
| `.card` | Rounded Rect | 1:1 | Card placeholders |

## Shimmer Modifier

Apply shimmer effect to any view:

```swift
// On artwork
ThemedArtworkView(type: .food(.pizza))
    .shimmer(isActive: isLoading)

// On any view
RoundedRectangle(cornerRadius: 12)
    .fill(Color.gray.opacity(0.3))
    .shimmer(isActive: true, duration: 2.0)
```

## Common Patterns

### Empty State

```swift
VStack(spacing: 16) {
    ThemedArtworkView(type: .food(.sushi))
        .frame(width: 120, height: 120)

    Text("No items yet")
        .font(.headline)

    Text("Add your first item to get started")
        .font(.caption)
        .foregroundStyle(.secondary)
}
```

### Loading State

```swift
if isLoading {
    ThemedLoaderView(type: .food(.pizza), size: 64)
} else {
    ContentView()
}
```

### Placeholder Grid

```swift
LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
    ForEach(ArtworkType.allBookCases, id: \.displayName) { type in
        ThemedArtworkView(type: type)
            .frame(width: 80, height: 120)
    }
}
```

### With Animation Control

```swift
struct InteractiveDemo: View {
    @State private var isAnimating = false
    @State private var animationType: ArtworkAnimationType = .spin

    var body: some View {
        VStack {
            ThemedArtworkView(
                type: .food(.pizza),
                isAnimating: isAnimating,
                animationType: animationType
            )
            .frame(width: 150, height: 150)

            Toggle("Animate", isOn: $isAnimating)

            Picker("Animation", selection: $animationType) {
                ForEach(ArtworkAnimationType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
```

## Accessibility

ThemedLoaderView includes comprehensive accessibility support:

- **VoiceOver Labels**: Customizable loading labels
- **Image Trait**: Properly identified as decorative image
- **Dynamic Type**: Scales appropriately with system settings

```swift
ThemedLoaderView(
    type: .food(.sushi),
    size: 64,
    accessibilityLabel: "Loading your order"
)
```

## Topics

### Essentials

- ``ThemedArtworkView``
- ``ThemedLoaderView``
- ``ArtworkType``

### Configuration

- ``ArtworkConfiguration``
- ``ArtworkTheme``
- ``ArtworkAnimationType``

### Effects

- ``ShimmerModifier``

### Shapes

- ``HeartShape``

### Helpers

- ``CircularDecoration``
- ``LinearDecoration``
- ``DecorationElement``

### Examples

- ``ThematicArtworkShowcase``
