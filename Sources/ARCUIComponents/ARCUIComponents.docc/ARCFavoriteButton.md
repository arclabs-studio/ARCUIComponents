# ARCFavoriteButton

An animated toggle button for marking content as favorite.

## Overview

ARCFavoriteButton provides a delightful interaction for toggling favorite state, matching the interaction patterns found in Music, Podcasts, Books, and other Apple apps.

![ARCFavoriteButton Preview](arcfavoritebutton-preview)

## Features

- **Spring Animation**: Smooth bounce effect when toggling
- **Symbol Effect**: iOS 17+ symbol animations
- **Haptic Feedback**: Tactile response on toggle
- **Gradient Colors**: Beautiful gradient fills
- **Accessibility**: Full VoiceOver support
- **HIG Compliant**: 44x44pt minimum touch target

## Basic Usage

```swift
import ARCUIComponents

struct ContentView: View {
    @State private var isFavorite = false

    var body: some View {
        ARCFavoriteButton(
            isFavorite: $isFavorite,
            favoriteColor: .pink
        ) { newValue in
            // Handle favorite state change
            saveFavoriteState(newValue)
        }
    }
}
```

## Configuration

### Using Presets

```swift
// Default (pink, medium size)
ARCFavoriteButton(
    isFavorite: $isFavorite,
    configuration: .default
)

// Large size
ARCFavoriteButton(
    isFavorite: $isFavorite,
    configuration: .large
)

// Subtle (small, muted)
ARCFavoriteButton(
    isFavorite: $isFavorite,
    configuration: .subtle
)
```

### Custom Configuration

```swift
let config = ARCFavoriteButtonConfiguration(
    favoriteIcon: "star.fill",      // Custom filled icon
    unfavoriteIcon: "star",         // Custom empty icon
    favoriteColor: .yellow,         // Favorited color
    unfavoriteColor: .gray,         // Unfavorited color
    size: .large,                   // Button size
    animationDuration: 0.3,         // Animation speed
    hapticFeedback: true            // Enable haptics
)

ARCFavoriteButton(
    isFavorite: $isFavorite,
    configuration: config
)
```

### Size Options

| Size | Icon Size | Touch Target |
|------|-----------|--------------|
| `.small` | 20pt | 44pt |
| `.medium` | 24pt | 44pt |
| `.large` | 28pt | 48pt |
| `.custom(CGFloat)` | Custom | Auto (min 44pt) |

## Common Patterns

### In List Rows

```swift
List(songs) { song in
    HStack {
        Text(song.title)
        Spacer()
        ARCFavoriteButton(
            isFavorite: binding(for: song),
            size: .small
        )
    }
}
```

### With ARCListCard

```swift
ARCListCard(
    image: .system("music.note", color: .pink),
    title: "Song Title",
    subtitle: "Artist Name",
    accessories: {
        ARCFavoriteButton(isFavorite: $isFavorite)
    }
)
```

### Multiple Colors

```swift
HStack(spacing: 20) {
    ARCFavoriteButton(
        isFavorite: $isHeart,
        favoriteColor: .pink
    )

    ARCFavoriteButton(
        isFavorite: $isStar,
        configuration: ARCFavoriteButtonConfiguration(
            favoriteIcon: "star.fill",
            unfavoriteIcon: "star",
            favoriteColor: .yellow
        )
    )

    ARCFavoriteButton(
        isFavorite: $isBookmark,
        configuration: ARCFavoriteButtonConfiguration(
            favoriteIcon: "bookmark.fill",
            unfavoriteIcon: "bookmark",
            favoriteColor: .blue
        )
    )
}
```

## Accessibility

ARCFavoriteButton includes comprehensive accessibility support:

- **VoiceOver Labels**: "Favorited" or "Not favorited"
- **Hints**: "Tap to add to/remove from favorites"
- **Button Trait**: Properly identified as interactive
- **Dynamic Type**: Scales appropriately

## Topics

### Essentials

- ``ARCFavoriteButton``
- ``ARCFavoriteButtonConfiguration``

### Configuration

- ``ARCFavoriteButtonConfiguration/ButtonSize``
- ``ARCFavoriteButtonConfiguration/default``
- ``ARCFavoriteButtonConfiguration/large``
- ``ARCFavoriteButtonConfiguration/subtle``

### Examples

- ``ARCFavoriteButtonShowcase``
