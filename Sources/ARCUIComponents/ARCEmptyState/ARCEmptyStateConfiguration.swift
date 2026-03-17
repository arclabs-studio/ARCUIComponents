//
//  ARCEmptyStateConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCEmptyState appearance and behavior.
///
/// ## Native vs Custom Rendering
///
/// ARCEmptyState automatically chooses between native `ContentUnavailableView`
/// and custom ARC rendering based on your configuration:
///
/// | Preset | Rendering | Why |
/// |--------|-----------|-----|
/// | `.noResults` | Native | Default colors, no action |
/// | `.noData` | Native | Default colors, no action |
/// | `.noFavorites` | Custom | Pink icon, action button |
/// | `.error` | Custom | Orange icon, action button |
/// | `.offline` | Custom | Red icon, action button |
/// | `.premium` | Custom | Liquid Glass background |
///
/// **Custom rendering triggers when ANY of these are true:**
/// - `iconColor` ≠ `.secondary`
/// - `showsAction` = `true`
/// - `backgroundStyle` = `.liquidGlass`
///
/// ## Usage
///
/// ```swift
/// // Native rendering (simple)
/// ARCEmptyState(configuration: .noResults)
///
/// // Custom rendering (branded)
/// ARCEmptyState(configuration: .noFavorites) {
///     navigateToExplore()
/// }
///
/// // Custom configuration
/// let config = ARCEmptyStateConfiguration(
///     icon: "photo.on.rectangle",
///     iconColor: .blue,
///     title: "No Photos",
///     message: "Add photos to get started",
///     actionTitle: "Add Photo",
///     showsAction: true
/// )
/// ```
@available(iOS 17.0, *)
public struct ARCEmptyStateConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Properties

    /// SF Symbol name for the icon
    public let icon: String

    /// Color for the icon
    public let iconColor: Color

    /// Primary title text
    public let title: String

    /// Supporting message text
    public let message: String

    /// Action button title (when showsAction is true)
    public let actionTitle: String

    /// Whether to show the action button
    public let showsAction: Bool

    /// Accent color for the action button and liquid glass tinting
    public let accentColor: Color

    /// Spacing between elements
    public let spacing: CGFloat

    // MARK: - LiquidGlassConfigurable Properties

    /// Background style for the empty state container
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the empty state container
    public let cornerRadius: CGFloat

    /// Shadow configuration for the empty state container
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a new empty state configuration
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name for the icon
    ///   - iconColor: Color for the icon
    ///   - title: Primary title text
    ///   - message: Supporting message text
    ///   - actionTitle: Action button title
    ///   - showsAction: Whether to show the action button
    ///   - accentColor: Accent color for the action button
    ///   - spacing: Spacing between elements in points
    ///   - backgroundStyle: Background style for liquid glass effect
    ///   - cornerRadius: Corner radius for the container
    ///   - shadow: Shadow configuration
    public init(
        icon: String,
        iconColor: Color = .secondary,
        title: String,
        message: String,
        actionTitle: String = "Get Started",
        showsAction: Bool = false,
        accentColor: Color = .blue,
        spacing: CGFloat = .arcSpacingLarge,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = .arcCornerRadiusLarge,
        shadow: ARCShadow = .subtle
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.showsAction = showsAction
        self.accentColor = accentColor
        self.spacing = spacing
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Presets (Native Rendering)

    /// No search results - uses native `ContentUnavailableView`.
    ///
    /// Ideal for search screens. Uses system styling for consistency.
    public static let noResults = ARCEmptyStateConfiguration(
        icon: "magnifyingglass",
        iconColor: .secondary,
        title: "No Results",
        message: "Try adjusting your search to find what you're looking for.",
        actionTitle: "Clear Search",
        showsAction: false
    )

    /// No data available - uses native `ContentUnavailableView`.
    ///
    /// Generic empty state for lists or collections without content.
    public static let noData = ARCEmptyStateConfiguration(
        icon: "tray",
        iconColor: .secondary,
        title: "No Data",
        message: "There's nothing here right now. Check back later.",
        actionTitle: "Refresh",
        showsAction: false
    )

    // MARK: - Presets (Custom ARC Rendering)

    /// Empty favorites - uses custom rendering with branded colors.
    ///
    /// Pink icon + action button triggers ARC custom view.
    public static let noFavorites = ARCEmptyStateConfiguration(
        icon: "heart",
        iconColor: .pink,
        title: "No Favorites Yet",
        message: "Items you mark as favorites will appear here.",
        actionTitle: "Browse",
        showsAction: true,
        accentColor: .pink
    )

    /// Error state - uses custom rendering with warning colors.
    ///
    /// Orange icon + retry action for failed operations.
    public static let error = ARCEmptyStateConfiguration(
        icon: "exclamationmark.triangle",
        iconColor: .orange,
        title: "Something Went Wrong",
        message: "We couldn't load your content. Please try again.",
        actionTitle: "Try Again",
        showsAction: true,
        accentColor: .orange
    )

    /// Offline state - uses custom rendering with status colors.
    ///
    /// Red icon + settings action for network issues.
    public static let offline = ARCEmptyStateConfiguration(
        icon: "wifi.slash",
        iconColor: .red,
        title: "No Connection",
        message: "Connect to the internet to view your content.",
        actionTitle: "Settings",
        showsAction: true,
        accentColor: .blue
    )

    /// Premium glass effect - full ARC styling with Liquid Glass.
    ///
    /// Use for premium/featured sections. Features glassmorphism background
    /// matching Apple's flagship app design language.
    public static let premium = ARCEmptyStateConfiguration(
        icon: "sparkles",
        iconColor: .purple,
        title: "No Content",
        message: "Start exploring to see content here.",
        actionTitle: "Explore",
        showsAction: true,
        accentColor: .purple,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusXLarge,
        shadow: .default
    )
}
