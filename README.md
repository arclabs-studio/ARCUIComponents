# 🎨 ARCUIComponents

> Premium UI components for iOS, following Apple's Human Interface Guidelines

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platforms-iOS%2017%2B%20%7C%20macOS%2014%2B-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)](https://developer.apple.com/xcode/swiftui/)

A modern Swift package providing beautifully designed, reusable UI components that feel native to Apple's ecosystem. Built with **Clean Architecture**, **Swift 6**, and the latest **SwiftUI** features.

---

## ✨ Components

### ARCMenu

A sophisticated menu component featuring Apple's **Liquid Glass** effect, as seen in apps like Music, Podcasts, and Fitness.

<details>
<summary><strong>🎯 Features</strong></summary>

- **Liquid Glass Effect**: Beautiful glassmorphism with ultra-thin materials
- **Smooth Animations**: Spring-based animations following Apple's curves
- **Gesture Support**: Drag-to-dismiss with haptic feedback
- **User Profile Section**: Customizable header with avatar
- **Flexible Menu Items**: Pre-built and custom item support
- **Badge Support**: For notifications and counts
- **Destructive Actions**: Specially styled (e.g., Logout)
- **Full Customization**: Colors, sizing, behavior
- **Swift 6 Ready**: Complete concurrency support
- **Clean Architecture**: Separation of concerns
- **Type-Safe**: Leverages Swift's type system
- **Dark Mode**: Automatic adaptation
- **Accessibility**: VoiceOver and Dynamic Type support

</details>

<details>
<summary><strong>📸 Screenshots</strong></summary>

The menu includes:
- **Top-right button** with avatar or icon
- **User header** with photo, name, and subtitle
- **Customizable menu items** (Settings, Profile, Plan, etc.)
- **Liquid glass background** with blur and vibrancy
- **Smooth slide-in/out** animations
- **Drag gesture** to dismiss

</details>

---

## 📦 Installation

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

## 🎪 Interactive Showcase

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

---

## 🚀 Quick Start

### Basic Implementation

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

---

## 📖 Documentation

### Creating a Menu

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

## ⚙️ Requirements

- **iOS** 17.0+ / **macOS** 14.0+ / **tvOS** 17.0+ / **watchOS** 10.0+
- **Swift** 6.0+
- **Xcode** 16.0+
- **SwiftUI**

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

### Version 1.x
- [x] ARCMenu with liquid glass effect
- [ ] ARCCard component
- [ ] ARCButton component
- [ ] ARCTextField component
- [ ] ARCAlert component

### Version 2.x
- [ ] macOS & iPadOS optimizations
- [ ] watchOS components
- [ ] Accessibility improvements
- [ ] More customization options

---

## 📚 Additional Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Swift Documentation](https://swift.org/documentation/)

---

Made with ❤️ using Swift and SwiftUI
