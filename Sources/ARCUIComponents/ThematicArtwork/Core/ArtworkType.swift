//
//  ArtworkType.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ArtworkType

/// The type of thematic artwork to display.
///
/// Use `ArtworkType` to specify which artwork style to render in a `ThemedArtworkView`.
/// Types are organized by category (food, book) with specific styles within each.
///
/// ## Example Usage
/// ```swift
/// ThemedArtworkView(type: .food(.pizza))
/// ThemedArtworkView(type: .book(.romance), configuration: .book)
/// ```
public enum ArtworkType: Sendable, Equatable {

    /// Food-themed artworks for restaurant or culinary apps.
    case food(FoodStyle)

    /// Book-themed artworks for reading or library apps.
    case book(BookStyle)
}

// MARK: - FoodStyle

public extension ArtworkType {

    /// Food artwork styles.
    enum FoodStyle: String, Sendable, CaseIterable {

        /// Italian pizza with toppings.
        case pizza

        /// Japanese sushi plate with nigiri.
        case sushi

        /// Mexican taco with toppings.
        case taco
    }
}

// MARK: - BookStyle

public extension ArtworkType {

    /// Book cover artwork styles.
    enum BookStyle: String, Sendable, CaseIterable {

        /// Dark noir/detective genre.
        case noir

        /// Romantic genre with hearts.
        case romance

        /// Horror genre with spooky elements.
        case horror
    }
}

// MARK: - Theme Resolution

extension ArtworkType {

    /// Returns the appropriate theme for this artwork type.
    var theme: ArtworkTheme {
        switch self {
        case .food(let style):
            switch style {
            case .pizza: return .pizza
            case .sushi: return .sushi
            case .taco: return .taco
            }
        case .book(let style):
            switch style {
            case .noir: return .noirBook
            case .romance: return .romanceBook
            case .horror: return .horrorBook
            }
        }
    }

    /// Returns the recommended configuration for this artwork type.
    var recommendedConfiguration: ArtworkConfiguration {
        switch self {
        case .food:
            return .circular
        case .book:
            return .book
        }
    }
}

// MARK: - Display Names

public extension ArtworkType {

    /// A human-readable name for the artwork type.
    var displayName: String {
        switch self {
        case .food(let style):
            return style.rawValue.capitalized
        case .book(let style):
            return style.rawValue.capitalized
        }
    }

    /// The category name for this artwork type.
    var categoryName: String {
        switch self {
        case .food:
            return "Food"
        case .book:
            return "Book"
        }
    }
}

// MARK: - All Cases

public extension ArtworkType {

    /// All available artwork types.
    static var allCases: [ArtworkType] {
        let foodCases = FoodStyle.allCases.map { ArtworkType.food($0) }
        let bookCases = BookStyle.allCases.map { ArtworkType.book($0) }
        return foodCases + bookCases
    }

    /// All food artwork types.
    static var allFoodCases: [ArtworkType] {
        FoodStyle.allCases.map { ArtworkType.food($0) }
    }

    /// All book artwork types.
    static var allBookCases: [ArtworkType] {
        BookStyle.allCases.map { ArtworkType.book($0) }
    }
}
