//
//  AIGlowBorderModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/19/26.
//

import ARCDesignSystem
import SwiftUI

/// Animated glowing border effect for AI-generated content
///
/// Adds a rotating angular gradient halo with an animated border to visually
/// distinguish AI recommendation cards. The effect includes:
///
/// - **Ambient halo:** A blurred, filled shape that radiates colored light outward
/// - **Gradient stroke:** A crisp rotating angular gradient border for edge definition
/// - **Sparkle particles:** Optional floating sparkles along the card perimeter
///
/// When `accessibilityReduceMotion` is enabled, the gradient becomes static
/// and sparkles are hidden entirely.
///
/// ## Usage
///
/// ```swift
/// MyCardView()
///     .aiGlowBorder(isActive: isFocused, cornerRadius: 16)
/// ```
@available(iOS 17.0, macOS 14.0, *) struct AIGlowBorderModifier: ViewModifier {
    // MARK: - Properties

    /// Whether the glow effect is currently visible
    let isActive: Bool

    /// Corner radius matching the card shape
    let cornerRadius: CGFloat

    /// Accent color for the gradient (gold/amber by default)
    let accentColor: Color

    /// Visual intensity of the glow
    let intensity: AIGlowIntensity

    /// Whether to show sparkle particles
    let showSparkles: Bool

    // MARK: - State

    @State private var rotationAngle: Angle = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Shapes & Gradients

    private var glowGradient: AngularGradient {
        AngularGradient(gradient: Gradient(colors: [accentColor,
                                                    accentColor.opacity(0.8),
                                                    Color.white.opacity(0.6),
                                                    accentColor.opacity(0.6),
                                                    Color(red: 0.85, green: 0.6, blue: 0.2),
                                                    accentColor.opacity(0.8),
                                                    accentColor]),
                        center: .center,
                        angle: reduceMotion ? .degrees(45) : rotationAngle)
    }

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    glowLayers
                        .transition(.opacity)
                }
            }
            .animation(.arcSmooth, value: isActive)
            .onAppear {
                startRotation()
            }
    }

    // MARK: - Glow Layers

    private var glowLayers: some View {
        ZStack {
            // Layer 1: Ambient halo — filled shape blurred outward
            // This is the main "glow" that radiates colored light.
            // Using a filled shape (not a stroke) produces much more
            // visible light that spreads to fill surrounding space.
            ambientHalo

            // Layer 2: Crisp rotating gradient stroke for edge definition
            cardShape
                .stroke(glowGradient, lineWidth: intensity.innerStrokeWidth)
                .opacity(intensity.strokeOpacity)

            // Layer 3: Sparkle particles
            if showSparkles {
                AISparkleCanvas(cornerRadius: cornerRadius,
                                accentColor: accentColor)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// Wide ambient halo created from a filled gradient shape with heavy blur
    ///
    /// The shape is inset slightly so the fill sits at the card edge, then
    /// negatively padded outward to create an expanded canvas for the blur
    /// to spread into the surrounding space.
    private var ambientHalo: some View {
        let expand = intensity.haloExpand

        return cardShape
            .fill(glowGradient)
            .padding(-expand)
            .mask {
                // Mask out the interior so only the edge ring glows.
                // Without this, the entire card area would be tinted.
                cardShape
                    .stroke(lineWidth: expand * 2)
                    .padding(-expand)
            }
            .blur(radius: intensity.haloBlurRadius)
            .opacity(intensity.haloOpacity)
    }

    // MARK: - Animation

    private func startRotation() {
        guard !reduceMotion else { return }
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            rotationAngle = .degrees(360)
        }
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *) extension View {
    /// Applies an animated AI glow border effect
    ///
    /// Adds a rotating gradient halo around the view to visually mark it
    /// as AI-generated content. The effect respects `accessibilityReduceMotion`.
    ///
    /// - Parameters:
    ///   - isActive: Whether the glow is visible (typically true for the focused card)
    ///   - cornerRadius: Corner radius matching the card shape
    ///   - accentColor: Accent color for the gradient (default: gold/amber)
    ///   - intensity: Visual intensity level (default: `.subtle`)
    ///   - showSparkles: Whether to show sparkle particles (default: `true`)
    /// - Returns: View with the AI glow border applied
    public func aiGlowBorder(isActive: Bool,
                             cornerRadius: CGFloat = .arcCornerRadiusMedium,
                             accentColor: Color = Color(red: 0.95, green: 0.75, blue: 0.3),
                             intensity: AIGlowIntensity = .subtle,
                             showSparkles: Bool = true) -> some View
    {
        modifier(AIGlowBorderModifier(isActive: isActive,
                                      cornerRadius: cornerRadius,
                                      accentColor: accentColor,
                                      intensity: intensity,
                                      showSparkles: showSparkles))
    }
}
