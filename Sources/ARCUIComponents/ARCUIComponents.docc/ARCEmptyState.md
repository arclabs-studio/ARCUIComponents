# ARCEmptyState

A component for displaying informative content when there's nothing to show.

## Overview

Empty states are crucial for user experience, transforming potentially frustrating moments into opportunities for guidance and engagement. ARCEmptyState follows Apple's design patterns as seen in Mail, Photos, Notes, and other system apps.

![ARCEmptyState Preview](arcemptystate-preview)

## Features

- **Clear Iconography**: SF Symbols with hierarchical rendering
- **Informative Text**: Title and supportive message
- **Call to Action**: Optional button to guide users
- **Dynamic Type**: Responsive to accessibility settings
- **Gradient Colors**: Beautiful gradient accents

## Basic Usage

```swift
import ARCUIComponents

// With preset configuration
ARCEmptyState(configuration: .noFavorites) {
    navigateToExplore()
}

// With custom parameters
ARCEmptyState(
    icon: "photo",
    title: "No Photos",
    message: "Add photos to get started",
    actionTitle: "Add Photo",
    showsAction: true
) {
    presentPhotoPicker()
}
```

## Configuration Presets

### No Favorites

For empty favorites lists:

```swift
ARCEmptyState(configuration: .noFavorites) {
    navigateToDiscover()
}
```

- Icon: `heart`
- Title: "No Favorites Yet"
- Message: Encourages exploration
- Accent: Pink

### No Results

For empty search results:

```swift
ARCEmptyState(configuration: .noResults)
```

- Icon: `magnifyingglass`
- Title: "No Results"
- Message: Suggests trying different terms
- No action button

### Error

For error states:

```swift
ARCEmptyState(configuration: .error) {
    retryAction()
}
```

- Icon: `exclamationmark.triangle`
- Title: "Something Went Wrong"
- Action: "Try Again"
- Accent: Orange

### Offline

For no connectivity:

```swift
ARCEmptyState(configuration: .offline) {
    openSettings()
}
```

- Icon: `wifi.slash`
- Title: "No Connection"
- Action: "Settings"
- Accent: Gray

### No Data

For empty data states:

```swift
ARCEmptyState(configuration: .noData)
```

- Icon: `tray`
- Title: "No Data"
- Message: Explains content will appear here
- No action button

## Custom Configuration

```swift
let customConfig = ARCEmptyStateConfiguration(
    icon: "cart",
    iconColor: .orange,
    title: "Your Cart is Empty",
    message: "Add items to your cart to see them here",
    actionTitle: "Start Shopping",
    showsAction: true,
    accentColor: .orange,
    spacing: 24
)

ARCEmptyState(configuration: customConfig) {
    navigateToStore()
}
```

## Common Patterns

### In Lists

```swift
List {
    if items.isEmpty {
        ARCEmptyState(configuration: .noData)
            .listRowBackground(Color.clear)
            .frame(maxWidth: .infinity)
    } else {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}
```

### In Search Results

```swift
if searchResults.isEmpty && !searchText.isEmpty {
    ARCEmptyState(
        icon: "magnifyingglass",
        title: "No Results for \"\(searchText)\"",
        message: "Try searching for something else",
        showsAction: false
    )
} else {
    SearchResultsList(results: searchResults)
}
```

### Error Handling

```swift
switch viewState {
case .loading:
    ProgressView()

case .loaded(let data):
    ContentView(data: data)

case .error:
    ARCEmptyState(configuration: .error) {
        await viewModel.retry()
    }

case .offline:
    ARCEmptyState(configuration: .offline) {
        openWiFiSettings()
    }
}
```

### Favorites Screen

```swift
@ViewBuilder
var body: some View {
    if favorites.isEmpty {
        ARCEmptyState(configuration: .noFavorites) {
            selectedTab = .explore
        }
    } else {
        FavoritesList(favorites: favorites)
    }
}
```

## Accessibility

ARCEmptyState provides comprehensive accessibility:

- **Icon Hidden**: Decorative icon hidden from VoiceOver
- **Combined Content**: Title and message read together
- **Action Button**: Clear label and hint
- **Dynamic Type**: Icon and text scale with user preferences

### Dynamic Type Behavior

| Size Category | Icon Size | Max Width |
|---------------|-----------|-----------|
| xSmall - medium | 64pt | 320pt |
| large - xxLarge | 72pt | 360pt |
| xxxLarge | 80pt | 360pt |
| Accessibility | 88pt | 400pt |

## Best Practices

### Do

- Use concise, helpful messages
- Provide actionable next steps when possible
- Match the empty state to the context
- Use appropriate icons that convey meaning

### Don't

- Blame the user for empty states
- Use technical jargon in messages
- Show actions that won't help resolve the situation
- Overwhelm with too much information

## Topics

### Essentials

- ``ARCEmptyState``
- ``ARCEmptyStateConfiguration``

### Presets

- ``ARCEmptyStateConfiguration/noFavorites``
- ``ARCEmptyStateConfiguration/noResults``
- ``ARCEmptyStateConfiguration/error``
- ``ARCEmptyStateConfiguration/offline``
- ``ARCEmptyStateConfiguration/noData``

### Examples

- ``ARCEmptyStateShowcase``
