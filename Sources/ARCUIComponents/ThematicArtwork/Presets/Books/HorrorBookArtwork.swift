//
//  HorrorBookArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - HorrorBookArtwork

/// A thematic artwork representing a horror genre book cover.
///
/// `HorrorBookArtwork` creates a stylized spooky book cover with
/// dark tones, toxic green accents, and eerie visual elements. Perfect for
/// book reading apps or horror-themed interfaces.
///
/// ## Example Usage
/// ```swift
/// // As a static placeholder
/// HorrorBookArtwork()
///     .frame(width: 130, height: 200)
///
/// // With book configuration
/// ThemedArtworkView(configuration: .book) {
///     HorrorBookArtwork()
/// }
/// ```
public struct HorrorBookArtwork: ThematicArtwork {

    // MARK: - Properties

    public var theme: ArtworkTheme { .horrorBook }

    // MARK: - Initialization

    public init() {}

    // MARK: - Layers

    public func backgroundLayer(dimension: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(
                    LinearGradient(
                        colors: [
                            theme.primaryColor,
                            theme.secondaryColor.opacity(0.6)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            RoundedRectangle(cornerRadius: dimension * 0.02)
                .fill(theme.secondaryColor.opacity(0.8))
                .frame(width: dimension * 0.08)
                .offset(x: -dimension * 0.46)
        }
    }

    public func decorationLayer(dimension: CGFloat) -> some View {
        ZStack {
            toxicDripsLayer(dimension: dimension)
            eyesLayer(dimension: dimension)
            scratchesLayer(dimension: dimension)
        }
    }

    public func overlayLayer(dimension: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .strokeBorder(
                    (theme.accentColors[safe: 1] ?? .red).opacity(0.3),
                    lineWidth: dimension * 0.015
                )

            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(
                    RadialGradient(
                        colors: [.clear, theme.primaryColor.opacity(0.5)],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.7
                    )
                )
                .blendMode(.multiply)
        }
    }

    // MARK: - Private Layers

    private func toxicDripsLayer(dimension: CGFloat) -> some View {
        ForEach(0..<4, id: \.self) { index in
            Capsule()
                .fill((theme.accentColors[safe: 0] ?? .green).opacity(0.7))
                .frame(
                    width: dimension * 0.04,
                    height: dimension * dripHeight(for: index)
                )
                .offset(
                    x: dripXOffset(for: index, dimension: dimension),
                    y: -dimension * 0.35
                )
                .blur(radius: 0.5)
        }
    }

    private func eyesLayer(dimension: CGFloat) -> some View {
        HStack(spacing: dimension * 0.15) {
            eyeView(dimension: dimension)
            eyeView(dimension: dimension)
        }
        .offset(y: dimension * 0.05)
    }

    private func eyeView(dimension: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: dimension * 0.12, height: dimension * 0.12)

            Circle()
                .fill((theme.accentColors[safe: 1] ?? .red).opacity(0.9))
                .frame(width: dimension * 0.06, height: dimension * 0.06)
        }
    }

    private func scratchesLayer(dimension: CGFloat) -> some View {
        ForEach(0..<3, id: \.self) { index in
            Path { path in
                let startX = dimension * (0.55 + Double(index) * 0.08)
                let startY = dimension * 0.5
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: startX + dimension * 0.1, y: startY + dimension * 0.2))
            }
            .stroke((theme.accentColors[safe: 1] ?? .red).opacity(0.5), lineWidth: 2)
        }
    }

    // MARK: - Position Helpers

    private func dripHeight(for index: Int) -> CGFloat {
        let heights: [CGFloat] = [0.15, 0.22, 0.12, 0.18]
        return heights[index % heights.count]
    }

    private func dripXOffset(for index: Int, dimension: CGFloat) -> CGFloat {
        let offsets: [CGFloat] = [-0.25, -0.1, 0.1, 0.25]
        return offsets[index % offsets.count] * dimension
    }
}

// MARK: - Array Extension

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview

#Preview("Horror Book Artwork") {
    HorrorBookArtwork()
        .frame(width: 130, height: 200)
        .padding()
}

#Preview("Horror Book - Dark Mode") {
    HorrorBookArtwork()
        .frame(width: 130, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Horror Book with Configuration") {
    ThemedArtworkView(configuration: .book) {
        HorrorBookArtwork()
    }
    .frame(width: 130, height: 200)
    .padding()
}

#Preview("Horror Book Loader") {
    ThemedLoaderView(
        size: 100,
        animationType: .shimmer
    ) {
        HorrorBookArtwork()
    }
    .padding()
}

#Preview("Horror Book Sizes") {
    HStack(spacing: 20) {
        HorrorBookArtwork()
            .frame(width: 65, height: 100)

        HorrorBookArtwork()
            .frame(width: 97, height: 150)

        HorrorBookArtwork()
            .frame(width: 130, height: 200)
    }
    .padding()
}
