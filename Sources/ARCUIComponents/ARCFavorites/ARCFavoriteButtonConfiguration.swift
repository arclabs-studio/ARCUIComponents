//
//  ARCFavoriteButtonConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCFavoriteButton appearance and behavior
///
/// Provides customization options for favorite button appearance while maintaining
/// Apple's Human Interface Guidelines for toggle buttons and favorites.
///
/// ## Overview
///
/// The favorite button is a common pattern across Apple's apps (Music, Podcasts,
/// Books, etc.) for marking content as favorite. ARCFavoriteButtonConfiguration
/// allows you to customize colors, icons, and sizing while preserving the
/// familiar interaction pattern.
///
/// ## Topics
///
/// ### Creating Configurations
///
/// - ``init(favoriteIcon:unfavoriteIcon:favoriteColor:unfavoriteColor:size:animationDuration:hapticFeedback:)``
///
/// ### Properties
///
/// - ``favoriteIcon``
/// - ``unfavoriteIcon``
/// - ``favoriteColor``
/// - ``unfavoriteColor``
/// - ``size``
/// - ``animationDuration``
/// - ``hapticFeedback``
/// - ``backgroundStyle``
/// - ``cornerRadius``
/// - ``shadow``
///
/// ### Presets
///
/// - ``default``
/// - ``large``
/// - ``subtle``
/// - ``glassmorphic``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// let config = ARCFavoriteButtonConfiguration.default
///
/// // Create custom configuration
/// let config = ARCFavoriteButtonConfiguration(
///     favoriteColor: .pink,
///     size: .large
/// )
/// ```
@available(iOS 17.0, *)
public struct ARCFavoriteButtonConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Properties

    /// SF Symbol name for favorited state
    public let favoriteIcon: String

    /// SF Symbol name for unfavorited state
    public let unfavoriteIcon: String

    /// Color when favorited
    public let favoriteColor: Color

    /// Color when not favorited
    public let unfavoriteColor: Color

    /// Button size
    public let size: ButtonSize

    /// Animation duration for state changes
    public let animationDuration: Double

    /// Whether to provide haptic feedback
    public let hapticFeedback: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Accent color for liquid glass tinting (uses favoriteColor)
    public var accentColor: Color { favoriteColor }

    /// Background style for the button container
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the button container
    public let cornerRadius: CGFloat

    /// Shadow configuration for the button container
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a new favorite button configuration
    ///
    /// - Parameters:
    ///   - favoriteIcon: SF Symbol for favorited state
    ///   - unfavoriteIcon: SF Symbol for unfavorited state
    ///   - favoriteColor: Color when favorited
    ///   - unfavoriteColor: Color when not favorited
    ///   - size: Button size
    ///   - animationDuration: Animation duration in seconds
    ///   - hapticFeedback: Whether to provide haptic feedback
    ///   - backgroundStyle: Background style for liquid glass effect
    ///   - cornerRadius: Corner radius for the container
    ///   - shadow: Shadow configuration
    public init(
        favoriteIcon: String = "heart.fill",
        unfavoriteIcon: String = "heart",
        favoriteColor: Color = .pink,
        unfavoriteColor: Color = .secondary,
        size: ButtonSize = .medium,
        animationDuration: Double = 0.3,
        hapticFeedback: Bool = true,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = .arcCornerRadiusMedium,
        shadow: ARCShadow = .none
    ) {
        self.favoriteIcon = favoriteIcon
        self.unfavoriteIcon = unfavoriteIcon
        self.favoriteColor = favoriteColor
        self.unfavoriteColor = unfavoriteColor
        self.size = size
        self.animationDuration = animationDuration
        self.hapticFeedback = hapticFeedback
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Presets

    /// Default configuration matching Apple Music style
    public static let `default` = ARCFavoriteButtonConfiguration()

    /// Large configuration for prominent placement
    public static let large = ARCFavoriteButtonConfiguration(
        size: .large
    )

    /// Subtle configuration with reduced visual weight
    public static let subtle = ARCFavoriteButtonConfiguration(
        unfavoriteColor: .secondary.opacity(0.6),
        size: .small
    )

    /// Glassmorphic configuration with liquid glass background
    ///
    /// Features a prominent liquid glass container for elevated
    /// visual presence, ideal for hero sections or featured content.
    public static let glassmorphic = ARCFavoriteButtonConfiguration(
        size: .large,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .subtle
    )

    // MARK: - Button Size

    /// Size options for the favorite button
    public enum ButtonSize: Sendable {
        /// Small button (20pt icon)
        case small

        /// Medium button (24pt icon)
        case medium

        /// Large button (28pt icon)
        case large

        /// Custom size in points
        case custom(CGFloat)

        /// Icon size in points
        public var iconSize: CGFloat {
            switch self {
            case .small: 20
            case .medium: 24
            case .large: 28
            case let .custom(size): size
            }
        }

        /// Touch target size in points (minimum 44x44 per Apple HIG)
        public var touchTargetSize: CGFloat {
            max(44, iconSize + 20)
        }
    }
}
