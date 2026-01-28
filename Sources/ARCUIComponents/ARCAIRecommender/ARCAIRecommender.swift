//
//  ARCAIRecommender.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - Mode

/// Display mode for the AI Recommender
@available(iOS 17.0, macOS 14.0, *)
public enum AIRecommenderMode: Sendable, Equatable {
    /// Quick results using predefined categories
    case quick

    /// Interactive questionnaire for personalized recommendations
    case questionnaire
}

// MARK: - ARCAIRecommender

/// AI-powered recommendation sheet content view
///
/// A reusable component for displaying AI-generated recommendations with
/// category filtering or interactive questionnaire. Designed for restaurant,
/// book, and similar recommendation apps.
///
/// ## Overview
///
/// `ARCAIRecommender` provides a complete recommendation UI with two modes:
///
/// **Quick Mode** (default):
/// - Animated header with AI branding
/// - Horizontal category picker
/// - Vertical list of recommendation cards
///
/// **Questionnaire Mode**:
/// - Interactive survey with chip-based answers
/// - Collects preferences for AI prompt building
/// - Progress indicator and submit button
///
/// ## Quick Mode Usage
///
/// ```swift
/// struct MyRecommendationsView: View {
///     @State private var selectedCategory: AIRecommenderCategory = .favorites
///     @State private var recommendations: [Restaurant] = []
///
///     var body: some View {
///         ARCAIRecommender(
///             selectedCategory: $selectedCategory,
///             items: recommendations,
///             configuration: .restaurant
///         ) { category in
///             loadRecommendations(for: category)
///         } onItemSelected: { restaurant in
///             navigateToDetail(restaurant)
///         }
///     }
/// }
/// ```
///
/// ## Questionnaire Mode Usage
///
/// ```swift
/// struct PreferencesView: View {
///     @State private var answers = AIRecommenderAnswers()
///     let questions: [AIRecommenderQuestion] = [...] // Your custom questions
///
///     var body: some View {
///         ARCAIRecommender<MyItem>(
///             questions: questions,
///             answers: $answers,
///             configuration: .default
///         ) { finalAnswers in
///             // Build AI prompt from answers
///             let prompt = buildPrompt(from: finalAnswers)
///             fetchRecommendations(prompt: prompt)
///         }
///     }
/// }
/// ```
///
/// ## Dual Mode with Tab Switcher
///
/// ```swift
/// ARCAIRecommender(
///     mode: $mode,
///     categories: categories,
///     selectedCategory: $selectedCategory,
///     questions: myQuestions,
///     answers: $answers,
///     items: recommendations,
///     configuration: .default
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAIRecommender<Item: AIRecommenderItem>: View {
    // MARK: - Properties

    /// Current display mode (quick or questionnaire)
    @Binding private var mode: AIRecommenderMode

    /// Available categories for quick mode
    private let categories: [AIRecommenderCategory]

    /// Currently selected category
    @Binding private var selectedCategory: AIRecommenderCategory

    /// Questions for questionnaire mode
    private let questions: [AIRecommenderQuestion]

    /// User answers for questionnaire mode
    @Binding private var answers: AIRecommenderAnswers

    /// Items to display for the current category (quick mode)
    private let items: [Item]

    /// Configuration for appearance and behavior
    private let configuration: ARCAIRecommenderConfiguration

    /// Whether to show mode switcher tabs
    private let showModeSwitcher: Bool

    /// Callback when a category is selected (quick mode)
    private let onCategorySelected: ((AIRecommenderCategory) -> Void)?

    /// Callback when an item is selected (quick mode)
    private let onItemSelected: ((Item) -> Void)?

    /// Callback when questionnaire is submitted
    private let onQuestionnaireSubmit: ((AIRecommenderAnswers) -> Void)?

    // MARK: - Private State

    @State private var internalMode: AIRecommenderMode = .quick

    // MARK: - Initialization (Quick Mode Only)

    /// Creates an AI recommender in quick mode with category selection
    public init(
        categories: [AIRecommenderCategory] = AIRecommenderCategory.defaultCategories,
        selectedCategory: Binding<AIRecommenderCategory>,
        items: [Item],
        configuration: ARCAIRecommenderConfiguration = .default,
        onCategorySelected: ((AIRecommenderCategory) -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil
    ) {
        _mode = .constant(.quick)
        self.categories = categories
        _selectedCategory = selectedCategory
        questions = []
        _answers = .constant(AIRecommenderAnswers())
        self.items = items
        self.configuration = configuration
        showModeSwitcher = false
        self.onCategorySelected = onCategorySelected
        self.onItemSelected = onItemSelected
        onQuestionnaireSubmit = nil
    }

    // MARK: - Initialization (Questionnaire Mode Only)

    /// Creates an AI recommender in questionnaire mode
    public init(
        questions: [AIRecommenderQuestion],
        answers: Binding<AIRecommenderAnswers>,
        configuration: ARCAIRecommenderConfiguration = .default,
        onSubmit: ((AIRecommenderAnswers) -> Void)? = nil
    ) {
        _mode = .constant(.questionnaire)
        categories = []
        _selectedCategory = .constant(.favorites)
        self.questions = questions
        _answers = answers
        items = []
        self.configuration = configuration
        showModeSwitcher = false
        onCategorySelected = nil
        onItemSelected = nil
        onQuestionnaireSubmit = onSubmit
    }

    // MARK: - Initialization (Dual Mode)

    /// Creates an AI recommender with both quick and questionnaire modes
    public init(
        mode: Binding<AIRecommenderMode>,
        categories: [AIRecommenderCategory] = AIRecommenderCategory.defaultCategories,
        selectedCategory: Binding<AIRecommenderCategory>,
        questions: [AIRecommenderQuestion],
        answers: Binding<AIRecommenderAnswers>,
        items: [Item],
        configuration: ARCAIRecommenderConfiguration = .default,
        onCategorySelected: ((AIRecommenderCategory) -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onQuestionnaireSubmit: ((AIRecommenderAnswers) -> Void)? = nil
    ) {
        _mode = mode
        self.categories = categories
        _selectedCategory = selectedCategory
        self.questions = questions
        _answers = answers
        self.items = items
        self.configuration = configuration
        showModeSwitcher = true
        self.onCategorySelected = onCategorySelected
        self.onItemSelected = onItemSelected
        self.onQuestionnaireSubmit = onQuestionnaireSubmit
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            // Header (always shown)
            AIRecommenderHeader(configuration: configuration)
                .padding(.top, .arcSpacingMedium)

            // Mode switcher (if dual mode)
            if showModeSwitcher {
                modeSwitcher
                    .padding(.vertical, .arcSpacingMedium)
            }

            // Content based on mode
            Group {
                switch mode {
                case .quick:
                    quickModeContent
                case .questionnaire:
                    questionnaireModeContent
                }
            }
            .animation(.arcSpring, value: mode)
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
    }

    // MARK: - Mode Switcher

    @ViewBuilder private var modeSwitcher: some View {
        HStack(spacing: 0) {
            ModeTab(
                title: "Rápido",
                icon: "bolt.fill",
                isSelected: mode == .quick,
                accentColor: configuration.accentColor
            ) {
                arcWithAnimation(.arcSpring) {
                    mode = .quick
                }
            }

            ModeTab(
                title: "Personalizado",
                icon: "slider.horizontal.3",
                isSelected: mode == .questionnaire,
                accentColor: configuration.accentColor
            ) {
                arcWithAnimation(.arcSpring) {
                    mode = .questionnaire
                }
            }
        }
        .padding(.horizontal, .arcSpacingLarge)
    }

    // MARK: - Quick Mode Content

    @ViewBuilder private var quickModeContent: some View {
        ScrollView {
            VStack(spacing: .arcSpacingLarge) {
                // Category picker
                AIRecommenderCategoryPicker(
                    categories: categories,
                    selectedCategory: $selectedCategory,
                    configuration: configuration,
                    onCategorySelected: onCategorySelected
                )

                // Items list
                itemsSection
            }
            .padding(.vertical, .arcSpacingMedium)
        }
    }

    // MARK: - Questionnaire Mode Content

    @ViewBuilder private var questionnaireModeContent: some View {
        AIRecommenderQuestionnaire(
            questions: questions,
            answers: $answers,
            configuration: configuration,
            onSubmit: onQuestionnaireSubmit
        )
    }

    // MARK: - Items Section

    @ViewBuilder private var itemsSection: some View {
        if items.isEmpty {
            emptyStateView
        } else {
            LazyVStack(spacing: .arcSpacingMedium) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    AIRecommenderItemCard(
                        item: item,
                        rank: configuration.showRankBadges ? index + 1 : nil,
                        configuration: configuration
                    ) {
                        onItemSelected?(item)
                    }
                }
            }
            .padding(.horizontal, .arcSpacingLarge)
        }
    }

    @ViewBuilder private var emptyStateView: some View {
        VStack(spacing: .arcSpacingMedium) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundStyle(configuration.accentColor.opacity(0.5))

            Text("Sin recomendaciones")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Explora otras categorías para descubrir nuevas sugerencias")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.arcSpacingXLarge)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Mode Tab

@available(iOS 17.0, macOS 14.0, *)
private struct ModeTab: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .arcSpacingSmall)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? accentColor : Color.clear)
            )
            .foregroundStyle(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
    }
}
