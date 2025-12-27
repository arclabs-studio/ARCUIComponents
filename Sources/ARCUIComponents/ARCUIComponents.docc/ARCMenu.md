# ARCMenu

A sophisticated menu component with liquid glass effect following Apple's design language.

## Overview

ARCMenu is a premium, reusable menu component that implements Apple's modern design patterns including the **Liquid Glass** effect seen in apps like Music, Podcasts, and Fitness.

![ARCMenu Preview](arcmenu-preview)

## Features

- **Liquid Glass Effect**: Beautiful glassmorphism with ultra-thin materials and vibrancy
- **Smooth Animations**: Spring-based animations following Apple's timing curves
- **Gesture Support**: Drag-to-dismiss with haptic feedback and progress visualization
- **User Profile Section**: Customizable header with flexible avatar options
- **Flexible Menu Items**: Pre-built common items and custom item support
- **Badge Support**: For notifications, counts, and "New" labels
- **Destructive Actions**: Specially styled for actions like Logout or Delete
- **Full Customization**: Colors, sizing, animations, and behavior
- **Swift 6 Ready**: Complete concurrency support with `@MainActor` and `Sendable`
- **Clean Architecture**: Clear separation of concerns

## Basic Usage

### Standard Implementation

```swift
import ARCUIComponents

struct ContentView: View {
    @State private var menuViewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@arclabs.studio",
            avatarImage: .initials("CR")
        ),
        configuration: .default,
        onSettings: { print("Settings") },
        onProfile: { print("Profile") },
        onLogout: { print("Logout") }
    )

    var body: some View {
        NavigationStack {
            YourContentView()
                .navigationTitle("My App")
                .arcMenuButton(viewModel: menuViewModel)
                .arcMenu(viewModel: menuViewModel)
        }
    }
}
```

### With Badge Notifications

```swift
.arcMenuButton(
    viewModel: menuViewModel,
    showsBadge: true,
    badgeCount: 5
)
```

## Customization

### Configuration Presets

ARCMenu includes five built-in configuration presets:

- **Default**: Apple Music style with blue accent
- **Fitness**: Health & Fitness apps with green accent
- **Premium**: Subscription services with orange/gold accent
- **Dark**: Dark theme apps with purple accent
- **Minimal**: Subtle and clean with gray accent

```swift
let config = ARCMenuConfiguration.fitness
let viewModel = ARCMenuViewModel(
    user: user,
    menuItems: items,
    configuration: config
)
```

### Custom Configuration

```swift
let customConfig = ARCMenuConfiguration(
    accentColor: .purple,
    backgroundStyle: .liquidGlass,
    cornerRadius: 30,
    shadow: .prominent,
    menuWidth: 340,
    hapticFeedback: .medium,
    allowsDragToDismiss: true
)
```

### Avatar Options

```swift
// Initials with gradient
.avatarImage(.initials("CR"))

// SF Symbol
.avatarImage(.systemImage("person.circle.fill"))

// Image from assets
.avatarImage(.imageName("user-avatar"))

// Remote URL with AsyncImage
.avatarImage(.url(URL(string: "https://...")!))
```

### Menu Items

#### Using Pre-built Items

```swift
let items: [ARCMenuItem] = [
    .Common.profile(action: { /* ... */ }),
    .Common.settings(action: { /* ... */ }),
    .Common.plan(badge: "Pro", action: { /* ... */ }),
    .Common.logout(action: { /* ... */ })
]
```

#### Creating Custom Items

```swift
let customItem = ARCMenuItem(
    title: "Custom Action",
    subtitle: "Optional description",
    icon: .system("star.fill", renderingMode: .multicolor),
    badge: "New",
    showsDisclosure: true,
    action: { print("Custom action") }
)
```

## Architecture

ARCMenu follows Clean Architecture principles with clear separation:

```
ARCMenu/
├── Models/
│   ├── ARCMenuUser          # User representation
│   ├── ARCMenuItem          # Menu item model
│   └── ARCMenuConfiguration # Configuration & theming
├── ViewModels/
│   └── ARCMenuViewModel     # Business logic & state
└── Views/
    ├── ARCMenu              # Main container
    ├── ARCMenuButton        # Trigger button
    ├── ARCMenuUserHeader    # User profile section
    ├── ARCMenuItemRow       # Individual item
    └── Modifiers            # Visual effects
```

## Topics

### Essentials

- ``ARCMenu``
- ``ARCMenuButton``
- ``ARCMenuViewModel``

### Configuration

- ``ARCMenuUser``
- ``ARCMenuItem``
- ``ARCMenuConfiguration``

### Customization

- ``ARCMenuUserImage``
- ``ARCMenuIcon``
- ``ARCMenuBackgroundStyle``
- ``ARCMenuShadow``
- ``ARCMenuHapticStyle``

### Components

- ``ARCMenuUserHeader``
- ``ARCMenuItemRow``

### Examples

- ``ARCMenuExample``
- ``ARCMenuShowcase``

## Best Practices

### Menu Placement

Always place the menu button in the top-right corner using the toolbar:

```swift
.arcMenuButton(viewModel: viewModel)
```

This automatically places the button in `.topBarTrailing` placement.

### Haptic Feedback

Keep haptic feedback enabled for better user experience:

```swift
ARCMenuConfiguration(
    hapticFeedback: .medium  // Recommended
)
```

### Badge Usage

Use badges sparingly for important notifications only:

```swift
.arcMenuButton(
    viewModel: viewModel,
    showsBadge: true,
    badgeCount: unreadCount
)
```

### Destructive Actions

Always place destructive actions (Logout, Delete) at the bottom and mark them appropriately:

```swift
let items: [ARCMenuItem] = [
    .Common.settings(action: {}),
    .Common.profile(action: {}),
    // ... other items ...
    .Common.logout(action: {})  // Last, marked as destructive
]
```

### Performance

ARCMenu is optimized for smooth animations:
- Minimal view updates with `@Observable`
- Efficient gesture handling
- Proper use of `@MainActor`
- Spring animations matching system behavior

## Accessibility

ARCMenu includes full accessibility support:

- **VoiceOver**: All interactive elements have appropriate labels
- **Dynamic Type**: Text scales with user preferences
- **Reduced Motion**: Respects system animation preferences
- **High Contrast**: Adapts to accessibility display modes

## See Also

- <doc:GettingStarted>
- ``ARCMenuShowcase``
- ``ARCMenuExample``
