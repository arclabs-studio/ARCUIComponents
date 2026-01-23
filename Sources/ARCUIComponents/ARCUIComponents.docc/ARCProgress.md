# ARCProgress

Progress indicators for showing task completion and multi-step processes.

## Overview

`ARCProgress` provides a comprehensive set of progress indicators following Apple's Human Interface Guidelines. The components help users understand that your app isn't stalled while loading content or performing lengthy operations.

Per Apple HIG: "Progress indicators let people know that your app isn't stalled while it loads content or performs lengthy operations. Use determinate indicators when duration is known, and indeterminate when it's unknown."

## Components

ARCProgress includes three main components:

- **ARCLinearProgress**: Horizontal progress bars for file downloads, uploads, and general progress
- **ARCCircularProgress**: Circular indicators and spinners for loading states
- **ARCStepIndicator**: Multi-step indicators for wizards, checkouts, and onboarding flows

## Features

- **Determinate & Indeterminate**: Support for both known and unknown progress
- **Smooth Animations**: Native-feeling transitions with respect for reduced motion
- **Multiple Variants**: Various sizes, colors, and styles
- **Full Accessibility**: VoiceOver announces progress changes
- **Step Tracking**: Visual representation of multi-step processes

## Usage

### Linear Progress

```swift
// Indeterminate (loading)
ARCLinearProgress()

// Determinate with progress
ARCLinearProgress(progress: 0.65)

// With percentage label
ARCLinearProgress(
    progress: downloadProgress,
    configuration: .withPercentage
)

// Different heights
ARCLinearProgress(progress: 0.5, configuration: .thin)
ARCLinearProgress(progress: 0.5, configuration: .thick)
```

### Circular Progress

```swift
// Spinner (indeterminate)
ARCCircularProgress()

// With progress value
ARCCircularProgress(progress: 0.75)

// With centered percentage
ARCCircularProgress(
    progress: 0.75,
    configuration: .labeledProgress
)

// Different sizes
ARCCircularProgress(configuration: .small)
ARCCircularProgress(configuration: .large)
```

### Step Indicator

```swift
// Basic numbered steps
ARCStepIndicator(totalSteps: 4, currentStep: 2)

// Compact dots (for onboarding)
ARCStepIndicator(
    totalSteps: 5,
    currentStep: 3,
    configuration: .compact
)

// With icons (for checkout)
ARCStepIndicator(
    totalSteps: 4,
    currentStep: 2,
    configuration: .withIcons([
        "cart.fill",
        "truck.box.fill",
        "creditcard.fill",
        "checkmark.seal.fill"
    ])
)

// Vertical with labels
ARCStepIndicator(
    totalSteps: 4,
    currentStep: 2,
    configuration: .detailed(labels: [
        "Account",
        "Shipping",
        "Payment",
        "Review"
    ])
)
```

## Configuration Presets

### Linear Progress

| Preset | Description |
|--------|-------------|
| `.default` | 4pt height, rounded corners |
| `.thin` | 2pt height, subtle |
| `.thick` | 8pt height, prominent |
| `.glass` | Translucent track, white progress |
| `.withPercentage` | Shows numeric percentage |

### Circular Progress

| Preset | Description |
|--------|-------------|
| `.default` | 40pt diameter |
| `.small` | 20pt diameter |
| `.large` | 60pt diameter |
| `.labeledProgress` | 60pt with centered percentage |
| `.spinner` | Fast rotation for loading |

### Step Indicator

| Preset | Description |
|--------|-------------|
| `.default` | Numbered, horizontal |
| `.compact` | Small dots, minimal |
| `.detailed(labels:)` | Vertical with text labels |
| `.withIcons(_:)` | SF Symbols for each step |

## Custom Configuration

Create custom configurations for specific needs:

```swift
// Custom linear progress
let linearConfig = ARCLinearProgressConfiguration(
    height: 6,
    trackColor: .gray.opacity(0.2),
    progressColor: .green,
    showPercentage: true
)

// Custom circular progress
let circularConfig = ARCCircularProgressConfiguration(
    size: .custom(50),
    lineWidth: 6,
    progressColor: .purple,
    lineCap: .round,
    showPercentage: true
)

// Custom step indicator
let stepConfig = ARCStepIndicatorConfiguration(
    style: .numbered,
    stepSize: 32,
    completedColor: .green,
    currentColor: .blue,
    animateCompletion: true
)
```

## Real-World Examples

### File Download

```swift
HStack(spacing: 12) {
    Image(systemName: "doc.fill")
    VStack(alignment: .leading) {
        Text(file.name)
        ARCLinearProgress(
            progress: file.downloadProgress,
            configuration: .thin
        )
    }
    Text("\(Int(file.downloadProgress * 100))%")
}
```

### Checkout Flow

```swift
VStack {
    ARCStepIndicator(
        totalSteps: 4,
        currentStep: checkoutStep,
        configuration: .withIcons([
            "cart.fill",
            "truck.box.fill",
            "creditcard.fill",
            "checkmark.seal.fill"
        ])
    )

    // Current step content
    CheckoutStepView(step: checkoutStep)

    // Navigation
    HStack {
        Button("Back") { checkoutStep -= 1 }
        Button("Continue") { checkoutStep += 1 }
    }
}
```

### Loading Overlay

```swift
ZStack {
    ContentView()
        .blur(radius: isLoading ? 3 : 0)

    if isLoading {
        VStack(spacing: 16) {
            ARCCircularProgress()
            Text("Loading...")
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 16))
    }
}
```

## Topics

### Linear Progress

- ``ARCLinearProgress``
- ``ARCLinearProgressConfiguration``

### Circular Progress

- ``ARCCircularProgress``
- ``ARCCircularProgressConfiguration``

### Step Indicator

- ``ARCStepIndicator``
- ``ARCStepIndicatorConfiguration``

### Showcases

- ``ARCProgressShowcase``
