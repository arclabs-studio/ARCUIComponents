//
//  ARCSearchButtonConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

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
///
/// ### Presets
///
/// - ``default``
/// - ``prominent``
/// - ``minimal``
/// - ``toolbar``
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
public struct ARCSearchButtonConfiguration: Sendable {
    // MARK: - Properties

    /// SF Symbol name for the search icon
    public let icon: String

    /// Accent color for the icon
    public let accentColor: Color

    /// Background color (when style uses background)
    public let backgroundColor: Color

    /// Button size
    public let size: ButtonSize

    /// Visual style
    public let style: ButtonStyle

    /// Whether to show background when not pressed
    public let showsBackgroundWhenIdle: Bool

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
    public init(
        icon: String = "magnifyingglass",
        accentColor: Color = .secondary,
        backgroundColor: Color = Color(.tertiarySystemFill),
        size: ButtonSize = .medium,
        style: ButtonStyle = .plain,
        showsBackgroundWhenIdle: Bool = false
    ) {
        self.icon = icon
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.size = size
        self.style = style
        self.showsBackgroundWhenIdle = showsBackgroundWhenIdle
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
            case .small: return 18
            case .medium: return 20
            case .large: return 24
            case .custom(let size): return size
            }
        }

        /// Button frame size
        public var frameSize: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            case .custom(let size): return size + 20
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
