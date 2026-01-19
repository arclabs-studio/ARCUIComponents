//
//  PizzaArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - PizzaArtwork

/// A thematic artwork representing a pizza with toppings.
///
/// `PizzaArtwork` creates a stylized pizza visual with a base, crust,
/// pepperoni/basil toppings, and overlay effects. Perfect for food-related
/// apps or as a fun loading indicator.
///
/// ## Example Usage
/// ```swift
/// // As a static placeholder
/// PizzaArtwork()
///     .frame(width: 150, height: 150)
///
/// // As a spinning loader
/// ThemedLoaderView(size: 64) {
///     PizzaArtwork()
/// }
/// ```
public struct PizzaArtwork: ThematicArtwork {

    // MARK: - Properties

    public var theme: ArtworkTheme { .pizza }

    // MARK: - Initialization

    public init() {}

    // MARK: - Layers

    public func backgroundLayer(dimension: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            theme.primaryColor.opacity(0.95),
                            theme.primaryColor.opacity(0.55)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.65
                    )
                )

            Circle()
                .strokeBorder(theme.backgroundColor.opacity(0.35), lineWidth: dimension * 0.05)
                .blur(radius: 0.6)
        }
    }

    public func decorationLayer(dimension: CGFloat) -> some View {
        ZStack {
            CircularDecoration(
                count: 6,
                radius: 0.18,
                dimension: dimension
            ) { _, dim in
                DecorationElement.capsule(
                    color: theme.backgroundColor,
                    size: CGSize(width: dim * 0.12, height: dim * 0.52),
                    opacity: 0.85
                )
            }

            CircularDecoration(
                count: 16,
                radius: 0.34,
                dimension: dimension
            ) { index, dim in
                let color = index.isMultiple(of: 2)
                    ? theme.accentColors[safe: 0] ?? .red
                    : theme.accentColors[safe: 1] ?? .green

                return DecorationElement.circle(
                    color: color,
                    diameter: dim * 0.09,
                    blur: 0.4,
                    opacity: index.isMultiple(of: 2) ? 0.85 : 0.75
                )
            }
        }
    }

    public func overlayLayer(dimension: CGFloat) -> some View {
        ZStack {
            Circle()
                .strokeBorder(theme.backgroundColor.opacity(0.5), lineWidth: dimension * 0.018)
                .blendMode(.overlay)

            Circle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: dimension * 0.65)
        }
    }
}

// MARK: - Array Extension

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview

#Preview("Pizza Artwork") {
    PizzaArtwork()
        .frame(width: 200, height: 200)
        .padding()
}

#Preview("Pizza Artwork - Dark") {
    PizzaArtwork()
        .frame(width: 200, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Pizza Loader") {
    ThemedLoaderView(size: 80) {
        PizzaArtwork()
    }
    .padding()
}

#Preview("Pizza Sizes") {
    HStack(spacing: 20) {
        PizzaArtwork()
            .frame(width: 50, height: 50)

        PizzaArtwork()
            .frame(width: 100, height: 100)

        PizzaArtwork()
            .frame(width: 150, height: 150)
    }
    .padding()
}
