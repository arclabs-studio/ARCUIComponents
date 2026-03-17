# ARCMenu

A sophisticated menu component using native SwiftUI sheet presentation with optional liquid glass effect.

## Overview

ARCMenu is a premium, reusable menu component that uses native SwiftUI `.sheet()` APIs for an Apple-native experience. It supports iOS 26+ Liquid Glass effect when available, falling back to Material on earlier versions.

![ARCMenu Preview](arcmenu-preview)

## Features

- **Native Sheet Presentation**: Uses SwiftUI's `.sheet()` with `PresentationDetent` support
- **Material Background**: Ultra-thin material for glass effect
- **iOS 26+ Liquid Glass**: Ready for future Liquid Glass API
- **Presentation Styles**: Bottom sheet (Apple standard) or trailing panel (drawer)
- **Drag Indicator**: Optional grabber handle
- **Close Button**: Optional X button in header
- **Haptic Feedback**: Configurable haptic responses
- **User Profile Section**: Customizable header with flexible avatar options
- **Flexible Menu Items**: Pre-built common items and custom item support
- **Badge Support**: For notifications, counts, and "New" labels
- **Destructive Actions**: Specially styled for actions like Logout or Delete
- **Swift 6 Ready**: Complete concurrency support with `@MainActor` and `Sendable`

## Basic Usage

ARCMenu uses an external `@State` binding for presentation control, following SwiftUI's native sheet pattern.

### Standard Implementation

```swift
import ARCUIComponents

struct ContentView: View {
    @State private var showMenu = false
    @State private var menuViewModel = ARCMenuViewModel.withDefaultItems(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@arclabs.studio",
            avatarImage: .initials("CR")
        ),
        actions: ARCMenuActions(
            onProfile: { print("Profile") },
            onSettings: { print("Settings") },
            onFeedback: { print("Feedback") },
            onSubscriptions: { print("Subscriptions") },
            onAbout: { print("About") },
            onLogout: { print("Logout") }
        )
    )

    var body: some View {
        NavigationStack {
            YourContentView()
                .navigationTitle("My App")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showMenu = true
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
                .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
        }
    }
}
```

### Using ARCMenuActions

`ARCMenuActions` encapsulates all action handlers for the default menu items, providing a cleaner API:

```swift
let actions = ARCMenuActions(
    onProfile: { router.navigate(to: .profile) },
    onSettings: { router.navigate(to: .settings) },
    onFeedback: { showFeedbackSheet = true },
    onSubscriptions: { router.navigate(to: .subscriptions) },
    onAbout: { router.navigate(to: .about) },
    onLogout: { authService.logout() }
)

let viewModel = ARCMenuViewModel.withDefaultItems(
    user: currentUser,
    configuration: .default,
    actions: actions
)
```

## Presentation Styles

ARCMenu supports two presentation styles, matching the patterns used by Apple apps.

### Bottom Sheet (Default)

The bottom sheet style slides up from the bottom of the screen using native SwiftUI sheet presentation. This is the recommended style for iOS apps.

```swift
let config = ARCMenuConfiguration(
    presentationStyle: .bottomSheet,
    showsGrabber: true,
    showsCloseButton: true,
    sheetTitle: "Account"
)
```

**Features:**
- Uses native `.sheet()` modifier
- Supports `PresentationDetent` for height control
- Includes grabber handle
- Close button in header
- Optional centered title
- Swipe down to dismiss

### Trailing Panel

The trailing panel style slides in from the right edge, similar to a drawer. Useful for iPad apps or desktop layouts.

```swift
let config = ARCMenuConfiguration(
    presentationStyle: .trailingPanel,
    showsGrabber: false,
    showsCloseButton: true
)
```

**Features:**
- Custom overlay implementation
- Slides in from right
- Swipe right to dismiss
- Backdrop tap to dismiss

## Customization

### Configuration Presets

ARCMenu includes built-in configuration presets:

| Preset | Description |
|--------|-------------|
| `.default` | Bottom sheet with blue accent |
| `.trailingPanel` | Drawer-style from trailing edge |
| `.fitness` | Health apps with green accent |
| `.premium` | Subscription services with gold accent |
| `.dark` | Dark theme with purple accent |
| `.minimal` | Subtle and clean with gray accent |
| `.prominent` | Bold category-style icons |
| `.restaurant` | Food apps with amber accent |

```swift
let viewModel = ARCMenuViewModel(
    user: user,
    menuItems: items,
    configuration: .fitness
)
```

### Icon Styles

ARCMenu supports two icon styles controlled via the `iconStyle` property:

#### Subtle (Default)

Low-opacity accent color background (15%) with primary-colored icon.

```swift
let config = ARCMenuConfiguration(iconStyle: .subtle)
```

#### Prominent

Dark muted background with accent-colored icons. Ideal for category-style menus.

```swift
let config = ARCMenuConfiguration(
    accentColor: .orange,
    iconStyle: .prominent
)
```

### Custom Configuration

```swift
let customConfig = ARCMenuConfiguration(
    presentationStyle: .bottomSheet,
    accentColor: .purple,
    backgroundStyle: .liquidGlass,
    cornerRadius: 30,
    shadow: .prominent,
    iconStyle: .subtle,
    menuWidth: 340,
    showsGrabber: true,
    showsCloseButton: true,
    sheetTitle: "My Account",
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
    .Common.subscriptions(badge: "Pro", action: { /* ... */ }),
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

ARCMenu follows Clean Architecture principles:

```
ARCMenu/
├── Models/
│   ├── ARCMenuUser              # User representation
│   ├── ARCMenuItem              # Menu item model
│   ├── ARCMenuActions           # Action handlers struct
│   ├── ARCMenuConfiguration     # Configuration & theming
│   ├── ARCMenuPresentationStyle # Presentation style enum
│   └── ARCMenuIconStyle         # Icon style (subtle/prominent)
├── ViewModels/
│   └── ARCMenuViewModel         # Data and configuration
└── Views/
    ├── ARCMenu                  # Main container
    ├── ARCMenuSheetContent      # Sheet content view
    ├── ARCMenuButton            # Trigger button
    ├── ARCMenuUserHeader        # User profile section
    ├── ARCMenuItemRow           # Individual item
    └── ARCMenuModifier          # View modifier
```

## Topics

### Essentials

- ``ARCMenu``
- ``ARCMenuViewModel``
- ``ARCMenuActions``

### Configuration

- ``ARCMenuUser``
- ``ARCMenuItem``
- ``ARCMenuConfiguration``
- ``ARCMenuPresentationStyle``

### Customization

- ``ARCMenuUserImage``
- ``ARCMenuIcon``
- ``ARCMenuHapticStyle``

### Components

- ``ARCMenuButton``
- ``ARCMenuUserHeader``
- ``ARCMenuItemRow``

### Examples

- ``ARCMenuShowcase``

## Best Practices

### Presentation Control

Always use an external `@State` binding for presentation control:

```swift
@State private var showMenu = false

// In body:
.arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
```

### Haptic Feedback

Keep haptic feedback enabled for better user experience:

```swift
ARCMenuConfiguration(hapticFeedback: .medium)
```

### Destructive Actions

Always place destructive actions (Logout, Delete) at the bottom:

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
- Native sheet presentation
- Efficient gesture handling
- Proper use of `@MainActor`
- Spring animations matching system behavior

## Accessibility

ARCMenu includes full accessibility support:

- **VoiceOver**: All interactive elements have appropriate labels
- **Dynamic Type**: Text scales with user preferences
- **Reduced Motion**: Respects system animation preferences
- **High Contrast**: Adapts to accessibility display modes
- **Backdrop Dismiss**: Accessible button for backdrop tap-to-dismiss

## Migration Guide

### From Legacy API

If you're using the deprecated API, migrate to the new native sheet pattern:

**Before (deprecated):**
```swift
@State private var viewModel = ARCMenuViewModel.standard(
    user: user,
    onSettings: { },
    onProfile: { },
    onLogout: { }
)

// In body:
.arcMenu(viewModel: viewModel)
```

**After (recommended):**
```swift
@State private var showMenu = false
@State private var viewModel = ARCMenuViewModel.withDefaultItems(
    user: user,
    actions: ARCMenuActions(
        onProfile: { },
        onSettings: { },
        onFeedback: { },
        onSubscriptions: { },
        onAbout: { },
        onLogout: { }
    )
)

// In body:
.arcMenu(isPresented: $showMenu, viewModel: viewModel)
```

## See Also

- <doc:GettingStarted>
- ``ARCMenuShowcase``
