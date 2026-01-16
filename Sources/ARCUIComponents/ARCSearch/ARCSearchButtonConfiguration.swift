//
//  ARCSearchButtonConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCSearchButton appearance and behavior
///
/// Provides customization options for search button appearance while maintaining
/// Apple's Human Interface Guidelines for search interface elements.
///
/// ## Overview
///
/// Search buttons are common throughout iOS, appearing in navigation bars,
/// toolbars, and content areas. ARCSearchButtonConfiguration allows you to
/// customize the button's appearance while preserving the familiar search icon
/// and interaction pattern users expect.
///
/// ## Topics
///
/// ### Creating Configurations
///
/// - ``init(icon:accentColor:backgroundColor:size:style:showsBackgroundWhenIdle:)``
///
/// ### Properties
///
/// - ``icon``
/// - ``accentColor``
/// - ``backgroundColor``
/// - ``size``
/// - ``style``
/// - ``showsBackgroundWhenIdle``
/// - ``backgroundStyle``
/// - ``cornerRadius``
/// - ``shadow``
///
/// ### Presets
///
/// - ``default``
/// - ``prominent``
/// - ``minimal``
/// - ``toolbar``
/// - ``glassmorphic``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// let config = ARCSearchButtonConfiguration.default
///
/// // Create custom configuration
/// let config = ARCSearchButtonConfiguration(
///     accentColor: .blue,
///     style: .prominent
/// )
/// ```
@available(iOS 17.0, *)
public struct ARCSearchButtonConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Properties

    /// SF Symbol name for the search icon
    public let icon: String

    /// Accent color for the icon and liquid glass tinting
    public let accentColor: Color

    /// Background color (when style uses background)
    public let backgroundColor: Color

    /// Button size
    public let size: ButtonSize

    /// Visual style
    public let style: ButtonStyle

    /// Whether to show background when not pressed
    public let showsBackgroundWhenIdle: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Background style for the button container
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the button container
    public let cornerRadius: CGFloat

    /// Shadow configuration for the button container
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a new search button configuration
    ///
    /// - Parameters:
    ///   - icon: SF Symbol for search icon
    ///   - accentColor: Color for the icon
    ///   - backgroundColor: Background color
    ///   - size: Button size
    ///   - style: Visual style
    ///   - showsBackgroundWhenIdle: Whether to show background when idle
    ///   - backgroundStyle: Background style for liquid glass effect
    ///   - cornerRadius: Corner radius for the container
    ///   - shadow: Shadow configuration
    public init(
        icon: String = "magnifyingglass",
        accentColor: Color = .secondary,
        backgroundColor: Color = Color(.tertiarySystemFill),
        size: ButtonSize = .medium,
        style: ButtonStyle = .plain,
        showsBackgroundWhenIdle: Bool = false,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = .arcCornerRadiusMedium,
        shadow: ARCShadow = .none
    ) {
        self.icon = icon
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.size = size
        self.style = style
        self.showsBackgroundWhenIdle = showsBackgroundWhenIdle
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Presets

    /// Default configuration for toolbar placement
    public static let `default` = ARCSearchButtonConfiguration()

    /// Prominent configuration with filled background
    public static let prominent = ARCSearchButtonConfiguration(
        accentColor: .white,
        backgroundColor: .blue,
        style: .filled,
        showsBackgroundWhenIdle: true
    )

    /// Minimal configuration with no background
    public static let minimal = ARCSearchButtonConfiguration(
        accentColor: .secondary,
        size: .small,
        style: .plain
    )

    /// Toolbar configuration with subtle styling
    public static let toolbar = ARCSearchButtonConfiguration(
        accentColor: .primary,
        size: .medium,
        style: .bordered,
        showsBackgroundWhenIdle: true
    )

    /// Glassmorphic configuration with liquid glass background
    ///
    /// Features a premium liquid glass container for elevated
    /// visual presence, matching Apple's flagship app style.
    public static let glassmorphic = ARCSearchButtonConfiguration(
        accentColor: .primary,
        size: .large,
        style: .bordered,
        showsBackgroundWhenIdle: true,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .subtle
    )

    // MARK: - Button Size

    /// Size options for the search button
    public enum ButtonSize: Sendable {
        /// Small button (18pt icon)
        case small

        /// Medium button (20pt icon)
        case medium

        /// Large button (24pt icon)
        case large

        /// Custom size in points
        case custom(CGFloat)

        /// Icon size in points
        public var iconSize: CGFloat {
            switch self {
            case .small: 18
            case .medium: 20
            case .large: 24
            case let .custom(size): size
            }
        }

        /// Button frame size
        public var frameSize: CGFloat {
            switch self {
            case .small: 36
            case .medium: 44
            case .large: 52
            case let .custom(size): size + 20
            }
        }
    }

    // MARK: - Button Style

    /// Visual style options for the button
    public enum ButtonStyle: Sendable {
        /// Plain icon without background
        case plain

        /// Icon with bordered background
        case bordered

        /// Icon with filled background
        case filled
    }
}
