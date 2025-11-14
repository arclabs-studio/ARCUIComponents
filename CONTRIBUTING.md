# Contributing to ARCUIComponents

First off, thank you for considering contributing to ARCUIComponents! It's people like you that make this package a great tool for the iOS development community.

## Code of Conduct

This project and everyone participating in it is governed by respect, professionalism, and a commitment to quality. By participating, you are expected to uphold this standard.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates.

When creating a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and expected**
- **Include screenshots if applicable**
- **Specify your environment** (iOS version, Xcode version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear and descriptive title**
- **Provide a detailed description of the proposed functionality**
- **Explain why this enhancement would be useful**
- **List any alternative solutions you've considered**
- **Include mockups or examples if applicable**

See [TECHNICAL_REVIEW.md](TECHNICAL_REVIEW.md) for planned enhancements.

### Pull Requests

1. Fork the repo and create your branch from `main`
2. Follow the coding standards (see below)
3. Write clear, concise commit messages
4. Include tests for new functionality
5. Update documentation
6. Ensure all tests pass
7. Submit your pull request

## Development Setup

### Prerequisites

- Xcode 16.0+
- Swift 6.0+
- macOS 14.0+

### Getting Started

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/ARCUIComponents.git
cd ARCUIComponents

# Build the package
swift build

# Run tests
swift test

# Generate documentation
swift package generate-documentation
```

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and [Apple's Swift Style Guide](https://google.github.io/swift/).

#### Key Points

1. **Naming**
   ```swift
   // Good
   func calculateTotalPrice(for items: [Item]) -> Decimal

   // Bad
   func calc(items: [Item]) -> Decimal
   ```

2. **Access Control**
   ```swift
   // Use explicit access control
   public struct ARCMenuUser { }
   private func helperMethod() { }
   ```

3. **Swift 6 Compliance**
   ```swift
   // All models must conform to Sendable
   public struct Model: Sendable { }

   // Use @MainActor for UI code
   @MainActor
   public final class ViewModel { }
   ```

4. **No Force Unwrapping**
   ```swift
   // Good
   guard let value = optionalValue else { return }

   // Bad
   let value = optionalValue!
   ```

### Architecture

Follow **Clean Architecture** principles:

```
Component/
├── Models/        # Data structures, configuration
├── ViewModels/    # Business logic, state management
├── Views/         # SwiftUI views
└── Utilities/     # Helpers, extensions
```

### Documentation

All public APIs must be documented using DocC:

```swift
/// Brief description of what this does.
///
/// ## Overview
///
/// Detailed explanation with context.
///
/// ## Example Usage
///
/// ```swift
/// let example = MyType(value: 42)
/// ```
///
/// - Parameters:
///   - value: Description of the parameter
/// - Returns: Description of return value
/// - Throws: Description of errors thrown
public func myFunction(value: Int) -> String { }
```

### Testing

1. **Unit Tests**: Required for all business logic
   ```swift
   @testable import ARCUIComponents
   import XCTest

   final class MyTests: XCTestCase {
       func testSomething() {
           // Arrange
           let sut = SystemUnderTest()

           // Act
           let result = sut.doSomething()

           // Assert
           XCTAssertEqual(result, expected)
       }
   }
   ```

2. **UI Tests**: Required for user-facing features
3. **Coverage Target**: 85%+ for business logic

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Build process, dependencies, etc.

**Examples**:
```
feat(ARCMenu): add search functionality

Implements search bar in menu header with filtering.
Closes #123

BREAKING CHANGE: ARCMenuConfiguration now requires searchEnabled parameter
```

```
fix(ARCMenuButton): correct badge positioning on iOS 17

Badge was misaligned on devices with dynamic island.
Fixes #456
```

## Project Structure

```
ARCUIComponents/
├── Sources/
│   └── ARCUIComponents/
│       ├── ARCUIComponents.swift        # Package entry point
│       ├── ARCUIComponents.docc/        # DocC catalog
│       └── ARCMenu/                     # Menu component
│           ├── Models/
│           ├── ViewModels/
│           ├── Views/
│           ├── ARCMenuExample.swift
│           └── ARCMenuShowcase.swift
├── Tests/
│   └── ARCUIComponentsTests/
├── Package.swift
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── TECHNICAL_REVIEW.md
└── LICENSE
```

## Review Process

1. **Automated Checks**
   - Build succeeds
   - Tests pass
   - No SwiftLint violations
   - Documentation builds

2. **Code Review**
   - Architecture consistency
   - Code quality
   - Test coverage
   - Documentation completeness

3. **Design Review** (for UI changes)
   - HIG compliance
   - Accessibility
   - Dark mode support
   - Animation quality

## Release Process

1. Update CHANGELOG.md
2. Update version in Package.swift
3. Create release notes
4. Tag release
5. Build and test
6. Publish

## Questions?

Feel free to open an issue for:
- Questions about contributing
- Clarifications on architecture decisions
- Discussions about proposed changes

## Attribution

This contribution guide is adapted from open-source contribution guidelines.

---

Thank you for contributing to ARCUIComponents! 🎉
