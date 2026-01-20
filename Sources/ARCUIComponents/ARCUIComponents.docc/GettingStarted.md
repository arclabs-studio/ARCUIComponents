# Getting Started with ARCUIComponents

Learn how to integrate ARCMenu into your iOS app in minutes.

## Overview

This guide walks you through adding ARCMenu to your project, creating your first menu, and customizing it to match your app's design.

### What You'll Build

By the end of this tutorial, you'll have a fully functional menu with:
- User profile section with avatar
- Multiple menu items (Settings, Profile, Logout)
- Smooth animations and gestures
- Liquid glass visual effects

## Prerequisites

- Xcode 16.0 or later
- iOS 17.0+ deployment target
- Basic knowledge of SwiftUI

## Understanding Naming Conventions

ARCUIComponents uses a consistent naming pattern:

| Type | Prefix | Example |
|------|--------|---------|
| **Main UI Views** | `ARC` | `ARCMenu`, `ARCThemedArtworkView` |
| **Configurations** | Component name | `ARCMenuConfiguration` |
| **ViewModels** | Component name | `ARCMenuViewModel` |
| **Protocols** | None | `ArtworkTypeProtocol` |
| **Modifiers** | None | `ShimmerModifier` |
| **Support Types** | None | `ArtworkTheme`, `HeartShape` |

The `ARC` prefix identifies primary UI views to avoid confusion with native SwiftUI components (e.g., `ARCMenu` vs SwiftUI's `Menu`).

## Step 1: Add the Package

### Using Xcode

1. Open your project in Xcode
2. Select **File → Add Package Dependencies**
3. Enter the repository URL:
   ```
   https://github.com/arclabs-studio/ARCUIComponents.git
   ```
4. Select version rule: "Up to Next Major Version" with 1.0.0
5. Click **Add Package**

### Using Package.swift

Add ARCUIComponents to your dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/arclabs-studio/ARCUIComponents.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["ARCUIComponents"]
)
```

## Step 2: Import the Package

In your SwiftUI view file:

```swift
import SwiftUI
import ARCUIComponents
```

## Step 3: Create a User Model

Define your user with their information:

```swift
let currentUser = ARCMenuUser(
    name: "Jane Cooper",
    email: "jane@example.com",
    avatarImage: .initials("JC")
)
```

### Avatar Options

Choose the avatar type that fits your needs:

```swift
// Initials with gradient (great for all users)
.avatarImage(.initials("JC"))

// SF Symbol (good for guest users)
.avatarImage(.systemImage("person.circle.fill"))

// Image from assets
.avatarImage(.imageName("user-avatar"))

// Remote URL (with loading state)
.avatarImage(.url(URL(string: "https://example.com/avatar.jpg")!))
```

## Step 4: Create the ViewModel

Use the convenience method for standard menus:

```swift
@State private var menuViewModel = ARCMenuViewModel.standard(
    user: currentUser,
    configuration: .default,
    onSettings: {
        print("Settings tapped")
        // Navigate to settings
    },
    onProfile: {
        print("Profile tapped")
        // Navigate to profile
    },
    onPlan: {
        print("Plan tapped")
        // Navigate to subscription
    },
    onContact: {
        print("Contact tapped")
        // Open contact form
    },
    onAbout: {
        print("About tapped")
        // Show about screen
    },
    onLogout: {
        print("Logout tapped")
        // Perform logout
    }
)
```

### Configuration Presets

ARCMenu includes five built-in presets:

```swift
.default   // Apple Music style (blue accent)
.fitness   // Health apps style (green accent)
.premium   // Subscription apps (orange/gold)
.dark      // Dark theme (purple accent)
.minimal   // Clean and subtle (gray)
```

## Step 5: Add to Your View

Integrate the menu into your view hierarchy:

```swift
struct ContentView: View {
    @State private var menuViewModel = ARCMenuViewModel.standard(
        user: currentUser,
        onSettings: { /* ... */ },
        onProfile: { /* ... */ },
        onLogout: { /* ... */ }
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                // Your app content here
                Text("Welcome to my app!")
                    .font(.largeTitle)
            }
            .navigationTitle("My App")
            .arcMenuButton(viewModel: menuViewModel)
            .arcMenu(viewModel: menuViewModel)
        }
    }
}
```

### Key Points

- Use `.arcMenuButton()` to add the trigger button (top-right by default)
- Use `.arcMenu()` to add the menu overlay
- Both modifiers need the same view model instance

## Step 6: Add Badge (Optional)

Show notification badges on the menu button:

```swift
.arcMenuButton(
    viewModel: menuViewModel,
    showsBadge: true,
    badgeCount: 5  // Number of unread items
)
```

## Step 7: Run Your App

Build and run your app (⌘R). You should see:

1. A button in the top-right corner with your user's avatar
2. Tapping the button opens the menu from the right
3. The menu shows your user profile at the top
4. Menu items are listed below
5. Tapping outside or swiping right dismisses the menu

## Customization

### Custom Configuration

Create your own configuration for brand-specific styling:

```swift
let customConfig = ARCMenuConfiguration(
    accentColor: .purple,
    backgroundStyle: .liquidGlass,
    cornerRadius: 30,
    shadow: .prominent,
    menuWidth: 340,
    hapticFeedback: .medium,
    allowsDragToDismiss: true,
    dismissOnOutsideTap: true
)

let viewModel = ARCMenuViewModel.standard(
    user: currentUser,
    configuration: customConfig,
    onSettings: { /* ... */ },
    onProfile: { /* ... */ },
    onLogout: { /* ... */ }
)
```

### Custom Menu Items

Add your own menu items:

```swift
let customItem = ARCMenuItem(
    title: "Favorites",
    subtitle: "Your saved items",
    icon: .system("heart.fill", renderingMode: .multicolor),
    badge: "12",
    showsDisclosure: true,
    action: {
        print("Favorites tapped")
    }
)

let viewModel = ARCMenuViewModel(
    user: currentUser,
    menuItems: [
        .Common.profile(action: { /* ... */ }),
        .Common.settings(action: { /* ... */ }),
        customItem,  // Your custom item
        .Common.logout(action: { /* ... */ })
    ],
    configuration: .default
)
```

### Menu Without User Section

For apps without user accounts:

```swift
let viewModel = ARCMenuViewModel.standard(
    user: nil,  // No user section
    onSettings: { /* ... */ },
    onAbout: { /* ... */ }
)
```

## Best Practices

### 1. Menu Item Order

Follow iOS conventions:
- User-specific actions first (Profile, Plan)
- General actions middle (Settings, Help)
- Destructive actions last (Logout, Delete)

### 2. Badge Usage

Use badges sparingly:
```swift
// Good: Important notifications
.Common.plan(badge: "New", action: {})

// Bad: Every item has a badge
```

### 3. Haptic Feedback

Keep haptic feedback enabled for better UX:
```swift
ARCMenuConfiguration(
    hapticFeedback: .medium  // Recommended
)
```

### 4. Accessibility

Provide meaningful names and subtitles:
```swift
ARCMenuUser(
    name: "Jane Cooper",  // Full name for VoiceOver
    email: "jane@example.com",
    avatarImage: .initials("JC")
)
```

## Troubleshooting

### Menu Doesn't Appear

**Problem**: The menu button shows, but nothing happens when tapped.

**Solution**: Ensure you're using the same view model instance for both modifiers:

```swift
// ✓ Correct
.arcMenuButton(viewModel: menuViewModel)
.arcMenu(viewModel: menuViewModel)

// ✗ Wrong - different instances
.arcMenuButton(viewModel: ARCMenuViewModel())
.arcMenu(viewModel: ARCMenuViewModel())
```

### Avatar Not Showing

**Problem**: Avatar appears as a placeholder.

**Solution**: Check your avatar type:

```swift
// For remote URLs, ensure HTTPS
.avatarImage(.url(URL(string: "https://...")!))

// For bundled images, verify asset exists
.avatarImage(.imageName("user-avatar"))

// Fallback to initials if image loading fails
.avatarImage(.initials("JC"))
```

### Menu Too Wide/Narrow

**Problem**: Menu doesn't fit your screen layout.

**Solution**: Adjust the menu width:

```swift
ARCMenuConfiguration(
    menuWidth: 280  // Narrower
    // or
    menuWidth: 360  // Wider
)
```

### Actions Not Firing

**Problem**: Menu item actions don't execute.

**Solution**: Ensure actions are captured correctly:

```swift
// ✓ Correct - captures properly
onSettings: {
    self.navigateToSettings()
}

// ✗ Wrong - might not capture context
onSettings: navigateToSettings
```

## Next Steps

### Explore the Showcase

Run the interactive showcase to see all options:

```swift
import ARCUIComponents

struct ShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
            ARCMenuShowcase()
        }
    }
}
```

### Learn Advanced Features

- <doc:ARCMenu> - Complete component documentation
- ``ARCMenuConfiguration`` - All configuration options
- ``ARCMenuItem`` - Custom menu items
- ``ARCMenuViewModel`` - Advanced view model usage

### Integration Examples

See ``ARCMenuExample`` for real-world integration patterns.

## Questions?

If you have questions or need help:
1. Check the <doc:ARCMenu> documentation
2. Review the ``ARCMenuExample`` implementations
3. Explore the ``ARCMenuShowcase`` interactive demo
4. Open an issue on GitHub

---

Congratulations! You've successfully integrated ARCMenu into your app. 🎉
