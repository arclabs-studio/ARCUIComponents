//
//  ARCLinearProgressConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCLinearProgressConfiguration

/// Configuration for ARCLinearProgress appearance and behavior
///
/// Provides customization options for linear progress bars following
/// Apple's Human Interface Guidelines for progress indicators.
///
/// ## Overview
///
/// Per Apple HIG: "A determinate progress indicator shows the progress of a task
/// by filling a linear or circular track as the task completes."
///
/// ARCLinearProgressConfiguration allows you to customize:
/// - Visual style (default, rounded, flat)
/// - Height variants (thin, default, thick)
/// - Colors for track and progress
/// - Animation behavior
/// - Optional percentage label
///
/// ## Topics
///
/// ### Style
///
/// - ``Style-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``thick``
/// - ``thin``
/// - ``glass``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCLinearProgressConfiguration: LiquidGlassConfigurable, Sendable {
    // MARK: - Style

    /// Visual styles for linear progress bars
    public enum Style: Sendable, Equatable {
        /// Default style with standard corner radius
        case `default`

        /// Pill shape with fully rounded corners
        case rounded

        /// No corner radius (flat ends)
        case flat
    }

    // MARK: - Properties

    /// Visual style of the progress bar
    public let style: Style

    /// Height of the progress bar in points
    public let height: CGFloat

    /// Color of the unfilled track
    public let trackColor: Color

    /// Color of the filled progress
    public let progressColor: Color

    /// Whether to show percentage label next to the bar
    public let showPercentage: Bool

    /// Font for the percentage label
    public let percentageFont: Font

    /// Whether to animate progress changes
    public let animated: Bool

    /// Animation duration for progress changes
    public let animationDuration: Double

    // MARK: - LiquidGlassConfigurable

    /// Accent color for glass effect
    public let accentColor: Color

    /// Background style for glass effect
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius (calculated from height for rounded style)
    public var cornerRadius: CGFloat {
        switch style {
        case .default:
            height / 2
        case .rounded:
            height / 2
        case .flat:
            0
        }
    }

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a linear progress configuration with the specified options
    ///
    /// - Parameters:
    ///   - style: Visual style (default: .default)
    ///   - height: Height in points (default: 4)
    ///   - trackColor: Color of unfilled track (default: secondary with 20% opacity)
    ///   - progressColor: Color of filled progress (default: accentColor)
    ///   - showPercentage: Show percentage label (default: false)
    ///   - percentageFont: Font for percentage (default: .caption)
    ///   - animated: Animate changes (default: true)
    ///   - animationDuration: Animation duration (default: 0.3)
    ///   - shadow: Shadow configuration (default: .none)
    public init(
        style: Style = .default,
        height: CGFloat = 4,
        trackColor: Color = Color.secondary.opacity(0.2),
        progressColor: Color = .accentColor,
        showPercentage: Bool = false,
        percentageFont: Font = .caption,
        animated: Bool = true,
        animationDuration: Double = 0.3,
        shadow: ARCShadow = .none
    ) {
        self.style = style
        self.height = height
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.showPercentage = showPercentage
        self.percentageFont = percentageFont
        self.animated = animated
        self.animationDuration = animationDuration
        accentColor = progressColor
        backgroundStyle = .solid(trackColor, opacity: 1.0)
        self.shadow = shadow
    }

    // MARK: - Presets

    /// Default progress bar (4pt height, rounded corners)
    ///
    /// Standard size suitable for most use cases.
    public static let `default` = ARCLinearProgressConfiguration()

    /// Thick progress bar (8pt height)
    ///
    /// More prominent, use for primary progress indicators.
    public static let thick = ARCLinearProgressConfiguration(
        height: 8
    )

    /// Thin progress bar (2pt height)
    ///
    /// Subtle, use for compact spaces or secondary indicators.
    public static let thin = ARCLinearProgressConfiguration(
        height: 2
    )

    /// Glass effect progress bar
    ///
    /// Premium style with translucent track.
    public static let glass = ARCLinearProgressConfiguration(
        trackColor: Color.white.opacity(0.15),
        progressColor: .white,
        shadow: .subtle
    )

    /// Progress bar with percentage label
    ///
    /// Shows numeric percentage next to the bar.
    public static let withPercentage = ARCLinearProgressConfiguration(
        showPercentage: true
    )
}
