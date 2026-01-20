//
//  GenericThemedLoaderView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/20/26.
//

import SwiftUI

// MARK: - GenericThemedLoaderView

/// A loader view using thematic artwork as its visual.
///
/// `GenericThemedLoaderView` displays an animated thematic artwork,
/// making it easy to create themed loading indicators. The view includes
/// accessibility support with customizable labels.
///
/// ## Example Usage
/// ```swift
/// // Simple loader with custom artwork type
/// GenericThemedLoaderView(type: MyArtwork.pizza, size: 64)
///
/// // Custom animation and accessibility
/// GenericThemedLoaderView(
///     type: MyArtwork.sushi,
///     size: 80,
///     animationType: .pulse,
///     accessibilityLabel: "Loading menu items"
/// )
/// ```
public struct GenericThemedLoaderView<ArtworkType: ArtworkTypeProtocol>: View {
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
    ///   - animationDuration: The duration of one animation cycle. Defaults to `4.0`.
    ///   - accessibilityLabel: The accessibility label. Defaults to `"Loading"`.
    public init(
        type: ArtworkType,
        size: CGFloat = 64,
        animationType: ArtworkAnimationType = .spin,
        animationDuration: Double = 4.0,
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
        GenericThemedArtworkView(
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
        let aspectRatio = type.recommendedConfiguration.aspectRatio
        return aspectRatio == 1.0 ? size : size / aspectRatio
    }
}
