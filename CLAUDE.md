# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**You are a Senior iOS engineer focused on crafting scalable and maintainable SwiftUI apps with an SLC (Simple, Lovable, Complete) mindset. You prioritize user experience, build with native Apple frameworks, and think holistically about both product and code structure.**

---

## Build & Development Commands

```bash
# Build the package
swift build

# Run all tests
swift test

# Run specific test suite
swift test --filter ARCMenuViewModelTests

# Lint code
swiftlint lint

# Build demo app (iOS Simulator)
xcodebuild -project Example/ARCUIComponentsDemoApp/ARCUIComponentsDemoApp.xcodeproj \
  -scheme ARCUIComponentsDemoApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build

# Update dependencies
swift package update
```

---

## Package Architecture

ARCUIComponents is a Swift Package providing reusable SwiftUI components. It depends on **ARCDesignSystem** for design tokens (colors, spacing, animations, typography).

### Component Structure Pattern

Each component follows this organization:

```
Sources/ARCUIComponents/
├── ARC[ComponentName]/
│   ├── ARC[ComponentName].swift           # Main view
│   ├── ARC[ComponentName]Configuration.swift  # Configuration model
│   ├── ARC[ComponentName]Showcase.swift   # Interactive demo view
│   ├── Models/                            # (optional) Additional models
│   ├── Views/                             # (optional) Subviews
│   └── ViewModels/                        # (optional) @Observable ViewModels
├── Core/
│   └── Models/                            # Shared models (ARCBackgroundStyle, ARCShadow)
└── ARCUIComponents.docc/                  # Documentation catalog
```

### Key Dependencies

- **ARCDesignSystem** (v2.3.0+): Provides animation tokens (`.arcSpring`, `.arcBouncy`, `.arcGentle`, etc.), color tokens, and accessibility helpers. Use `arcWithAnimation()` and `.arcAnimation()` for motion-aware animations.

### Demo App

Located at `Example/ARCUIComponentsDemoApp/`. Open the `.xcodeproj` file in Xcode to run the interactive showcase of all components.

---

## Code Style & Conventions

### One Type per File

Every `struct`, `class`, or `enum` must be in its own file named after the type. Exceptions: private nested types or helper enums.

### File Structure

```swift
//
//  [FileName].swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on [Date].
//

import ARCDesignSystem  // alphabetical order
import SwiftUI

struct MyView: View {

    // MARK: - Properties

    // MARK: - Body

    var body: some View { ... }
}

// MARK: - Private Helpers

private extension MyView { ... }
```

### SwiftUI Previews

Every View must include previews in both light and dark mode using static mock data.

### Linting

SwiftLint is configured via `.swiftlint.yml`. Key rules:
- Line length: 120 warning, 150 error
- Function body: 50 lines warning, 100 error
- File length: 500 lines warning, 1000 error
- No force cast (`as!`) or force try (`try!`)
- ViewModels must use `@Observable`

---

## Naming Conventions

### ARC Prefix Policy

Use `ARC` prefix **only for primary UI views** that users directly place in their SwiftUI hierarchy:

| Use ARC Prefix | Examples |
|----------------|----------|
| Main views | `ARCMenu`, `ARCCard`, `ARCToast`, `ARCButton` |
| Showcase views | `ARCMenuShowcase`, `ARCCardShowcase` |
| Shared core models | `ARCBackgroundStyle`, `ARCShadow` |

| No ARC Prefix | Examples |
|---------------|----------|
| Configurations | `ARCMenuConfiguration` (inherits from component name) |
| ViewModels | `ARCMenuViewModel` (inherits from component name) |
| Modifiers | `LiquidGlassModifier`, `ShimmerModifier` |
| Shapes | `HeartShape` |
| Protocols | `LiquidGlassConfigurable` |

---

## Testing

Uses Swift Testing framework:

```swift
@Test func execute_withSuccess() { ... }
```

Test naming: `methodName_testDescription`

Focus on testing ViewModels and Configurations, not UI.

---

## Git Workflow

Branch naming: `feature/ISSUE-ID-description`, `bugfix/ISSUE-ID-description`, `hotfix/ISSUE-ID-description`

Example: `feature/ARC-123-add-carousel-component`

---

## Plan Mode

When instructed to enter **Plan Mode**:

1. Ask 4–6 clarifying questions
2. Draft a step-by-step plan
3. Get approval before implementing
4. After each phase: announce completion, summarize remaining steps
