//
//  ARCButtonConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCButtonConfiguration

/// Configuration for ARCButton appearance and behavior
///
/// Provides customization options for button style, size, and interaction
/// following Apple's Human Interface Guidelines for buttons.
///
/// ## Overview
///
/// ARCButton is designed for CTAs, form submissions, and important actions.
/// Per Apple HIG: "Make buttons easy for people to use. It's essential to include
/// enough space around a button so that people can visually distinguish it from
/// surrounding components and content."
///
/// ## Topics
///
/// ### Style
///
/// - ``Style-swift.enum``
///
/// ### Size
///
/// - ``Size-swift.enum``
///
/// ### Presets
///
/// - ``primary``
/// - ``secondary``
/// - ``destructive``
/// - ``ghost``
/// - ``glass``
/// - ``small``
/// - ``large``
/// - ``iconOnly``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCButtonConfiguration: LiquidGlassConfigurable, Sendable {
    // MARK: - Style

    /// Visual styles for action buttons
    public enum Style: Sendable, Equatable {
        /// Solid filled background with contrasting text
        case filled

        /// Outlined border with transparent background
        case outlined

        /// No background, text only
        case ghost

        /// Liquid glass effect background
        case glass
    }

    // MARK: - Size

    /// Size variants for action buttons
    public enum Size: Sendable {
        /// Small button (32pt height)
        case small

        /// Default button size (44pt height)
        case medium

        /// Large button (56pt height)
        case large

        /// Height in points
        var height: CGFloat {
            switch self {
            case .small: 32
            case .medium: 44
            case .large: 56
            }
        }

        /// Font for the button text
        var font: Font {
            switch self {
            case .small: .subheadline.weight(.semibold)
            case .medium: .body.weight(.semibold)
            case .large: .title3.weight(.semibold)
            }
        }

        /// Icon size in points
        var iconSize: CGFloat {
            switch self {
            case .small: 14
            case .medium: 17
            case .large: 20
            }
        }

        /// Horizontal padding
        var horizontalPadding: CGFloat {
            switch self {
            case .small: 12
            case .medium: 20
            case .large: 24
            }
        }
    }

    // MARK: - Properties

    /// Visual style of the button
    public let style: Style

    /// Size of the button
    public let size: Size

    /// Primary color of the button
    public let color: Color

    /// Text color (auto-calculated if nil)
    public let textColor: Color?

    /// Whether the button should expand to full width
    public let isFullWidth: Bool

    /// Whether the button is disabled
    public let isDisabled: Bool

    /// Scale factor when pressed (typically 0.97)
    public let pressedScale: CGFloat

    /// Whether to provide haptic feedback on tap
    public let hapticFeedback: Bool

    /// Color for the loading indicator (auto-calculated if nil)
    public let loadingIndicatorColor: Color?

    // MARK: - LiquidGlassConfigurable

    /// Accent color for glass effect
    public let accentColor: Color

    /// Background style for glass effect
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius of the button
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a button configuration with the specified options
    ///
    /// - Parameters:
    ///   - style: Visual style (default: .filled)
    ///   - size: Button size (default: .medium)
    ///   - color: Primary color (default: .accentColor)
    ///   - textColor: Text color (default: auto-calculated)
    ///   - isFullWidth: Expand to full width (default: false)
    ///   - isDisabled: Disable the button (default: false)
    ///   - pressedScale: Scale when pressed (default: 0.97)
    ///   - hapticFeedback: Enable haptics (default: true)
    ///   - loadingIndicatorColor: Loading spinner color (default: auto)
    ///   - cornerRadius: Corner radius (default: 12)
    ///   - shadow: Shadow configuration (default: .subtle)
    public init(
        style: Style = .filled,
        size: Size = .medium,
        color: Color = .accentColor,
        textColor: Color? = nil,
        isFullWidth: Bool = false,
        isDisabled: Bool = false,
        pressedScale: CGFloat = 0.97,
        hapticFeedback: Bool = true,
        loadingIndicatorColor: Color? = nil,
        cornerRadius: CGFloat = 12,
        shadow: ARCShadow = .subtle
    ) {
        self.style = style
        self.size = size
        self.color = color
        self.textColor = textColor
        self.isFullWidth = isFullWidth
        self.isDisabled = isDisabled
        self.pressedScale = pressedScale
        self.hapticFeedback = hapticFeedback
        self.loadingIndicatorColor = loadingIndicatorColor
        accentColor = color
        backgroundStyle = style == .glass ? .liquidGlass : .solid(color, opacity: 1.0)
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Semantic Presets

    /// Primary filled button with accent color
    ///
    /// Use for the most likely action in a view.
    /// Per Apple HIG: "Use a button that has a prominent visual style
    /// for the most likely action in a view."
    public static let primary = ARCButtonConfiguration(
        style: .filled,
        color: .accentColor
    )

    /// Secondary outlined button
    ///
    /// Use for secondary actions that need visibility.
    public static let secondary = ARCButtonConfiguration(
        style: .outlined,
        color: .accentColor,
        shadow: .none
    )

    /// Destructive red button
    ///
    /// Use for actions that result in data destruction.
    /// Per Apple HIG: "Don't assign the primary role to a button
    /// that performs a destructive action."
    public static let destructive = ARCButtonConfiguration(
        style: .filled,
        color: .red
    )

    /// Ghost button with no background
    ///
    /// Use for tertiary actions or compact spaces.
    public static let ghost = ARCButtonConfiguration(
        style: .ghost,
        color: .accentColor,
        shadow: .none
    )

    /// Liquid glass effect button
    ///
    /// Use for premium, floating UI elements.
    public static let glass = ARCButtonConfiguration(
        style: .glass,
        color: .primary,
        shadow: .default
    )

    // MARK: - Size Presets

    /// Small button preset (32pt height)
    public static let small = ARCButtonConfiguration(
        size: .small
    )

    /// Large button preset (56pt height)
    public static let large = ARCButtonConfiguration(
        size: .large
    )

    /// Square icon-only button
    public static let iconOnly = ARCButtonConfiguration(
        style: .filled,
        size: .medium
    )

    // MARK: - Computed Properties

    /// Resolved text color based on style and background
    var resolvedTextColor: Color {
        if let textColor {
            return textColor
        }

        switch style {
        case .filled:
            return .white
        case .outlined, .ghost:
            return color
        case .glass:
            return .primary
        }
    }

    /// Resolved loading indicator color
    var resolvedLoadingColor: Color {
        loadingIndicatorColor ?? resolvedTextColor
    }
}
