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

    /// Size of the circular gradient background behind the header icon
    public let headerIconCircleSize: CGFloat

    /// Top padding above the header icon (controls distance from navigation bar)
    public let headerTopPadding: CGFloat

    /// Font for the header icon SF Symbol
    public let headerIconFont: Font

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

    /// Label for the bookmark save button (not yet bookmarked)
    public let bookmarkSaveLabel: String

    /// Label for the bookmark button when item is already saved
    public let bookmarkSavedLabel: String

    // MARK: - Questionnaire Configuration

    /// Default mode when using dual mode
    public let defaultMode: AIRecommenderMode

    /// Title for the questionnaire submit button (when at least one answer is given)
    public let questionnaireSubmitText: String

    /// Text shown on the submit button when no answers have been given yet
    public let questionnaireMinAnswerPrompt: String

    /// Progress text shown at the start of the questionnaire (zero answers)
    public let questionnaireStartPrompt: String

    /// Progress text shown when all questions are answered
    public let questionnaireCompletePrompt: String

    /// Format string for mid-questionnaire progress (args: answered count, total count)
    ///
    /// Use `%lld` placeholders, e.g. `"%lld of %lld answered"`.
    public let questionnaireProgressFormat: String

    /// Whether to show progress dots in questionnaire mode
    public let showQuestionnaireProgress: Bool

    // MARK: - Spacing Configuration

    /// Spacing between header and mode switcher
    public let headerToModeSwitcherSpacing: CGFloat

    /// Spacing between mode switcher and content area
    public let modeSwitcherToContentSpacing: CGFloat

    /// Spacing between progress indicator and question cards in questionnaire
    public let progressToQuestionsSpacing: CGFloat

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

    // MARK: - Generate Action Configuration

    /// Title displayed in the generate CTA (quick mode, before generating)
    public let generateTitle: String

    /// Subtitle displayed in the generate CTA
    public let generateSubtitle: String

    /// Button text for the generate action
    public let generateButtonText: String

    /// SF Symbol icon for the generate button
    public let generateButtonIcon: String

    // MARK: - Initialization

    // swiftlint:disable function_body_length
    /// Creates a new AI recommender configuration with all customization options.
    /// All parameters have sensible defaults — use `.default` for the standard preset.
    public init(title: String = "AI Recommender",
                subtitle: String = "Discover personalized places based on your taste",
                headerIcon: String = "sparkles",
                animateHeaderIcon: Bool = true,
                headerIconCircleSize: CGFloat = 100,
                headerTopPadding: CGFloat = 0,
                headerIconFont: Font = .title2,
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
                allViewedText: String = "You've explored all recommendations",
                bookmarkSaveLabel: String = "Save",
                bookmarkSavedLabel: String = "Saved",
                defaultMode: AIRecommenderMode = .quick,
                questionnaireSubmitText: String = "Get recommendations",
                questionnaireMinAnswerPrompt: String = "Answer at least one question",
                questionnaireStartPrompt: String = "Tell me what you're looking for",
                questionnaireCompletePrompt: String = "All done! Ready to recommend",
                questionnaireProgressFormat: String = "%lld of %lld answered",
                showQuestionnaireProgress: Bool = true,
                headerToModeSwitcherSpacing: CGFloat = .arcSpacingLarge,
                modeSwitcherToContentSpacing: CGFloat = .arcSpacingMedium,
                progressToQuestionsSpacing: CGFloat = .arcSpacingMedium,
                categoryToContentSpacing: CGFloat = .arcSpacingMedium,
                emptyStateTitle: String = "No recommendations",
                emptyStateSubtitle: String = "Explore other categories to discover new suggestions",
                emptyStateIcon: String = "sparkles",
                emptyStateActionText: String? = nil,
                questionnaireRetakeText: String = "Retake questionnaire",
                generateTitle: String = "Generate your recommendations",
                generateSubtitle: String = "Select a category and tap to discover personalized AI suggestions",
                generateButtonText: String = "Generate recommendations",
                generateButtonIcon: String = "sparkles") {
        self.title = title
        self.subtitle = subtitle
        self.headerIcon = headerIcon
        self.animateHeaderIcon = animateHeaderIcon
        self.headerIconCircleSize = headerIconCircleSize
        self.headerTopPadding = headerTopPadding
        self.headerIconFont = headerIconFont
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
        self.bookmarkSaveLabel = bookmarkSaveLabel
        self.bookmarkSavedLabel = bookmarkSavedLabel
        self.defaultMode = defaultMode
        self.questionnaireSubmitText = questionnaireSubmitText
        self.questionnaireMinAnswerPrompt = questionnaireMinAnswerPrompt
        self.questionnaireStartPrompt = questionnaireStartPrompt
        self.questionnaireCompletePrompt = questionnaireCompletePrompt
        self.questionnaireProgressFormat = questionnaireProgressFormat
        self.showQuestionnaireProgress = showQuestionnaireProgress
        self.headerToModeSwitcherSpacing = headerToModeSwitcherSpacing
        self.modeSwitcherToContentSpacing = modeSwitcherToContentSpacing
        self.progressToQuestionsSpacing = progressToQuestionsSpacing
        self.categoryToContentSpacing = categoryToContentSpacing
        self.emptyStateTitle = emptyStateTitle
        self.emptyStateSubtitle = emptyStateSubtitle
        self.emptyStateIcon = emptyStateIcon
        self.emptyStateActionText = emptyStateActionText
        self.questionnaireRetakeText = questionnaireRetakeText
        self.generateTitle = generateTitle
        self.generateSubtitle = generateSubtitle
        self.generateButtonText = generateButtonText
        self.generateButtonIcon = generateButtonIcon
    }

    // swiftlint:enable function_body_length

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
