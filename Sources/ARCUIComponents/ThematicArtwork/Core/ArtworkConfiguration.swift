//
//  ArtworkConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ArtworkConfiguration

/// Configuration for the shape and proportions of a thematic artwork.
///
/// Use `ArtworkConfiguration` to customize the base shape, aspect ratio,
/// corner radius, and shadow properties of an artwork when wrapping it
/// with `ThemedArtworkView`.
///
/// ## Predefined Configurations
/// - `.circular` - Circle shape with 1:1 aspect ratio
/// - `.book` - Rounded rectangle with typical book proportions (0.65)
/// - `.card` - Square rounded rectangle
public struct ArtworkConfiguration: Sendable {

    // MARK: - BaseShape

    /// The base shape type for the artwork container.
    public enum BaseShape: Sendable, Equatable {

        /// A circular shape.
        case circle

        /// A rounded rectangle with the specified corner radius.
        case roundedRectangle(cornerRadius: CGFloat)

        /// A capsule shape.
        case capsule
    }

    // MARK: - Properties

    /// The base shape for clipping the artwork.
    public let baseShape: BaseShape

    /// The aspect ratio (width/height) of the artwork.
    public let aspectRatio: CGFloat

    /// The corner radius for the outer container.
    public let cornerRadius: CGFloat

    /// The shadow blur radius.
    public let shadowRadius: CGFloat

    /// The shadow offset from the artwork.
    public let shadowOffset: CGSize

    // MARK: - Initialization

    /// Creates a new artwork configuration.
    ///
    /// - Parameters:
    ///   - baseShape: The base shape for clipping. Defaults to `.circle`.
    ///   - aspectRatio: The width/height ratio. Defaults to `1.0`.
    ///   - cornerRadius: The outer corner radius. Defaults to `16`.
    ///   - shadowRadius: The shadow blur radius. Defaults to `14`.
    ///   - shadowOffset: The shadow offset. Defaults to `(0, 8)`.
    public init(
        baseShape: BaseShape = .circle,
        aspectRatio: CGFloat = 1.0,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 14,
        shadowOffset: CGSize = CGSize(width: 0, height: 8)
    ) {
        self.baseShape = baseShape
        self.aspectRatio = aspectRatio
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
}

// MARK: - Predefined Configurations

public extension ArtworkConfiguration {

    /// Circular configuration for round artworks like pizza or sushi.
    static let circular = ArtworkConfiguration(baseShape: .circle)

    /// Book configuration with typical book proportions.
    static let book = ArtworkConfiguration(
        baseShape: .roundedRectangle(cornerRadius: 4),
        aspectRatio: 0.65,
        cornerRadius: 8
    )

    /// Card configuration for square card-style artworks.
    static let card = ArtworkConfiguration(
        baseShape: .roundedRectangle(cornerRadius: 12),
        aspectRatio: 1.0,
        cornerRadius: 16
    )
}
