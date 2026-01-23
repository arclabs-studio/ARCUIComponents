# ``ARCButton``

A standardized action button with consistent styling, loading states, and haptic feedback.

## Overview

`ARCButton` is the primary interactive button used throughout apps for CTAs,
form submissions, and important actions. It follows Apple's Human Interface Guidelines
for button design while providing ARC Labs' premium styling options.

Per Apple HIG: "A button initiates an instantaneous action. Versatile and highly
customizable, buttons give people simple, familiar ways to do tasks in your app."

### Features

- **Multiple Visual Styles**: Filled, outlined, ghost, and glass variants
- **Three Size Options**: Small (32pt), medium (44pt), large (56pt)
- **Loading State**: Built-in progress indicator for async actions
- **Haptic Feedback**: Optional tactile response on tap
- **SF Symbols Integration**: Leading, trailing, or icon-only configurations
- **Full Accessibility Support**: VoiceOver labels and hints

## Topics

### Creating Buttons

- ``init(_:isLoading:configuration:action:)``
- ``init(_:icon:iconPosition:isLoading:configuration:action:)``
- ``init(icon:isLoading:configuration:action:)``

### Configuration

- ``ARCButtonConfiguration``

### Content Types

- ``Content``
- ``IconPosition``

### Styling

- ``ARCButtonStyle``

## Usage Examples

### Primary CTA

```swift
ARCButton("Get Started") {
    startOnboarding()
}
```

### With Loading State

```swift
@State private var isSaving = false

ARCButton("Save Changes", isLoading: $isSaving) {
    isSaving = true
    await saveChanges()
    isSaving = false
}
```

### With Icon

```swift
ARCButton("Add to Favorites", icon: "heart.fill") {
    addToFavorites()
}

// Trailing icon
ARCButton("Continue", icon: "arrow.right", iconPosition: .trailing) {
    goToNext()
}
```

### Icon Only

```swift
ARCButton(icon: "plus") {
    addNewItem()
}
```

### Semantic Presets

```swift
// Primary (default)
ARCButton("Submit", configuration: .primary) { }

// Secondary
ARCButton("Cancel", configuration: .secondary) { }

// Destructive
ARCButton("Delete", configuration: .destructive) { }

// Ghost
ARCButton("Skip", configuration: .ghost) { }

// Glass
ARCButton("Apply", configuration: .glass) { }
```

### Full Width

```swift
ARCButton(
    "Continue to Checkout",
    configuration: ARCButtonConfiguration(isFullWidth: true)
) {
    checkout()
}
```

### Custom Configuration

```swift
ARCButton(
    "Custom Button",
    configuration: ARCButtonConfiguration(
        style: .filled,
        size: .large,
        color: .purple,
        cornerRadius: 16,
        hapticFeedback: true
    )
) {
    doSomething()
}
```

## Best Practices

1. **Use prominent buttons sparingly**: Per Apple HIG, limit prominent (filled) buttons
   to one or two per view.

2. **Match button importance to visual style**:
   - Primary actions → `.filled` (primary)
   - Secondary actions → `.outlined` (secondary)
   - Tertiary actions → `.ghost`
   - Destructive actions → `.destructive`

3. **Provide loading feedback**: Use the `isLoading` binding for async operations
   to show users that their action is being processed.

4. **Don't disable without context**: If a button is disabled, provide clear
   indication of what's needed to enable it.

5. **Ensure adequate hit area**: The minimum button height (32pt for small)
   ensures accessibility. Never reduce this.

## See Also

- <doc:ARCButtonConfiguration>
- Apple Human Interface Guidelines: [Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons)
