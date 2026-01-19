//
//  ThematicArtwork.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ThematicArtwork Protocol

/// A protocol that defines a thematic artwork composed of visual layers.
///
/// Thematic artworks are decorative visual components that can be used as placeholders,
/// loaders, or visual representations of concepts (food, books, etc.). Each artwork
/// is built from three composable layers: background, decoration, and overlay.
///
/// ## Example Usage
/// ```swift
/// struct MyCustomArtwork: ThematicArtwork {
///     var theme: ArtworkTheme { .pizza }
///
///     func backgroundLayer(dimension: CGFloat) -> some View {
///         Circle().fill(theme.primaryColor)
///     }
///
///     func decorationLayer(dimension: CGFloat) -> some View {
///         // Add decorative elements
///     }
///
///     func overlayLayer(dimension: CGFloat) -> some View {
///         // Add overlay effects
///     }
/// }
/// ```
public protocol ThematicArtwork: View {

    associatedtype BackgroundLayer: View
    associatedtype DecorationLayer: View
    associatedtype OverlayLayer: View

    /// The theme containing color tokens and design values for this artwork.
    var theme: ArtworkTheme { get }

    /// Creates the background layer of the artwork.
    ///
    /// This layer typically contains the base shape with gradients or solid fills.
    /// - Parameter dimension: The computed dimension (minimum of width/height) for sizing.
    /// - Returns: A view representing the background layer.
    @ViewBuilder func backgroundLayer(dimension: CGFloat) -> BackgroundLayer

    /// Creates the decoration layer of the artwork.
    ///
    /// This layer contains the decorative elements distributed over the background.
    /// - Parameter dimension: The computed dimension (minimum of width/height) for sizing.
    /// - Returns: A view representing the decoration layer.
    @ViewBuilder func decorationLayer(dimension: CGFloat) -> DecorationLayer

    /// Creates the overlay layer of the artwork.
    ///
    /// This layer contains effects like glows, shadows, or highlights.
    /// - Parameter dimension: The computed dimension (minimum of width/height) for sizing.
    /// - Returns: A view representing the overlay layer.
    @ViewBuilder func overlayLayer(dimension: CGFloat) -> OverlayLayer
}

// MARK: - Default Implementation

public extension ThematicArtwork {

    var body: some View {
        GeometryReader { geometry in
            let dimension = min(geometry.size.width, geometry.size.height)
            ZStack {
                backgroundLayer(dimension: dimension)
                decorationLayer(dimension: dimension)
                overlayLayer(dimension: dimension)
            }
            .frame(width: dimension, height: dimension)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
