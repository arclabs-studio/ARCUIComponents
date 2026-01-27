//
//  ARCAIRecommenderConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCAIRecommender appearance and behavior
///
/// Provides customization options for the AI recommendation sheet while
/// maintaining Apple's design principles and Human Interface Guidelines.
///
/// ## Overview
///
/// Use configuration presets for quick setup or create custom configurations
/// for specific app needs.
///
/// ```swift
/// // Use a preset
/// ARCAIRecommender(
///     categories: .defaultCategories,
///     selectedCategory: $selectedCategory,
///     items: recommendations,
///     configuration: .restaurant
/// )
///
/// // Or customize
/// let config = ARCAIRecommenderConfiguration(
///     title: "Tu Recomendador",
///     accentColor: .purple
/// )
/// ```
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
/// - Note: Conforms to `LiquidGlassConfigurable` for unified liquid glass effect
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAIRecommenderConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Header Configuration

    /// Title displayed in the header
    public let title: String

    /// Subtitle displayed below the title
    public let subtitle: String

    /// SF Symbol icon displayed in the hero section
    public let headerIcon: String

    /// Whether to animate the header icon with pulse effect
    public let animateHeaderIcon: Bool

    // MARK: - Visual Customization (LiquidGlassConfigurable)

    /// Primary accent color for the component
    public let accentColor: Color

    /// Background style for the liquid glass effect
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for cards and containers
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Category Picker Configuration

    /// Animation used for category selection
    public let categoryAnimation: Animation

    /// Whether to show icons in category pills
    public let showCategoryIcons: Bool

    // MARK: - Item Card Configuration

    /// Whether to show rank badges (1, 2, 3...)
    public let showRankBadges: Bool

    /// Whether to show AI-generated reason text
    public let showAIReason: Bool

    /// Whether to show rating with disclosure indicator
    public let showRating: Bool

    /// Corner radius for item cards
    public let itemCornerRadius: CGFloat

    // MARK: - Rating Configuration

    /// Color used for rating display
    public let ratingColor: Color

    // MARK: - Questionnaire Configuration

    /// Default mode when using dual mode
    public let defaultMode: AIRecommenderMode

    /// Title for the questionnaire submit button
    public let questionnaireSubmitText: String

    /// Whether to show progress dots in questionnaire mode
    public let showQuestionnaireProgress: Bool

    // MARK: - Initialization

    /// Creates a new AI recommender configuration
    /// - Parameters:
    ///   - title: Title displayed in the header
    ///   - subtitle: Subtitle displayed below the title
    ///   - headerIcon: SF Symbol icon for the hero section
    ///   - animateHeaderIcon: Whether to animate the header icon
    ///   - accentColor: Primary accent color
    ///   - backgroundStyle: Background style for liquid glass effect
    ///   - cornerRadius: Corner radius for containers
    ///   - shadow: Shadow configuration
    ///   - categoryAnimation: Animation for category selection
    ///   - showCategoryIcons: Whether to show icons in category pills
    ///   - showRankBadges: Whether to show rank badges
    ///   - showAIReason: Whether to show AI reason text
    ///   - showRating: Whether to show rating
    ///   - itemCornerRadius: Corner radius for item cards
    ///   - ratingColor: Color for rating display
    ///   - defaultMode: Default mode when using dual mode
    ///   - questionnaireSubmitText: Text for the questionnaire submit button
    ///   - showQuestionnaireProgress: Whether to show progress dots in questionnaire
    public init(
        title: String = "Recomendador IA",
        subtitle: String = "Descubre lugares personalizados según tus gustos",
        headerIcon: String = "sparkles",
        animateHeaderIcon: Bool = true,
        accentColor: Color = Color(red: 0.95, green: 0.75, blue: 0.3),
        backgroundStyle: ARCBackgroundStyle = .material(.ultraThinMaterial),
        cornerRadius: CGFloat = .arcCornerRadiusMedium,
        shadow: ARCShadow = .subtle,
        categoryAnimation: Animation = .arcQuick,
        showCategoryIcons: Bool = true,
        showRankBadges: Bool = true,
        showAIReason: Bool = true,
        showRating: Bool = true,
        itemCornerRadius: CGFloat = .arcCornerRadiusMedium,
        ratingColor: Color = Color(red: 0.95, green: 0.75, blue: 0.3),
        defaultMode: AIRecommenderMode = .quick,
        questionnaireSubmitText: String = "Obtener recomendaciones",
        showQuestionnaireProgress: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.headerIcon = headerIcon
        self.animateHeaderIcon = animateHeaderIcon
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.categoryAnimation = categoryAnimation
        self.showCategoryIcons = showCategoryIcons
        self.showRankBadges = showRankBadges
        self.showAIReason = showAIReason
        self.showRating = showRating
        self.itemCornerRadius = itemCornerRadius
        self.ratingColor = ratingColor
        self.defaultMode = defaultMode
        self.questionnaireSubmitText = questionnaireSubmitText
        self.showQuestionnaireProgress = showQuestionnaireProgress
    }

    // MARK: - Presets

    /// Default configuration with amber accent (AI/Intelligence style)
    public static let `default` = ARCAIRecommenderConfiguration()

    /// Configuration for restaurant/food apps (FavRes style)
    ///
    /// Features orange accent color optimized for food-related applications.
    public static let restaurant = ARCAIRecommenderConfiguration(
        title: "Recomendador IA",
        subtitle: "Descubre restaurantes personalizados según tus gustos",
        accentColor: .orange,
        ratingColor: .orange
    )

    /// Configuration for book apps (FavBook style)
    ///
    /// Features blue accent color optimized for reading applications.
    public static let books = ARCAIRecommenderConfiguration(
        title: "Recomendador IA",
        subtitle: "Encuentra tu próxima lectura perfecta",
        accentColor: .blue,
        ratingColor: .blue
    )

    /// Minimal configuration without ranks or AI reasons
    ///
    /// Simplified display for contexts where detailed information isn't needed.
    public static let minimal = ARCAIRecommenderConfiguration(
        showRankBadges: false,
        showAIReason: false
    )

    /// Compact configuration for limited space
    ///
    /// Hides icons and reduces visual complexity.
    public static let compact = ARCAIRecommenderConfiguration(
        showCategoryIcons: false,
        showRankBadges: false,
        itemCornerRadius: .arcCornerRadiusSmall
    )
}
