//
//  NoirBookArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - NoirBookArtwork

/// A thematic artwork representing a noir/detective genre book cover.
///
/// `NoirBookArtwork` creates a stylized dark book cover with mystery
/// elements like blood splatters and shadowy silhouettes. Perfect for
/// book reading apps or mystery-themed interfaces.
///
/// ## Example Usage
/// ```swift
/// // As a static placeholder
/// NoirBookArtwork()
///     .frame(width: 130, height: 200)
///
/// // With book configuration
/// ThemedArtworkView(configuration: .book) {
///     NoirBookArtwork()
/// }
/// ```
public struct NoirBookArtwork: ThematicArtwork {

    // MARK: - Properties

    public var theme: ArtworkTheme { .noirBook }

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
                            theme.primaryColor.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: dimension * 0.02)
                .fill(theme.secondaryColor)
                .frame(width: dimension * 0.08)
                .offset(x: -dimension * 0.46)
        }
    }

    public func decorationLayer(dimension: CGFloat) -> some View {
        ZStack {
            LinearDecoration(
                lineCount: 5,
                dimension: dimension,
                color: theme.secondaryColor.opacity(0.5),
                spacing: 0.06,
                startOffset: -0.1
            )

            Circle()
                .fill((theme.accentColors[safe: 0] ?? .red).opacity(0.7))
                .frame(width: dimension * 0.15)
                .offset(x: dimension * 0.25, y: dimension * 0.3)
                .blur(radius: 1)

            Path { path in
                path.move(to: CGPoint(x: dimension * 0.3, y: dimension * 0.6))
                path.addLine(to: CGPoint(x: dimension * 0.5, y: dimension * 0.55))
                path.addLine(to: CGPoint(x: dimension * 0.7, y: dimension * 0.65))
            }
            .stroke(theme.secondaryColor.opacity(0.4), lineWidth: 2)
        }
    }

    public func overlayLayer(dimension: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .strokeBorder(
                    LinearGradient(
                        colors: [theme.secondaryColor.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: dimension * 0.02
                )

            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(Color.white.opacity(0.03))
                .blendMode(.overlay)
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

#Preview("Noir Book Artwork") {
    NoirBookArtwork()
        .frame(width: 130, height: 200)
        .padding()
}

#Preview("Noir Book - Dark Mode") {
    NoirBookArtwork()
        .frame(width: 130, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

#Preview("Noir Book with Configuration") {
    ThemedArtworkView(configuration: .book) {
        NoirBookArtwork()
    }
    .frame(width: 130, height: 200)
    .padding()
}

#Preview("Noir Book Loader") {
    ThemedLoaderView(
        size: 100,
        animationType: .pulse
    ) {
        NoirBookArtwork()
    }
    .padding()
}

#Preview("Noir Book Sizes") {
    HStack(spacing: 20) {
        NoirBookArtwork()
            .frame(width: 65, height: 100)

        NoirBookArtwork()
            .frame(width: 97, height: 150)

        NoirBookArtwork()
            .frame(width: 130, height: 200)
    }
    .padding()
}
