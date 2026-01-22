//
//  ARCRatingViewConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import SwiftUI

// MARK: - ARCRatingViewConfiguration

/// Configuration for ARCRatingView appearance
///
/// Use presets for common configurations or create custom ones.
///
/// ## Presets
///
/// ```swift
/// // Circular gauge (default)
/// ARCRatingView(rating: 8.5, configuration: .circularGauge)
///
/// // Compact inline for lists
/// ARCRatingView(rating: 7.0, configuration: .compactInline)
///
/// // Minimal badge
/// ARCRatingView(rating: 9.2, configuration: .minimal)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingViewConfiguration: Sendable {
    // MARK: - Properties

    /// Visual style for the rating display
    public let style: ARCRatingStyle

    /// Maximum rating value (determines the scale)
    public let maxRating: Double

    /// Whether to animate value changes
    public let animated: Bool

    // MARK: - Initialization

    /// Creates a rating view configuration
    ///
    /// - Parameters:
    ///   - style: Visual style (default: `.circularGauge`)
    ///   - maxRating: Maximum rating value (default: `10.0`)
    ///   - animated: Whether to animate changes (default: `true`)
    public init(
        style: ARCRatingStyle = .circularGauge,
        maxRating: Double = 10.0,
        animated: Bool = true
    ) {
        self.style = style
        self.maxRating = maxRating
        self.animated = animated
    }

    // MARK: - Presets

    /// Circular gauge style, 1-10 scale, animated
    public static let circularGauge = ARCRatingViewConfiguration()

    /// Compact inline style for lists, 1-10 scale
    public static let compactInline = ARCRatingViewConfiguration(style: .compactInline)

    /// Minimal badge style, 1-10 scale
    public static let minimal = ARCRatingViewConfiguration(style: .minimal)
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *)
public extension View {
    /// Adds a rating overlay to the view
    ///
    /// - Parameters:
    ///   - rating: The rating value
    ///   - style: Visual style
    ///   - alignment: Position of the rating
    /// - Returns: View with rating overlay
    func ratingOverlay(
        _ rating: Double,
        style: ARCRatingStyle = .minimal,
        alignment: Alignment = .topTrailing
    ) -> some View {
        overlay(alignment: alignment) {
            ARCRatingView(rating: rating, style: style)
                .padding(8)
        }
    }
}
