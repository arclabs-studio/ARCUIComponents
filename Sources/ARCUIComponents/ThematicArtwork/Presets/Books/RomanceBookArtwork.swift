//
//  RomanceBookArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - RomanceBookArtwork

/// A thematic artwork representing a romance genre book cover.
///
/// `RomanceBookArtwork` creates a stylized romantic book cover with
/// hearts, soft pink tones, and decorative flourishes. Perfect for
/// book reading apps or romance-themed interfaces.
///
/// ## Example Usage
/// ```swift
/// // As a static placeholder
/// RomanceBookArtwork()
///     .frame(width: 130, height: 200)
///
/// // With book configuration
/// ThemedArtworkView(configuration: .book) {
///     RomanceBookArtwork()
/// }
/// ```
public struct RomanceBookArtwork: ThematicArtwork {

    // MARK: - Properties

    public var theme: ArtworkTheme { .romanceBook }

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
                            theme.secondaryColor.opacity(0.3)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            RoundedRectangle(cornerRadius: dimension * 0.02)
                .fill(theme.secondaryColor.opacity(0.5))
                .frame(width: dimension * 0.08)
                .offset(x: -dimension * 0.46)
        }
    }

    public func decorationLayer(dimension: CGFloat) -> some View {
        ZStack {
            HeartShape()
                .fill(theme.secondaryColor.opacity(0.8))
                .frame(width: dimension * 0.25, height: dimension * 0.25)
                .offset(y: -dimension * 0.1)

            smallHeartsLayer(dimension: dimension)
            decorativeCurveLayer(dimension: dimension)
        }
    }

    public func overlayLayer(dimension: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .strokeBorder(
                    (theme.accentColors[safe: 0] ?? .yellow).opacity(0.4),
                    lineWidth: dimension * 0.015
                )

            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(Color.white.opacity(0.05))
                .blendMode(.overlay)
        }
    }

    // MARK: - Private Layers

    private func smallHeartsLayer(dimension: CGFloat) -> some View {
        ForEach(0..<5, id: \.self) { index in
            HeartShape()
                .fill((theme.accentColors[safe: 1] ?? .pink).opacity(0.6))
                .frame(width: dimension * 0.08, height: dimension * 0.08)
                .offset(
                    x: heartOffset(for: index, dimension: dimension).x,
                    y: heartOffset(for: index, dimension: dimension).y
                )
                .rotationEffect(.degrees(heartRotation(for: index)))
        }
    }

    private func decorativeCurveLayer(dimension: CGFloat) -> some View {
        Path { path in
            path.move(to: CGPoint(x: dimension * 0.2, y: dimension * 0.7))
            path.addQuadCurve(
                to: CGPoint(x: dimension * 0.8, y: dimension * 0.7),
                control: CGPoint(x: dimension * 0.5, y: dimension * 0.5)
            )
        }
        .stroke((theme.accentColors[safe: 0] ?? .yellow).opacity(0.5), lineWidth: 2)
    }

    // MARK: - Position Helpers

    private func heartOffset(for index: Int, dimension: CGFloat) -> CGPoint {
        let xOffsets: [CGFloat] = [-0.25, 0.28, -0.15, 0.2, 0.0]
        let yOffsets: [CGFloat] = [-0.25, -0.2, 0.25, 0.3, 0.35]
        return CGPoint(
            x: xOffsets[index % xOffsets.count] * dimension,
            y: yOffsets[index % yOffsets.count] * dimension
        )
    }

    private func heartRotation(for index: Int) -> Double {
        let rotations = [-15.0, 20.0, -25.0, 10.0, -5.0]
        return rotations[index % rotations.count]
    }
}

// MARK: - Array Extension

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview

#Preview("Romance Book Artwork") {
    RomanceBookArtwork()
        .frame(width: 130, height: 200)
        .padding()
}

#Preview("Romance Book - Dark Mode") {
    RomanceBookArtwork()
        .frame(width: 130, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Romance Book with Configuration") {
    ThemedArtworkView(configuration: .book) {
        RomanceBookArtwork()
    }
    .frame(width: 130, height: 200)
    .padding()
}

#Preview("Romance Book Loader") {
    ThemedLoaderView(
        size: 100,
        animationType: .breathe
    ) {
        RomanceBookArtwork()
    }
    .padding()
}

#Preview("Romance Book Sizes") {
    HStack(spacing: 20) {
        RomanceBookArtwork()
            .frame(width: 65, height: 100)

        RomanceBookArtwork()
            .frame(width: 97, height: 150)

        RomanceBookArtwork()
            .frame(width: 130, height: 200)
    }
    .padding()
}
