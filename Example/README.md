# ARCUIComponentsDemoApp

This standalone Xcode project demonstrates all features of the ARCUIComponents package in a runnable iOS application.

## Requirements

- Xcode 16.0+
- iOS 17.0+ Simulator or device

## Running the Demo

1. Open the project in Xcode:
   ```bash
   open ARCUIComponentsDemoApp/ARCUIComponentsDemo.xcodeproj
   ```

2. Select an iOS Simulator (iPhone 15 Pro recommended)

3. Press `Cmd + R` to build and run

## Demo Screens

### Components

- **ARCMenu**: Slide-in menu with liquid glass effect, user profile header, drag-to-dismiss gesture, and multiple style presets (Default, Fitness, Premium, Dark)
- **ARCFavoriteButton**: Animated toggle button with haptic feedback, multiple sizes (Small, Medium, Large), icon presets (heart, star, bookmark, flag), and customizable colors
- **ARCListCard**: Versatile list card with system/remote images, custom accessories (badges, toggles), and multiple configurations (Default, Prominent, Subtle)
- **ARCEmptyState**: Empty state views for various scenarios (No Favorites, No Results, No Data, Error, Offline)
- **ARCTabView**: Floating tab bar with Liquid Glass effect (iOS 18+)

### Effects

- **Liquid Glass**: Glassmorphism effect with dynamic backgrounds (Gradient, Image, Solid, Animated)
- **Thematic Artwork**: Themed placeholder views with shimmer animations

### Full Showcases

Each component includes a full showcase view (from the package itself) demonstrating all variants and configurations.

## Architecture

```
Example/
├── README.md
└── ARCUIComponentsDemoApp/
    ├── ARCUIComponentsDemo.xcodeproj  # Xcode project
    ├── ARCUIComponentsDemoApp.swift   # App entry point
    ├── DemoHomeView.swift             # Navigation menu
    ├── Screens/
    │   ├── ARCMenuDemoScreen.swift
    │   ├── ARCFavoriteButtonDemoScreen.swift
    │   ├── ARCListCardDemoScreen.swift
    │   ├── ARCEmptyStateDemoScreen.swift
    │   ├── ARCTabViewDemoScreen.swift
    │   ├── LiquidGlassDemoScreen.swift
    │   └── ThematicArtworkDemoScreen.swift
    └── Resources/
        └── Assets.xcassets
```

## Key Patterns Demonstrated

### Using ARCMenu with View Modifier

```swift
@State private var menuViewModel = ARCMenuViewModel.standard(...)

var body: some View {
    ContentView()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ARCMenuButton(viewModel: menuViewModel)
            }
        }
        .arcMenu(viewModel: menuViewModel)
}
```

### Using ARCFavoriteButton

```swift
@State private var isFavorite = false

// Default heart icon
ARCFavoriteButton(isFavorite: $isFavorite)

// Star icon with custom color
ARCFavoriteButton(
    isFavorite: $isStarred,
    icon: .star,
    color: .yellow,
    size: .large
)

// With callback
ARCFavoriteButton(isFavorite: $isFavorite) { newValue in
    saveFavoriteState(newValue)
}
```

### Using ARCListCard with Accessories

```swift
ARCListCard(
    image: .system("music.note", color: .pink),
    title: "Song Title",
    subtitle: "Artist Name",
    accessories: {
        ARCFavoriteButton(isFavorite: $isFavorite)
    },
    action: {
        playSong()
    }
)
```

### Using ARCEmptyState

```swift
ARCEmptyState(configuration: .noFavorites) {
    navigateToDiscover()
}
```

## Notes

- The demo app is for **iOS only** (not macOS/tvOS/watchOS)
- Uses SwiftUI's native patterns with ARCUIComponents
- Demonstrates the "Liquid Glass" aesthetic throughout

## License

MIT License - see main package LICENSE for details.
