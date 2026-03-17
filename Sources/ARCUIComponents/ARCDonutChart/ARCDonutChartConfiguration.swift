//
//  ARCDonutChartConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCDonutChart appearance
///
/// ## Presets
///
/// - ``default``
/// - ``compact``
@available(iOS 17.0, macOS 14.0, *) public struct ARCDonutChartConfiguration: Sendable {
    /// Color palette for chart sectors (cycles through if more items than colors)
    public let colors: [Color]

    /// Inner radius ratio (0.0 = pie, 1.0 = ring). Default: 0.6
    public let innerRadiusRatio: CGFloat

    /// Angular inset between sectors in points
    public let angularInset: CGFloat

    /// Corner radius for sector marks
    public let cornerRadius: CGFloat

    /// Whether to show a legend list below the chart
    public let showLegend: Bool

    /// Maximum number of sectors before grouping remainder into "Other"
    public let maxSectors: Int

    /// Chart height in points
    public let height: CGFloat

    /// Horizontal padding
    public let horizontalPadding: CGFloat

    /// Creates a donut chart configuration
    public init(colors: [Color] = [.accentColor, .blue, .orange, .red, .green, .purple, .gray],
                innerRadiusRatio: CGFloat = 0.6,
                angularInset: CGFloat = 2,
                cornerRadius: CGFloat = 4,
                showLegend: Bool = true,
                maxSectors: Int = 7,
                height: CGFloat = 200,
                horizontalPadding: CGFloat = .arcSpacingLarge) {
        self.colors = colors
        self.innerRadiusRatio = innerRadiusRatio
        self.angularInset = angularInset
        self.cornerRadius = cornerRadius
        self.showLegend = showLegend
        self.maxSectors = maxSectors
        self.height = height
        self.horizontalPadding = horizontalPadding
    }

    // MARK: - Presets

    /// Default donut chart configuration
    public static let `default` = ARCDonutChartConfiguration()

    /// Compact configuration without legend
    public static let compact = ARCDonutChartConfiguration(showLegend: false,
                                                           height: 150)
}
