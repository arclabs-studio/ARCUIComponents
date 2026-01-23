//
//  ARCChipConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCChipConfiguration

/// Configuration for ARCChip appearance and behavior
///
/// Provides customization options for chip size, colors, and interaction behavior.
/// Conforms to `LiquidGlassConfigurable` for consistent styling across ARC components.
///
/// ## Topics
///
/// ### Size
///
/// - ``Size-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``filter``
/// - ``input``
/// - ``glass``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCChipConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Size

    /// Size variants for chips
    public enum Size: Sendable {
        /// Small chip
        case small

        /// Default chip size
        case medium

        /// Large chip
        case large

        /// Height in points (minimum 44pt for touch target)
        var height: CGFloat {
            switch self {
            case .small: 32
            case .medium: 36
            case .large: 44
            }
        }

        /// Horizontal padding
        var horizontalPadding: CGFloat {
            switch self {
            case .small: 12
            case .medium: 14
            case .large: 16
            }
        }

        /// Font size
        var fontSize: CGFloat {
            switch self {
            case .small: 13
            case .medium: 14
            case .large: 15
            }
        }

        /// Icon size
        var iconSize: CGFloat {
            switch self {
            case .small: 14
            case .medium: 16
            case .large: 18
            }
        }
    }

    // MARK: - Properties

    /// Chip size
    public let size: Size

    /// Color when selected
    public let selectedColor: Color

    /// Color when unselected
    public let unselectedColor: Color

    /// Whether to show checkmark when selected
    public let showCheckmark: Bool

    /// Whether to trigger haptic feedback on tap
    public let hapticFeedback: Bool

    /// Whether to show dismiss (X) button when selected
    public let dismissible: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Accent color for liquid glass effect
    public let accentColor: Color

    /// Background style
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a chip configuration with the specified options
    ///
    /// - Parameters:
    ///   - size: Chip size (default: .medium)
    ///   - selectedColor: Color when selected (default: .blue)
    ///   - unselectedColor: Color when unselected (default: .gray)
    ///   - showCheckmark: Show checkmark when selected (default: true)
    ///   - hapticFeedback: Trigger haptics on tap (default: true)
    ///   - dismissible: Show X button when selected (default: false)
    ///   - accentColor: Accent for glass effect (default: .blue)
    ///   - backgroundStyle: Background style (default: .translucent)
    ///   - cornerRadius: Corner radius (default: 0 for capsule)
    ///   - shadow: Shadow configuration (default: .none)
    public init(
        size: Size = .medium,
        selectedColor: Color = .blue,
        unselectedColor: Color = .gray,
        showCheckmark: Bool = true,
        hapticFeedback: Bool = true,
        dismissible: Bool = false,
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .translucent,
        cornerRadius: CGFloat = 0,
        shadow: ARCShadow = .none
    ) {
        self.size = size
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.showCheckmark = showCheckmark
        self.hapticFeedback = hapticFeedback
        self.dismissible = dismissible
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Presets

    /// Default chip configuration
    public static let `default` = ARCChipConfiguration()

    /// Filter chip for filtering UIs
    public static let filter = ARCChipConfiguration(
        showCheckmark: true,
        dismissible: false
    )

    /// Input chip for form inputs (dismissible)
    public static let input = ARCChipConfiguration(
        showCheckmark: false,
        dismissible: true
    )

    /// Glass effect chip
    public static let glass = ARCChipConfiguration(
        backgroundStyle: .liquidGlass,
        shadow: .subtle
    )

    /// Compact chip without checkmark
    public static let compact = ARCChipConfiguration(
        size: .small,
        showCheckmark: false
    )
}
