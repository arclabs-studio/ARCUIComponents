//
//  ARCCardPressStyle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import SwiftUI

/// A button style that provides a pressed effect with scale and opacity animations
///
/// `ARCCardPressStyle` creates a tactile press effect commonly used for interactive cards,
/// matching the interaction patterns found in App Store, Music, and other Apple apps.
///
/// ## Overview
///
/// This style provides:
/// - Smooth scale-down animation on press
/// - Optional opacity change for visual feedback
/// - Customizable animation parameters
/// - Spring animation for natural feel
///
/// ## Topics
///
/// ### Creating Card Press Styles
///
/// - ``init(pressedScale:pressedOpacity:animationDuration:)``
///
/// ### Presets
///
/// - ``default``
/// - ``subtle``
/// - ``prominent``
///
/// ## Usage
///
/// ```swift
/// Button {
///     openCard()
/// } label: {
///     CardContent()
/// }
/// .buttonStyle(ARCCardPressStyle())
///
/// // Or with custom parameters
/// .buttonStyle(ARCCardPressStyle(pressedScale: 0.95, pressedOpacity: 0.8))
/// ```
///
/// - Note: For best results, use on larger interactive elements like cards or cells.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCardPressStyle: ButtonStyle {

    // MARK: - Properties

    /// Scale factor when pressed (0.0 - 1.0)
    private let pressedScale: CGFloat

    /// Opacity when pressed (0.0 - 1.0)
    private let pressedOpacity: Double

    /// Animation response duration in seconds
    private let animationDuration: Double

    // MARK: - Initialization

    /// Creates a card press style with custom parameters
    ///
    /// - Parameters:
    ///   - pressedScale: Scale factor when pressed (default: 0.96)
    ///   - pressedOpacity: Opacity when pressed (default: 1.0)
    ///   - animationDuration: Animation response time in seconds (default: 0.15)
    public init(
        pressedScale: CGFloat = 0.96,
        pressedOpacity: Double = 1.0,
        animationDuration: Double = 0.15
    ) {
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
        self.animationDuration = animationDuration
    }

    // MARK: - Body

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .opacity(configuration.isPressed ? pressedOpacity : 1.0)
            .animation(
                .spring(response: animationDuration, dampingFraction: 0.6),
                value: configuration.isPressed
            )
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCCardPressStyle {

    /// Default card press style matching Apple's patterns
    ///
    /// Uses 0.96 scale for a subtle but noticeable press effect.
    public static let `default` = ARCCardPressStyle()

    /// Subtle press style with minimal visual feedback
    ///
    /// Uses 0.98 scale for a very light press effect, suitable for
    /// smaller interactive elements or when less emphasis is desired.
    public static let subtle = ARCCardPressStyle(
        pressedScale: 0.98,
        pressedOpacity: 0.95
    )

    /// Prominent press style with stronger visual feedback
    ///
    /// Uses 0.94 scale and 0.9 opacity for a more dramatic press effect,
    /// suitable for hero cards or important interactive elements.
    public static let prominent = ARCCardPressStyle(
        pressedScale: 0.94,
        pressedOpacity: 0.9
    )
}

// MARK: - Preview

#Preview("Default Style") {
    VStack(spacing: 20) {
        Button {
            print("Card tapped")
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.gradient)
                .frame(height: 120)
                .overlay {
                    Text("Tap me")
                        .foregroundStyle(.white)
                        .font(.headline)
                }
        }
        .buttonStyle(ARCCardPressStyle())
    }
    .padding()
}

#Preview("Style Comparison") {
    VStack(spacing: 24) {
        Text("Default")
            .font(.caption)
            .foregroundStyle(.secondary)

        Button {} label: {
            cardContent(color: .blue, text: "Default (0.96)")
        }
        .buttonStyle(ARCCardPressStyle.default)

        Text("Subtle")
            .font(.caption)
            .foregroundStyle(.secondary)

        Button {} label: {
            cardContent(color: .green, text: "Subtle (0.98)")
        }
        .buttonStyle(ARCCardPressStyle.subtle)

        Text("Prominent")
            .font(.caption)
            .foregroundStyle(.secondary)

        Button {} label: {
            cardContent(color: .orange, text: "Prominent (0.94)")
        }
        .buttonStyle(ARCCardPressStyle.prominent)
    }
    .padding()
}

@ViewBuilder
private func cardContent(color: Color, text: String) -> some View {
    RoundedRectangle(cornerRadius: 12)
        .fill(color.gradient)
        .frame(height: 80)
        .overlay {
            Text(text)
                .foregroundStyle(.white)
                .font(.subheadline.weight(.medium))
        }
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        Button {} label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .frame(height: 120)
                .overlay {
                    Text("Dark Mode Card")
                        .font(.headline)
                }
        }
        .buttonStyle(ARCCardPressStyle())
    }
    .padding()
    .preferredColorScheme(.dark)
}
