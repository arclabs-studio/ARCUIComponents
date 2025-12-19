//
//  ARCEmptyStateConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

/// Configuration for ARCEmptyState appearance and behavior
///
/// Provides customization options for empty state displays while maintaining
/// Apple's Human Interface Guidelines for informative, helpful empty states.
///
/// ## Overview
///
/// Empty states should be encouraging and actionable, guiding users toward
/// their next step. ARCEmptyStateConfiguration allows you to customize the
/// visual appearance while preserving best practices for empty state design.
///
/// ## Topics
///
/// ### Creating Configurations
///
/// - ``init(icon:iconColor:title:message:actionTitle:showsAction:accentColor:spacing:)``
///
/// ### Properties
///
/// - ``icon``
/// - ``iconColor``
/// - ``title``
/// - ``message``
/// - ``actionTitle``
/// - ``showsAction``
/// - ``accentColor``
/// - ``spacing``
///
/// ### Presets
///
/// - ``noResults``
/// - ``noFavorites``
/// - ``noData``
/// - ``error``
/// - ``offline``
///
/// ## Usage
///
/// ```swift
/// // Use a preset
/// let config = ARCEmptyStateConfiguration.noResults
///
/// // Create custom configuration
/// let config = ARCEmptyStateConfiguration(
///     icon: "photo.on.rectangle",
///     iconColor: .blue,
///     title: "No Photos",
///     message: "Add photos to get started",
///     actionTitle: "Add Photo"
/// )
/// ```
@available(iOS 17.0, *)
public struct ARCEmptyStateConfiguration: Sendable {
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

    /// Accent color for the action button
    public let accentColor: Color

    /// Spacing between elements
    public let spacing: CGFloat

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
    public init(
        icon: String,
        iconColor: Color = .secondary,
        title: String,
        message: String,
        actionTitle: String = "Get Started",
        showsAction: Bool = false,
        accentColor: Color = .blue,
        spacing: CGFloat = 16
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.showsAction = showsAction
        self.accentColor = accentColor
        self.spacing = spacing
    }

    // MARK: - Presets

    /// Configuration for no search results
    public static let noResults = ARCEmptyStateConfiguration(
        icon: "magnifyingglass",
        iconColor: .secondary,
        title: "No Results",
        message: "Try adjusting your search to find what you're looking for.",
        actionTitle: "Clear Search",
        showsAction: false
    )

    /// Configuration for empty favorites
    public static let noFavorites = ARCEmptyStateConfiguration(
        icon: "heart",
        iconColor: .pink,
        title: "No Favorites Yet",
        message: "Items you mark as favorites will appear here.",
        actionTitle: "Browse",
        showsAction: true,
        accentColor: .pink
    )

    /// Configuration for no data
    public static let noData = ARCEmptyStateConfiguration(
        icon: "tray",
        iconColor: .secondary,
        title: "No Data",
        message: "There's nothing here right now. Check back later.",
        actionTitle: "Refresh",
        showsAction: false
    )

    /// Configuration for error state
    public static let error = ARCEmptyStateConfiguration(
        icon: "exclamationmark.triangle",
        iconColor: .orange,
        title: "Something Went Wrong",
        message: "We couldn't load your content. Please try again.",
        actionTitle: "Try Again",
        showsAction: true,
        accentColor: .orange
    )

    /// Configuration for offline state
    public static let offline = ARCEmptyStateConfiguration(
        icon: "wifi.slash",
        iconColor: .red,
        title: "No Connection",
        message: "Connect to the internet to view your content.",
        actionTitle: "Settings",
        showsAction: true,
        accentColor: .blue
    )
}
