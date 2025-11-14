//
//  ARCUIComponents.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

// The Swift Programming Language
// https://docs.swift.org/swift-book

/// ARCUIComponents - Premium UI Components for iOS
///
/// A modern Swift package providing reusable, beautifully designed
/// UI components following Apple's Human Interface Guidelines.
///
/// ## Components
///
/// ### ARCMenu
/// A sophisticated menu component with liquid glass effect,
/// following Apple's latest design language.
///
/// **Features:**
/// - Liquid Glass effect (glassmorphism)
/// - Smooth spring animations
/// - Drag-to-dismiss gestures
/// - Haptic feedback
/// - Full customization support
/// - Swift 6 ready with complete concurrency support
///
/// **Usage Example:**
/// ```swift
/// import ARCUIComponents
///
/// struct ContentView: View {
///     @State private var menuViewModel = ARCMenuViewModel.standard(
///         user: ARCMenuUser(
///             name: "Your Name",
///             email: "you@email.com",
///             avatarImage: .initials("YN")
///         ),
///         onSettings: { /* handle settings */ },
///         onProfile: { /* handle profile */ },
///         onLogout: { /* handle logout */ }
///     )
///
///     var body: some View {
///         NavigationStack {
///             YourContentView()
///                 .arcMenuButton(viewModel: menuViewModel)
///                 .arcMenu(viewModel: menuViewModel)
///         }
///     }
/// }
/// ```
///
/// ## Requirements
/// - iOS 17.0+
/// - iPadOS 17.0+
/// - Swift 6.0+
/// - Xcode 16.0+
///
/// ## Platform Strategy
/// ARCUIComponents is designed exclusively for iOS and iPadOS, following mobile-first
/// design patterns and touch-based interaction paradigms. For other platforms (macOS,
/// tvOS, watchOS), use native system patterns. See `docs/Platform-Alternatives.md`.
///
/// ## Architecture
/// Built with Clean Architecture principles:
/// - **Models**: Data structures (ARCMenuUser, ARCMenuItem, ARCMenuConfiguration)
/// - **ViewModels**: Business logic (ARCMenuViewModel)
/// - **Views**: UI components (ARCMenu, ARCMenuButton, etc.)
/// - **Utilities**: Helper code and modifiers
/// - **Design System**: Powered by ``ARCDesignSystem`` tokens for fonts, colors, spacing, and animations
///
/// ## Design Philosophy
/// - **Apple First**: Follows iOS/iPadOS HIG meticulously
/// - **Performance**: Optimized for smooth 120Hz animations
/// - **Accessibility**: Full VoiceOver and Dynamic Type support
/// - **Customization**: Highly configurable while maintaining consistency
/// - **Type Safety**: Leverages Swift's type system for compile-time safety
/// - **Mobile Focus**: Designed for touch-first interaction
///
@available(iOS 17.0, *)
public struct ARCUIComponents {
    /// Returns the current version of ARCUIComponents
    public static var version: String {
        "1.0.0"
    }

    /// Returns information about the package
    public static var info: String {
        """
        ARCUIComponents v\(version)
        Premium UI Components for iOS
        Following Apple's Human Interface Guidelines

        Components:
        • ARCMenu - Premium menu with liquid glass effect

        Built with ❤️ by ARC Labs
        """
    }

    private init() {}
}

// MARK: - Public API Exports

// Re-export all public types for convenient importing
@_exported import struct Foundation.UUID
@_exported import struct Foundation.URL
@_exported import class Foundation.Bundle
@_exported import SwiftUI
@_exported import ARCDesignSystem
