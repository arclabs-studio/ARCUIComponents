//
//  ARCAIRecommenderShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCAIRecommender in various configurations
///
/// This view provides a visual gallery of all AI recommender styles,
/// demonstrating different presets, categories, and use cases.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAIRecommenderShowcase: View {
    // MARK: - State

    @State private var selectedPreset: ShowcasePreset = .default
    @State private var selectedCategory: AIRecommenderCategory = .favorites
    @State private var selectedMode: AIRecommenderMode = .quick
    @State private var questionnaireAnswers = AIRecommenderAnswers()

    // MARK: - Initialization

    public init() {}

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                heroSection
                presetsSection
                modesSection
                livePreviewSection
                questionnaireSection
                categoriesSection
                cardsSection
                integrationSection
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .navigationTitle("ARCAIRecommender")
    }
}

// MARK: - Sections

@available(iOS 17.0, macOS 14.0, *)
extension ARCAIRecommenderShowcase {
    @ViewBuilder var heroSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [selectedPreset.accentColor, selectedPreset.accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                    .symbolEffect(.pulse, options: .repeating)
            }

            Text("ARCAIRecommender")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("AI-powered recommendation component")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, .arcSpacingMedium)
    }

    @ViewBuilder var presetsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Configuration Presets", subtitle: "4 presets for different app types")
            VStack(spacing: .arcSpacingMedium) {
                ForEach(ShowcasePreset.allCases) { preset in
                    presetRow(preset)
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    @ViewBuilder var modesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Display Modes", subtitle: "Quick categories or personalized questionnaire")
            VStack(spacing: .arcSpacingMedium) {
                modeRow(
                    mode: .quick,
                    title: "Quick Mode",
                    description: "Fast results using predefined categories",
                    icon: "bolt.fill"
                )
                modeRow(
                    mode: .questionnaire,
                    title: "Questionnaire Mode",
                    description: "Interactive survey for personalized recommendations",
                    icon: "slider.horizontal.3"
                )
            }
            .padding()
            .background(cardBackground)
        }
    }

    @ViewBuilder var livePreviewSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Live Preview", subtitle: "Interactive demonstration with mode switcher")
            ARCAIRecommender(
                mode: $selectedMode,
                categories: AIRecommenderCategory.defaultCategories,
                selectedCategory: $selectedCategory,
                questions: sampleQuestions,
                answers: $questionnaireAnswers,
                items: sampleItems,
                configuration: selectedPreset.configuration
            )
            .frame(height: 550)
            .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusLarge))
            .overlay(
                RoundedRectangle(cornerRadius: .arcCornerRadiusLarge)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }

    @ViewBuilder var questionnaireSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Question Types", subtitle: "Different input types for gathering preferences")
            VStack(spacing: .arcSpacingMedium) {
                ForEach(sampleQuestions) { question in
                    questionRow(question)
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    @ViewBuilder var categoriesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Categories", subtitle: "Predefined and custom categories")
            VStack(spacing: .arcSpacingMedium) {
                categoryRow(.favorites)
                categoryRow(.nearYou)
                categoryRow(.trending)
                categoryRow(.new)
                Divider().padding(.vertical, .arcSpacingSmall)
                Text("Custom Categories")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                categoryRow(.custom(id: "cuisine", icon: "fork.knife", label: "Por Cocina"))
                categoryRow(.custom(id: "price", icon: "dollarsign.circle", label: "Por Precio"))
            }
            .padding()
            .background(cardBackground)
        }
    }

    @ViewBuilder var cardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Item Cards", subtitle: "Card variants and configurations")
            VStack(spacing: .arcSpacingMedium) {
                cardLabel("With Rank & AI Reason")
                AIRecommenderItemCard(
                    item: sampleItems[0],
                    rank: 1,
                    configuration: selectedPreset.configuration,
                    action: {}
                )
                Divider()
                cardLabel("Without Rank (Minimal)")
                AIRecommenderItemCard(
                    item: sampleItems[1],
                    rank: nil,
                    configuration: .minimal,
                    action: {}
                )
                Divider()
                cardLabel("Compact Style")
                AIRecommenderItemCard(
                    item: sampleItems[2],
                    rank: nil,
                    configuration: .compact,
                    action: {}
                )
            }
            .padding()
            .background(cardBackground)
        }
    }

    @ViewBuilder var integrationSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Integration", subtitle: "Code example")
            VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                Text("Basic Usage").font(.caption).foregroundStyle(.secondary)
                Text(codeExample)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.8))
                    .foregroundStyle(.green)
                    .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
            }
            .padding()
            .background(cardBackground)
        }
    }
}

// MARK: - Row Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCAIRecommenderShowcase {
    @ViewBuilder
    func presetRow(_ preset: ShowcasePreset) -> some View {
        Button {
            arcWithAnimation(.arcSpring) { selectedPreset = preset }
        } label: {
            HStack(spacing: .arcSpacingMedium) {
                Circle()
                    .fill(preset.accentColor.gradient)
                    .frame(width: 32, height: 32)
                    .overlay { Image(systemName: preset.icon).font(.caption).foregroundStyle(.white) }
                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.name).font(.subheadline.weight(.medium))
                    Text(preset.description).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                if selectedPreset == preset {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(preset.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func modeRow(mode: AIRecommenderMode, title: String, description: String, icon: String) -> some View {
        Button {
            arcWithAnimation(.arcSpring) { selectedMode = mode }
        } label: {
            HStack(spacing: .arcSpacingMedium) {
                Image(systemName: icon).font(.title3).foregroundStyle(selectedPreset.accentColor).frame(width: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.subheadline.weight(.medium))
                    Text(description).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                if selectedMode == mode {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(selectedPreset.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func questionRow(_ question: AIRecommenderQuestion) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            if let icon = question.icon {
                Image(systemName: icon).font(.body).foregroundStyle(selectedPreset.accentColor).frame(width: 24)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(question.text).font(.subheadline.weight(.medium))
                HStack(spacing: .arcSpacingXSmall) {
                    Text(question.inputType.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(selectedPreset.accentColor.opacity(0.2)))
                        .foregroundStyle(selectedPreset.accentColor)
                    Text("·").foregroundStyle(.tertiary)
                    Text("\(question.options.count) options").font(.caption2).foregroundStyle(.tertiary)
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    func categoryRow(_ category: AIRecommenderCategory) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            Image(systemName: category.icon).font(.body).foregroundStyle(selectedPreset.accentColor).frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(category.label).font(.subheadline.weight(.medium))
                Text("ID: \(category.id)").font(.caption2).foregroundStyle(.tertiary)
            }
            Spacer()
            Text(category.shortLabel)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.secondary.opacity(0.1)))
        }
    }
}

// MARK: - Helpers

@available(iOS 17.0, macOS 14.0, *)
extension ARCAIRecommenderShowcase {
    @ViewBuilder
    func sectionHeader(_ title: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
            Text(title).font(.title2.bold())
            if let subtitle {
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func cardLabel(_ text: String) -> some View {
        Text(text).font(.caption).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading)
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: .arcCornerRadiusMedium).fill(.ultraThinMaterial)
    }

    var codeExample: String {
        selectedMode == .quick ? quickModeCodeExample : questionnaireModeCodeExample
    }

    var quickModeCodeExample: String {
        """
        // Quick Mode
        ARCAIRecommender(
            selectedCategory: $selected,
            items: recommendations,
            configuration: .\(selectedPreset.configName)
        ) { category in
            loadItems(for: category)
        } onItemSelected: { item in
            navigateToDetail(item)
        }
        """
    }

    var questionnaireModeCodeExample: String {
        """
        // Questionnaire Mode
        ARCAIRecommender<MyItem>(
            questions: myQuestions,
            answers: $answers,
            configuration: .\(selectedPreset.configName)
        ) { answers in
            let prompt = buildPrompt(answers)
            fetchAIRecommendations(prompt)
        }
        """
    }
}
