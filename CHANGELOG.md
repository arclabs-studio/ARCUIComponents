# Changelog

All notable changes to ARCUIComponents will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.9.1] - 2026-01-29

### Fixed
- **ARCMenu Presentation Bug**: Fixed critical bug where `.arcMenu(viewModel:)` deprecated modifier
  used `.constant()` binding, preventing the menu from opening when using `ARCMenuButton`

### Changed
- **ARCMenuButton Refactored for External Binding Pattern**:
  - New primary initializer: `init(isPresented: Binding<Bool>, viewModel:, showsBadge:, badgeCount:)`
  - Button now toggles the external `isPresented` binding instead of ViewModel's internal state
  - Deprecated initializer maintains backward compatibility with proper binding wrapper
  - Animation now observes external `isPresented` for rotation effect

- **New Toolbar Modifier**:
  - Added `.arcMenuToolbarButton(isPresented:viewModel:showsBadge:badgeCount:)`
  - Deprecated `.arcMenuButton(viewModel:)` - use new modifier with binding instead

- **ARCMenuLegacyModifier**: New internal modifier that properly wraps ViewModel's deprecated
  `isPresented` state into a working `Binding<Bool>` for backward compatibility

### Documentation
- Updated `ARCMenu.swift` with comprehensive usage examples
- Updated `ARCMenuShowcase.swift` integration guide with v1.9.1 patterns
- Demo app `ARCMenuDemoScreen` updated to use new `ARCMenuButton(isPresented:viewModel:)` API
- Added architecture integration examples (plain SwiftUI, Coordinator, TCA, etc.)
- Added inline documentation explaining the external binding pattern

### Migration Guide

**Before (v1.9.0 - deprecated, but now works)**:
```swift
@State var viewModel = ARCMenuViewModel(...)

var body: some View {
    ContentView()
        .arcMenuButton(viewModel: viewModel)
        .arcMenu(viewModel: viewModel)
}
```

**After (v1.9.1 - recommended)**:
```swift
@State var showMenu = false
@State var viewModel = ARCMenuViewModel(...)

var body: some View {
    NavigationStack {
        ContentView()
            .arcMenuToolbarButton(
                isPresented: $showMenu,
                viewModel: viewModel
            )
    }
    .arcMenu(isPresented: $showMenu, viewModel: viewModel)
}
```

## [1.9.0] - 2026-01-29

### Changed
- **ARCMenu Refactored for Native iOS/macOS Feel**:
  - Simplified `ARCMenuConfiguration` to use native `.sheet()` presentation
  - Removed `LiquidGlassConfigurable` conformance (uses native Material)
  - Removed custom backdrop, blur, and animation properties
  - Reduced configuration to essential properties: `accentColor`, `itemSpacing`, `sectionSpacing`
  - Configuration presets reduced to `.default`, `.fitness`, `.minimal`, `.dark`
  - Removed `.premium` and `.trailingPanel` presets

- **ARCMenuItem Enhanced with Factory Methods**:
  - Added factory methods for common menu items: `.profile()`, `.settings()`, `.help()`, `.logout()`
  - Added `.customIcon()` factory for custom SF Symbol icons
  - Simplified item creation API

- **ARCMenuViewModel Simplified**:
  - Removed complex drag gesture handling (uses native sheet gestures)
  - Removed backdrop tap dismiss logic (handled by sheet)
  - Cleaner state management focused on menu presentation

- **ARCMenuItemRow Improved**:
  - Icons now use accent color directly without background circles
  - Reduced icon size to 24x24 for cleaner native appearance
  - Better alignment with Apple HIG

### Added
- `ARCMenuActions`: New model for encapsulating menu action callbacks
- `ARCMenuIconStyle`: Enum for icon rendering styles (`.subtle`, `.prominent`)
- `ARCMenu+Previews.swift`: Extracted previews to separate file

### Documentation
- Updated `ARCMenu.md` DocC documentation with simplified API
- Improved code examples reflecting new native sheet approach
- Updated demo screen with simplified configuration options

### Technical
- Reduced code complexity and file sizes across ARCMenu module
- Better separation of concerns with extracted preview files
- Improved SwiftLint compliance

## [1.8.0] - 2026-01-28

### Added
- **ARCAIRecommender Component**: AI-powered recommendation interface
  - Dual mode support: quick categories and questionnaire modes
  - Type-safe generic architecture
  - Configuration presets: `.default`, `.minimal`, `.compact`
  - Full VoiceOver accessibility support
  - Dark mode support with semantic colors
  - Demo screen with interactive examples
  - Comprehensive DocC documentation

### Changed
- **ARCMenu Icon Styling Simplified**:
  - Icons use accent color directly without background circles
  - Reduced icon size for cleaner native appearance
  - Removed `.prominent` and `.restaurant` presets

- **Modal Close Buttons Updated**:
  - Replaced text "Done"/"Close" buttons with `xmark.circle.fill` icons
  - Better visual consistency following iOS design patterns

### Technical
- Updated ARCDevTools to v2.3.0 (GitHub Actions automation)
- CI migrated to macos-14 runners for better availability
- Optimized CI workflow matrix

## [1.7.0] - 2026-01-28

### Added
- **ARCAIRecommender Component**: AI-powered recommendation interface
  - Dual mode support: quick categories and questionnaire modes
  - `ARCAIRecommender`: Main view with mode switcher tabs
  - `AIRecommenderCategory`: Predefined and custom categories for quick mode
  - `AIRecommenderItem`: Protocol for type-safe displayable items
  - `AIRecommenderQuestion`: Model for single/multiple/slider inputs
  - `AIRecommenderAnswers`: Collection for storing user responses with JSON/Dictionary export
  - `AIRecommenderHeader`: Hero section with animated sparkles icon
  - `AIRecommenderCategoryPicker`: Horizontal scrolling capsule buttons
  - `AIRecommenderItemCard`: Recommendation card with rank badge, image, and rating
  - `AIRecommenderQuestionCard`: Question with chip-based option selection
  - `AIRecommenderQuestionnaire`: Full survey with progress indicator
  - `QuestionFlowLayout`: Custom SwiftUI Layout for wrapping chips
  - `ARCAIRecommenderConfiguration`: Comprehensive configuration system
  - Configuration presets: `.default`, `.restaurant`, `.books`, `.minimal`, `.compact`
  - Full VoiceOver accessibility support
  - Dark mode support with semantic colors
  - Demo screen with interactive examples
  - Comprehensive DocC documentation

- **ARCMenu Icon Styles**:
  - `ARCMenuIconStyle` enum with two options:
    - `.subtle`: Low-opacity background (15%) with primary-colored icon (default)
    - `.prominent`: Dark muted background with accent-colored icon
  - New configuration presets: `.prominent`, `.restaurant`
  - Interactive icon style picker in demo app

### Changed
- Demo app updated with ARCAIRecommender demo screen
- ARCMenu demo enhanced with icon style selector
- Updated ARCUIComponents.md documentation catalog

### Technical
- Refactored ARCAIRecommender previews to separate files for SwiftLint compliance
- Moved showcase sections to extensions to fix type_body_length violations

## [1.6.0] - 2026-01-27

### Added
- **ARCTabView Component**: Tab navigation with iOS 26 Liquid Glass support
  - Native `TabView` wrapper with automatic Liquid Glass detection
  - Fallback styling for iOS 17-25 with translucent materials
  - `ARCTabViewConfiguration` for customization
  - `ARCTabViewStyle` enum for visual variants
  - Demo screen with interactive examples

- **ARCMenu Presentation Styles** (Apple HIG compliant):
  - New `ARCMenuPresentationStyle` enum with two options:
    - `bottomSheet`: Slides up from bottom (Apple standard, default)
    - `trailingPanel`: Slides in from trailing edge (drawer style)
  - New configuration properties for bottomSheet style:
    - `showsGrabber`: Display grabber handle at top (default: true)
    - `showsCloseButton`: Display close button in header (default: true)
    - `sheetTitle`: Optional centered title in header
  - New `.trailingPanel` preset configuration for drawer-style presentation
  - Comprehensive unit tests for `ARCMenuPresentationStyle`

- **Demo App Improvements**:
  - ARC brand colors integration (Burgundy #541311, Gold #FFB42E, Black #000000)
  - Dark mode support with dedicated SwiftUI Previews for all screens
  - Improved code organization following ARCKnowledge standards
  - New `Color+Brand.swift` extension for brand colors
  - Enhanced UI sections with better visual hierarchy
  - Consistent styling across all demo screens
- Comprehensive unit test suite (190 tests across 14 suites)
  - ARCMenuViewModel tests (state, presentation, gestures, factory methods)
  - ARCMenuConfiguration tests (presets, custom init, LiquidGlassConfigurable)
  - ARCMenuItem tests (initialization, factory methods, icon types)
  - ARCMenuUser tests (initialization, Identifiable, Sendable)
  - ARCFavoriteButtonConfiguration tests (sizes, colors, presets)
  - ARCListCardConfiguration tests (background styles, conformances)
  - ARCSearchButtonConfiguration tests (sizes, styles, presets)
  - ARCEmptyStateConfiguration tests (all presets, custom init)
  - ARCShadow and ARCBackgroundStyle tests
- Comprehensive DocC documentation for all components
  - ARCFavoriteButton documentation
  - ARCListCard documentation
  - ARCSearchButton documentation
  - ARCEmptyState documentation
- Standard file headers to all source files
- Technical review document with improvement roadmap
- CHANGELOG file for version tracking

### Changed
- **ARCMenu Component Enhancements**:
  - `ARCMenuConfiguration`: Added `presentationStyle`, `showsGrabber`, `showsCloseButton`, and `sheetTitle` properties
  - `ARCMenu`: Refactored to support both `bottomSheet` and `trailingPanel` presentations with appropriate transitions
  - `ARCMenuViewModel`: Updated drag gesture handling to support both vertical (bottomSheet) and horizontal (trailingPanel) directions
  - Default presentation style changed from trailing panel to bottom sheet (Apple standard)

- **Demo App ARCMenu Screen**:
  - Added presentation style picker (Bottom Sheet / Trailing Panel)
  - Added theme picker (ARC / Fitness / Premium / Dark)
  - Dynamic features card showing style-specific characteristics
  - Real-time configuration updates when switching styles

- **Folder structure renamed for consistency**:
  - `Lists/` → `ARCLists/`
  - `Favorites/` → `ARCFavorites/`
  - `Search/` → `ARCSearch/`
  - `Effects/` → `ARCEffects/`
  - `Utilities/` → `ARCEmptyState/`
  - `Shared/` → `Core/`
- Enhanced inline documentation with DocC markup
- Improved code examples in documentation

### Fixed
- **Demo App Configuration**:
  - Added missing `ARCTabViewDemoScreen.swift` to Xcode project (file existed but was not registered)
  - Removed residual `Examples/` directory (correct path is `Example/ARCUIComponentsDemoApp/`)
  - Updated Package.swift comments to reflect correct demo app path

### Technical
- Enabled `StrictConcurrency` experimental feature for main target and test target
- Updated ARCDevTools submodule to latest version

## [1.0.0] - 2025-11-12

### Added
- **ARCMenu Component**: Premium menu with liquid glass effect
  - `ARCMenu`: Main menu container with animations and gestures
  - `ARCMenuButton`: Trigger button with avatar or icon
  - `ARCMenuUser`: User profile model with flexible avatars
  - `ARCMenuItem`: Menu item model with pre-built common items
  - `ARCMenuConfiguration`: Comprehensive configuration system
  - `ARCMenuViewModel`: Business logic and state management
  - `ARCMenuUserHeader`: User profile section component
  - `ARCMenuItemRow`: HIG-compliant menu item rows
  - Liquid glass effect with ultra-thin materials
  - Smooth spring animations matching Apple's timing curves
  - Drag-to-dismiss gesture with haptic feedback
  - Badge support for notifications and counts
  - Five configuration presets (Default, Fitness, Premium, Dark, Minimal)

- **Interactive Showcase**:
  - `ARCMenuShowcase`: Complete interactive demo
  - Live preview with customization controls
  - Style selector for all presets
  - Code generator for quick implementation
  - Complete gallery view

- **Examples**:
  - `ARCMenuExample`: Integration examples
  - Multiple preview configurations
  - Usage documentation

### Technical
- Swift 6.0 with complete concurrency support
- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+
- Clean Architecture with clear layer separation
- `@Observable` macro for reactive updates
- `@MainActor` for UI thread safety
- Full `Sendable` compliance
- No external dependencies

### Documentation
- Comprehensive README with examples
- Inline code documentation
- Usage guides and best practices
- Architecture documentation

## Release Notes

### Version 1.0.0 - Initial Release

ARCUIComponents launches with its first component: **ARCMenu**, a sophisticated menu component featuring Apple's Liquid Glass effect.

**Highlights**:
- Production-ready code following Apple's HIG
- Professional design matching native iOS apps
- Fully customizable while maintaining consistency
- Type-safe API with Swift 6
- Zero external dependencies
- Comprehensive documentation

**What's Next**:
See [TECHNICAL_REVIEW.md](TECHNICAL_REVIEW.md) for planned improvements and future features.

---

[Unreleased]: https://github.com/arclabs-studio/ARCUIComponents/compare/v1.9.1...HEAD
[1.9.1]: https://github.com/arclabs-studio/ARCUIComponents/compare/v1.9.0...v1.9.1
[1.9.0]: https://github.com/arclabs-studio/ARCUIComponents/releases/tag/v1.9.0
[1.8.0]: https://github.com/arclabs-studio/ARCUIComponents/releases/tag/v1.8.0
[1.7.0]: https://github.com/arclabs-studio/ARCUIComponents/releases/tag/v1.7.0
[1.6.0]: https://github.com/arclabs-studio/ARCUIComponents/releases/tag/v1.6.0
[1.0.0]: https://github.com/arclabs-studio/ARCUIComponents/releases/tag/v1.0.0
