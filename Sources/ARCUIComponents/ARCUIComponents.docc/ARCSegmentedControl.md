# ARCSegmentedControl

A customizable segmented control with smooth selection animation.

## Overview

`ARCSegmentedControl` provides a horizontal set of mutually exclusive options with smooth sliding selection animation. It supports multiple visual styles including Apple's liquid glass effect, text, icons, or combined segment content.

The component follows Apple's design patterns as seen in native Picker with segmented style, but extends functionality with additional visual styles and customization options.

## Features

- **Multiple visual styles**: Filled (iOS default), outlined, glass, underlined (tab-like)
- **Flexible content**: Text-only, icon-only, or combined segments
- **Smooth animation**: Spring-based sliding selection indicator
- **Haptic feedback**: Optional tactile response on selection
- **Full accessibility**: VoiceOver support with proper traits
- **Size variants**: Small (28pt), medium (36pt), large (44pt)

## Usage

### Basic with Enum

The simplest way to use ARCSegmentedControl is with an enum conforming to `CaseIterable`:

```swift
enum Tab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case profile = "Profile"
}

@State private var selectedTab: Tab = .home

ARCSegmentedControl(selection: $selectedTab)
```

### With Custom Segments

For more control, define segments explicitly:

```swift
enum Filter: Hashable {
    case all, favorites, recent
}

@State private var filter: Filter = .all

ARCSegmentedControl(
    selection: $filter,
    segments: [
        .text("All", value: .all),
        .textAndIcon("Favorites", icon: "heart.fill", value: .favorites),
        .textAndIcon("Recent", icon: "clock.fill", value: .recent)
    ]
)
```

### Icon Only

Perfect for view mode switchers:

```swift
ARCSegmentedControl(
    selection: $viewMode,
    segments: [
        .icon("list.bullet", value: .list, accessibilityLabel: "List view"),
        .icon("square.grid.2x2", value: .grid, accessibilityLabel: "Grid view")
    ],
    configuration: .pill
)
```

### Glass Style

For overlay on colorful backgrounds:

```swift
ZStack {
    GradientBackground()

    ARCSegmentedControl(
        selection: $tab,
        segments: segments,
        configuration: .glass
    )
}
```

### Underlined (Tab Style)

For profile or content navigation:

```swift
ARCSegmentedControl(
    selection: $tab,
    segments: [
        .text("Posts", value: .posts),
        .text("Replies", value: .replies),
        .text("Media", value: .media)
    ],
    configuration: .underlined
)
```

## Configuration Presets

ARCSegmentedControl provides several built-in presets:

| Preset | Description |
|--------|-------------|
| `.default` | iOS-like filled style |
| `.outlined` | Border highlight on selection |
| `.glass` | Liquid glass blur effect |
| `.underlined` | Tab-like underline indicator |
| `.pill` | Compact rounded style |
| `.small` | Small size (28pt height) |
| `.large` | Large size (44pt height) |

## Custom Configuration

Create a custom configuration for specific needs:

```swift
let customConfig = ARCSegmentedControlConfiguration(
    style: .filled,
    size: .large,
    segmentWidth: .equal,
    selectedColor: .blue,
    selectedTextColor: .white,
    backgroundColor: Color(.systemGray5),
    animated: true,
    hapticFeedback: true,
    cornerRadius: 12
)

ARCSegmentedControl(
    selection: $selection,
    segments: segments,
    configuration: customConfig
)
```

## Topics

### Main Components

- ``ARCSegmentedControl``
- ``ARCSegment``

### Configuration

- ``ARCSegmentedControlConfiguration``
- ``ARCSegmentedControlConfiguration/Style-swift.enum``
- ``ARCSegmentedControlConfiguration/Size-swift.enum``
- ``ARCSegmentedControlConfiguration/SegmentWidth-swift.enum``

### Showcases

- ``ARCSegmentedControlShowcase``
