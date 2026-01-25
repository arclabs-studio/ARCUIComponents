# ARCDesignSystem Integration

Learn how ARCUIComponents leverages ARCDesignSystem for consistent animations, typography, and design tokens.

## Overview

ARCUIComponents is built on top of ARCDesignSystem, which provides standardized animation tokens, typography, spacing, and accessibility helpers. This ensures a consistent and polished user experience across all components.

## Animation Tokens

All ARCUIComponents use ARCDesignSystem animation tokens for consistent motion design.

### Available Animations

| Token | Description | Use Case |
|-------|-------------|----------|
| `.arcStandard` | Default timing (0.3s) | General UI updates |
| `.arcQuick` | Fast response (0.15s) | Button presses, micro-interactions |
| `.arcSmooth` | Smooth ease (0.35s) | Page transitions |
| `.arcSlow` | Deliberate pace (0.5s) | Modal presentations |
| `.arcSpring` | Balanced spring | Interactive elements |
| `.arcBouncy` | Playful spring | Favorites, likes, fun actions |
| `.arcGentle` | Soft spring | Sheets, overlays |
| `.arcSnappy` | Responsive spring | Quick feedback |

### Usage Examples

```swift
import ARCDesignSystem

// Using the view modifier
Circle()
    .arcAnimation(.arcBouncy, value: isExpanded)

// Using the helper function
Button("Toggle") {
    arcWithAnimation(.arcSpring) {
        showMenu.toggle()
    }
}

// Motion-aware animations (respects Reduce Motion)
Rectangle()
    .arcAnimationIfAllowed(.arcGentle, value: currentPage)
```

## Accessibility

ARCUIComponents respect the user's accessibility preferences automatically.

### Reduce Motion Support

All components check for the Reduce Motion setting and simplify animations accordingly:

```swift
// Built-in support - no extra code needed
ARCBottomSheet(isPresented: $show) {
    // Animations are simplified when Reduce Motion is enabled
}

// For custom implementations
.arcAnimationIfAllowed(.arcSpring, value: selection)
```

### Accessibility Utilities

```swift
// Check system settings
if ARCAccessibility.isReduceMotionEnabled {
    // Use simplified animations
}

if ARCAccessibility.isVoiceOverRunning {
    // Provide additional context
}

// Get motion-aware animation
let animation = ARCAccessibility.animation(
    .arcBouncy,
    reducedMotion: .linear(duration: 0.1)
)
```

## Spacing Tokens

Use consistent spacing throughout your app:

```swift
VStack(spacing: .arcSpacingMedium) {
    // ...
}
.padding(.arcPaddingCard)

RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
```

### Available Spacing

| Token | Value | Use Case |
|-------|-------|----------|
| `.arcSpacingXSmall` | 4 | Tight spacing |
| `.arcSpacingSmall` | 8 | Compact elements |
| `.arcSpacingMedium` | 16 | Standard spacing |
| `.arcSpacingLarge` | 24 | Section separation |
| `.arcSpacingXLarge` | 32 | Major sections |
| `.arcSpacingXXLarge` | 48 | Page-level spacing |

### Corner Radii

| Token | Value | Use Case |
|-------|-------|----------|
| `.arcCornerRadiusSmall` | 8 | Chips, tags |
| `.arcCornerRadiusMedium` | 12 | Cards, buttons |
| `.arcCornerRadiusLarge` | 16 | Modals, sheets |
| `.arcCornerRadiusXLarge` | 24 | Full-screen cards |

## Typography

ARCDesignSystem provides ARC-branded typography tokens:

```swift
Text("Headline")
    .font(.arcHeadline)

Text("Body text")
    .font(.arcBody)

// Brand font (Radley Sans)
Text("ARC Labs Studio")
    .font(.arcBrandFont(.title))
```

### Available Typography Tokens

| Token | Maps To |
|-------|---------|
| `.arcLargeTitle` | `.largeTitle` |
| `.arcTitle` | `.title` |
| `.arcTitle2` | `.title2` |
| `.arcTitle3` | `.title3` |
| `.arcHeadline` | `.headline` |
| `.arcSubheadline` | `.subheadline` |
| `.arcBody` | `.body` |
| `.arcCallout` | `.callout` |
| `.arcFootnote` | `.footnote` |
| `.arcCaption` | `.caption` |

## Colors

### Brand Colors

```swift
Color.arcBrandBurgundy  // #722F37
Color.arcBrandGold      // #D4AF37
Color.arcBrandBlack     // #1C1C1E
```

### Semantic Colors

```swift
Color.arcBackgroundPrimary
Color.arcBackgroundSecondary
Color.arcBackgroundTertiary
Color.arcTextTertiary
Color.arcTextQuaternary
Color.arcTextDisabled
```

## Best Practices

### 1. Use Animation Tokens

Instead of custom animations, use the provided tokens:

```swift
// ✓ Good
.arcAnimation(.arcSpring, value: isExpanded)

// ✗ Avoid
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
```

### 2. Respect Reduce Motion

Always consider accessibility:

```swift
// ✓ Good - uses motion-aware modifier
.arcAnimationIfAllowed(.arcBouncy, value: likeCount)

// ✓ Also good - manual check with Environment
withAnimation(reduceMotion ? .none : .arcBouncy) {
    likeCount += 1
}
```

### 3. Use Spacing Tokens

Maintain consistent spacing:

```swift
// ✓ Good
.padding(.arcSpacingMedium)
.cornerRadius(.arcCornerRadiusMedium)

// ✗ Avoid
.padding(16)
.cornerRadius(12)
```

## Migration from Custom Animations

If you're migrating from custom animations to ARCDesignSystem tokens:

| Old Pattern | New Pattern |
|-------------|-------------|
| `.spring(response: 0.3, dampingFraction: 0.7)` | `.arcSpring` |
| `.spring(response: 0.3, dampingFraction: 0.6)` | `.arcBouncy` |
| `.spring(response: 0.35, dampingFraction: 0.8)` | `.arcGentle` |
| `.spring(response: 0.25, dampingFraction: 0.7)` | `.arcSnappy` |
| `.easeInOut(duration: 0.3)` | `.arcStandard` |
| `.easeInOut(duration: 0.15)` | `.arcQuick` |
| `.easeInOut(duration: 0.5)` | `.arcSlow` |

## Topics

### Animation

- ``Animation/arcStandard``
- ``Animation/arcSpring``
- ``Animation/arcBouncy``
- ``Animation/arcGentle``

### Accessibility

- ``ARCAccessibility``
- ``View/arcAnimationIfAllowed(_:value:)``

### Spacing

- ``CGFloat/arcSpacingMedium``
- ``CGFloat/arcCornerRadiusMedium``
