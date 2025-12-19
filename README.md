# 🎨 ARCUIComponents

> Premium UI components for iOS, following Apple's Human Interface Guidelines

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2017%2B%20%7C%20iPadOS%2017%2B-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)](https://developer.apple.com/xcode/swiftui/)

---

## 🎯 Overview

A modern Swift package providing beautifully designed, reusable UI components that feel native to Apple's ecosystem. Built with **Clean Architecture**, **Swift 6**, and the latest **SwiftUI** features.

### Components

| Component | Description |
|-----------|-------------|
| **ARCMenu** | Slide-in menu with Liquid Glass effect, user profile, and customizable items |
| **ARCFavoriteButton** | Animated toggle button with haptic feedback and spring animations |
| **ARCListCard** | Versatile card for lists with images, accessories, and multiple styles |
| **ARCSearchButton** | Search button with multiple styles (default, prominent, minimal) |
| **ARCEmptyState** | Empty state views for various scenarios (no data, errors, offline) |
| **LiquidGlass** | Glassmorphism effect modifier for any view |

---

## 📋 Requirements

| Requirement | Version |
|-------------|---------|
| **iOS** | 17.0+ |
| **iPadOS** | 17.0+ |
| **macOS** | 14.0+ (compiles, iOS-optimized) |
| **Swift** | 6.0+ |
| **Xcode** | 16.0+ |

---

## 🚀 Installation

### Swift Package Manager

Add ARCUIComponents to your project using Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL:
   ```
   https://github.com/arclabs-studio/ARCUIComponents.git
   ```
3. Select version rule (recommend: "Up to Next Major Version")

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCUIComponents.git", from: "1.0.0")
]
```

---

## 📖 Usage

### Interactive Showcase

Want to see all the menu variations in action? We've included an **interactive showcase**!

```swift
import SwiftUI
import ARCUIComponents

@main
struct ShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
            ARCMenuShowcase()
        }
    }
}
```

The showcase includes:
- **Live Preview**: See the menu in real-time with different configurations
- **Style Selector**: Switch between Default, Fitness, Premium, Dark, and Minimal styles
- **Variant Options**: Toggle between Full, Compact, Minimal, and Custom variants
- **Customization Controls**: Adjust badges, user header, and more
- **Code Generator**: Automatic code snippets for your selected configuration
- **Complete Gallery**: Browse all styles side-by-side

Perfect for:
- 🎨 Exploring design options
- 👨‍💻 Generating implementation code
- 🎯 Client demonstrations
- 📚 Learning the API
- ✅ Visual QA testing

### Quick Start

```swift
import SwiftUI
import ARCUIComponents

struct ContentView: View {
    @State private var menuViewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Carlos Ramirez",
            email: "carlos@arclabs.studio",
            avatarImage: .initials("CR")
        ),
        onSettings: {
            print("Settings tapped")
        },
        onProfile: {
            print("Profile tapped")
        },
        onLogout: {
            print("Logout tapped")
        }
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

That's it! You now have a fully functional, beautiful menu. 🎉

### API Reference

#### Creating a Menu

#### 1. Define Your User

```swift
let user = ARCMenuUser(
    name: "Jane Cooper",
    email: "jane@example.com",
    subtitle: "Premium Member",  // Optional
    avatarImage: .initials("JC")
)
```

**Avatar Options:**

```swift
// Initials with gradient
.avatarImage(.initials("AB"))

// SF Symbol
.avatarImage(.systemImage("person.circle.fill"))

// Image from Assets
.avatarImage(.imageName("user-avatar"))

// Remote URL
.avatarImage(.url(URL(string: "https://...")!))
```

#### 2. Create Menu Items

**Using Pre-built Items:**

```swift
let items: [ARCMenuItem] = [
    .Common.profile(action: { /* ... */ }),
    .Common.settings(action: { /* ... */ }),
    .Common.plan(badge: "Pro", action: { /* ... */ }),
    .Common.contact(action: { /* ... */ }),
    .Common.about(action: { /* ... */ }),
    .Common.logout(action: { /* ... */ })
]
```

**Creating Custom Items:**

```swift
let customItem = ARCMenuItem(
    title: "Custom Action",
    subtitle: "Optional description",
    icon: .system("star.fill", renderingMode: .multicolor),
    badge: "New",
    isDestructive: false,
    showsDisclosure: true,
    action: {
        print("Custom action")
    }
)
```

#### 3. Configure the Menu

**Using Presets:**

```swift
// Default (Music app style)
let config = ARCMenuConfiguration.default

// Fitness app style
let config = ARCMenuConfiguration.fitness

// Premium/subscription app style
let config = ARCMenuConfiguration.premium

// Dark theme
let config = ARCMenuConfiguration.dark

// Minimal style
let config = ARCMenuConfiguration.minimal
```

**Custom Configuration:**

```swift
let config = ARCMenuConfiguration(
    accentColor: .purple,
    backgroundStyle: .liquidGlass,
    cornerRadius: 30,
    shadow: .prominent,
    menuWidth: 340,
    topPadding: 0,
    sectionSpacing: 24,
    presentationAnimation: .spring(response: 0.5, dampingFraction: 0.8),
    dismissalAnimation: .spring(response: 0.4, dampingFraction: 0.85),
    hapticFeedback: .medium,
    allowsDragToDismiss: true,
    dismissOnOutsideTap: true
)
```

#### 4. Create ViewModel

**Standard Setup:**

```swift
let viewModel = ARCMenuViewModel.standard(
    user: user,
    configuration: .default,
    onSettings: { /* ... */ },
    onProfile: { /* ... */ },
    onPlan: { /* ... */ },
    onContact: { /* ... */ },
    onAbout: { /* ... */ },
    onLogout: { /* ... */ }
)
```

**Custom Setup:**

```swift
let viewModel = ARCMenuViewModel(
    user: user,
    menuItems: items,
    configuration: config
)
```

#### 5. Add to Your View

```swift
NavigationStack {
    YourContentView()
        .arcMenuButton(viewModel: viewModel)
        .arcMenu(viewModel: viewModel)
}
```

**With Badge:**

```swift
.arcMenuButton(
    viewModel: viewModel,
    showsBadge: true,
    badgeCount: 5
)
```

---

## 🎨 Customization Examples

### Music App Style

```swift
let viewModel = ARCMenuViewModel.standard(
    user: ARCMenuUser(
        name: "Music Lover",
        subtitle: "Apple Music",
        avatarImage: .systemImage("music.note")
    ),
    configuration: .default,  // Red accent, liquid glass
    onSettings: { /* ... */ },
    onProfile: { /* ... */ },
    onLogout: { /* ... */ }
)
```

### Fitness App Style

```swift
let viewModel = ARCMenuViewModel(
    user: ARCMenuUser(
        name: "Athlete",
        subtitle: "Pro Plan",
        avatarImage: .systemImage("figure.run")
    ),
    menuItems: [
        .Common.profile(action: {}),
        .Common.plan(badge: "Pro", action: {}),
        ARCMenuItem(
            title: "Workouts",
            icon: .system("dumbbell.fill"),
            showsDisclosure: true,
            action: {}
        ),
        .Common.settings(action: {}),
        .Common.logout(action: {})
    ],
    configuration: .fitness  // Green accent
)
```

### Subscription App Style

```swift
let viewModel = ARCMenuViewModel(
    user: ARCMenuUser(
        name: "Premium User",
        subtitle: "Gold Member",
        avatarImage: .systemImage("crown.fill")
    ),
    menuItems: [
        .Common.profile(action: {}),
        .Common.plan(badge: "Gold", action: {}),
        ARCMenuItem(
            title: "Billing",
            subtitle: "Manage payments",
            icon: .system("creditcard.fill"),
            action: {}
        ),
        .Common.logout(action: {})
    ],
    configuration: .premium  // Orange accent
)
```

---

## 🏗️ Architecture

ARCMenu follows **Clean Architecture** principles:

```
ARCMenu/
├── Models/                   # Data layer
│   ├── ARCMenuUser.swift           # User representation
│   ├── ARCMenuItem.swift           # Menu item model
│   └── ARCMenuConfiguration.swift  # Configuration
├── ViewModels/               # Business logic layer
│   └── ARCMenuViewModel.swift      # Menu state & logic
├── Views/                    # Presentation layer
│   ├── ARCMenu.swift               # Main menu view
│   ├── ARCMenuButton.swift         # Trigger button
│   ├── ARCMenuUserHeader.swift     # User profile section
│   ├── ARCMenuItemRow.swift        # Menu item row
│   └── ARCMenuLiquidGlassModifier.swift  # Visual effects
└── ARCMenuExample.swift      # Usage examples
```

---

## 🎯 Design Philosophy

### Apple First
Every component follows Apple's Human Interface Guidelines meticulously. We study Apple's native apps and replicate their design patterns.

### Performance
Optimized for smooth 60-120Hz animations. Minimal view updates, efficient rendering, and proper use of SwiftUI's view lifecycle.

### Accessibility
Full VoiceOver support, Dynamic Type, high contrast modes, and reduced motion preferences.

### Customization
Highly configurable while maintaining visual consistency. You can adapt colors and behavior without breaking the design language.

### Type Safety
Leverages Swift's type system for compile-time safety. No stringly-typed APIs or runtime crashes.

### Clean Code
- SOLID principles
- Separation of concerns
- Testable architecture
- Comprehensive documentation
- Meaningful naming

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
swift test

# Run with verbose output
swift test --verbose
```

### Demo App

A standalone demo app is available in `Examples/ARCUIComponentsDemo/`:

```bash
cd Examples/ARCUIComponentsDemo
open ARCUIComponentsDemo.xcodeproj
```

The demo showcases all components with interactive examples.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Guidelines

1. Follow Apple's HIG
2. Use Clean Architecture
3. Write comprehensive documentation
4. Add unit tests
5. Follow Swift API Design Guidelines
6. Use Swift 6 features
7. Ensure accessibility

---

## 📄 License

ARCUIComponents is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

## 👨‍💻 Author

**ARC Labs**
- Website: [arclabs.studio](https://arclabs.studio)
- GitHub: [@arclabs-studio](https://github.com/arclabs-studio)

---

## 🙏 Acknowledgments

- Inspired by Apple's design language
- Built with modern SwiftUI
- Following Clean Architecture principles

---

## 🗺️ Roadmap

### Version 1.x (iOS/iPadOS Focus)
- [x] ARCMenu with liquid glass effect
- [x] ARCFavoriteButton
- [x] ARCListCard
- [x] ARCSearchButton
- [x] ARCEmptyState
- [x] LiquidGlass effect modifier
- [ ] ARCCard component
- [ ] ARCButton component
- [ ] ARCTextField component
- [ ] ARCAlert component

### Version 2.x (Platform Expansion)
- [ ] **macOS Components**
  - [ ] ARCPopoverMenu (macOS-native menu)
  - [ ] ARCSidebar (NSOutlineView-style)
  - [ ] ARCToolbarButton (native toolbar integration)
- [ ] iPadOS-specific optimizations (split view, larger displays)
- [ ] Advanced search functionality
- [ ] Section support for menu organization
- [ ] Enhanced accessibility features

### Version 3.x (Extended Platforms)
- [ ] visionOS spatial components
- [ ] tvOS focus-based components
- [ ] watchOS compact components

> **Design Philosophy**: Each platform gets components designed for its unique interaction patterns.
> iOS components use touch gestures; macOS components will use pointer interactions and native patterns.

---

## 📚 Additional Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Swift Documentation](https://swift.org/documentation/)

---

Made with ❤️ using Swift and SwiftUI
