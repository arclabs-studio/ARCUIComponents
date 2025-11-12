# ``ARCUIComponents``

Premium UI components for iOS following Apple's Human Interface Guidelines.

## Overview

ARCUIComponents is a modern Swift package providing beautifully designed, reusable UI components that feel native to Apple's ecosystem. Built with **Clean Architecture**, **Swift 6**, and the latest **SwiftUI** features.

Each component is crafted to match Apple's design language as seen in their flagship apps like Music, Podcasts, Fitness, and App Store.

## Topics

### Components

- ``ARCMenu``
- ``ARCMenuButton``

### Models

- ``ARCMenuUser``
- ``ARCMenuItem``
- ``ARCMenuConfiguration``
- ``ARCMenuUserImage``
- ``ARCMenuIcon``
- ``ARCMenuBackgroundStyle``
- ``ARCMenuShadow``
- ``ARCMenuHapticStyle``

### View Models

- ``ARCMenuViewModel``

### Views

- ``ARCMenuUserHeader``
- ``ARCMenuItemRow``

### Examples

- ``ARCMenuExample``
- ``ARCMenuShowcase``

## Getting Started

### Installation

Add ARCUIComponents to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCUIComponents.git", from: "1.0.0")
]
```

### Quick Start

```swift
import ARCUIComponents

struct ContentView: View {
    @State private var menuViewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Your Name",
            email: "you@email.com",
            avatarImage: .initials("YN")
        ),
        onSettings: { /* handle settings */ },
        onProfile: { /* handle profile */ },
        onLogout: { /* handle logout */ }
    )

    var body: some View {
        NavigationStack {
            YourContentView()
                .arcMenuButton(viewModel: menuViewModel)
                .arcMenu(viewModel: menuViewModel)
        }
    }
}
```

## Requirements

- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+
- Swift 6.0+
- Xcode 16.0+

## Design Philosophy

### Apple First
Every component follows Apple's Human Interface Guidelines meticulously. We study Apple's native apps and replicate their design patterns.

### Performance
Optimized for smooth 60-120Hz animations. Minimal view updates, efficient rendering, and proper use of SwiftUI's view lifecycle.

### Accessibility
Full VoiceOver support, Dynamic Type, high contrast modes, and reduced motion preferences.

### Type Safety
Leverages Swift's type system for compile-time safety. No stringly-typed APIs or runtime crashes.

## Architecture

Built with Clean Architecture principles:
- **Models**: Data structures and configuration
- **ViewModels**: Business logic and state management
- **Views**: SwiftUI presentation layer
- **Utilities**: Helper code and modifiers
