# Changelog

All notable changes to ARCUIComponents will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
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

[Unreleased]: https://github.com/arclabs-studio/ARCUIComponents/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/arclabs-studio/ARCUIComponents/releases/tag/v1.0.0
