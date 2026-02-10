//
//  ARCRatingInputConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/2/26.
//

import SwiftUI

// MARK: - ARCRatingInputConfiguration

/// Configuration for ARCRatingInputView appearance and behavior
///
/// Use presets for common configurations or create custom ones.
///
/// ## Presets
///
/// ```swift
/// // Slider style (default)
/// ARCRatingInputView(rating: $rating, configuration: .slider)
///
/// // Circular drag style
/// ARCRatingInputView(rating: $rating, configuration: .circularDrag)
///
/// // Compact (no label)
/// ARCRatingInputView(rating: $rating, configuration: .compact)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingInputConfiguration: Sendable {
    // MARK: - Properties

    /// Interaction style for rating selection
    public let style: ARCRatingInputStyle

    /// Whether to show the numeric label in the gauge
    public let showLabel: Bool

    /// Whether to show the hint text below the circular drag gauge
    public let showHint: Bool

    /// Whether to animate value changes
    public let animated: Bool

    // MARK: - Initialization

    /// Creates a rating input configuration
    ///
    /// - Parameters:
    ///   - style: Interaction style (default: `.slider`)
    ///   - showLabel: Whether to show numeric label (default: `true`)
    ///   - showHint: Whether to show hint text for circular drag (default: `true`)
    ///   - animated: Whether to animate changes (default: `true`)
    public init(
        style: ARCRatingInputStyle = .slider,
        showLabel: Bool = true,
        showHint: Bool = true,
        animated: Bool = true
    ) {
        self.style = style
        self.showLabel = showLabel
        self.showHint = showHint
        self.animated = animated
    }

    // MARK: - Presets

    /// Slider style with label, animated
    public static let slider = ARCRatingInputConfiguration()

    /// Circular drag style with label, animated
    public static let circularDrag = ARCRatingInputConfiguration(style: .circularDrag)

    /// Circular drag style without label (compact)
    public static let compact = ARCRatingInputConfiguration(
        style: .circularDrag,
        showLabel: false
    )
}
