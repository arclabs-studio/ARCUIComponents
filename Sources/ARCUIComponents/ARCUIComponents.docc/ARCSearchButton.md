# ARCSearchButton

A button component for triggering search functionality.

## Overview

ARCSearchButton provides a consistent search entry point, matching the design patterns found throughout iOS in apps like Mail, Messages, Photos, and Settings.

![ARCSearchButton Preview](arcsearchbutton-preview)

## Features

- **Multiple Styles**: Plain, bordered, and filled options
- **Adaptive Sizing**: Small, medium, and large sizes
- **Press Animation**: Smooth scale feedback
- **Haptic Feedback**: Light impact on tap
- **HIG Compliant**: 44x44pt minimum touch target
- **Accessibility**: Full VoiceOver support

## Basic Usage

```swift
import ARCUIComponents

// Simple search button
ARCSearchButton {
    presentSearchView()
}

// In toolbar
.toolbar {
    ToolbarItem(placement: .topBarTrailing) {
        ARCSearchButton {
            showSearch = true
        }
    }
}
```

## Styles

### Plain (Default)

Minimal style, ideal for toolbars:

```swift
ARCSearchButton(style: .plain) {
    showSearch()
}
```

### Bordered

Subtle border, good for secondary actions:

```swift
ARCSearchButton(
    style: .bordered,
    accentColor: .blue
) {
    showSearch()
}
```

### Filled

Prominent filled background:

```swift
ARCSearchButton(
    style: .filled,
    accentColor: .white
) {
    showSearch()
}
```

## Configuration Presets

### Default

```swift
ARCSearchButton(configuration: .default) {
    // Plain style, medium size
}
```

### Prominent

```swift
ARCSearchButton(configuration: .prominent) {
    // Filled style with blue background
}
```

### Minimal

```swift
ARCSearchButton(configuration: .minimal) {
    // Small size, subtle appearance
}
```

### Toolbar

```swift
ARCSearchButton(configuration: .toolbar) {
    // Optimized for toolbar placement
}
```

## Size Options

| Size | Icon Size | Frame Size |
|------|-----------|------------|
| `.small` | 18pt | 36pt |
| `.medium` | 20pt | 44pt |
| `.large` | 24pt | 52pt |
| `.custom(CGFloat)` | Custom | Auto |

```swift
// Small for compact layouts
ARCSearchButton(size: .small) { ... }

// Large for prominent placement
ARCSearchButton(size: .large) { ... }
```

## Custom Configuration

```swift
let customConfig = ARCSearchButtonConfiguration(
    accentColor: .blue,
    backgroundColor: .blue.opacity(0.1),
    size: .medium,
    style: .bordered,
    icon: "doc.text.magnifyingglass",  // Custom icon
    showsBackgroundWhenIdle: true
)

ARCSearchButton(configuration: customConfig) {
    searchDocuments()
}
```

## Common Patterns

### Navigation Bar

```swift
NavigationStack {
    ContentView()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ARCSearchButton {
                    isSearchPresented = true
                }
            }
        }
        .sheet(isPresented: $isSearchPresented) {
            SearchView()
        }
}
```

### With Navigation Title

```swift
.toolbar {
    ToolbarItem(placement: .topBarTrailing) {
        HStack(spacing: 16) {
            ARCSearchButton { showSearch() }
            ARCMenuButton(viewModel: menuViewModel)
        }
    }
}
```

### In Card Header

```swift
HStack {
    Text("Library")
        .font(.title2.bold())

    Spacer()

    ARCSearchButton(
        style: .bordered,
        size: .small,
        accentColor: .secondary
    ) {
        searchLibrary()
    }
}
```

## Accessibility

ARCSearchButton includes comprehensive accessibility:

- **Label**: "Search"
- **Hint**: "Tap to search"
- **Button Trait**: Properly identified as interactive

## Topics

### Essentials

- ``ARCSearchButton``
- ``ARCSearchButtonConfiguration``

### Styles

- ``ARCSearchButtonConfiguration/ButtonStyle``
- ``ARCSearchButtonConfiguration/ButtonSize``

### Presets

- ``ARCSearchButtonConfiguration/default``
- ``ARCSearchButtonConfiguration/prominent``
- ``ARCSearchButtonConfiguration/minimal``
- ``ARCSearchButtonConfiguration/toolbar``

### Examples

- ``ARCSearchButtonShowcase``
