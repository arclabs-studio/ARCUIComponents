# ARCRatingInputView

An interactive view for selecting a rating from 1 to 10 with 0.5 increments.

## Overview

ARCRatingInputView provides a user-friendly way to select ratings on a 1-10 scale with 0.5 step increments (19 possible values). It offers two interaction styles: a traditional slider or an innovative circular drag gesture.

## Features

- **1-10 Scale**: Fixed scale with 0.5 increments (1, 1.5, 2, 2.5, ... 9.5, 10)
- **2 Interaction Styles**: Slider or circular drag
- **Semantic Colors**: Automatic color gradients based on rating value
- **Smooth Animations**: Spring animations on value changes
- **Haptic Feedback**: Sensory feedback when changing values (circular drag)
- **Accessibility**: Full VoiceOver support with adjustable trait

## Basic Usage

```swift
import ARCUIComponents

struct ContentView: View {
    @State private var rating: Double = 5.0

    var body: some View {
        // Slider style (default)
        ARCRatingInputView(rating: $rating)

        // Circular drag style
        ARCRatingInputView(rating: $rating, style: .circularDrag)
    }
}
```

## Interaction Styles

### Slider Style (Default)

A horizontal slider below the circular gauge. Best for forms and precise selection.

```swift
ARCRatingInputView(rating: $rating, style: .slider)
// or
ARCRatingInputView(rating: $rating, configuration: .slider)
```

### Circular Drag Style

Drag directly on the circular gauge to select. Best for compact spaces and visual experiences.

```swift
ARCRatingInputView(rating: $rating, style: .circularDrag)
// or
ARCRatingInputView(rating: $rating, configuration: .circularDrag)
```

The circular drag style includes:
- Visual indicator that follows the drag
- Haptic feedback on value changes
- Scale animation when dragging

## Available Values

The component provides 19 possible rating values:

| Values |
|--------|
| 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5 |
| 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10 |

## Configuration Presets

| Preset | Style | Label | Description |
|--------|-------|-------|-------------|
| `.slider` | Slider | Yes | Default, for forms |
| `.circularDrag` | Circular drag | Yes | For visual experiences |
| `.compact` | Circular drag | No | For tight spaces |

```swift
// Using presets
ARCRatingInputView(rating: $rating, configuration: .slider)
ARCRatingInputView(rating: $rating, configuration: .circularDrag)
ARCRatingInputView(rating: $rating, configuration: .compact)
```

## Custom Configuration

Create custom configurations:

```swift
let customConfig = ARCRatingInputConfiguration(
    style: .circularDrag,
    showLabel: true,
    animated: true
)

ARCRatingInputView(rating: $rating, configuration: customConfig)
```

### Hiding the Label

```swift
ARCRatingInputView(
    rating: $rating,
    style: .circularDrag,
    showLabel: false
)
```

### Disabling Animation

```swift
ARCRatingInputView(
    rating: $rating,
    style: .slider,
    animated: false
)
```

## Common Patterns

### Review Form

```swift
struct ReviewForm: View {
    @State private var foodRating: Double = 7.0
    @State private var serviceRating: Double = 7.0
    @State private var ambianceRating: Double = 7.0

    var body: some View {
        Form {
            Section("Rate Your Experience") {
                LabeledContent("Food Quality") {
                    ARCRatingInputView(
                        rating: $foodRating,
                        configuration: .compact
                    )
                }

                LabeledContent("Service") {
                    ARCRatingInputView(
                        rating: $serviceRating,
                        configuration: .compact
                    )
                }

                LabeledContent("Ambiance") {
                    ARCRatingInputView(
                        rating: $ambianceRating,
                        configuration: .compact
                    )
                }
            }
        }
    }
}
```

### Quick Rating Selection

```swift
struct QuickRating: View {
    @State private var rating: Double = 5.0

    var body: some View {
        VStack {
            Text("How was your experience?")
                .font(.headline)

            ARCRatingInputView(rating: $rating, style: .circularDrag)

            Button("Submit") {
                submitRating(rating)
            }
        }
    }
}
```

### Inline Rating in List

```swift
List(items) { item in
    HStack {
        Text(item.name)
        Spacer()
        ARCRatingInputView(
            rating: $item.rating,
            configuration: .compact
        )
        .scaleEffect(0.7)
    }
}
```

## Color Scale

Colors are semantic and match ARCRatingView:

| Rating | Range | Color | Meaning |
|--------|-------|-------|---------|
| 1-3 | 10-30% | Red/Orange | Poor |
| 3-5 | 30-50% | Orange/Yellow | Fair |
| 5-6.5 | 50-65% | Yellow/Lime | Good |
| 6.5-7.5 | 65-75% | Lime/Light Green | Great |
| 7.5-8.5 | 75-85% | Light/Medium Green | Very Good |
| 8.5-10 | 85-100% | Strong Green | Excellent |

## Accessibility

ARCRatingInputView includes comprehensive accessibility support:

- **Adjustable Trait**: VoiceOver users can swipe up/down to change values
- **Value Announcements**: "5.5 out of 10"
- **Semantic Labels**: "Rating selector"
- **Dynamic Type**: Scales with system font settings

## Comparison with ARCRatingView

| Feature | ARCRatingView | ARCRatingInputView |
|---------|---------------|-------------------|
| Purpose | Display rating | Select rating |
| Binding | Value (read-only) | Binding (read-write) |
| Scale | Customizable | Fixed 1-10 |
| Step | Any | 0.5 |
| Interaction | None | Slider/Drag |

## Topics

### Essentials

- ``ARCRatingInputView``
- ``ARCRatingInputStyle``
- ``ARCRatingInputConfiguration``
