# ARCListCard

A versatile card component for displaying content in lists.

## Overview

ARCListCard provides a flexible container for list content, matching patterns found in Music, App Store, Books, and Podcasts with liquid glass effects and rich content support.

![ARCListCard Preview](arclistcard-preview)

## Features

- **Liquid Glass Effect**: Beautiful glassmorphism backgrounds
- **Flexible Images**: Remote URLs, SF Symbols, or custom images
- **Rich Content**: Title, subtitle, and trailing accessories
- **Press Animation**: Smooth scale and opacity feedback
- **Haptic Feedback**: Light impact on tap
- **Accessibility**: Combined element for VoiceOver

## Basic Usage

```swift
import ARCUIComponents

// Simple card
ARCListCard(
    title: "Song Title",
    subtitle: "Artist Name"
) {
    playSong()
}

// Card with image
ARCListCard(
    image: .system("music.note", color: .pink),
    title: "Album Name",
    subtitle: "Artist • 2024"
) {
    showAlbumDetails()
}
```

## Image Options

### SF Symbol

```swift
ARCListCard(
    image: .system("music.note", color: .pink),
    title: "Music Track",
    subtitle: "Artist Name"
)
```

### Remote URL

```swift
ARCListCard(
    image: .url(URL(string: "https://example.com/album.jpg")!),
    title: "Album Title",
    subtitle: "Artist Name"
)
```

### Custom Image

```swift
ARCListCard(
    image: .custom(Image("album-cover"), size: 60),
    title: "Custom Album",
    subtitle: "Artist Name"
)
```

## Configuration Presets

### Default

```swift
ARCListCard(
    configuration: .default,  // Translucent background
    title: "Default Card"
)
```

### Prominent

```swift
ARCListCard(
    configuration: .prominent,  // Liquid glass effect
    title: "Prominent Card"
)
```

### Glassmorphic

```swift
ARCListCard(
    configuration: .glassmorphic,  // Apple Music style
    title: "Glassmorphic Card"
)
```

## With Accessories

Add trailing views like buttons or indicators:

```swift
ARCListCard(
    image: .system("music.note", color: .pink),
    title: "Song Title",
    subtitle: "Artist Name",
    accessories: {
        ARCFavoriteButton(isFavorite: $isFavorite)
    }
) {
    playSong()
}
```

### Multiple Accessories

```swift
ARCListCard(
    title: "Track Name",
    subtitle: "Album • Artist",
    accessories: {
        HStack(spacing: 12) {
            ARCFavoriteButton(isFavorite: $isFavorite, size: .small)

            Image(systemName: "ellipsis")
                .foregroundStyle(.secondary)
        }
    }
)
```

## Common Patterns

### Music Library

```swift
ForEach(songs) { song in
    ARCListCard(
        configuration: .prominent,
        image: .url(song.artworkURL),
        title: song.title,
        subtitle: song.artist,
        accessories: {
            ARCFavoriteButton(
                isFavorite: binding(for: song)
            )
        }
    ) {
        playSong(song)
    }
}
```

### Podcast Episodes

```swift
ARCListCard(
    image: .system("mic.fill", color: .purple),
    title: "Episode Title",
    subtitle: "45 min • Published today",
    accessories: {
        Image(systemName: "play.circle.fill")
            .font(.title2)
            .foregroundStyle(.blue)
    }
) {
    playEpisode()
}
```

### App Store Style

```swift
ARCListCard(
    configuration: .glassmorphic,
    image: .custom(appIcon, size: 60),
    title: "App Name",
    subtitle: "Category • Free",
    accessories: {
        Button("GET") {
            downloadApp()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
    }
)
```

## Custom Configuration

```swift
let customConfig = ARCListCardConfiguration(
    backgroundStyle: .liquidGlass,
    cornerRadius: 20,
    shadow: .prominent,
    spacing: 16
)

ARCListCard(
    configuration: customConfig,
    title: "Custom Card"
)
```

## Accessibility

ARCListCard provides comprehensive accessibility:

- **Combined Element**: Title, subtitle, and image combined for VoiceOver
- **Button Trait**: Added when action is provided
- **Dynamic Type**: Text scales appropriately

## Topics

### Essentials

- ``ARCListCard``
- ``ARCListCardConfiguration``

### Image Types

- ``ARCListCard/CardImage``

### Configuration

- ``ARCListCardConfiguration/default``
- ``ARCListCardConfiguration/prominent``
- ``ARCListCardConfiguration/glassmorphic``

### Examples

- ``ARCListCardShowcase``
