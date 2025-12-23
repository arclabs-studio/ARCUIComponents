# Platform Support

> ARCUIComponents follows Apple's design philosophy: **"Design for each platform"** rather than "write once, run everywhere".

---

## Current Status (v1.x)

| Platform | Compiles | Components Available | Design Status |
|----------|----------|---------------------|---------------|
| **iOS 17.0+** | ✅ | All | ✅ Fully designed for iOS |
| **iPadOS 17.0+** | ✅ | All | ✅ Fully designed for iPadOS |
| **macOS 14.0+** | ✅ | All | ⚠️ iOS-centric design (native components planned) |

---

## iOS/iPadOS Components (v1.x)

All current components are designed following **iOS Human Interface Guidelines**:

### ARCMenu
- **Pattern**: Slide-in menu from right edge
- **Interaction**: Touch gestures, drag-to-dismiss
- **Design**: Liquid glass effect, 44pt touch targets
- **macOS Note**: This pattern doesn't exist on macOS. Use native menus or popovers instead.

### ARCMenuButton
- **Pattern**: Circular button with rotation animation
- **Interaction**: Touch with haptic feedback
- **Design**: 44x44pt touch target, badge support
- **macOS Note**: Button size is optimized for touch, may feel large for pointer.

### ARCFavoriteButton
- **Pattern**: Heart toggle with animation
- **Interaction**: Tap with haptic feedback
- **Design**: SF Symbol with bounce effect
- **macOS Note**: Works on macOS, but haptics are iOS-only.

### ARCListCard
- **Pattern**: Card-based list rows
- **Interaction**: Tap with visual feedback
- **Design**: Rounded corners, shadows, materials
- **macOS Note**: Card-based layouts are more common on iOS. macOS typically uses standard List views.

### ARCSearchButton
- **Pattern**: Search trigger button
- **Interaction**: Tap to open search
- **Design**: Customizable styles
- **macOS Note**: Works on both platforms.

### ARCEmptyState
- **Pattern**: Empty content placeholder
- **Interaction**: Optional action button
- **Design**: Icon, title, message, CTA
- **macOS Note**: Universal pattern, works well on all platforms.

### LiquidGlass Modifier
- **Pattern**: Glassmorphism effect
- **Interaction**: Visual only
- **Design**: Ultra-thin material, blur, vibrancy
- **macOS Note**: SwiftUI materials work on macOS, but the aesthetic is more iOS-centric.

---

## macOS Design Considerations

Current components use iOS interaction patterns that don't translate well to macOS:

| iOS Pattern | macOS Equivalent |
|-------------|------------------|
| Slide-in menu | Popover, Sidebar, or NSMenu |
| 44pt touch targets | 24-32pt pointer targets |
| Haptic feedback | No equivalent (silent) |
| Full-screen modals | Window-based dialogs |
| Card-heavy layouts | List/Table-based layouts |
| Bottom sheets | Popovers or inspectors |

---

## Planned macOS Components (v2.x)

Native macOS components designed for pointer interaction:

### ARCPopoverMenu
- **Pattern**: Popover from toolbar button
- **Interaction**: Click, hover states
- **Design**: Native NSPopover feel

### ARCSidebar
- **Pattern**: Source list / outline view style
- **Interaction**: Click, selection, disclosure
- **Design**: NavigationSplitView integration

### ARCToolbarButton
- **Pattern**: Native toolbar integration
- **Interaction**: Click, contextual menus
- **Design**: Standard macOS toolbar sizing

### ARCInspector
- **Pattern**: Side inspector panel
- **Interaction**: Toggle visibility
- **Design**: Inspector sidebar pattern

---

## Future Platforms (v3.x)

### visionOS
- Spatial UI components
- Eye tracking and gesture support
- Depth and dimensionality

### tvOS
- Focus-based navigation
- Remote control optimization
- Living room viewing distances

### watchOS
- Compact UI components
- Digital Crown integration
- Glanceable information

---

## Using Components on macOS

While current components compile on macOS, we recommend:

1. **For production macOS apps**: Wait for native macOS components in v2.x, or use AppKit/native SwiftUI patterns.

2. **For iOS apps running on Apple Silicon Macs**: Current components work via Designed for iPad mode.

3. **For Catalyst apps**: Components work but may feel out of place with macOS UI conventions.

### Conditional Platform Code

```swift
var body: some View {
    #if os(iOS)
    // Use ARCMenu on iOS
    ContentView()
        .arcMenu(viewModel: menuViewModel)
    #else
    // Use native macOS patterns
    NavigationSplitView {
        Sidebar()
    } detail: {
        ContentView()
    }
    #endif
}
```

---

## Why Platform-Specific Design?

Apple's platforms have distinct interaction paradigms:

- **iOS**: Direct manipulation, touch gestures, haptic feedback
- **macOS**: Indirect manipulation, pointer precision, keyboard shortcuts
- **visionOS**: Spatial interaction, eye tracking, hand gestures
- **tvOS**: Remote navigation, focus system, lean-back experience
- **watchOS**: Quick interactions, Digital Crown, complications

A great iOS component might be a poor macOS component. ARCUIComponents aims to provide **excellent** components for each platform, not mediocre cross-platform ones.

---

## Contributing Platform-Specific Components

We welcome contributions for new platforms! Guidelines:

1. **Study the platform**: Understand its HIG and native patterns
2. **Design natively**: Don't port iOS designs directly
3. **Test on device**: Simulators miss important nuances
4. **Consider accessibility**: Each platform has unique accessibility features
5. **Document clearly**: Explain platform-specific behaviors

---

## Questions?

- **Issues**: [GitHub Issues](https://github.com/arclabs-studio/ARCUIComponents/issues)
- **Discussions**: [GitHub Discussions](https://github.com/arclabs-studio/ARCUIComponents/discussions)
