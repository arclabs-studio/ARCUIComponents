//
//  LiquidGlassModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Liquid glass effect modifier for ARC components
///
/// Implements Apple's modern glassmorphism effect seen in flagship apps like
/// Music, Podcasts, and Fitness. Combines ultra-thin materials, vibrancy, and
/// subtle blur for a premium, depth-rich appearance.
///
/// ## Overview
///
/// The liquid glass effect creates a sense of layering and hierarchy while
/// maintaining readability and following Apple's Human Interface Guidelines.
///
/// This unified modifier can be used with any component whose configuration
/// conforms to ``LiquidGlassConfigurable``, ensuring visual consistency
/// across the entire ARCUIComponents package.
///
/// ## Topics
///
/// ### Creating the Effect
///
/// - ``init(configuration:)``
///
/// ### View Extension
///
/// - ``SwiftUI/View/liquidGlass(configuration:)``
///
/// ## Usage
///
/// ```swift
/// // With any LiquidGlassConfigurable configuration
/// MyView()
///     .liquidGlass(configuration: myConfig)
///
/// // The modifier automatically adapts to:
/// // - .liquidGlass: Full premium effect
/// // - .translucent: Standard blur
/// // - .solid: Custom color
/// // - .material: Custom material
/// ```
///
/// ## Design Philosophy
///
/// The liquid glass effect is subtle yet sophisticated. It provides:
/// - **Depth**: Multiple layers create visual hierarchy
/// - **Vibrancy**: Content beneath shows through with enhanced contrast
/// - **Subtlety**: Effects are noticeable but never overwhelming
/// - **Adaptability**: Automatically adjusts for Dark Mode and accessibility
///
/// - Note: Best experienced on ProMotion displays where subtle animations
///   and blur transitions are smoothest.
@available(iOS 17.0, *)
struct LiquidGlassModifier<Configuration: LiquidGlassConfigurable>: ViewModifier {
    // MARK: - Properties

    /// Configuration providing visual styling
    let configuration: Configuration

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .background {
                backgroundView
            }
    }

    // MARK: - Background View

    @ViewBuilder
    private var backgroundView: some View {
        switch configuration.backgroundStyle {
        case .liquidGlass:
            liquidGlassBackground

        case .translucent:
            translucentBackground

        case .solid(let color, let opacity):
            solidBackground(color: color, opacity: opacity)

        case .material(let material):
            materialBackground(material: material)
        }
    }

    // MARK: - Liquid Glass Background

    /// Full liquid glass effect with all visual layers
    ///
    /// Combines:
    /// 1. Ultra-thin material base
    /// 2. Gradient overlay for depth
    /// 3. Inner shadow for dimensionality
    /// 4. Accent color tint (3% opacity)
    /// 5. Border stroke for definition
    /// 6. Drop shadow for elevation
    private var liquidGlassBackground: some View {
        ZStack {
            // Base ultra-thin material for system-aware blur
            Rectangle()
                .fill(.ultraThinMaterial)

            // Subtle gradient overlay for depth
            LinearGradient(
                colors: [
                    Color.white.opacity(0.1),
                    Color.white.opacity(0.05),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Vibrancy layer for content that sits on top
            Rectangle()
                .fill(.ultraThinMaterial.shadow(.inner(radius: 1, y: 1)))

            // Accent color tint (very subtle)
            configuration.accentColor
                .opacity(0.03)
                .blendMode(.overlay)
        }
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay {
            // Stroke border for definition
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
    }

    // MARK: - Alternative Backgrounds

    /// Translucent background with standard blur
    ///
    /// Lighter than liquid glass, using thin material with minimal accent tinting.
    private var translucentBackground: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)

            configuration.accentColor
                .opacity(0.05)
                .blendMode(.overlay)
        }
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
    }

    /// Solid background with custom color and opacity
    ///
    /// - Parameters:
    ///   - color: Background color
    ///   - opacity: Opacity from 0.0 to 1.0
    private func solidBackground(color: Color, opacity: Double) -> some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(color.opacity(opacity))
            .shadow(
                color: configuration.shadow.color,
                radius: configuration.shadow.radius,
                x: configuration.shadow.x,
                y: configuration.shadow.y
            )
    }

    /// Material background with custom SwiftUI material
    ///
    /// - Parameter material: SwiftUI Material to use
    private func materialBackground(material: Material) -> some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(material)
            .shadow(
                color: configuration.shadow.color,
                radius: configuration.shadow.radius,
                x: configuration.shadow.x,
                y: configuration.shadow.y
            )
    }
}

// MARK: - View Extension

@available(iOS 17.0, *)
extension View {
    /// Applies the liquid glass effect to a view
    ///
    /// This unified modifier works with any configuration type that conforms
    /// to ``LiquidGlassConfigurable``, automatically adapting the visual
    /// treatment based on the ``ARCBackgroundStyle`` specified.
    ///
    /// - Parameter configuration: Configuration providing visual styling
    /// - Returns: View with liquid glass effect applied
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct MyView: View {
    ///     let config: MyConfiguration // conforms to LiquidGlassConfigurable
    ///
    ///     var body: some View {
    ///         VStack {
    ///             // Your content
    ///         }
    ///         .padding()
    ///         .liquidGlass(configuration: config)
    ///     }
    /// }
    /// ```
    public func liquidGlass<Configuration: LiquidGlassConfigurable>(
        configuration: Configuration
    ) -> some View {
        modifier(LiquidGlassModifier(configuration: configuration))
    }
}
