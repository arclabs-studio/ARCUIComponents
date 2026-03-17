//
//  ARCStepIndicatorConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCStepIndicatorConfiguration

/// Configuration for ARCStepIndicator appearance and behavior
///
/// Provides customization options for multi-step progress indicators,
/// commonly used in onboarding, checkout, or wizard flows.
///
/// ## Overview
///
/// Step indicators show progress through a multi-step process,
/// helping users understand where they are and how many steps remain.
///
/// ARCStepIndicatorConfiguration allows you to customize:
/// - Visual style (numbered, dots, icons, labels)
/// - Layout direction (horizontal, vertical)
/// - Step sizes and spacing
/// - Colors for completed, current, and pending states
/// - Animation behavior
///
/// ## Topics
///
/// ### Style
///
/// - ``Style-swift.enum``
///
/// ### Layout
///
/// - ``Layout-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``compact``
/// - ``detailed``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStepIndicatorConfiguration: Sendable {
    // MARK: - Style

    /// Visual styles for step indicators
    public enum Style: Sendable, Equatable {
        /// Shows step numbers (1, 2, 3...)
        case numbered

        /// Simple dots without numbers
        case dots

        /// SF Symbols icons for each step
        case icons([String])

        /// Text labels below each step
        case labels([String])

        /// Compares only the case, not associated values for Equatable
        public static func == (lhs: Style, rhs: Style) -> Bool {
            switch (lhs, rhs) {
            case (.numbered, .numbered),
                 (.dots, .dots):
                true
            case let (.icons(lhsIcons), .icons(rhsIcons)):
                lhsIcons == rhsIcons
            case let (.labels(lhsLabels), .labels(rhsLabels)):
                lhsLabels == rhsLabels
            default:
                false
            }
        }
    }

    // MARK: - Layout

    /// Layout direction for step indicators
    public enum Layout: Sendable, Equatable {
        /// Steps arranged horizontally
        case horizontal

        /// Steps arranged vertically
        case vertical
    }

    // MARK: - Properties

    /// Visual style of the steps
    public let style: Style

    /// Layout direction
    public let layout: Layout

    /// Diameter of step circles in points
    public let stepSize: CGFloat

    /// Length of connector lines between steps
    public let connectorLength: CGFloat

    /// Thickness of connector lines
    public let connectorThickness: CGFloat

    // MARK: - Colors

    /// Color for completed steps
    public let completedColor: Color

    /// Color for the current step
    public let currentColor: Color

    /// Color for pending (future) steps
    public let pendingColor: Color

    /// Color for connector lines
    public let connectorColor: Color

    // MARK: - Typography

    /// Font for step numbers
    public let numberFont: Font

    /// Font for step labels (when using labels style)
    public let labelFont: Font

    // MARK: - Animation

    /// Whether to animate step transitions
    public let animated: Bool

    /// Animation duration for transitions
    public let animationDuration: Double

    /// Whether to show checkmark animation on completion
    public let showCheckmarkAnimation: Bool

    // MARK: - Computed Properties

    /// Icons array (for icons style)
    var icons: [String] {
        if case let .icons(iconArray) = style {
            return iconArray
        }
        return []
    }

    /// Labels array (for labels style)
    var labels: [String] {
        if case let .labels(labelArray) = style {
            return labelArray
        }
        return []
    }

    // MARK: - Initialization

    /// Creates a step indicator configuration with the specified options
    ///
    /// - Parameters:
    ///   - style: Visual style (default: .numbered)
    ///   - layout: Layout direction (default: .horizontal)
    ///   - stepSize: Step circle diameter (default: 28)
    ///   - connectorLength: Line length between steps (default: 40)
    ///   - connectorThickness: Line thickness (default: 2)
    ///   - completedColor: Color for completed steps (default: accentColor)
    ///   - currentColor: Color for current step (default: accentColor)
    ///   - pendingColor: Color for pending steps (default: secondary at 30% opacity)
    ///   - connectorColor: Color for connector lines (default: secondary at 20% opacity)
    ///   - numberFont: Font for numbers (default: .caption.bold())
    ///   - labelFont: Font for labels (default: .caption)
    ///   - animated: Enable animations (default: true)
    ///   - animationDuration: Animation duration (default: 0.3)
    ///   - showCheckmarkAnimation: Show checkmark on complete (default: true)
    public init(
        style: Style = .numbered,
        layout: Layout = .horizontal,
        stepSize: CGFloat = 28,
        connectorLength: CGFloat = 40,
        connectorThickness: CGFloat = 2,
        completedColor: Color = .accentColor,
        currentColor: Color = .accentColor,
        pendingColor: Color = Color.secondary.opacity(0.3),
        connectorColor: Color = Color.secondary.opacity(0.2),
        numberFont: Font = .caption.bold(),
        labelFont: Font = .caption,
        animated: Bool = true,
        animationDuration: Double = 0.3,
        showCheckmarkAnimation: Bool = true
    ) {
        self.style = style
        self.layout = layout
        self.stepSize = stepSize
        self.connectorLength = connectorLength
        self.connectorThickness = connectorThickness
        self.completedColor = completedColor
        self.currentColor = currentColor
        self.pendingColor = pendingColor
        self.connectorColor = connectorColor
        self.numberFont = numberFont
        self.labelFont = labelFont
        self.animated = animated
        self.animationDuration = animationDuration
        self.showCheckmarkAnimation = showCheckmarkAnimation
    }

    // MARK: - Presets

    /// Default step indicator (numbered, horizontal)
    ///
    /// Standard configuration for most wizard/checkout flows.
    public static let `default` = ARCStepIndicatorConfiguration()

    /// Compact dots indicator
    ///
    /// Minimal style, suitable for onboarding or limited space.
    public static let compact = ARCStepIndicatorConfiguration(
        style: .dots,
        stepSize: 10,
        connectorLength: 24,
        connectorThickness: 2
    )

    /// Detailed vertical indicator with labels
    ///
    /// Full-featured style with step descriptions.
    public static func detailed(labels: [String]) -> ARCStepIndicatorConfiguration {
        ARCStepIndicatorConfiguration(
            style: .labels(labels),
            layout: .vertical,
            stepSize: 32,
            connectorLength: 40
        )
    }

    /// Icon-based indicator
    ///
    /// Uses SF Symbols for each step.
    public static func withIcons(_ icons: [String]) -> ARCStepIndicatorConfiguration {
        ARCStepIndicatorConfiguration(
            style: .icons(icons),
            stepSize: 32
        )
    }
}
