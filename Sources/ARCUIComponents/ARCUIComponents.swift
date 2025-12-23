// The Swift Programming Language
// https://docs.swift.org/swift-book

/// ARCUIComponents - Premium UI Components for Apple Platforms
///
/// A modern Swift package providing reusable, beautifully designed
/// UI components following Apple's Human Interface Guidelines.
///
/// ## Platform Support
///
/// | Platform | Status |
/// |----------|--------|
/// | iOS 17.0+ | ✅ Full Support - All components |
/// | iPadOS 17.0+ | ✅ Full Support - All components |
/// | macOS 14.0+ | ⚠️ Compiles - Components designed for iOS (native macOS components coming soon) |
///
/// > **Note**: Current components use iOS-centric design patterns (touch targets, haptics, slide-in menus).
/// > Native macOS components with pointer-optimized interactions are planned for version 2.x.
///
/// ## Components (iOS/iPadOS)
///
/// ### ARCMenu
/// A sophisticated slide-in menu component with liquid glass effect.
///
/// ### ARCFavoriteButton
/// Animated heart toggle button for favorite/like actions.
///
/// ### ARCListCard
/// Card-based list rows with configurable styles.
///
/// ### ARCSearchButton
/// Customizable search trigger button.
///
/// ### ARCEmptyState
/// Empty content placeholder with optional action.
///
/// ### LiquidGlass Modifier
/// Apple Music-style glassmorphism effect.
///
/// ## Quick Start
///
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
/// ## Architecture
///
/// Built with Clean Architecture principles:
/// - **Models**: Data structures
/// - **ViewModels**: Business logic
/// - **Views**: UI components
/// - **Effects**: Visual modifiers
///
/// ## Design Philosophy
///
/// - **Platform Native**: Each platform gets components designed for its interaction patterns
/// - **Apple First**: Follows Apple's HIG meticulously
/// - **Performance**: Optimized for smooth 120Hz animations
/// - **Accessibility**: Full VoiceOver and Dynamic Type support
/// - **Type Safety**: Leverages Swift's type system for compile-time safety
///
@available(iOS 17.0, macOS 14.0, *)
public struct ARCUIComponents {
    /// Returns the current version of ARCUIComponents
    public static var version: String {
        "1.0.0"
    }

    /// Returns information about the package
    public static var info: String {
        """
        ARCUIComponents v\(version)
        Premium UI Components for Apple Platforms

        iOS/iPadOS Components (v1.x):
        • ARCMenu - Premium slide-in menu with liquid glass effect
        • ARCFavoriteButton - Animated favorite toggle
        • ARCListCard - Card-based list rows
        • ARCSearchButton - Search trigger button
        • ARCEmptyState - Empty content placeholder
        • LiquidGlass - Glassmorphism effect modifier

        Coming Soon (v2.x):
        • macOS-native components (popovers, sidebars, toolbars)

        Built with ❤️ by ARC Labs
        """
    }

    private init() {}
}

// MARK: - Public API Exports

@_exported import class Foundation.Bundle
@_exported import struct Foundation.URL

// Re-export all public types for convenient importing
@_exported import struct Foundation.UUID
@_exported import SwiftUI
