//
//  ThemedLoaderView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ThemedLoaderView

/// A loader view using any `ThematicArtwork` as its visual.
///
/// `ThemedLoaderView` wraps a thematic artwork with automatic animation,
/// making it easy to create themed loading indicators. The view includes
/// accessibility support with customizable labels.
///
/// ## Example Usage
/// ```swift
/// // Simple pizza loader
/// ThemedLoaderView(size: 64) {
///     PizzaArtwork()
/// }
///
/// // Custom animation and accessibility
/// ThemedLoaderView(
///     size: 80,
///     animationType: .pulse,
///     accessibilityLabel: "Loading menu items"
/// ) {
///     SushiArtwork()
/// }
/// ```
public struct ThemedLoaderView<Content: ThematicArtwork>: View {

    // MARK: - Properties

    private let content: Content
    private let size: CGFloat
    private let animationType: ArtworkAnimationType
    private let animationDuration: Double
    private let accessibilityLabel: String

    // MARK: - Initialization

    /// Creates a themed loader view.
    ///
    /// - Parameters:
    ///   - size: The width and height of the loader. Defaults to `64`.
    ///   - animationType: The animation type. Defaults to `.spin`.
    ///   - animationDuration: The duration of one animation cycle. Defaults to `1.0`.
    ///   - accessibilityLabel: The accessibility label. Defaults to `"Loading"`.
    ///   - content: A closure that returns the thematic artwork to use.
    public init(
        size: CGFloat = 64,
        animationType: ArtworkAnimationType = .spin,
        animationDuration: Double = 1.0,
        accessibilityLabel: String = "Loading",
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.size = size
        self.animationType = animationType
        self.animationDuration = animationDuration
        self.accessibilityLabel = accessibilityLabel
    }

    // MARK: - Body

    public var body: some View {
        ThemedArtworkView(
            isAnimating: true,
            animationType: animationType,
            animationDuration: animationDuration
        ) {
            content
        }
        .frame(width: size, height: size)
        .accessibilityLabel(Text(accessibilityLabel))
        .accessibilityAddTraits(.isImage)
    }
}

// MARK: - Preview

#Preview("Loader - Spin") {
    VStack(spacing: 32) {
        ThemedLoaderView(size: 64) {
            PreviewLoaderArtwork()
        }

        ThemedLoaderView(size: 100) {
            PreviewLoaderArtwork()
        }
    }
    .padding()
}

#Preview("Loader - Pulse") {
    ThemedLoaderView(
        size: 80,
        animationType: .pulse
    ) {
        PreviewLoaderArtwork()
    }
    .padding()
}

#Preview("Loader - Shimmer") {
    ThemedLoaderView(
        size: 80,
        animationType: .shimmer
    ) {
        PreviewLoaderArtwork()
    }
    .padding()
}

#Preview("Loader - Breathe") {
    ThemedLoaderView(
        size: 80,
        animationType: .breathe
    ) {
        PreviewLoaderArtwork()
    }
    .padding()
}

#Preview("Loader Sizes", traits: .sizeThatFitsLayout) {
    HStack(spacing: 24) {
        ThemedLoaderView(size: 32) {
            PreviewLoaderArtwork()
        }

        ThemedLoaderView(size: 48) {
            PreviewLoaderArtwork()
        }

        ThemedLoaderView(size: 64) {
            PreviewLoaderArtwork()
        }

        ThemedLoaderView(size: 80) {
            PreviewLoaderArtwork()
        }
    }
    .padding()
}

// MARK: - Preview Helper

/// A simple preview artwork for testing the loader.
private struct PreviewLoaderArtwork: ThematicArtwork {

    var theme: ArtworkTheme { .pizza }

    func backgroundLayer(dimension: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [theme.primaryColor, theme.primaryColor.opacity(0.6)],
                    center: .center,
                    startRadius: 0,
                    endRadius: dimension * 0.5
                )
            )
    }

    func decorationLayer(dimension: CGFloat) -> some View {
        ForEach(0..<6, id: \.self) { index in
            Capsule()
                .fill(Color.black.opacity(0.8))
                .frame(width: dimension * 0.1, height: dimension * 0.4)
                .offset(y: -dimension * 0.15)
                .rotationEffect(.degrees(Double(index) * 60))
        }
    }

    func overlayLayer(dimension: CGFloat) -> some View {
        Circle()
            .fill(Color.gray.opacity(0.1))
            .frame(width: dimension * 0.5)
    }
}
