//
//  ThemedLoaderView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ThemedLoaderView

/// A loader view using thematic artwork as its visual.
///
/// `ThemedLoaderView` displays an animated thematic artwork,
/// making it easy to create themed loading indicators. The view includes
/// accessibility support with customizable labels.
///
/// ## Example Usage
/// ```swift
/// // Simple pizza loader
/// ThemedLoaderView(type: .food(.pizza), size: 64)
///
/// // Custom animation and accessibility
/// ThemedLoaderView(
///     type: .food(.sushi),
///     size: 80,
///     animationType: .pulse,
///     accessibilityLabel: "Loading menu items"
/// )
///
/// // Book loader
/// ThemedLoaderView(type: .book(.romance), size: 100)
/// ```
public struct ThemedLoaderView: View {

    // MARK: - Properties

    private let type: ArtworkType
    private let size: CGFloat
    private let animationType: ArtworkAnimationType
    private let animationDuration: Double
    private let accessibilityLabel: String

    // MARK: - Initialization

    /// Creates a themed loader view.
    ///
    /// - Parameters:
    ///   - type: The type of artwork to display.
    ///   - size: The width and height of the loader. Defaults to `64`.
    ///   - animationType: The animation type. Defaults to `.spin`.
    ///   - animationDuration: The duration of one animation cycle. Defaults to `1.0`.
    ///   - accessibilityLabel: The accessibility label. Defaults to `"Loading"`.
    public init(
        type: ArtworkType,
        size: CGFloat = 64,
        animationType: ArtworkAnimationType = .spin,
        animationDuration: Double = 1.0,
        accessibilityLabel: String = "Loading"
    ) {
        self.type = type
        self.size = size
        self.animationType = animationType
        self.animationDuration = animationDuration
        self.accessibilityLabel = accessibilityLabel
    }

    // MARK: - Body

    public var body: some View {
        ThemedArtworkView(
            type: type,
            isAnimating: true,
            animationType: animationType,
            animationDuration: animationDuration
        )
        .frame(width: size, height: loaderHeight)
        .accessibilityLabel(Text(accessibilityLabel))
        .accessibilityAddTraits(.isImage)
    }

    // MARK: - Private

    private var loaderHeight: CGFloat {
        switch type {
        case .food:
            return size
        case .book:
            return size / type.recommendedConfiguration.aspectRatio
        }
    }
}

// MARK: - Preview

#Preview("Loader - Pizza") {
    ThemedLoaderView(type: .food(.pizza), size: 64)
        .padding()
}

#Preview("Loader - Sushi") {
    ThemedLoaderView(type: .food(.sushi), size: 64)
        .padding()
}

#Preview("Loader - Book") {
    ThemedLoaderView(type: .book(.romance), size: 80)
        .padding()
}

#Preview("Loader - Pulse") {
    ThemedLoaderView(
        type: .food(.pizza),
        size: 80,
        animationType: .pulse
    )
    .padding()
}

#Preview("Loader - Shimmer") {
    ThemedLoaderView(
        type: .food(.sushi),
        size: 80,
        animationType: .shimmer
    )
    .padding()
}

#Preview("Loader - Breathe") {
    ThemedLoaderView(
        type: .book(.horror),
        size: 80,
        animationType: .breathe
    )
    .padding()
}

#Preview("Loader Sizes") {
    HStack(spacing: 24) {
        ThemedLoaderView(type: .food(.pizza), size: 32)
        ThemedLoaderView(type: .food(.pizza), size: 48)
        ThemedLoaderView(type: .food(.pizza), size: 64)
        ThemedLoaderView(type: .food(.pizza), size: 80)
    }
    .padding()
}

#Preview("All Food Loaders") {
    HStack(spacing: 24) {
        ForEach(ArtworkType.allFoodCases, id: \.displayName) { type in
            VStack {
                ThemedLoaderView(type: type, size: 60)
                Text(type.displayName)
                    .font(.caption)
            }
        }
    }
    .padding()
}

#Preview("All Book Loaders") {
    HStack(spacing: 24) {
        ForEach(ArtworkType.allBookCases, id: \.displayName) { type in
            VStack {
                ThemedLoaderView(type: type, size: 60)
                Text(type.displayName)
                    .font(.caption)
            }
        }
    }
    .padding()
}
