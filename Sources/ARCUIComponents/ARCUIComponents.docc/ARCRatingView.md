# ARCRatingView

A view that displays a numeric rating with multiple visual styles.

## Overview

ARCRatingView provides versatile rating displays optimized for a 1-10 scale, with semantic color gradients and smooth SwiftUI animations. Colors automatically adjust based on the rating value, providing visual feedback from red (poor) to green (excellent).

## Features

- **3 Visual Styles**: Circular gauge, compact inline, and minimal badge
- **Semantic Colors**: Automatic color gradients based on rating value
- **Smooth Animations**: Spring animations on value changes
- **Custom Scales**: Support for any max rating (default: 10)
- **Accessibility**: Full VoiceOver support with meaningful labels
- **Dynamic Type**: Scales appropriately with system font size

## Basic Usage

```swift
import ARCUIComponents

struct ContentView: View {
    var body: some View {
        // Default circular gauge
        ARCRatingView(rating: 8.5)

        // Using configuration presets
        ARCRatingView(rating: 7.0, configuration: .circularGauge)
        ARCRatingView(rating: 6.5, configuration: .compactInline)
        ARCRatingView(rating: 9.2, configuration: .minimal)
    }
}
```

## Visual Styles

### Circular Gauge (Default)

A progress ring with centered number, best for cards and featured content.

```swift
ARCRatingView(rating: 8.5, style: .circularGauge)
// or
ARCRatingView(rating: 8.5, configuration: .circularGauge)
```

### Compact Inline

A mini progress bar with number, ideal for lists and table rows.

```swift
ARCRatingView(rating: 7.2, style: .compactInline)
// or
ARCRatingView(rating: 7.2, configuration: .compactInline)
```

### Minimal

A colored number badge with border, perfect for inline text and badges.

```swift
ARCRatingView(rating: 9.0, style: .minimal)
// or
ARCRatingView(rating: 9.0, configuration: .minimal)
```

## Color Scale

Colors are semantic and change based on the rating percentage:

| Rating | Range | Color | Meaning |
|--------|-------|-------|---------|
| 1-3 | 0-30% | Red/Orange | Poor |
| 3-5 | 30-50% | Orange/Yellow | Fair |
| 5-6.5 | 50-65% | Yellow/Lime | Good |
| 6.5-7.5 | 65-75% | Lime/Light Green | Great |
| 7.5-8.5 | 75-85% | Light/Medium Green | Very Good |
| 8.5-10 | 85-100% | Strong Green | Excellent |

## Configuration Presets

| Preset | Style | Description |
|--------|-------|-------------|
| `.circularGauge` | Circular gauge | Default, for cards and featured content |
| `.compactInline` | Compact inline | For lists and compact spaces |
| `.minimal` | Minimal badge | For inline text and badges |

```swift
// Using presets
ARCRatingView(rating: 8.5, configuration: .circularGauge)
ARCRatingView(rating: 7.0, configuration: .compactInline)
ARCRatingView(rating: 9.2, configuration: .minimal)
```

## Custom Configuration

Create custom configurations for specific needs:

```swift
let customConfig = ARCRatingViewConfiguration(
    style: .circularGauge,
    maxRating: 10.0,
    animated: true
)

ARCRatingView(rating: 8.5, configuration: customConfig)
```

### Disabling Animation

```swift
ARCRatingView(
    rating: 8.0,
    style: .circularGauge,
    animated: false
)
```

### Custom Max Rating

```swift
// 5-point scale
ARCRatingView(rating: 4.5, maxRating: 5.0)

// 100-point scale
ARCRatingView(rating: 85, maxRating: 100)
```

## Common Patterns

### In Restaurant Cards

```swift
HStack {
    VStack(alignment: .leading) {
        Text("La Bella Italia")
            .font(.headline)
        Text("Italian Restaurant")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    Spacer()

    ARCRatingView(rating: 9.2)
}
```

### In List Rows

```swift
List(items) { item in
    HStack {
        Text(item.name)
        Spacer()
        ARCRatingView(rating: item.rating, style: .compactInline)
    }
}
```

### Inline with Text

```swift
HStack(spacing: 4) {
    Text("Rating:")
        .foregroundStyle(.secondary)
    ARCRatingView(rating: 8.7, style: .minimal)
    Text("(234 reviews)")
        .foregroundStyle(.secondary)
}
```

### Rating Overlay on Images

```swift
AsyncImage(url: imageURL) { image in
    image.resizable()
} placeholder: {
    Color.gray
}
.ratingOverlay(8.5)  // Uses minimal style by default
```

## View Modifier

Add rating overlays to any view:

```swift
someView.ratingOverlay(
    8.5,
    style: .minimal,
    alignment: .topTrailing
)
```

## Accessibility

ARCRatingView includes comprehensive accessibility support:

- **VoiceOver Labels**: "Rating: 8.5 out of 10"
- **Dynamic Type**: Scales with system font settings
- **Semantic Colors**: High contrast support

## Topics

### Essentials

- ``ARCRatingView``
- ``ARCRatingStyle``
- ``ARCRatingViewConfiguration``
