//
//  LiquidGlassConfigurable.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

/// Protocol for types that can provide liquid glass effect configuration
///
/// Components that want to use the liquid glass effect should have their
/// configuration types conform to this protocol, providing the necessary
/// visual styling properties.
///
/// ## Overview
///
/// LiquidGlassConfigurable defines the minimum set of properties needed to
/// render the liquid glass effect consistently across all ARC components.
///
/// By conforming to this protocol, component configurations can leverage
/// the unified ``LiquidGlassModifier`` without duplicating code.
///
/// ## Topics
///
/// ### Required Properties
///
/// - ``accentColor``
/// - ``backgroundStyle``
/// - ``cornerRadius``
/// - ``shadow``
///
/// ## Usage
///
/// ```swift
/// public struct MyComponentConfiguration: LiquidGlassConfigurable {
///     public let accentColor: Color
///     public let backgroundStyle: ARCBackgroundStyle
///     public let cornerRadius: CGFloat
///     public let shadow: ARCShadow
///
///     // Additional component-specific properties...
/// }
///
/// // Use with liquid glass modifier
/// MyView()
///     .liquidGlass(configuration: myConfig)
/// ```
///
/// - Note: All conforming types should be `Sendable` for Swift 6 concurrency safety.
@available(iOS 17.0, *)
public protocol LiquidGlassConfigurable: Sendable {
    /// Primary accent color for the component
    ///
    /// This color is used very subtly (typically 3% opacity) as an overlay
    /// in the liquid glass effect, adding a hint of the theme color to the blur.
    var accentColor: Color { get }

    /// Background style for the liquid glass effect
    ///
    /// Determines the visual treatment of the component's background.
    /// Use `.liquidGlass` for the premium Apple-style effect, or choose
    /// alternatives like `.translucent`, `.solid`, or `.material`.
    var backgroundStyle: ARCBackgroundStyle { get }

    /// Corner radius for the component
    ///
    /// Defines the roundedness of corners. Apple typically uses continuous
    /// corner radii between 12-32 points for modern interfaces.
    ///
    /// Recommended values:
    /// - Small components: 12-16pt
    /// - Medium components: 20-24pt
    /// - Large components: 28-32pt
    var cornerRadius: CGFloat { get }

    /// Shadow configuration for the component
    ///
    /// Defines the shadow appearance. Use preset values like ``ARCShadow/default``,
    /// ``ARCShadow/subtle``, or ``ARCShadow/prominent`` for consistency.
    var shadow: ARCShadow { get }
}
