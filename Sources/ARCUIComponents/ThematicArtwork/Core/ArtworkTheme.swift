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
/// - `.neutral` - Gray tones for generic placeholders
/// - `.warm` - Orange and red tones
/// - `.cool` - Blue and purple tones
/// - `.nature` - Green and earth tones
/// - `.dark` - Dark tones for noir or mystery styles
///
/// ## Creating Custom Themes
/// ```swift
/// extension ArtworkTheme {
///     static let pizza = ArtworkTheme(
///         primaryColor: .orange,
///         secondaryColor: .red,
///         accentColors: [.brown, .green]
///     )
/// }
/// ```
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

// MARK: - Preset Themes

public extension ArtworkTheme {

    /// A neutral gray theme suitable for generic placeholders.
    static let neutral = ArtworkTheme(
        primaryColor: Color(white: 0.85),
        secondaryColor: Color(white: 0.6),
        accentColors: [Color(white: 0.4)]
    )

    /// A warm theme with orange and red tones.
    static let warm = ArtworkTheme(
        primaryColor: Color(red: 0.95, green: 0.6, blue: 0.2),
        secondaryColor: Color(red: 0.8, green: 0.3, blue: 0.2),
        accentColors: [
            Color(red: 0.64, green: 0.28, blue: 0.18),
            Color(red: 0.9, green: 0.5, blue: 0.1)
        ]
    )

    /// A cool theme with blue and purple tones.
    static let cool = ArtworkTheme(
        primaryColor: Color(red: 0.4, green: 0.6, blue: 0.9),
        secondaryColor: Color(red: 0.3, green: 0.4, blue: 0.7),
        accentColors: [
            Color(red: 0.5, green: 0.3, blue: 0.8),
            Color(red: 0.2, green: 0.5, blue: 0.9)
        ]
    )

    /// A nature theme with green and earth tones.
    static let nature = ArtworkTheme(
        primaryColor: Color(red: 0.4, green: 0.7, blue: 0.4),
        secondaryColor: Color(red: 0.6, green: 0.5, blue: 0.3),
        accentColors: [
            Color(red: 0.2, green: 0.5, blue: 0.2),
            Color(red: 0.8, green: 0.7, blue: 0.4)
        ]
    )

    /// A dark theme suitable for noir or mystery styles.
    static let dark = ArtworkTheme(
        primaryColor: Color(red: 0.15, green: 0.15, blue: 0.18),
        secondaryColor: Color(red: 0.3, green: 0.3, blue: 0.35),
        accentColors: [Color(red: 0.6, green: 0.1, blue: 0.1)]
    )
}
