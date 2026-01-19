//
//  TacoArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - TacoArtwork

/// A thematic artwork representing a Mexican taco with toppings.
///
/// `TacoArtwork` creates a stylized taco visual with a tortilla base,
/// meat, cilantro, onion, and salsa toppings. Perfect for Mexican food apps
/// or as a fun loading indicator.
///
/// ## Example Usage
/// ```swift
/// // As a static placeholder
/// TacoArtwork()
///     .frame(width: 150, height: 150)
///
/// // As a spinning loader
/// ThemedLoaderView(size: 64) {
///     TacoArtwork()
/// }
/// ```
public struct TacoArtwork: ThematicArtwork {

    // MARK: - Properties

    public var theme: ArtworkTheme { .taco }

    // MARK: - Initialization

    public init() {}

    // MARK: - Layers

    public func backgroundLayer(dimension: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.gray.opacity(0.2)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.5
                    )
                )

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.primaryColor,
                            theme.primaryColor.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: dimension * 0.7, height: dimension * 0.35)
                .offset(y: dimension * 0.05)
        }
    }

    public func decorationLayer(dimension: CGFloat) -> some View {
        ZStack {
            meatLayer(dimension: dimension)
            cilantroLayer(dimension: dimension)
            onionLayer(dimension: dimension)
            salsaLayer(dimension: dimension)
        }
    }

    public func overlayLayer(dimension: CGFloat) -> some View {
        Capsule()
            .fill(Color.white.opacity(0.15))
            .frame(width: dimension * 0.5, height: dimension * 0.05)
            .offset(y: -dimension * 0.08)
            .blendMode(.overlay)
    }

    // MARK: - Private Layers

    private func meatLayer(dimension: CGFloat) -> some View {
        ForEach(0..<4, id: \.self) { index in
            RoundedRectangle(cornerRadius: dimension * 0.02)
                .fill(theme.secondaryColor.opacity(0.85))
                .frame(width: dimension * 0.12, height: dimension * 0.08)
                .offset(
                    x: CGFloat(index - 2) * dimension * 0.12 + dimension * 0.06,
                    y: -dimension * 0.02
                )
                .rotationEffect(.degrees(meatRotation(for: index)))
        }
    }

    private func cilantroLayer(dimension: CGFloat) -> some View {
        ForEach(0..<8, id: \.self) { index in
            Circle()
                .fill((theme.accentColors[safe: 0] ?? .green).opacity(0.8))
                .frame(width: dimension * 0.04)
                .offset(
                    x: cilantroOffset(for: index, dimension: dimension).x,
                    y: cilantroOffset(for: index, dimension: dimension).y
                )
        }
    }

    private func onionLayer(dimension: CGFloat) -> some View {
        ForEach(0..<6, id: \.self) { index in
            Circle()
                .fill((theme.accentColors[safe: 1] ?? .white).opacity(0.9))
                .frame(width: dimension * 0.035)
                .offset(
                    x: onionOffset(for: index, dimension: dimension).x,
                    y: onionOffset(for: index, dimension: dimension).y
                )
        }
    }

    private func salsaLayer(dimension: CGFloat) -> some View {
        ForEach(0..<3, id: \.self) { index in
            Circle()
                .fill((theme.accentColors[safe: 2] ?? .red).opacity(0.7))
                .frame(width: dimension * 0.05)
                .offset(
                    x: CGFloat(index - 1) * dimension * 0.15,
                    y: dimension * 0.03
                )
                .blur(radius: 0.5)
        }
    }

    // MARK: - Position Helpers

    private func meatRotation(for index: Int) -> Double {
        let rotations = [-8.0, 5.0, -3.0, 7.0]
        return rotations[index % rotations.count]
    }

    private func cilantroOffset(for index: Int, dimension: CGFloat) -> CGPoint {
        let xOffsets: [CGFloat] = [-0.18, -0.1, -0.02, 0.06, 0.14, 0.2, -0.14, 0.1]
        let yOffsets: [CGFloat] = [-0.06, 0.02, -0.08, 0.0, -0.04, 0.03, 0.05, -0.02]
        return CGPoint(
            x: xOffsets[index % xOffsets.count] * dimension,
            y: yOffsets[index % yOffsets.count] * dimension
        )
    }

    private func onionOffset(for index: Int, dimension: CGFloat) -> CGPoint {
        let xOffsets: [CGFloat] = [-0.15, -0.05, 0.05, 0.15, -0.1, 0.1]
        let yOffsets: [CGFloat] = [-0.03, 0.01, -0.05, 0.02, 0.04, -0.01]
        return CGPoint(
            x: xOffsets[index % xOffsets.count] * dimension,
            y: yOffsets[index % yOffsets.count] * dimension
        )
    }
}

// MARK: - Array Extension

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview

#Preview("Taco Artwork") {
    TacoArtwork()
        .frame(width: 200, height: 200)
        .padding()
}

#Preview("Taco Artwork - Dark") {
    TacoArtwork()
        .frame(width: 200, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Taco Loader") {
    ThemedLoaderView(size: 80) {
        TacoArtwork()
    }
    .padding()
}

#Preview("Taco Sizes") {
    HStack(spacing: 20) {
        TacoArtwork()
            .frame(width: 50, height: 50)

        TacoArtwork()
            .frame(width: 100, height: 100)

        TacoArtwork()
            .frame(width: 150, height: 150)
    }
    .padding()
}
