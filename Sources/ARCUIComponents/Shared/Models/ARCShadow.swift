//
//  ARCShadow.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Shadow configuration for ARC components
///
/// Provides shadow presets and custom configuration following Apple's
/// Human Interface Guidelines for depth and hierarchy.
///
/// ## Overview
///
/// Shadows create visual depth and help establish hierarchy in your interface.
/// ARCShadow offers carefully calibrated presets that match Apple's design language,
/// along with the ability to create custom shadow configurations.
///
/// ## Topics
///
/// ### Properties
///
/// - ``color``
/// - ``radius``
/// - ``x``
/// - ``y``
///
/// ### Presets
///
/// - ``default``
/// - ``subtle``
/// - ``prominent``
/// - ``none``
///
/// ## Usage
///
/// ```swift
/// // Use a preset
/// let shadow = ARCShadow.default
///
/// // Create custom shadow
/// let shadow = ARCShadow(
///     color: .black.opacity(0.2),
///     radius: 15,
///     x: 0,
///     y: 8
/// )
/// ```
///
/// - Note: Shadows should be subtle and used sparingly. Excessive shadows can
///   make interfaces feel heavy and dated. Follow Apple's minimal approach.
@available(iOS 17.0, *)
public struct ARCShadow: Sendable {
    // MARK: - Properties

    /// The color of the shadow
    public let color: Color

    /// The blur radius of the shadow
    ///
    /// Larger values create softer, more diffuse shadows.
    /// Typical range: 5-30 points.
    public let radius: CGFloat

    /// Horizontal offset of the shadow
    ///
    /// Positive values shift the shadow to the right,
    /// negative values shift it to the left.
    public let x: CGFloat

    /// Vertical offset of the shadow
    ///
    /// Positive values shift the shadow downward,
    /// negative values shift it upward.
    public let y: CGFloat

    // MARK: - Initialization

    /// Creates a new shadow configuration
    ///
    /// - Parameters:
    ///   - color: Shadow color (typically black with low opacity)
    ///   - radius: Blur radius in points
    ///   - x: Horizontal offset in points
    ///   - y: Vertical offset in points
    public init(
        color: Color,
        radius: CGFloat,
        x: CGFloat,
        y: CGFloat
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    // MARK: - Presets

    /// Default shadow matching Apple's design language
    ///
    /// Subtle shadow with 10% opacity, 20pt radius, and 10pt vertical offset.
    /// Suitable for most elevated components like cards and menus.
    public static let `default` = ARCShadow(
        color: .black.opacity(0.1),
        radius: 20,
        x: 0,
        y: 10
    )

    /// Subtle shadow for minimal elevation
    ///
    /// Very light shadow with 5% opacity, 10pt radius, and 5pt vertical offset.
    /// Use for components that need slight separation without strong emphasis.
    public static let subtle = ARCShadow(
        color: .black.opacity(0.05),
        radius: 10,
        x: 0,
        y: 5
    )

    /// Prominent shadow for high elevation
    ///
    /// Stronger shadow with 15% opacity, 30pt radius, and 15pt vertical offset.
    /// Use sparingly for modals, popovers, or critical floating elements.
    public static let prominent = ARCShadow(
        color: .arcShadowMedium,
        radius: 30,
        x: 0,
        y: 15
    )

    /// No shadow
    ///
    /// Completely transparent shadow with zero dimensions.
    /// Use when shadow should be disabled or removed.
    public static let none = ARCShadow(
        color: .clear,
        radius: 0,
        x: 0,
        y: 0
    )
}
