//
//  AIRecommenderCategory.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import Foundation

/// Categories for AI-powered recommendations
///
/// Provides predefined categories for common recommendation types,
/// with support for custom categories per app.
///
/// ## Predefined Categories
///
/// - ``favorites``: Based on user's favorites/preferences
/// - ``trending``: Currently popular items
/// - ``nearYou``: Location-based recommendations
/// - ``new``: Recently added items
///
/// ## Custom Categories
///
/// Use ``custom(id:icon:label:)`` to create app-specific categories:
///
/// ```swift
/// let cuisine = AIRecommenderCategory.custom(
///     id: "cuisine",
///     icon: "fork.knife",
///     label: "Por Cocina"
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public enum AIRecommenderCategory: Identifiable, Sendable, Equatable, Hashable {
    // MARK: - Predefined Categories

    /// Recommendations based on user's favorites and preferences
    case favorites

    /// Currently trending/popular items
    case trending

    /// Location-based recommendations nearby
    case nearYou

    /// Recently added or discovered items
    case new

    // MARK: - Custom Category

    /// Custom category with configurable icon and label
    /// - Parameters:
    ///   - id: Unique identifier for the category
    ///   - icon: SF Symbol name for the category icon
    ///   - label: Display label for the category
    case custom(id: String, icon: String, label: String)

    // MARK: - Identifiable

    public var id: String {
        switch self {
        case .favorites:
            "favorites"
        case .trending:
            "trending"
        case .nearYou:
            "nearYou"
        case .new:
            "new"
        case let .custom(id, _, _):
            id
        }
    }

    // MARK: - Display Properties

    /// SF Symbol icon name for the category
    public var icon: String {
        switch self {
        case .favorites:
            "star.fill"
        case .trending:
            "flame.fill"
        case .nearYou:
            "location.fill"
        case .new:
            "sparkles"
        case let .custom(_, icon, _):
            icon
        }
    }

    /// Display label for the category
    public var label: String {
        switch self {
        case .favorites:
            "Basado en tus favoritos"
        case .trending:
            "Tendencias"
        case .nearYou:
            "Cerca de ti"
        case .new:
            "Nuevos descubrimientos"
        case let .custom(_, _, label):
            label
        }
    }

    /// Short label for compact displays (e.g., category picker)
    public var shortLabel: String {
        switch self {
        case .favorites:
            "Favoritos"
        case .trending:
            "Tendencias"
        case .nearYou:
            "Cerca"
        case .new:
            "Nuevos"
        case let .custom(_, _, label):
            label
        }
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - Equatable

    public static func == (lhs: AIRecommenderCategory, rhs: AIRecommenderCategory) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Default Categories

@available(iOS 17.0, macOS 14.0, *)
extension AIRecommenderCategory {
    /// Default set of categories for most apps
    public static var defaultCategories: [AIRecommenderCategory] {
        [.favorites, .nearYou, .trending, .new]
    }
}
