//
//  ARCSegmentedControlConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSegmentedControlConfiguration

/// Configuration for ARCSegmentedControl appearance and behavior
///
/// Provides customization options for visual style, sizing, colors, and animation behavior.
/// Conforms to `LiquidGlassConfigurable` for consistent styling across ARC components.
///
/// ## Overview
///
/// `ARCSegmentedControlConfiguration` allows you to customize the appearance of
/// segmented controls to match your app's design while maintaining Apple's
/// Human Interface Guidelines standards.
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
/// ### Segment Width
///
/// - ``SegmentWidth-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``outlined``
/// - ``glass``
/// - ``underlined``
/// - ``pill``
///
/// ## Usage
///
/// ```swift
/// // Use a preset
/// ARCSegmentedControl(
///     selection: $tab,
///     segments: segments,
///     configuration: .glass
/// )
///
/// // Custom configuration
/// ARCSegmentedControl(
///     selection: $tab,
///     segments: segments,
///     configuration: ARCSegmentedControlConfiguration(
///         style: .filled,
///         size: .large,
///         selectedColor: .blue
///     )
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSegmentedControlConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Style

    /// Visual style variants for the segmented control
    public enum Style: Sendable {
        /// iOS default style with filled selection indicator
        case filled

        /// Border outline around selected segment
        case outlined

        /// Liquid glass blur effect
        case glass

        /// Tab-like underline indicator
        case underlined
    }

    // MARK: - Size

    /// Size variants for the segmented control
    public enum Size: Sendable {
        /// Small size (28pt height)
        case small

        /// Medium size (36pt height)
        case medium

        /// Large size (44pt height)
        case large

        /// Height in points
        var height: CGFloat {
            switch self {
            case .small: 28
            case .medium: 36
            case .large: 44
            }
        }

        /// Font for segment labels
        var font: Font {
            switch self {
            case .small: .subheadline
            case .medium: .body
            case .large: .body.weight(.medium)
            }
        }

        /// Icon size in points
        var iconSize: CGFloat {
            switch self {
            case .small: 12
            case .medium: 14
            case .large: 16
            }
        }

        /// Horizontal padding inside segments
        var horizontalPadding: CGFloat {
            switch self {
            case .small: 8
            case .medium: 12
            case .large: 16
            }
        }
    }

    // MARK: - SegmentWidth

    /// Width behavior for segments
    public enum SegmentWidth: Sendable, Equatable {
        /// All segments have equal width
        case equal

        /// Width based on content size
        case proportional

        /// Fixed width per segment
        case fixed(CGFloat)
    }

    // MARK: - Properties

    /// Visual style of the control
    public let style: Style

    /// Size variant
    public let size: Size

    /// Segment width behavior
    public let segmentWidth: SegmentWidth

    /// Color for selection indicator
    public let selectedColor: Color

    /// Color for unselected text/icons
    public let unselectedColor: Color

    /// Color for selected segment text
    public let selectedTextColor: Color

    /// Background color for the control container
    public let backgroundColor: Color

    /// Whether to animate selection changes
    public let animated: Bool

    /// Whether to trigger haptic feedback on selection
    public let hapticFeedback: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Accent color for liquid glass effect
    public let accentColor: Color

    /// Background style
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the control
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a segmented control configuration with the specified options
    ///
    /// - Parameters:
    ///   - style: Visual style (default: .filled)
    ///   - size: Size variant (default: .medium)
    ///   - segmentWidth: Segment width behavior (default: .equal)
    ///   - selectedColor: Selection indicator color (default: .white for filled)
    ///   - unselectedColor: Unselected text color (default: .secondary)
    ///   - selectedTextColor: Selected text color (default: .primary)
    ///   - backgroundColor: Container background (default: system gray)
    ///   - animated: Enable animations (default: true)
    ///   - hapticFeedback: Enable haptics (default: true)
    ///   - accentColor: Accent for glass effect (default: .blue)
    ///   - backgroundStyle: Background style (default: .translucent)
    ///   - cornerRadius: Corner radius (default: 8)
    ///   - shadow: Shadow configuration (default: .none)
    public init(
        style: Style = .filled,
        size: Size = .medium,
        segmentWidth: SegmentWidth = .equal,
        selectedColor: Color = .white,
        unselectedColor: Color = .secondary,
        selectedTextColor: Color = .primary,
        backgroundColor: Color = .gray.opacity(0.15),
        animated: Bool = true,
        hapticFeedback: Bool = true,
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = 8,
        shadow: ARCShadow = .none
    ) {
        self.style = style
        self.size = size
        self.segmentWidth = segmentWidth
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.selectedTextColor = selectedTextColor
        self.backgroundColor = backgroundColor
        self.animated = animated
        self.hapticFeedback = hapticFeedback
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Computed Properties

    /// Corner radius for the selection indicator (slightly smaller than container)
    var selectionCornerRadius: CGFloat {
        max(cornerRadius - 2, 4)
    }

    /// Padding inside the container
    var containerPadding: CGFloat {
        style == .underlined ? 0 : 2
    }

    // MARK: - Presets

    /// Default iOS-like filled style
    public static let `default` = ARCSegmentedControlConfiguration()

    /// Outlined style with border
    public static let outlined = ARCSegmentedControlConfiguration(
        style: .outlined,
        selectedColor: .accentColor,
        unselectedColor: .secondary,
        selectedTextColor: .accentColor,
        backgroundColor: .clear,
        cornerRadius: 8
    )

    /// Liquid glass effect style
    public static let glass = ARCSegmentedControlConfiguration(
        style: .glass,
        selectedColor: .white.opacity(0.9),
        unselectedColor: .primary.opacity(0.6),
        selectedTextColor: .primary,
        backgroundColor: .clear,
        backgroundStyle: .liquidGlass,
        cornerRadius: 12,
        shadow: .subtle
    )

    /// Tab-like underlined style
    public static let underlined = ARCSegmentedControlConfiguration(
        style: .underlined,
        selectedColor: .accentColor,
        unselectedColor: .secondary,
        selectedTextColor: .accentColor,
        backgroundColor: .clear,
        cornerRadius: 0
    )

    /// Pill-shaped compact style
    public static let pill = ARCSegmentedControlConfiguration(
        style: .filled,
        size: .small,
        selectedColor: .accentColor,
        unselectedColor: .secondary,
        selectedTextColor: .white,
        backgroundColor: .gray.opacity(0.15),
        cornerRadius: 14
    )

    /// Large prominent style
    public static let large = ARCSegmentedControlConfiguration(
        size: .large,
        cornerRadius: 12
    )

    /// Small compact style
    public static let small = ARCSegmentedControlConfiguration(
        size: .small,
        cornerRadius: 6
    )
}
