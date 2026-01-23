//
//  ARCBadgeConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCBadgeConfiguration

/// Configuration for ARCBadge appearance and behavior
///
/// Provides customization options for badge size, style, and animation
/// while following Apple's Human Interface Guidelines for badges.
///
/// ## Overview
///
/// ARCBadge is designed for notification counts and status indicators.
/// Per Apple HIG: "Reserve badges for critical information so you don't
/// dilute their impact and meaning."
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
/// ### Presets
///
/// - ``default``
/// - ``dot``
/// - ``notification``
/// - ``success``
/// - ``warning``
/// - ``info``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBadgeConfiguration: Sendable {
    // MARK: - Size

    /// Size variants for badges
    public enum Size: Sendable {
        /// Small badge for dots or single digits (16pt height)
        case small

        /// Default badge size (20pt height)
        case medium

        /// Prominent badge (24pt height)
        case large

        /// Height in points
        var height: CGFloat {
            switch self {
            case .small: 16
            case .medium: 20
            case .large: 24
            }
        }

        /// Horizontal padding
        var horizontalPadding: CGFloat {
            switch self {
            case .small: 6
            case .medium: 8
            case .large: 10
            }
        }

        /// Font size
        var fontSize: CGFloat {
            switch self {
            case .small: 10
            case .medium: 12
            case .large: 14
            }
        }
    }

    // MARK: - Style

    /// Visual styles for badges
    public enum Style: Sendable, Equatable {
        /// Solid filled background with contrasting text
        case filled(Color)

        /// Outlined border with transparent background
        case outlined(Color)

        /// Subtle background with matching text
        case subtle(Color)

        /// The primary color for this style
        var color: Color {
            switch self {
            case let .filled(color), let .outlined(color), let .subtle(color):
                color
            }
        }
    }

    // MARK: - Properties

    /// Badge size
    public let size: Size

    /// Visual style
    public let style: Style

    /// Maximum count before showing "99+"
    public let maxCount: Int

    /// Whether to show badge when count is zero
    public let showZero: Bool

    /// Whether to animate on count changes
    public let animate: Bool

    // MARK: - Initialization

    /// Creates a badge configuration with the specified options
    ///
    /// - Parameters:
    ///   - size: Badge size (default: .medium)
    ///   - style: Visual style (default: filled red)
    ///   - maxCount: Maximum displayable count (default: 99)
    ///   - showZero: Show badge when count is 0 (default: false)
    ///   - animate: Animate on changes (default: true)
    public init(
        size: Size = .medium,
        style: Style = .filled(.red),
        maxCount: Int = 99,
        showZero: Bool = false,
        animate: Bool = true
    ) {
        self.size = size
        self.style = style
        self.maxCount = maxCount
        self.showZero = showZero
        self.animate = animate
    }

    // MARK: - Presets

    /// Default red notification badge
    public static let `default` = ARCBadgeConfiguration()

    /// Small dot indicator
    public static let dot = ARCBadgeConfiguration(
        size: .small,
        style: .filled(.red),
        showZero: true
    )

    /// Notification-style badge (same as default)
    public static let notification = ARCBadgeConfiguration(
        size: .medium,
        style: .filled(.red)
    )

    /// Success indicator (green)
    public static let success = ARCBadgeConfiguration(
        style: .filled(.green)
    )

    /// Warning indicator (orange)
    public static let warning = ARCBadgeConfiguration(
        style: .filled(.orange)
    )

    /// Info indicator (blue)
    public static let info = ARCBadgeConfiguration(
        style: .filled(.blue)
    )

    /// Subtle style with gray background
    public static let subtle = ARCBadgeConfiguration(
        style: .subtle(.gray)
    )

    /// Outlined style
    public static let outlined = ARCBadgeConfiguration(
        style: .outlined(.red)
    )
}
