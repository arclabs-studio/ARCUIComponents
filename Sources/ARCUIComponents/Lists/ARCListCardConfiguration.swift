//
//  ARCListCardConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCListCard appearance and behavior
///
/// Provides customization options for list card appearance while maintaining
/// Apple's Human Interface Guidelines for card-based interfaces.
///
/// ## Overview
///
/// List cards are ubiquitous across Apple's apps (Music, App Store, Books, Podcasts),
/// presenting content in scannable, actionable chunks. ARCListCardConfiguration
/// allows you to customize visual treatment while preserving familiar patterns.
///
/// ## Topics
///
/// ### Creating Configurations
///
/// - ``init(accentColor:backgroundStyle:cornerRadius:shadow:spacing:showsSeparator:)``
///
/// ### Properties
///
/// - ``accentColor``
/// - ``backgroundStyle``
/// - ``cornerRadius``
/// - ``shadow``
/// - ``spacing``
/// - ``showsSeparator``
///
/// ### Presets
///
/// - ``default``
/// - ``prominent``
/// - ``subtle``
/// - ``glassmorphic``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// let config = ARCListCardConfiguration.default
///
/// // Create custom configuration
/// let config = ARCListCardConfiguration(
///     accentColor: .blue,
///     backgroundStyle: .liquidGlass
/// )
/// ```
@available(iOS 17.0, *)
public struct ARCListCardConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Properties

    /// Primary accent color
    public let accentColor: Color

    /// Background style for the card
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the card
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    /// Spacing between card elements
    public let spacing: CGFloat

    /// Whether to show separator between content sections
    public let showsSeparator: Bool

    // MARK: - Initialization

    /// Creates a new list card configuration
    ///
    /// - Parameters:
    ///   - accentColor: Primary accent color
    ///   - backgroundStyle: Background style
    ///   - cornerRadius: Corner radius in points
    ///   - shadow: Shadow configuration
    ///   - spacing: Spacing between elements
    ///   - showsSeparator: Whether to show separators
    public init(
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = .arcCornerRadiusMedium,
        shadow: ARCShadow = .subtle,
        spacing: CGFloat = .arcSpacingMedium,
        showsSeparator: Bool = false
    ) {
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.spacing = spacing
        self.showsSeparator = showsSeparator
    }

    // MARK: - Presets

    /// Default configuration with translucent background
    public static let `default` = ARCListCardConfiguration()

    /// Prominent configuration with liquid glass effect
    public static let prominent = ARCListCardConfiguration(
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .default
    )

    /// Subtle configuration with minimal styling
    public static let subtle = ARCListCardConfiguration(
        backgroundStyle: .solid(Color(uiColor: .secondarySystemGroupedBackground), opacity: 1.0),
        cornerRadius: .arcCornerRadiusSmall,
        shadow: .none,
        showsSeparator: true
    )

    /// Glassmorphic configuration matching Apple Music style
    public static let glassmorphic = ARCListCardConfiguration(
        accentColor: .pink,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusMedium,
        shadow: .default
    )
}
