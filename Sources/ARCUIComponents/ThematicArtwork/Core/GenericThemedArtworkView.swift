//
//  GenericThemedArtworkView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/20/26.
//

import SwiftUI

// MARK: - GenericThemedArtworkView

/// A customizable thematic artwork view for placeholders and loaders.
///
/// Use `GenericThemedArtworkView` to display themed visual components based on
/// any type conforming to `ArtworkTypeProtocol`. The view supports animations,
/// custom configurations, and automatically applies the appropriate theme colors.
///
/// ## Example Usage
/// ```swift
/// // Basic usage with custom artwork type
/// GenericThemedArtworkView(type: MyArtwork.pizza)
///
/// // With animation
/// GenericThemedArtworkView(
///     type: MyArtwork.sushi,
///     isAnimating: true,
///     animationType: .spin
/// )
///
/// // Custom configuration override
/// GenericThemedArtworkView(
///     type: MyArtwork.taco,
///     configuration: .card
/// )
/// ```
public struct GenericThemedArtworkView<ArtworkType: ArtworkTypeProtocol>: View {

    // MARK: - Properties

    private let type: ArtworkType
    private let configuration: ArtworkConfiguration
    private let isAnimating: Bool
    private let animationType: ArtworkAnimationType
    private let animationDuration: Double

    // MARK: - Initialization

    /// Creates a themed artwork view.
    ///
    /// - Parameters:
    ///   - type: The type of artwork to display.
    ///   - configuration: The shape and shadow configuration. If not provided,
    ///     uses the recommended configuration for the artwork type.
    ///   - isAnimating: Whether the artwork should animate. Defaults to `false`.
    ///   - animationType: The type of animation to apply. Defaults to `.spin`.
    ///   - animationDuration: The duration of one animation cycle. Defaults to `4.0`.
    public init(
        type: ArtworkType,
        configuration: ArtworkConfiguration? = nil,
        isAnimating: Bool = false,
        animationType: ArtworkAnimationType = .spin,
        animationDuration: Double = 4.0
    ) {
        self.type = type
        self.configuration = configuration ?? type.recommendedConfiguration
        self.isAnimating = isAnimating
        self.animationType = animationType
        self.animationDuration = animationDuration
    }

    // MARK: - Body

    public var body: some View {
        if isAnimating && animationType != .shimmer {
            animatedContent
        } else {
            staticContent
        }
    }

    // MARK: - Private

    @ViewBuilder
    private var animatedContent: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: false)) { timeline in
            let progress = calculateProgress(from: timeline.date)

            artworkContent
                .artworkAnimation(
                    type: animationType,
                    isActive: isAnimating,
                    progress: progress
                )
        }
    }

    @ViewBuilder
    private var staticContent: some View {
        artworkContent
            .modifier(ShimmerConditionalModifier(
                isActive: isAnimating && animationType == .shimmer,
                duration: animationDuration
            ))
    }

    @ViewBuilder
    private var artworkContent: some View {
        GeometryReader { geometry in
            let dimension = min(geometry.size.width, geometry.size.height)

            type.makeContent(dimension: dimension)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(configuration.aspectRatio, contentMode: .fit)
        .clipShape(resolvedShape)
        .shadow(
            color: type.theme.shadowColor,
            radius: configuration.shadowRadius,
            x: configuration.shadowOffset.width,
            y: configuration.shadowOffset.height
        )
    }

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

    private func calculateProgress(from date: Date) -> Double {
        let seconds = date.timeIntervalSinceReferenceDate
        let cycle = seconds.truncatingRemainder(dividingBy: animationDuration)
        return cycle / animationDuration
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
