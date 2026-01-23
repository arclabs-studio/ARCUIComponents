//
//  ARCTagConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCTagConfiguration

/// Configuration for ARCTag appearance
///
/// Provides customization options for tag size, style, colors, and icon position.
/// Conforms to `LiquidGlassConfigurable` for consistent styling across ARC components.
///
/// ## Topics
///
/// ### Size
///
/// - ``Size-swift.enum``
///
/// ### Style
///
/// - ``Style-swift.enum``
///
/// ### Icon Position
///
/// - ``IconPosition``
///
/// ### Presets
///
/// - ``default``
/// - ``category``
/// - ``status``
/// - ``glass``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTagConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Size

    /// Size variants for tags
    public enum Size: Sendable {
        /// Small tag (24pt height)
        case small

        /// Default tag size (28pt height)
        case medium

        /// Large tag (32pt height)
        case large

        /// Height in points
        var height: CGFloat {
            switch self {
            case .small: 24
            case .medium: 28
            case .large: 32
            }
        }

        /// Horizontal padding
        var horizontalPadding: CGFloat {
            switch self {
            case .small: 8
            case .medium: 10
            case .large: 12
            }
        }

        /// Vertical padding
        var verticalPadding: CGFloat {
            switch self {
            case .small: 4
            case .medium: 5
            case .large: 6
            }
        }

        /// Font size
        var fontSize: CGFloat {
            switch self {
            case .small: 12
            case .medium: 13
            case .large: 14
            }
        }

        /// Icon size
        var iconSize: CGFloat {
            switch self {
            case .small: 12
            case .medium: 14
            case .large: 16
            }
        }
    }

    // MARK: - Style

    /// Visual styles for tags
    public enum Style: Sendable {
        /// Solid filled background
        case filled

        /// Outlined border with transparent background
        case outlined

        /// Subtle tinted background
        case subtle

        /// Liquid glass effect
        case glass
    }

    // MARK: - Icon Position

    /// Position of icon relative to text
    public enum IconPosition: Sendable {
        /// Icon appears before text
        case leading

        /// Icon appears after text
        case trailing
    }

    // MARK: - Properties

    /// Tag size
    public let size: Size

    /// Visual style
    public let style: Style

    /// Primary color for the tag
    public let color: Color

    /// Text color (auto-calculated if nil)
    public let textColor: Color?

    /// Icon position relative to text
    public let iconPosition: IconPosition

    // MARK: - LiquidGlassConfigurable Properties

    /// Accent color for liquid glass effect
    public let accentColor: Color

    /// Background style
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius (capsule by default)
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a tag configuration with the specified options
    ///
    /// - Parameters:
    ///   - size: Tag size (default: .medium)
    ///   - style: Visual style (default: .subtle)
    ///   - color: Primary color (default: .blue)
    ///   - textColor: Text color, auto-calculated if nil
    ///   - iconPosition: Icon position (default: .leading)
    ///   - accentColor: Accent for glass effect (default: .blue)
    ///   - backgroundStyle: Background style (default: .translucent)
    ///   - cornerRadius: Corner radius (default: 0 for capsule)
    ///   - shadow: Shadow configuration (default: .none)
    public init(
        size: Size = .medium,
        style: Style = .subtle,
        color: Color = .blue,
        textColor: Color? = nil,
        iconPosition: IconPosition = .leading,
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = 0, // 0 means capsule
        shadow: ARCShadow = .none
    ) {
        self.size = size
        self.style = style
        self.color = color
        self.textColor = textColor
        self.iconPosition = iconPosition
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Presets

    /// Default tag configuration
    public static let `default` = ARCTagConfiguration()

    /// Category tag (e.g., genres, types)
    public static let category = ARCTagConfiguration(
        style: .subtle,
        color: .secondary
    )

    /// Status tag (e.g., Open, Closed)
    public static let status = ARCTagConfiguration(
        style: .filled,
        color: .green
    )

    /// Glass effect tag
    public static let glass = ARCTagConfiguration(
        style: .glass,
        backgroundStyle: .liquidGlass,
        shadow: .subtle
    )

    /// Outlined tag
    public static let outlined = ARCTagConfiguration(
        style: .outlined
    )
}
