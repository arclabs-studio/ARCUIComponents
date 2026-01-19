//
//  ArtworkTheme.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ArtworkTheme

/// Design tokens for a thematic artwork.
///
/// `ArtworkTheme` encapsulates the color palette and visual properties
/// that define the appearance of a thematic artwork. Use predefined themes
/// or create custom ones for specific visual styles.
///
/// ## Predefined Themes
/// - `.pizza` - Warm orange tones with pepperoni and basil accents
/// - `.sushi` - Clean whites with salmon and avocado accents
/// - `.taco` - Tortilla browns with cilantro and salsa accents
/// - `.noirBook` - Dark grays with blood red accent
/// - `.horrorBook` - Deep purples with toxic green accent
/// - `.romanceBook` - Soft pinks with gold accent
public struct ArtworkTheme: Sendable {

    // MARK: - Properties

    /// The primary color used for the main shape/background.
    public let primaryColor: Color

    /// The secondary color used for supporting elements.
    public let secondaryColor: Color

    /// Accent colors for decorative elements.
    public let accentColors: [Color]

    /// Background color for shadows and dark elements.
    public let backgroundColor: Color

    /// Shadow color for depth effects.
    public let shadowColor: Color

    // MARK: - Initialization

    /// Creates a new artwork theme with the specified colors.
    ///
    /// - Parameters:
    ///   - primaryColor: The primary color for the main shape.
    ///   - secondaryColor: The secondary color for supporting elements.
    ///   - accentColors: An array of accent colors for decorations. Defaults to empty.
    ///   - backgroundColor: The background/dark color. Defaults to black.
    ///   - shadowColor: The shadow color. Defaults to black at 20% opacity.
    public init(
        primaryColor: Color,
        secondaryColor: Color,
        accentColors: [Color] = [],
        backgroundColor: Color = .black,
        shadowColor: Color = Color.black.opacity(0.2)
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColors = accentColors
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
    }
}

// MARK: - Food Themes

public extension ArtworkTheme {

    /// Pizza theme with warm orange and tomato tones.
    static let pizza = ArtworkTheme(
        primaryColor: Color(red: 0.95, green: 0.6, blue: 0.2),
        secondaryColor: Color(red: 0.8, green: 0.3, blue: 0.2),
        accentColors: [
            Color(red: 0.64, green: 0.28, blue: 0.18),
            Color(red: 0.2, green: 0.45, blue: 0.16)
        ]
    )

    /// Sushi theme with clean whites and fresh accents.
    static let sushi = ArtworkTheme(
        primaryColor: .white,
        secondaryColor: Color(red: 0.1, green: 0.1, blue: 0.1),
        accentColors: [
            Color(red: 0.9, green: 0.4, blue: 0.3),
            Color(red: 0.4, green: 0.7, blue: 0.4)
        ]
    )

    /// Taco theme with tortilla and fresh ingredient tones.
    static let taco = ArtworkTheme(
        primaryColor: Color(red: 0.85, green: 0.7, blue: 0.4),
        secondaryColor: Color(red: 0.6, green: 0.3, blue: 0.2),
        accentColors: [
            Color(red: 0.3, green: 0.6, blue: 0.3),
            Color(red: 0.95, green: 0.9, blue: 0.8),
            Color(red: 0.8, green: 0.2, blue: 0.2)
        ]
    )
}

// MARK: - Book Themes

public extension ArtworkTheme {

    /// Noir book theme with dark, mysterious tones.
    static let noirBook = ArtworkTheme(
        primaryColor: Color(red: 0.15, green: 0.15, blue: 0.18),
        secondaryColor: Color(red: 0.3, green: 0.3, blue: 0.35),
        accentColors: [
            Color(red: 0.6, green: 0.1, blue: 0.1)
        ]
    )

    /// Horror book theme with eerie purple and toxic green.
    static let horrorBook = ArtworkTheme(
        primaryColor: Color(red: 0.1, green: 0.08, blue: 0.12),
        secondaryColor: Color(red: 0.3, green: 0.1, blue: 0.35),
        accentColors: [
            Color(red: 0.4, green: 0.8, blue: 0.3),
            Color(red: 0.8, green: 0.1, blue: 0.1)
        ]
    )

    /// Romance book theme with soft pinks and gold.
    static let romanceBook = ArtworkTheme(
        primaryColor: Color(red: 0.95, green: 0.85, blue: 0.88),
        secondaryColor: Color(red: 0.85, green: 0.4, blue: 0.5),
        accentColors: [
            Color(red: 0.8, green: 0.6, blue: 0.2),
            Color(red: 0.95, green: 0.3, blue: 0.4)
        ]
    )
}
