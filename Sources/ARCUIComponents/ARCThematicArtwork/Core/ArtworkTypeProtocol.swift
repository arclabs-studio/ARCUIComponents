//
//  ArtworkTypeProtocol.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/20/26.
//

import SwiftUI

// MARK: - ArtworkTypeProtocol

/// Protocol defining requirements for a thematic artwork type.
///
/// Implement this protocol to create custom artwork types for your app.
/// Each artwork type provides its theme, recommended configuration, and
/// the visual content to render.
///
/// ## Example Implementation
/// ```swift
/// enum RestaurantArtwork: ArtworkTypeProtocol {
///     case pizza
///     case sushi
///     case taco
///
///     var theme: ArtworkTheme {
///         switch self {
///         case .pizza: return .init(primaryColor: .orange, secondaryColor: .red)
///         case .sushi: return .init(primaryColor: .white, secondaryColor: .black)
///         case .taco: return .init(primaryColor: .yellow, secondaryColor: .brown)
///         }
///     }
///
///     var recommendedConfiguration: ArtworkConfiguration {
///         .circular
///     }
///
///     @ViewBuilder
///     func makeContent(dimension: CGFloat) -> some View {
///         switch self {
///         case .pizza: PizzaArtwork(dimension: dimension)
///         case .sushi: SushiArtwork(dimension: dimension)
///         case .taco: TacoArtwork(dimension: dimension)
///         }
///     }
/// }
/// ```
public protocol ArtworkTypeProtocol: Sendable, Equatable {
    /// The associated view type returned by `makeContent`.
    associatedtype ContentView: View

    /// The color theme for this artwork type.
    var theme: ArtworkTheme { get }

    /// The recommended configuration (shape, aspect ratio, shadow) for this artwork.
    var recommendedConfiguration: ArtworkConfiguration { get }

    /// Creates the visual content for this artwork.
    ///
    /// - Parameter dimension: The size dimension to use for scaling the artwork.
    /// - Returns: A view containing the artwork's visual representation.
    @ViewBuilder
    func makeContent(dimension: CGFloat) -> ContentView
}

// MARK: - Default Implementations

public extension ArtworkTypeProtocol {
    /// Default recommended configuration is circular.
    var recommendedConfiguration: ArtworkConfiguration {
        .circular
    }
}
