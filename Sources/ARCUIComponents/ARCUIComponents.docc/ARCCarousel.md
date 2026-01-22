# ARCCarousel

A customizable horizontal carousel component for showcasing content.

## Overview

`ARCCarousel` provides a smooth, native-feeling carousel experience with support for snapping, page indicators, auto-scroll, and visual effects. It's perfect for featured content, image galleries, card collections, and stories-style displays.

The component follows Apple's design patterns as seen in the App Store featured apps, Netflix content rows, and Photos app memories.

## Features

- **Multiple item sizing modes**: Full width, fractional (peek effect), or fixed width
- **Configurable snap behavior**: None, item-based, or page-based snapping
- **Indicator styles**: Dots, lines, or numbers
- **Auto-scroll**: Optional automatic advancement with pause on interaction
- **Scale effects**: Visual emphasis on centered items
- **Full accessibility**: VoiceOver support with adjustable actions

## Usage

### Basic Carousel

```swift
ARCCarousel(items) { item in
    CardView(item: item)
}
```

### Featured Carousel with Auto-scroll

```swift
ARCFeaturedCarousel(banners) { banner in
    BannerView(banner: banner)
}
```

### With Current Index Binding

```swift
@State private var currentPage = 0

ARCCarousel(
    items,
    currentIndex: $currentPage,
    configuration: .featured
) { item in
    ItemView(item: item)
}
```

### Card Gallery

```swift
ARCCarousel(
    restaurants,
    configuration: .cards
) { restaurant in
    RestaurantCard(restaurant: restaurant)
}
```

## Configuration Presets

ARCCarousel provides several built-in presets:

| Preset | Description |
|--------|-------------|
| `.default` | 85% width with peek, item snapping, dots |
| `.featured` | 90% width, auto-scroll, scale effect |
| `.gallery` | 75% width, prominent scale effect |
| `.cards` | Fixed 280pt cards, multiple visible |
| `.stories` | Small 80pt items, free scroll |
| `.paging` | Full width, line indicators |

## Custom Configuration

Create a custom configuration for specific needs:

```swift
let customConfig = ARCCarouselConfiguration(
    itemSize: .fractional(0.75),
    itemSpacing: 20,
    snapBehavior: .item,
    autoScrollEnabled: true,
    autoScrollInterval: 5,
    indicatorStyle: .dots,
    indicatorPosition: .bottom(offset: 16),
    scaleEffect: .default
)

ARCCarousel(items, configuration: customConfig) { item in
    ContentView(item: item)
}
```

## Topics

### Main Components

- ``ARCCarousel``
- ``ARCFeaturedCarousel``

### Configuration

- ``ARCCarouselConfiguration``
- ``ARCCarouselConfiguration/ItemSize``
- ``ARCCarouselConfiguration/SnapBehavior``
- ``ARCCarouselConfiguration/IndicatorStyle``
- ``ARCCarouselConfiguration/IndicatorPosition``
- ``ARCCarouselConfiguration/ScaleEffect``

### Showcases

- ``ARCCarouselShowcase``
