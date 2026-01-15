# Changelog

All notable changes to ARCUIComponents will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
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
