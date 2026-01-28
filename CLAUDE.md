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

# Build and test with xcodebuild (iOS Simulator)
xcodebuild -scheme ARCUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  test

# Lint code
swiftlint lint

# Lint with strict mode (CI)
swiftlint --strict

# Build demo app
xcodebuild -project Example/ARCUIComponentsDemoApp/ARCUIComponentsDemoApp.xcodeproj \
  -scheme ARCUIComponentsDemoApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  build

# Update dependencies
swift package update

# Build documentation
xcodebuild docbuild \
  -scheme ARCUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -derivedDataPath ./DerivedData
```

---

## Package Architecture

ARCUIComponents is a Swift Package providing reusable SwiftUI components. It depends on **ARCDesignSystem** for design tokens (colors, spacing, animations, typography).

### Component Structure Pattern

Each component follows this organization:

```
Sources/ARCUIComponents/ARC[ComponentName]/
├── ARC[ComponentName].swift              # Main view
├── ARC[ComponentName]Configuration.swift # Configuration model with presets
├── ARC[ComponentName]Showcase.swift      # Interactive demo view with previews
├── Models/                               # (optional) Supporting models
├── Views/                                # (optional) Subviews
└── ViewModels/                           # (optional) @Observable ViewModels
```

### Key Dependencies

- **ARCDesignSystem** (v2.3.0+): Provides animation tokens, color tokens, and accessibility helpers
  - Animation tokens: `.arcSpring`, `.arcBouncy`, `.arcGentle`, `.arcSnappy`, `.arcQuick`, `.arcSlow`
  - Use `arcWithAnimation()` and `.arcAnimation()` for motion-aware animations
  - Respects Reduce Motion accessibility setting

### Demo App

Located at `Example/ARCUIComponentsDemoApp/`. Open the `.xcodeproj` file in Xcode. Each component has a corresponding `ARC[ComponentName]DemoScreen.swift` in `Screens/`.

---

## Code Style & Conventions

### One Type per File

Every public `struct`, `class`, or `enum` must be in its own file named after the type. Exceptions: private nested types or helper enums used only within that file.

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

// MARK: - [TypeName]

/// DocC documentation with overview and usage examples
@available(iOS 17.0, macOS 14.0, *)
public struct MyView: View {
    // MARK: - Properties

    // MARK: - Body

    public var body: some View { ... }
}

// MARK: - Private Helpers

private extension MyView { ... }
```

### SwiftUI Previews

Every View must include `#Preview` macros in both light and dark mode using static mock data.

### Linting

SwiftLint is configured via `.swiftlint.yml`. Key rules:
- Line length: 120 warning, 150 error
- Function body: 50 lines warning, 100 error
- File length: 500 lines warning, 1000 error
- No force cast (`as!`) or force try (`try!`) - both are errors
- ViewModels must use `@Observable` (custom rule)

Use `// swiftlint:disable` sparingly and only when necessary (e.g., SwiftFormat conflicts).

---

## Naming Conventions

### ARC Prefix Policy

Use `ARC` prefix for **all public types** in this package:

| Category | Examples |
|----------|----------|
| Main views | `ARCMenu`, `ARCCard`, `ARCToast`, `ARCButton` |
| Configurations | `ARCMenuConfiguration`, `ARCCardConfiguration` |
| Showcase views | `ARCMenuShowcase`, `ARCCardShowcase` |
| ViewModels | `ARCMenuViewModel` |
| Shared models | `ARCBackgroundStyle`, `ARCShadow` |

**No ARC prefix** for internal/private types:

| Category | Examples |
|----------|----------|
| View modifiers | `LiquidGlassModifier`, `ShimmerModifier` |
| Shapes | `HeartShape` |
| Internal protocols | `LiquidGlassConfigurable` |
| Supporting enums | `AIRecommenderMode`, `AIRecommenderCategory` |

---

## Testing

Uses **Swift Testing** framework (not XCTest):

```swift
import Testing
@testable import ARCUIComponents

@Suite("ARCMenuViewModel Tests")
@MainActor
struct ARCMenuViewModelTests {
    @Test("init_withDefaultValues_setsCorrectInitialState")
    func init_withDefaultValues_setsCorrectInitialState() {
        let viewModel = ARCMenuViewModel()

        #expect(viewModel.isPresented == false)
        #expect(viewModel.menuItems.isEmpty)
    }
}
```

### Test Naming Convention

`methodName_testCondition_expectedBehavior` or `methodName_expectedBehavior`

Examples:
- `init_withDefaultValues_setsCorrectInitialState`
- `present_whenCalled_setsIsPresentedToTrue`
- `endDrag_aboveThreshold_dismissesMenu`

### Test Structure

- Use `@Suite("Component Tests")` for grouping
- Add `@MainActor` for ViewModel tests
- Use `#expect()` for assertions (not XCTAssert)
- Focus on testing ViewModels and Configurations, not UI rendering

---

## Git Workflow

Branch naming: `feature/ISSUE-ID-description`, `bugfix/ISSUE-ID-description`, `hotfix/ISSUE-ID-description`

Example: `feature/ARC-123-add-carousel-component`

Commits follow Conventional Commits: `feat(scope):`, `fix(scope):`, `docs(scope):`, `refactor(scope):`

---

## Plan Mode

When instructed to enter **Plan Mode**:

1. Ask 4–6 clarifying questions
2. Draft a step-by-step plan
3. Get approval before implementing
4. After each phase: announce completion, summarize remaining steps
