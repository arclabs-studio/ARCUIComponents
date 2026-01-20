# ARCFavoriteButton

An animated toggle button for marking content as favorite.

## Overview

ARCFavoriteButton provides a delightful interaction for toggling favorite state, matching the interaction patterns found in Music, Podcasts, Books, and other Apple apps.

## Features

- **Symbol Effect**: iOS 17+ bounce animations on toggle
- **Gradient Colors**: Beautiful gradient fills
- **Icon Presets**: Heart, star, bookmark, flag, or custom icons
- **Haptic Feedback**: Tactile response on toggle
- **Accessibility**: Full VoiceOver support
- **HIG Compliant**: 44x44pt minimum touch target

## Basic Usage

```swift
import ARCUIComponents

struct ContentView: View {
    @State private var isFavorite = false

    var body: some View {
        ARCFavoriteButton(isFavorite: $isFavorite)
    }
}
```

## Icon Presets

```swift
// Heart (default) - Music, Photos style
ARCFavoriteButton(isFavorite: $isFavorite, icon: .heart, color: .pink)

// Star - Ratings, highlights
ARCFavoriteButton(isFavorite: $isStarred, icon: .star, color: .yellow)

// Bookmark - Reading lists, saved items
ARCFavoriteButton(isFavorite: $isBookmarked, icon: .bookmark, color: .blue)

// Flag - Important items
ARCFavoriteButton(isFavorite: $isFlagged, icon: .flag, color: .orange)

// Custom SF Symbol pair
ARCFavoriteButton(
    isFavorite: $isLiked,
    icon: .custom(filled: "hand.thumbsup.fill", empty: "hand.thumbsup"),
    color: .blue
)
```

## Size Options

| Size | Icon Size | Touch Target |
|------|-----------|--------------|
| `.small` | 20pt | 44pt |
| `.medium` | 24pt | 44pt |
| `.large` | 28pt | 48pt |
| `.custom(CGFloat)` | Custom | Auto (min 44pt) |

```swift
// Different sizes
ARCFavoriteButton(isFavorite: $fav, size: .small)
ARCFavoriteButton(isFavorite: $fav, size: .medium)
ARCFavoriteButton(isFavorite: $fav, size: .large)
ARCFavoriteButton(isFavorite: $fav, size: .custom(32))
```

## Callback on Toggle

```swift
ARCFavoriteButton(isFavorite: $isFavorite) { newValue in
    // Handle favorite state change
    saveFavoriteState(newValue)
}
```

## Disabling Haptics

```swift
ARCFavoriteButton(
    isFavorite: $isFavorite,
    haptics: false
)
```

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

### Multiple Icon Types

```swift
HStack(spacing: 20) {
    ARCFavoriteButton(isFavorite: $heart, icon: .heart, color: .pink)
    ARCFavoriteButton(isFavorite: $star, icon: .star, color: .yellow)
    ARCFavoriteButton(isFavorite: $bookmark, icon: .bookmark, color: .blue)
    ARCFavoriteButton(isFavorite: $flag, icon: .flag, color: .orange)
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
- ``ARCFavoriteButton/Icon``
- ``ARCFavoriteButton/Size``
