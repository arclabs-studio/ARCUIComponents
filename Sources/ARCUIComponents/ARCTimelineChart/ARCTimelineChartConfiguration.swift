//
//  ARCTimelineChartConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCTimelineChart appearance
///
/// ## Presets
///
/// - ``default``
/// - ``compact``
@available(iOS 17.0, macOS 14.0, *) public struct ARCTimelineChartConfiguration: Sendable {
    /// Color for the line mark
    public let lineColor: Color

    /// Whether to fill the area under the line with a gradient
    public let fillGradient: Bool

    /// Line width in points
    public let lineWidth: CGFloat

    /// Chart height in points
    public let height: CGFloat

    /// Calendar component for x-axis stride
    public let xAxisStride: Calendar.Component

    /// Stride count for x-axis marks
    public let xAxisStrideCount: Int

    /// Horizontal padding
    public let horizontalPadding: CGFloat

    /// Creates a timeline chart configuration
    public init(lineColor: Color = .accentColor,
                fillGradient: Bool = true,
                lineWidth: CGFloat = 2,
                height: CGFloat = 200,
                xAxisStride: Calendar.Component = .month,
                xAxisStrideCount: Int = 2,
                horizontalPadding: CGFloat = .arcSpacingLarge) {
        self.lineColor = lineColor
        self.fillGradient = fillGradient
        self.lineWidth = lineWidth
        self.height = height
        self.xAxisStride = xAxisStride
        self.xAxisStrideCount = xAxisStrideCount
        self.horizontalPadding = horizontalPadding
    }

    // MARK: - Presets

    /// Default timeline chart with gradient fill
    public static let `default` = ARCTimelineChartConfiguration()

    /// Compact configuration without gradient fill
    public static let compact = ARCTimelineChartConfiguration(fillGradient: false,
                                                              height: 120)
}
