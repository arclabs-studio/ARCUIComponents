//
//  SushiArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - SushiArtwork

/// A thematic artwork representing a sushi plate with nigiri pieces.
///
/// `SushiArtwork` creates a stylized sushi plate visual with nori rolls,
/// salmon/avocado pieces, and chopsticks. Perfect for Japanese food apps
/// or as a sophisticated loading indicator.
///
/// ## Example Usage
/// ```swift
/// // As a static placeholder
/// SushiArtwork()
///     .frame(width: 150, height: 150)
///
/// // As a spinning loader
/// ThemedLoaderView(size: 64) {
///     SushiArtwork()
/// }
/// ```
public struct SushiArtwork: ThematicArtwork {

    // MARK: - Properties

    public var theme: ArtworkTheme { .sushi }

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
                            theme.primaryColor.opacity(0.7)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.5
                    )
                )

            Circle()
                .strokeBorder(theme.secondaryColor.opacity(0.3), lineWidth: dimension * 0.03)
        }
    }

    public func decorationLayer(dimension: CGFloat) -> some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                RoundedRectangle(cornerRadius: dimension * 0.02)
                    .fill(theme.secondaryColor.opacity(0.9))
                    .frame(width: dimension * 0.15, height: dimension * 0.35)
                    .offset(x: CGFloat(index - 1) * dimension * 0.22)
            }

            CircularDecoration(
                count: 6,
                radius: 0.32,
                dimension: dimension
            ) { index, dim in
                let color = index.isMultiple(of: 2)
                    ? theme.accentColors[safe: 0] ?? .orange
                    : theme.accentColors[safe: 1] ?? .green

                return DecorationElement.circle(
                    color: color,
                    diameter: dim * 0.12,
                    opacity: 0.9
                )
            }

            ForEach(0..<2, id: \.self) { index in
                Capsule()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.2))
                    .frame(width: dimension * 0.03, height: dimension * 0.7)
                    .rotationEffect(.degrees(index == 0 ? -15 : 15))
                    .offset(x: dimension * 0.35)
            }
        }
    }

    public func overlayLayer(dimension: CGFloat) -> some View {
        Circle()
            .strokeBorder(Color.white.opacity(0.2), lineWidth: dimension * 0.01)
            .blendMode(.overlay)
    }
}

// MARK: - Array Extension

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview

#Preview("Sushi Artwork") {
    SushiArtwork()
        .frame(width: 200, height: 200)
        .padding()
}

#Preview("Sushi Artwork - Dark") {
    SushiArtwork()
        .frame(width: 200, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Sushi Loader") {
    ThemedLoaderView(size: 80) {
        SushiArtwork()
    }
    .padding()
}

#Preview("Sushi Sizes") {
    HStack(spacing: 20) {
        SushiArtwork()
            .frame(width: 50, height: 50)

        SushiArtwork()
            .frame(width: 100, height: 100)

        SushiArtwork()
            .frame(width: 150, height: 150)
    }
    .padding()
}
