//
//  ARCBarChartConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCBarChart appearance
///
/// ## Presets
///
/// - ``default``
/// - ``horizontal``
@available(iOS 17.0, macOS 14.0, *) public struct ARCBarChartConfiguration: Sendable {
    /// Bar chart orientation
    public enum Orientation: Sendable {
        case vertical
        case horizontal
    }

    /// Chart orientation
    public let orientation: Orientation

    /// Default bar color when no per-item color is provided
    public let defaultColor: Color

    /// Whether to apply gradient to bars
    public let useGradient: Bool

    /// Corner radius for bar marks
    public let cornerRadius: CGFloat

    /// Whether to show value annotations on bars
    public let showAnnotations: Bool

    /// Chart height (nil = auto-calculated from item count for horizontal)
    public let height: CGFloat?

    /// Height per bar for horizontal charts (used for auto height calculation)
    public let heightPerBar: CGFloat

    /// Horizontal padding
    public let horizontalPadding: CGFloat

    /// Creates a bar chart configuration
    public init(orientation: Orientation = .vertical,
                defaultColor: Color = .accentColor,
                useGradient: Bool = true,
                cornerRadius: CGFloat = 4,
                showAnnotations: Bool = false,
                height: CGFloat? = nil,
                heightPerBar: CGFloat = 40,
                horizontalPadding: CGFloat = .arcSpacingLarge) {
        self.orientation = orientation
        self.defaultColor = defaultColor
        self.useGradient = useGradient
        self.cornerRadius = cornerRadius
        self.showAnnotations = showAnnotations
        self.height = height
        self.heightPerBar = heightPerBar
        self.horizontalPadding = horizontalPadding
    }

    // MARK: - Presets

    /// Default vertical bar chart
    public static let `default` = ARCBarChartConfiguration(height: 160)

    /// Horizontal bar chart with annotations
    public static let horizontal = ARCBarChartConfiguration(orientation: .horizontal,
                                                            showAnnotations: true)
}
