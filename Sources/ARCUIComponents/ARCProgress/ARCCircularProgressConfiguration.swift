//
//  ARCCircularProgressConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCCircularProgressConfiguration

/// Configuration for ARCCircularProgress appearance and behavior
///
/// Provides customization options for circular progress indicators following
/// Apple's Human Interface Guidelines.
///
/// ## Overview
///
/// Per Apple HIG: "Circular progress indicators have a track that fills in a
/// clockwise direction. An indeterminate progress indicator uses an animated
/// image to indicate progress."
///
/// ARCCircularProgressConfiguration allows you to customize:
/// - Size variants (small, medium, large, custom)
/// - Ring thickness and cap style
/// - Colors for track and progress
/// - Optional centered percentage label
/// - Animation behavior
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
/// - ``small``
/// - ``large``
/// - ``labeledProgress``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCircularProgressConfiguration: Sendable {
    // MARK: - Size

    /// Size variants for circular progress indicators
    public enum Size: Sendable, Equatable {
        /// Small size (20pt diameter)
        case small

        /// Medium size (40pt diameter)
        case medium

        /// Large size (60pt diameter)
        case large

        /// Custom size
        case custom(CGFloat)

        /// Diameter in points
        var diameter: CGFloat {
            switch self {
            case .small: 20
            case .medium: 40
            case .large: 60
            case let .custom(size): size
            }
        }

        /// Default line width based on size
        var defaultLineWidth: CGFloat {
            diameter * 0.1
        }
    }

    // MARK: - Properties

    /// Size of the circular indicator
    public let size: Size

    /// Thickness of the ring stroke
    public let lineWidth: CGFloat

    /// Color of the unfilled track
    public let trackColor: Color

    /// Color of the filled progress arc
    public let progressColor: Color

    /// Line cap style for the stroke
    public let lineCap: CGLineCap

    /// Whether to show percentage label in center
    public let showPercentage: Bool

    /// Font for the percentage label
    public let percentageFont: Font

    /// Start angle for the progress (default: top/12 o'clock)
    public let startAngle: Angle

    /// Whether to animate progress changes
    public let animated: Bool

    /// Animation duration for progress changes
    public let animationDuration: Double

    /// Rotation speed for indeterminate mode (seconds per rotation)
    public let rotationDuration: Double

    // MARK: - Computed Properties

    /// Diameter in points
    public var diameter: CGFloat {
        size.diameter
    }

    // MARK: - Initialization

    /// Creates a circular progress configuration with the specified options
    ///
    /// - Parameters:
    ///   - size: Size variant (default: .medium)
    ///   - lineWidth: Ring thickness (default: auto-calculated from size)
    ///   - trackColor: Color of unfilled track (default: secondary with 20% opacity)
    ///   - progressColor: Color of progress arc (default: accentColor)
    ///   - lineCap: Stroke cap style (default: .round)
    ///   - showPercentage: Show centered label (default: false)
    ///   - percentageFont: Font for percentage (default: .caption.monospacedDigit())
    ///   - startAngle: Start position (default: -90 degrees / 12 o'clock)
    ///   - animated: Animate changes (default: true)
    ///   - animationDuration: Animation duration (default: 0.3)
    ///   - rotationDuration: Indeterminate rotation speed (default: 1.0)
    public init(
        size: Size = .medium,
        lineWidth: CGFloat? = nil,
        trackColor: Color = Color.secondary.opacity(0.2),
        progressColor: Color = .accentColor,
        lineCap: CGLineCap = .round,
        showPercentage: Bool = false,
        percentageFont: Font = .caption.monospacedDigit(),
        startAngle: Angle = .degrees(-90),
        animated: Bool = true,
        animationDuration: Double = 0.3,
        rotationDuration: Double = 1.0
    ) {
        self.size = size
        self.lineWidth = lineWidth ?? size.defaultLineWidth
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.lineCap = lineCap
        self.showPercentage = showPercentage
        self.percentageFont = percentageFont
        self.startAngle = startAngle
        self.animated = animated
        self.animationDuration = animationDuration
        self.rotationDuration = rotationDuration
    }

    // MARK: - Presets

    /// Default circular progress (40pt, medium size)
    ///
    /// Standard size suitable for most use cases.
    public static let `default` = ARCCircularProgressConfiguration()

    /// Small circular progress (20pt)
    ///
    /// Compact size for inline indicators or tight spaces.
    public static let small = ARCCircularProgressConfiguration(
        size: .small,
        percentageFont: .caption2.monospacedDigit()
    )

    /// Large circular progress (60pt)
    ///
    /// Prominent size for primary progress indicators.
    public static let large = ARCCircularProgressConfiguration(
        size: .large,
        percentageFont: .body.monospacedDigit()
    )

    /// Progress indicator with centered percentage label
    ///
    /// Shows numeric percentage inside the ring.
    public static let labeledProgress = ARCCircularProgressConfiguration(
        size: .large,
        showPercentage: true,
        percentageFont: .headline.monospacedDigit()
    )

    /// Spinner style (indeterminate)
    ///
    /// Fast-spinning indicator for loading states.
    public static let spinner = ARCCircularProgressConfiguration(
        rotationDuration: 0.8
    )
}
