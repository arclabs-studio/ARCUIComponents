//
//  ARCStatCardConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCStatCard appearance
///
/// Provides customization options for stat card appearance while maintaining
/// consistent design across all ARC apps.
///
/// ## Topics
///
/// ### Presets
///
/// - ``default``
/// - ``compact``
/// - ``prominent``
///
/// ## Usage
///
/// ```swift
/// ARCStatCard(icon: "star.fill", value: "42", label: "Total", configuration: .compact)
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCStatCardConfiguration: Sendable {
    /// Color for the icon
    public let iconColor: Color

    /// Font for the value text
    public let valueFont: Font

    /// Font for the label text
    public let labelFont: Font

    /// Font for the icon
    public let iconFont: Font

    /// Internal spacing between elements
    public let spacing: CGFloat

    /// Padding around the card content
    public let padding: CGFloat

    /// Corner radius for the card background
    public let cornerRadius: CGFloat

    /// Style used for ARCRatingView when the card displays a rating
    public let ratingStyle: ARCRatingStyle

    /// Creates a stat card configuration
    ///
    /// - Parameters:
    ///   - iconColor: Color for the icon (default: .accentColor)
    ///   - valueFont: Font for the value (default: .title.bold())
    ///   - labelFont: Font for the label (default: .caption)
    ///   - iconFont: Font for the icon (default: .title2)
    ///   - spacing: Spacing between elements (default: small)
    ///   - padding: Content padding (default: medium)
    ///   - cornerRadius: Corner radius (default: medium)
    ///   - ratingStyle: Style for ARCRatingView (default: .circularGauge)
    public init(iconColor: Color = .accentColor,
                valueFont: Font = .title.bold(),
                labelFont: Font = .caption,
                iconFont: Font = .title2,
                spacing: CGFloat = .arcSpacingSmall,
                padding: CGFloat = .arcSpacingMedium,
                cornerRadius: CGFloat = .arcCornerRadiusMedium,
                ratingStyle: ARCRatingStyle = .circularGauge)
    {
        self.iconColor = iconColor
        self.valueFont = valueFont
        self.labelFont = labelFont
        self.iconFont = iconFont
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.ratingStyle = ratingStyle
    }

    // MARK: - Presets

    /// Default configuration matching FavRes StatSummaryCard style
    public static let `default` = ARCStatCardConfiguration()

    /// Compact configuration with smaller fonts and less padding
    public static let compact = ARCStatCardConfiguration(valueFont: .title2.bold(),
                                                         labelFont: .caption2,
                                                         iconFont: .title3,
                                                         spacing: .arcSpacingXSmall,
                                                         padding: .arcSpacingSmall,
                                                         ratingStyle: .compactInline)

    /// Prominent configuration with larger icon and font
    public static let prominent = ARCStatCardConfiguration(valueFont: .largeTitle.bold(),
                                                           iconFont: .title,
                                                           spacing: .arcSpacingMedium,
                                                           padding: .arcSpacingLarge)
}
