//
//  ThemedArtworkView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ThemedArtworkView

/// A container view that adds animation and configuration to any `ThematicArtwork`.
///
/// Use `ThemedArtworkView` to wrap thematic artworks with animations, custom shapes,
/// and shadow effects. This view handles the animation state and applies the
/// appropriate visual transformations based on the configuration.
///
/// ## Example Usage
/// ```swift
/// // Static artwork
/// ThemedArtworkView {
///     PizzaArtwork()
/// }
///
/// // Animated loader
/// ThemedArtworkView(
///     isAnimating: true,
///     animationType: .spin,
///     animationDuration: 1.2
/// ) {
///     PizzaArtwork()
/// }
///
/// // Book-shaped artwork
/// ThemedArtworkView(configuration: .book) {
///     NoirBookArtwork()
/// }
/// ```
public struct ThemedArtworkView<Content: ThematicArtwork>: View {

    // MARK: - Properties

    private let content: Content
    private let configuration: ArtworkConfiguration
    private let isAnimating: Bool
    private let animationType: ArtworkAnimationType
    private let animationDuration: Double

    @State private var animationProgress: Double = 0

    // MARK: - Initialization

    /// Creates a themed artwork view.
    ///
    /// - Parameters:
    ///   - configuration: The shape and shadow configuration. Defaults to `.circular`.
    ///   - isAnimating: Whether the artwork should animate. Defaults to `false`.
    ///   - animationType: The type of animation to apply. Defaults to `.spin`.
    ///   - animationDuration: The duration of one animation cycle. Defaults to `1.2`.
    ///   - content: A closure that returns the thematic artwork to display.
    public init(
        configuration: ArtworkConfiguration = .circular,
        isAnimating: Bool = false,
        animationType: ArtworkAnimationType = .spin,
        animationDuration: Double = 1.2,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.configuration = configuration
        self.isAnimating = isAnimating
        self.animationType = animationType
        self.animationDuration = animationDuration
    }

    // MARK: - Body

    public var body: some View {
        content
            .aspectRatio(configuration.aspectRatio, contentMode: .fit)
            .artworkAnimation(
                type: animationType,
                isActive: isAnimating,
                progress: animationProgress
            )
            .clipShape(resolvedShape)
            .shadow(
                color: content.theme.shadowColor,
                radius: configuration.shadowRadius,
                x: configuration.shadowOffset.width,
                y: configuration.shadowOffset.height
            )
            .modifier(ShimmerConditionalModifier(
                isActive: isAnimating && animationType == .shimmer,
                duration: animationDuration
            ))
            .onAppear { startAnimationIfNeeded() }
            .onDisappear { animationProgress = 0 }
    }

    // MARK: - Private

    private var resolvedShape: AnyShape {
        switch configuration.baseShape {
        case .circle:
            AnyShape(Circle())
        case .roundedRectangle(let radius):
            AnyShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        case .capsule:
            AnyShape(Capsule())
        }
    }

    private func startAnimationIfNeeded() {
        guard isAnimating, animationType != .shimmer else { return }
        animationProgress = 0
        withAnimation(.linear(duration: max(0.3, animationDuration)).repeatForever(autoreverses: false)) {
            animationProgress = 1
        }
    }
}

// MARK: - ShimmerConditionalModifier

/// Helper modifier to conditionally apply shimmer effect.
private struct ShimmerConditionalModifier: ViewModifier {

    let isActive: Bool
    let duration: Double

    func body(content: Content) -> some View {
        if isActive {
            content.shimmer(isActive: true, duration: duration)
        } else {
            content
        }
    }
}

// MARK: - Preview

#Preview("Static Artwork") {
    ThemedArtworkView {
        PreviewArtwork()
    }
    .frame(width: 150, height: 150)
    .padding()
}

#Preview("Spinning Animation") {
    ThemedArtworkView(
        isAnimating: true,
        animationType: .spin
    ) {
        PreviewArtwork()
    }
    .frame(width: 150, height: 150)
    .padding()
}

#Preview("Pulse Animation") {
    ThemedArtworkView(
        isAnimating: true,
        animationType: .pulse
    ) {
        PreviewArtwork()
    }
    .frame(width: 150, height: 150)
    .padding()
}

// MARK: - Preview Helper

/// A simple preview artwork for testing the wrapper.
private struct PreviewArtwork: ThematicArtwork {

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
            Circle()
                .fill(theme.accentColors.first ?? .red)
                .frame(width: dimension * 0.1)
                .offset(y: -dimension * 0.3)
                .rotationEffect(.degrees(Double(index) * 60))
        }
    }

    func overlayLayer(dimension: CGFloat) -> some View {
        Circle()
            .strokeBorder(Color.white.opacity(0.2), lineWidth: dimension * 0.02)
    }
}
