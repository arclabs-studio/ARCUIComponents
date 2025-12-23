//
//  ARCBackgroundStyle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Background style options for ARC components with liquid glass effects
///
/// Provides multiple background style variations following Apple's design language,
/// as seen in apps like Music, Podcasts, and Fitness.
///
/// ## Overview
///
/// ARCBackgroundStyle defines the visual treatment for component backgrounds,
/// offering everything from Apple's signature liquid glass effect to solid colors.
///
/// ## Topics
///
/// ### Styles
///
/// - ``liquidGlass``
/// - ``translucent``
/// - ``solid(_:opacity:)``
/// - ``material(_:)``
///
/// ## Usage
///
/// ```swift
/// // Liquid glass effect (default for premium components)
/// let style: ARCBackgroundStyle = .liquidGlass
///
/// // Translucent blur
/// let style: ARCBackgroundStyle = .translucent
///
/// // Solid color with opacity
/// let style: ARCBackgroundStyle = .solid(.blue, opacity: 0.8)
///
/// // Custom material
/// let style: ARCBackgroundStyle = .material(.ultraThick)
/// ```
///
/// - Note: The liquid glass effect works best on iOS 17+ with ProMotion displays,
///   where the subtle animations and blur effects are most noticeable.
@available(iOS 17.0, *)
public enum ARCBackgroundStyle: Sendable {
    /// Apple's liquid glass effect with ultra-thin material and vibrancy
    ///
    /// Creates a premium, depth-rich appearance combining blur, gradient overlays,
    /// and subtle tinting. This is the signature style seen in Apple Music,
    /// Podcasts, and other flagship apps.
    ///
    /// The effect includes:
    /// - Ultra-thin material for system-aware adaptive blur
    /// - Gradient overlay for visual depth
    /// - Inner shadow for subtle dimensionality
    /// - Accent color tint (very subtle, 3% opacity)
    /// - Border stroke with gradient for definition
    case liquidGlass

    /// Translucent background with standard blur
    ///
    /// Lighter than liquid glass, using thin material with minimal accent tinting.
    /// Suitable for components that need visual hierarchy without overwhelming
    /// the content.
    case translucent

    /// Solid background with custom color and opacity
    ///
    /// Provides full control over background appearance when materials are not desired.
    /// Useful for high-contrast scenarios or when matching specific brand colors.
    ///
    /// - Parameters:
    ///   - color: The background color
    ///   - opacity: Opacity value from 0.0 (transparent) to 1.0 (opaque)
    case solid(Color, opacity: Double)

    /// Custom SwiftUI material effect
    ///
    /// Allows using any of SwiftUI's built-in materials (.ultraThin, .thin, .regular,
    /// .thick, .ultraThick) for maximum flexibility.
    ///
    /// - Parameter material: SwiftUI Material to use
    case material(Material)
}
