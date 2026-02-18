//
//  ARCStatHighlightCardConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCStatHighlightCard appearance
///
/// ## Presets
///
/// - ``default``
/// - ``compact``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatHighlightCardConfiguration: Sendable {
    /// Font for the title label
    public let titleFont: Font

    /// Font for the headline text
    public let headlineFont: Font

    /// Font for the subtitle text
    public let subtitleFont: Font

    /// Font for the subtitle icon
    public let subtitleIconFont: Font

    /// Internal spacing between elements
    public let spacing: CGFloat

    /// Padding around the card content
    public let padding: CGFloat

    /// Corner radius for the card background
    public let cornerRadius: CGFloat

    /// Creates a highlight card configuration
    public init(
        titleFont: Font = .caption.bold(),
        headlineFont: Font = .subheadline.bold(),
        subtitleFont: Font = .subheadline,
        subtitleIconFont: Font = .caption,
        spacing: CGFloat = .arcSpacingSmall,
        padding: CGFloat = .arcSpacingMedium,
        cornerRadius: CGFloat = .arcCornerRadiusMedium
    ) {
        self.titleFont = titleFont
        self.headlineFont = headlineFont
        self.subtitleFont = subtitleFont
        self.subtitleIconFont = subtitleIconFont
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
    }

    // MARK: - Presets

    /// Default configuration
    public static let `default` = ARCStatHighlightCardConfiguration()

    /// Compact configuration with smaller fonts
    public static let compact = ARCStatHighlightCardConfiguration(
        titleFont: .caption2.bold(),
        headlineFont: .caption.bold(),
        subtitleFont: .caption,
        subtitleIconFont: .caption2,
        spacing: .arcSpacingXSmall,
        padding: .arcSpacingSmall
    )
}
