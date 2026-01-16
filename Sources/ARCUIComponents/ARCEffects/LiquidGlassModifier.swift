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
/// Implements Apple's modern glassmorphism effect. On iOS 26+, uses the native
/// `.glassEffect()` API for optimal performance and full Liquid Glass features.
/// On iOS 17-25, provides a manual implementation using materials and gradients.
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
/// ## Platform Behavior
///
/// - **iOS 26+**: Uses native `glassEffect()` API with full Liquid Glass features
///   including touch/pointer interactivity, morphing animations, and system optimizations.
/// - **iOS 17-25**: Uses manual implementation with materials, gradients, and shadows
///   for a similar visual appearance.
///
/// ## Topics
///
/// ### Creating the Effect
///
/// - ``init(configuration:isInteractive:)``
///
/// ### View Extension
///
/// - ``SwiftUI/View/liquidGlass(configuration:isInteractive:)``
///
/// ## Usage
///
/// ```swift
/// // With any LiquidGlassConfigurable configuration
/// MyView()
///     .liquidGlass(configuration: myConfig)
///
/// // With interactivity (for buttons, responds to touch on iOS 26+)
/// Button("Tap") { }
///     .liquidGlass(configuration: myConfig, isInteractive: true)
///
/// // The modifier automatically adapts to:
/// // - .liquidGlass: Full premium effect (Glass.regular on iOS 26+)
/// // - .translucent: Lighter effect (Glass.clear on iOS 26+)
/// // - .solid: Custom color (no glass effect)
/// // - .material: Custom material (no glass effect)
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
/// - Note: On iOS 26+, the native implementation provides additional features
///   like touch responsiveness and morphing animations when used with
///   ``ARCGlassContainer``.
@available(iOS 17.0, macOS 14.0, *)
struct LiquidGlassModifier<Configuration: LiquidGlassConfigurable>: ViewModifier {
    // MARK: - Properties

    /// Configuration providing visual styling
    let configuration: Configuration

    /// Whether the glass effect should respond to touch/pointer interactions (iOS 26+ only)
    let isInteractive: Bool

    // MARK: - Initialization

    /// Creates a liquid glass modifier with the specified configuration
    ///
    /// - Parameters:
    ///   - configuration: Configuration providing visual styling
    ///   - isInteractive: Whether the effect responds to touch (iOS 26+ only). Default is `false`.
    init(configuration: Configuration, isInteractive: Bool = false) {
        self.configuration = configuration
        self.isInteractive = isInteractive
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        #if compiler(>=6.2)
        if #available(iOS 26.0, macOS 26.0, *) {
            nativeGlassBody(content: content)
        } else {
            legacyGlassBody(content: content)
        }
        #else
        legacyGlassBody(content: content)
        #endif
    }

    // MARK: - iOS 26+ Native Implementation

    #if compiler(>=6.2)
    /// Native Liquid Glass implementation using iOS 26+ APIs
    @available(iOS 26.0, macOS 26.0, *)
    @ViewBuilder
    private func nativeGlassBody(content: Content) -> some View {
        switch configuration.backgroundStyle {
        case .liquidGlass:
            content
                .glassEffect(
                    nativeGlassConfiguration,
                    in: .rect(cornerRadius: configuration.cornerRadius)
                )

        case .translucent:
            content
                .glassEffect(
                    nativeClearGlassConfiguration,
                    in: .rect(cornerRadius: configuration.cornerRadius)
                )

        case let .solid(color, opacity):
            // Solid backgrounds don't use glass effect
            content
                .background {
                    solidBackground(color: color, opacity: opacity)
                }

        case let .material(material):
            // Custom materials don't use glass effect
            content
                .background {
                    materialBackground(material: material)
                }
        }
    }

    /// Native Glass configuration for liquidGlass style
    @available(iOS 26.0, macOS 26.0, *)
    private var nativeGlassConfiguration: Glass {
        var glass = Glass.regular.tint(configuration.accentColor)
        if isInteractive {
            glass = glass.interactive()
        }
        return glass
    }

    /// Native Glass configuration for translucent style
    @available(iOS 26.0, macOS 26.0, *)
    private var nativeClearGlassConfiguration: Glass {
        var glass = Glass.clear.tint(configuration.accentColor)
        if isInteractive {
            glass = glass.interactive()
        }
        return glass
    }
    #endif

    // MARK: - iOS 17-25 Legacy Implementation

    /// Legacy implementation using materials and gradients
    @ViewBuilder
    private func legacyGlassBody(content: Content) -> some View {
        content
            .background {
                legacyBackgroundView
            }
    }

    @ViewBuilder
    private var legacyBackgroundView: some View {
        switch configuration.backgroundStyle {
        case .liquidGlass:
            liquidGlassBackground

        case .translucent:
            translucentBackground

        case let .solid(color, opacity):
            solidBackground(color: color, opacity: opacity)

        case let .material(material):
            materialBackground(material: material)
        }
    }

    // MARK: - Legacy Liquid Glass Background

    /// Full liquid glass effect with all visual layers (iOS 17-25)
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

    // MARK: - Legacy Translucent Background

    /// Translucent background with standard blur (iOS 17-25)
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

    // MARK: - Shared Backgrounds

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

@available(iOS 17.0, macOS 14.0, *)
public extension View {
    /// Applies the liquid glass effect to a view
    ///
    /// This unified modifier works with any configuration type that conforms
    /// to ``LiquidGlassConfigurable``, automatically adapting the visual
    /// treatment based on the ``ARCBackgroundStyle`` specified.
    ///
    /// On iOS 26+, this uses the native `glassEffect()` API for optimal performance.
    /// On iOS 17-25, it uses a manual implementation with materials and gradients.
    ///
    /// - Parameters:
    ///   - configuration: Configuration providing visual styling
    ///   - isInteractive: Whether the effect responds to touch/pointer interactions.
    ///     Only effective on iOS 26+. Default is `false`.
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
    ///
    /// // For interactive buttons (iOS 26+)
    /// Button("Action") { }
    ///     .liquidGlass(configuration: config, isInteractive: true)
    /// ```
    func liquidGlass(
        configuration: some LiquidGlassConfigurable,
        isInteractive: Bool = false
    ) -> some View {
        modifier(LiquidGlassModifier(configuration: configuration, isInteractive: isInteractive))
    }
}
