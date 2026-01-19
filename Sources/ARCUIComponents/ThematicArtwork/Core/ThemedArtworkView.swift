//
//  ThemedArtworkView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ThemedArtworkView

/// A customizable thematic artwork view for placeholders and loaders.
///
/// Use `ThemedArtworkView` to display themed visual components based on the
/// specified `ArtworkType`. The view supports animations, custom configurations,
/// and automatically applies the appropriate theme colors.
///
/// ## Example Usage
/// ```swift
/// // Food artwork (circular by default)
/// ThemedArtworkView(type: .food(.pizza))
///
/// // Book artwork (uses book configuration by default)
/// ThemedArtworkView(type: .book(.romance))
///
/// // Animated loader
/// ThemedArtworkView(
///     type: .food(.sushi),
///     isAnimating: true,
///     animationType: .spin
/// )
///
/// // Custom configuration
/// ThemedArtworkView(
///     type: .food(.taco),
///     configuration: .card
/// )
/// ```
public struct ThemedArtworkView: View {

    // MARK: - Properties

    private let type: ArtworkType
    private let configuration: ArtworkConfiguration
    private let isAnimating: Bool
    private let animationType: ArtworkAnimationType
    private let animationDuration: Double

    @State private var animationProgress: Double = 0

    // MARK: - Initialization

    /// Creates a themed artwork view.
    ///
    /// - Parameters:
    ///   - type: The type of artwork to display.
    ///   - configuration: The shape and shadow configuration. If not provided,
    ///     uses the recommended configuration for the artwork type.
    ///   - isAnimating: Whether the artwork should animate. Defaults to `false`.
    ///   - animationType: The type of animation to apply. Defaults to `.spin`.
    ///   - animationDuration: The duration of one animation cycle. Defaults to `1.2`.
    public init(
        type: ArtworkType,
        configuration: ArtworkConfiguration? = nil,
        isAnimating: Bool = false,
        animationType: ArtworkAnimationType = .spin,
        animationDuration: Double = 1.2
    ) {
        self.type = type
        self.configuration = configuration ?? type.recommendedConfiguration
        self.isAnimating = isAnimating
        self.animationType = animationType
        self.animationDuration = animationDuration
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            let dimension = min(geometry.size.width, geometry.size.height)

            ArtworkRenderer(type: type, dimension: dimension)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(configuration.aspectRatio, contentMode: .fit)
        .artworkAnimation(
            type: animationType,
            isActive: isAnimating,
            progress: animationProgress
        )
        .clipShape(resolvedShape)
        .shadow(
            color: type.theme.shadowColor,
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

#Preview("Food - Pizza") {
    ThemedArtworkView(type: .food(.pizza))
        .frame(width: 150, height: 150)
        .padding()
}

#Preview("Food - Sushi") {
    ThemedArtworkView(type: .food(.sushi))
        .frame(width: 150, height: 150)
        .padding()
}

#Preview("Food - Taco") {
    ThemedArtworkView(type: .food(.taco))
        .frame(width: 150, height: 150)
        .padding()
}

#Preview("Book - Noir") {
    ThemedArtworkView(type: .book(.noir))
        .frame(width: 130, height: 200)
        .padding()
}

#Preview("Book - Romance") {
    ThemedArtworkView(type: .book(.romance))
        .frame(width: 130, height: 200)
        .padding()
}

#Preview("Book - Horror") {
    ThemedArtworkView(type: .book(.horror))
        .frame(width: 130, height: 200)
        .padding()
}

#Preview("Animated - Spin") {
    ThemedArtworkView(
        type: .food(.pizza),
        isAnimating: true,
        animationType: .spin
    )
    .frame(width: 100, height: 100)
    .padding()
}

#Preview("Animated - Pulse") {
    ThemedArtworkView(
        type: .food(.sushi),
        isAnimating: true,
        animationType: .pulse
    )
    .frame(width: 100, height: 100)
    .padding()
}

#Preview("All Food Types") {
    HStack(spacing: 20) {
        ForEach(ArtworkType.allFoodCases, id: \.displayName) { type in
            VStack {
                ThemedArtworkView(type: type)
                    .frame(width: 80, height: 80)
                Text(type.displayName)
                    .font(.caption)
            }
        }
    }
    .padding()
}

#Preview("All Book Types") {
    HStack(spacing: 20) {
        ForEach(ArtworkType.allBookCases, id: \.displayName) { type in
            VStack {
                ThemedArtworkView(type: type)
                    .frame(width: 80, height: 120)
                Text(type.displayName)
                    .font(.caption)
            }
        }
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            ThemedArtworkView(type: .food(.pizza))
                .frame(width: 100, height: 100)
            ThemedArtworkView(type: .food(.sushi))
                .frame(width: 100, height: 100)
        }

        HStack(spacing: 20) {
            ThemedArtworkView(type: .book(.noir))
                .frame(width: 80, height: 120)
            ThemedArtworkView(type: .book(.horror))
                .frame(width: 80, height: 120)
        }
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
