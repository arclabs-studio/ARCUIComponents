# ARCAvatar

A reusable avatar component for displaying user profile images, initials, or placeholder icons with support for status indicators and grouped display.

## Overview

ARCAvatar provides a flexible way to display user avatars in your SwiftUI application. It supports multiple content types, sizes, shapes, and includes features like online status indicators and grouped avatar displays.

## Features

- Multiple content types: images, URLs, initials, SF Symbols, placeholders
- Six size presets from extra small (24pt) to extra extra large (120pt)
- Three shape options: circle, rounded square, squircle
- Status indicators: online, offline, busy, away, custom
- Automatic initials extraction from names
- Consistent color generation based on user names
- Avatar groups with overflow indicator
- Full accessibility support
- Dark mode compatible

## Usage

### Basic Avatar

```swift
// From name (extracts initials automatically)
ARCAvatar(name: "John Doe")

// From URL
ARCAvatar(url: user.avatarURL)

// Explicit initials
ARCAvatar(initials: "JD")

// SF Symbol
ARCAvatar(systemImage: "person.crop.circle.fill")

// Placeholder
ARCAvatar()
```

### With Status Indicator

```swift
ARCAvatar(name: "John Doe", status: .online)
ARCAvatar(name: "Jane Smith", status: .busy)
ARCAvatar(name: "Bob Wilson", status: .away)
```

### Size Presets

```swift
ARCAvatar(name: "User", configuration: .compact)   // XS - 24pt
ARCAvatar(name: "User", configuration: .small)     // SM - 32pt
ARCAvatar(name: "User", configuration: .default)   // MD - 40pt
ARCAvatar(name: "User", configuration: .large)     // LG - 56pt
ARCAvatar(name: "User", configuration: .profile)   // XXL - 120pt
```

### Custom Configuration

```swift
let config = ARCAvatarConfiguration(
    size: .lg,
    shape: .squircle,
    backgroundColor: .blue.opacity(0.2),
    borderColor: .blue,
    borderWidth: 2,
    statusBadgePosition: .topTrailing
)

ARCAvatar(name: "Custom", status: .online, configuration: config)
```

### Avatar Groups

```swift
// Basic group
ARCAvatarGroup(
    avatars: [
        ARCAvatar(name: "Alice"),
        ARCAvatar(name: "Bob"),
        ARCAvatar(name: "Carol")
    ]
)

// With overflow
ARCAvatarGroup(
    avatars: teamMembers.map { ARCAvatar(name: $0.name) },
    maxDisplay: 4,  // Shows 4 avatars + "+N" for overflow
    configuration: .compact
)
```

### In a List

```swift
List(users) { user in
    HStack {
        ARCAvatar(
            name: user.name,
            status: user.isOnline ? .online : .offline,
            configuration: .listItem
        )
        VStack(alignment: .leading) {
            Text(user.name)
            Text(user.email)
                .foregroundStyle(.secondary)
        }
    }
}
```

### Profile Header

```swift
VStack {
    ARCAvatar(
        name: user.name,
        status: .online,
        configuration: .profile
    )
    Text(user.name)
        .font(.title)
}
```

## Configuration Options

### ARCAvatarConfiguration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `size` | `Size` | `.md` | Avatar size (xs, sm, md, lg, xl, xxl) |
| `shape` | `Shape` | `.circle` | Avatar shape |
| `backgroundColor` | `Color` | `.gray.opacity(0.3)` | Background for initials |
| `foregroundColor` | `Color` | `.primary` | Color for initials/icons |
| `borderColor` | `Color?` | `nil` | Optional border color |
| `borderWidth` | `CGFloat` | `0` | Border width |
| `showStatusBadge` | `Bool` | `true` | Show status indicator |
| `statusBadgePosition` | `Position` | `.bottomTrailing` | Badge placement |
| `placeholderIcon` | `String` | `"person.fill"` | Default SF Symbol |

### ARCAvatarStatus

| Status | Color | Description |
|--------|-------|-------------|
| `.none` | - | No indicator |
| `.online` | Green | User is available |
| `.offline` | Gray | User is offline |
| `.busy` | Red | Do not disturb |
| `.away` | Orange | User is away |
| `.custom(Color)` | Custom | Custom status color |

### Size Reference

| Size | Dimension | Use Case |
|------|-----------|----------|
| `.xs` | 24pt | Compact UI, inline mentions |
| `.sm` | 32pt | List items, comments |
| `.md` | 40pt | Default, general use |
| `.lg` | 56pt | Prominent displays |
| `.xl` | 80pt | Profile cards |
| `.xxl` | 120pt | Profile headers |

## Accessibility

ARCAvatar includes full accessibility support:
- Automatic accessibility labels from names
- Status descriptions for VoiceOver
- Image trait for proper interaction

## Requirements

- iOS 17.0+
- macOS 14.0+
- Swift 5.9+

## File Structure

```
ARCAvatar/
├── ARCAvatar.swift              # Main avatar view
├── ARCAvatarConfiguration.swift # Configuration and status types
├── ARCAvatarGroup.swift         # Grouped avatars display
├── ARCAvatarShowcase.swift      # Preview and demo view
└── README.md                    # This file
```

## Author

ARC Labs Studio
