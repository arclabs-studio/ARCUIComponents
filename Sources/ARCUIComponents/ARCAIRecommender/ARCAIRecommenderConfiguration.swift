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
/// // Use default preset
/// ARCAIRecommender(
///     categories: .defaultCategories,
///     selectedCategory: $selectedCategory,
///     items: recommendations,
///     configuration: .default
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
@available(iOS 17.0, macOS 14.0, *) public struct ARCAIRecommenderConfiguration: Sendable, LiquidGlassConfigurable {
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

    // MARK: - Card Content Visibility

    /// Whether to show subtitle tags (e.g., cuisine type, price range)
    public let showTags: Bool

    /// Whether to show the location row
    public let showLocation: Bool

    /// Whether to show the highlight detail row (e.g., featured dish, standout feature)
    public let showHighlightDetail: Bool

    // MARK: - Glow Effect Configuration

    /// Whether to show the animated AI glow border on the focused card
    public let showGlowEffect: Bool

    /// Intensity level for the glow border effect
    public let glowIntensity: AIGlowIntensity

    /// Whether to show sparkle particles around the focused card
    public let showSparkles: Bool

    // MARK: - Card Stack Configuration

    /// Whether to use the swipeable card stack layout (default) or vertical list
    public let useCardStack: Bool

    /// Number of cards visible in the stack behind the top card
    public let cardStackDepth: Int

    /// Fraction of card width that must be swiped to snap to next card
    public let swipeThreshold: CGFloat

    /// Maximum rotation angle (degrees) applied during drag
    public let maxSwipeRotation: Double

    /// Fraction of container width used by the centered card (0.0–1.0)
    public let peekFraction: CGFloat

    /// Scale applied to non-centered (adjacent) cards
    public let adjacentCardScale: CGFloat

    /// Opacity applied to non-centered (adjacent) cards
    public let adjacentCardOpacity: Double

    /// Spacing between cards in the carousel
    public let cardSpacing: CGFloat

    /// Aspect ratio (width/height) for the card stack container.
    /// Lower values produce taller cards. Default is `0.75`.
    public let cardAspectRatio: CGFloat

    /// Whether to show the position indicator (e.g., "2 / 8")
    public let showCardIndicator: Bool

    /// SF Symbol for the bookmark button (inactive state)
    public let bookmarkIcon: String

    /// SF Symbol for the bookmark button (active state)
    public let bookmarkActiveIcon: String

    /// Text shown when user has viewed all cards
    public let allViewedText: String

    // MARK: - Questionnaire Configuration

    /// Default mode when using dual mode
    public let defaultMode: AIRecommenderMode

    /// Title for the questionnaire submit button
    public let questionnaireSubmitText: String

    /// Whether to show progress dots in questionnaire mode
    public let showQuestionnaireProgress: Bool

    // MARK: - Spacing Configuration

    /// Spacing between category picker and content in quick mode
    public let categoryToContentSpacing: CGFloat

    // MARK: - Empty State Configuration

    /// Title displayed in the empty state
    public let emptyStateTitle: String

    /// Subtitle displayed in the empty state
    public let emptyStateSubtitle: String

    /// SF Symbol icon displayed in the empty state
    public let emptyStateIcon: String

    /// Optional action button text in the empty state (nil hides the button)
    public let emptyStateActionText: String?

    // MARK: - Questionnaire Results Configuration

    /// Text for the retake questionnaire button
    public let questionnaireRetakeText: String

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
    ///   - showTags: Whether to show subtitle tags
    ///   - showLocation: Whether to show location row
    ///   - showHighlightDetail: Whether to show highlight detail row
    ///   - showGlowEffect: Whether to show the animated AI glow border
    ///   - glowIntensity: Intensity level for the glow effect
    ///   - showSparkles: Whether to show sparkle particles
    ///   - useCardStack: Whether to use swipeable card stack layout
    ///   - cardStackDepth: Number of visible background cards
    ///   - swipeThreshold: Fraction of width to trigger navigation
    ///   - maxSwipeRotation: Max rotation during drag (degrees)
    ///   - peekFraction: Fraction of width for centered card
    ///   - adjacentCardScale: Scale for non-centered cards
    ///   - adjacentCardOpacity: Opacity for non-centered cards
    ///   - cardSpacing: Spacing between cards in carousel
    ///   - showCardIndicator: Whether to show position indicator
    ///   - bookmarkIcon: SF Symbol for inactive bookmark
    ///   - bookmarkActiveIcon: SF Symbol for active bookmark
    ///   - allViewedText: Text when all cards have been viewed
    ///   - defaultMode: Default mode when using dual mode
    ///   - questionnaireSubmitText: Text for the questionnaire submit button
    ///   - showQuestionnaireProgress: Whether to show progress dots in questionnaire
    ///   - categoryToContentSpacing: Spacing between category picker and content
    ///   - emptyStateTitle: Title for the empty state
    ///   - emptyStateSubtitle: Subtitle for the empty state
    ///   - emptyStateIcon: SF Symbol icon for the empty state
    ///   - emptyStateActionText: Optional action button text for the empty state
    ///   - questionnaireRetakeText: Text for the retake questionnaire button
    public init(title: String = "Recomendador IA",
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
                showTags: Bool = true,
                showLocation: Bool = true,
                showHighlightDetail: Bool = true,
                showGlowEffect: Bool = true,
                glowIntensity: AIGlowIntensity = .standard,
                showSparkles: Bool = true,
                useCardStack: Bool = true,
                cardStackDepth: Int = 3,
                swipeThreshold: CGFloat = 0.3,
                maxSwipeRotation: Double = 8.0,
                peekFraction: CGFloat = 0.85,
                adjacentCardScale: CGFloat = 0.95,
                adjacentCardOpacity: Double = 0.85,
                cardSpacing: CGFloat = 12,
                cardAspectRatio: CGFloat = 0.75,
                showCardIndicator: Bool = true,
                bookmarkIcon: String = "bookmark",
                bookmarkActiveIcon: String = "bookmark.fill",
                allViewedText: String = "Has explorado todas las recomendaciones",
                defaultMode: AIRecommenderMode = .quick,
                questionnaireSubmitText: String = "Obtener recomendaciones",
                showQuestionnaireProgress: Bool = true,
                categoryToContentSpacing: CGFloat = .arcSpacingMedium,
                emptyStateTitle: String = "Sin recomendaciones",
                emptyStateSubtitle: String = "Explora otras categorías para descubrir nuevas sugerencias",
                emptyStateIcon: String = "sparkles",
                emptyStateActionText: String? = nil,
                questionnaireRetakeText: String = "Repetir cuestionario")
    {
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
        self.showTags = showTags
        self.showLocation = showLocation
        self.showHighlightDetail = showHighlightDetail
        self.showGlowEffect = showGlowEffect
        self.glowIntensity = glowIntensity
        self.showSparkles = showSparkles
        self.useCardStack = useCardStack
        self.cardStackDepth = cardStackDepth
        self.swipeThreshold = swipeThreshold
        self.maxSwipeRotation = maxSwipeRotation
        self.peekFraction = peekFraction
        self.adjacentCardScale = adjacentCardScale
        self.adjacentCardOpacity = adjacentCardOpacity
        self.cardSpacing = cardSpacing
        self.cardAspectRatio = cardAspectRatio
        self.showCardIndicator = showCardIndicator
        self.bookmarkIcon = bookmarkIcon
        self.bookmarkActiveIcon = bookmarkActiveIcon
        self.allViewedText = allViewedText
        self.defaultMode = defaultMode
        self.questionnaireSubmitText = questionnaireSubmitText
        self.showQuestionnaireProgress = showQuestionnaireProgress
        self.categoryToContentSpacing = categoryToContentSpacing
        self.emptyStateTitle = emptyStateTitle
        self.emptyStateSubtitle = emptyStateSubtitle
        self.emptyStateIcon = emptyStateIcon
        self.emptyStateActionText = emptyStateActionText
        self.questionnaireRetakeText = questionnaireRetakeText
    }

    // MARK: - Presets

    /// Default configuration with amber accent (AI/Intelligence style)
    public static let `default` = ARCAIRecommenderConfiguration()

    /// Minimal configuration without ranks or AI reasons
    ///
    /// Simplified display for contexts where detailed information isn't needed.
    public static let minimal = ARCAIRecommenderConfiguration(showRankBadges: false,
                                                              showAIReason: false,
                                                              showGlowEffect: false)

    /// Compact configuration for limited space
    ///
    /// Hides icons and reduces visual complexity.
    public static let compact = ARCAIRecommenderConfiguration(showCategoryIcons: false,
                                                              showRankBadges: false,
                                                              itemCornerRadius: .arcCornerRadiusSmall,
                                                              showSparkles: false)

    /// Classic vertical list layout without card stack
    ///
    /// Use this preset to display items in the traditional list format.
    /// Glow effect is enabled without sparkles for a clean look.
    public static let list = ARCAIRecommenderConfiguration(showSparkles: false,
                                                           useCardStack: false)
}
