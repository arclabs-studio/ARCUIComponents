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
/// Provides a complete recommendation UI with two modes:
/// - **Quick Mode**: Category picker + recommendation cards (swipeable or list)
/// - **Questionnaire Mode**: Interactive survey for personalized AI recommendations
///
/// Supports dual mode with a tab switcher for users to toggle between modes.
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

    /// Callback when an item's bookmark status is toggled
    private let onItemBookmarked: ((Item) -> Void)?

    /// Set of bookmarked item IDs (managed by the consumer)
    private let bookmarkedItemIDs: Set<AnyHashable>

    /// Callback when questionnaire is submitted
    private let onQuestionnaireSubmit: ((AIRecommenderAnswers) -> Void)?

    /// Callback when the empty state action button is tapped
    private let onEmptyStateAction: (() -> Void)?

    /// Items to display in questionnaire results mode
    private let questionnaireItems: [Item]

    /// Callback when user taps retake questionnaire
    private let onQuestionnaireRetake: (() -> Void)?

    // MARK: - Private State

    @State private var internalMode: AIRecommenderMode = .quick

    // MARK: - Initialization (Quick Mode Only)

    /// Creates an AI recommender in quick mode with category selection
    public init(
        categories: [AIRecommenderCategory] = AIRecommenderCategory.defaultCategories,
        selectedCategory: Binding<AIRecommenderCategory>,
        items: [Item],
        configuration: ARCAIRecommenderConfiguration = .default,
        bookmarkedItemIDs: Set<AnyHashable> = [],
        onCategorySelected: ((AIRecommenderCategory) -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemBookmarked: ((Item) -> Void)? = nil,
        onEmptyStateAction: (() -> Void)? = nil
    ) {
        _mode = .constant(.quick)
        self.categories = categories
        _selectedCategory = selectedCategory
        questions = []
        _answers = .constant(AIRecommenderAnswers())
        self.items = items
        self.configuration = configuration
        self.bookmarkedItemIDs = bookmarkedItemIDs
        showModeSwitcher = false
        self.onCategorySelected = onCategorySelected
        self.onItemSelected = onItemSelected
        self.onItemBookmarked = onItemBookmarked
        onQuestionnaireSubmit = nil
        self.onEmptyStateAction = onEmptyStateAction
        questionnaireItems = []
        onQuestionnaireRetake = nil
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
        bookmarkedItemIDs = []
        showModeSwitcher = false
        onCategorySelected = nil
        onItemSelected = nil
        onItemBookmarked = nil
        onQuestionnaireSubmit = onSubmit
        onEmptyStateAction = nil
        questionnaireItems = []
        onQuestionnaireRetake = nil
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
        bookmarkedItemIDs: Set<AnyHashable> = [],
        questionnaireItems: [Item] = [],
        onCategorySelected: ((AIRecommenderCategory) -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemBookmarked: ((Item) -> Void)? = nil,
        onQuestionnaireSubmit: ((AIRecommenderAnswers) -> Void)? = nil,
        onEmptyStateAction: (() -> Void)? = nil,
        onQuestionnaireRetake: (() -> Void)? = nil
    ) {
        _mode = mode
        self.categories = categories
        _selectedCategory = selectedCategory
        self.questions = questions
        _answers = answers
        self.items = items
        self.configuration = configuration
        self.bookmarkedItemIDs = bookmarkedItemIDs
        showModeSwitcher = true
        self.onCategorySelected = onCategorySelected
        self.onItemSelected = onItemSelected
        self.onItemBookmarked = onItemBookmarked
        self.onQuestionnaireSubmit = onQuestionnaireSubmit
        self.onEmptyStateAction = onEmptyStateAction
        self.questionnaireItems = questionnaireItems
        self.onQuestionnaireRetake = onQuestionnaireRetake
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

    private var modeSwitcher: some View {
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
        if configuration.useCardStack {
            ScrollView {
                VStack(spacing: configuration.categoryToContentSpacing) {
                    AIRecommenderCategoryPicker(
                        categories: categories,
                        selectedCategory: $selectedCategory,
                        configuration: configuration,
                        onCategorySelected: onCategorySelected
                    )

                    itemsSection
                }
                .padding(.vertical, .arcSpacingMedium)
            }
        } else {
            ScrollView {
                VStack(spacing: .arcSpacingLarge) {
                    AIRecommenderCategoryPicker(
                        categories: categories,
                        selectedCategory: $selectedCategory,
                        configuration: configuration,
                        onCategorySelected: onCategorySelected
                    )

                    itemsSection
                }
                .padding(.vertical, .arcSpacingMedium)
            }
        }
    }

    // MARK: - Questionnaire Mode Content

    @ViewBuilder private var questionnaireModeContent: some View {
        if !questionnaireItems.isEmpty {
            questionnaireResultsContent
        } else {
            AIRecommenderQuestionnaire(
                questions: questions,
                answers: $answers,
                configuration: configuration,
                onSubmit: onQuestionnaireSubmit
            )
        }
    }

    // MARK: - Questionnaire Results Content

    private var questionnaireResultsContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let retake = onQuestionnaireRetake {
                    Button(action: retake) {
                        HStack(spacing: .arcSpacingSmall) {
                            Image(systemName: "arrow.counterclockwise")
                            Text(configuration.questionnaireRetakeText)
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(configuration.accentColor)
                    }
                    .padding(.vertical, .arcSpacingSmall)
                }

                if configuration.useCardStack {
                    AIRecommenderCardStack(
                        items: questionnaireItems,
                        bookmarkedItemIDs: bookmarkedItemIDs,
                        configuration: configuration,
                        onItemSelected: onItemSelected,
                        onItemBookmarked: onItemBookmarked
                    )
                } else {
                    LazyVStack(spacing: .arcSpacingMedium) {
                        ForEach(Array(questionnaireItems.enumerated()), id: \.element.id) { index, item in
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
            .padding(.vertical, .arcSpacingMedium)
        }
    }

    // MARK: - Items Section

    @ViewBuilder private var itemsSection: some View {
        if items.isEmpty {
            emptyStateView
        } else if configuration.useCardStack {
            AIRecommenderCardStack(
                items: items,
                bookmarkedItemIDs: bookmarkedItemIDs,
                configuration: configuration,
                onItemSelected: onItemSelected,
                onItemBookmarked: onItemBookmarked
            )
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
                    .aiGlowBorder(
                        isActive: configuration.showGlowEffect,
                        cornerRadius: configuration.itemCornerRadius,
                        accentColor: configuration.accentColor,
                        intensity: configuration.glowIntensity,
                        showSparkles: configuration.showSparkles
                    )
                }
            }
            .padding(.horizontal, .arcSpacingLarge)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: .arcSpacingMedium) {
            Image(systemName: configuration.emptyStateIcon)
                .font(.system(size: 40))
                .foregroundStyle(configuration.accentColor.opacity(0.5))

            Text(configuration.emptyStateTitle)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(configuration.emptyStateSubtitle)
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            if let actionText = configuration.emptyStateActionText,
               let action = onEmptyStateAction
            {
                Button(action: action) {
                    HStack(spacing: .arcSpacingSmall) {
                        Image(systemName: "sparkles")
                        Text(actionText)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, .arcSpacingMedium)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(configuration.accentColor)
                    )
                    .foregroundStyle(.white)
                }
                .padding(.top, .arcSpacingSmall)
                .padding(.horizontal, .arcSpacingLarge)
            }
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
