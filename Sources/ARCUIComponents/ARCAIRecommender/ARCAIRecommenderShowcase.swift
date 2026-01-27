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

    // MARK: - Hero Section

    @ViewBuilder
    private var heroSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                selectedPreset.accentColor,
                                selectedPreset.accentColor.opacity(0.6)
                            ],
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

    // MARK: - Presets Section

    @ViewBuilder
    private var presetsSection: some View {
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

    @ViewBuilder
    private func presetRow(_ preset: ShowcasePreset) -> some View {
        Button {
            arcWithAnimation(.arcSpring) {
                selectedPreset = preset
            }
        } label: {
            HStack(spacing: .arcSpacingMedium) {
                Circle()
                    .fill(preset.accentColor.gradient)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(systemName: preset.icon)
                            .font(.caption)
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.name)
                        .font(.subheadline.weight(.medium))
                    Text(preset.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if selectedPreset == preset {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(preset.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Modes Section

    @ViewBuilder
    private var modesSection: some View {
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

    @ViewBuilder
    private func modeRow(mode: AIRecommenderMode, title: String, description: String, icon: String) -> some View {
        Button {
            arcWithAnimation(.arcSpring) {
                selectedMode = mode
            }
        } label: {
            HStack(spacing: .arcSpacingMedium) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(selectedPreset.accentColor)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.medium))
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if selectedMode == mode {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(selectedPreset.accentColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Live Preview Section

    @ViewBuilder
    private var livePreviewSection: some View {
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

    // MARK: - Questionnaire Section

    @ViewBuilder
    private var questionnaireSection: some View {
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

    @ViewBuilder
    private func questionRow(_ question: AIRecommenderQuestion) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            if let icon = question.icon {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(selectedPreset.accentColor)
                    .frame(width: 24)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(question.text)
                    .font(.subheadline.weight(.medium))

                HStack(spacing: .arcSpacingXSmall) {
                    Text(question.inputType.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(selectedPreset.accentColor.opacity(0.2)))
                        .foregroundStyle(selectedPreset.accentColor)

                    Text("·")
                        .foregroundStyle(.tertiary)

                    Text("\(question.options.count) options")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()
        }
    }

    // MARK: - Categories Section

    @ViewBuilder
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Categories", subtitle: "Predefined and custom categories")

            VStack(spacing: .arcSpacingMedium) {
                categoryRow(.favorites)
                categoryRow(.nearYou)
                categoryRow(.trending)
                categoryRow(.new)

                Divider()
                    .padding(.vertical, .arcSpacingSmall)

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

    @ViewBuilder
    private func categoryRow(_ category: AIRecommenderCategory) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            Image(systemName: category.icon)
                .font(.body)
                .foregroundStyle(selectedPreset.accentColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(category.label)
                    .font(.subheadline.weight(.medium))
                Text("ID: \(category.id)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Text(category.shortLabel)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.secondary.opacity(0.1)))
        }
    }

    // MARK: - Cards Section

    @ViewBuilder
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Item Cards", subtitle: "Card variants and configurations")

            VStack(spacing: .arcSpacingMedium) {
                Text("With Rank & AI Reason")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                AIRecommenderItemCard(
                    item: sampleItems[0],
                    rank: 1,
                    configuration: selectedPreset.configuration,
                    action: {}
                )

                Divider()

                Text("Without Rank (Minimal)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                AIRecommenderItemCard(
                    item: sampleItems[1],
                    rank: nil,
                    configuration: .minimal,
                    action: {}
                )

                Divider()

                Text("Compact Style")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

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

    // MARK: - Integration Section

    @ViewBuilder
    private var integrationSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Integration", subtitle: "Code example")

            VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                Text("Basic Usage")
                    .font(.caption)
                    .foregroundStyle(.secondary)

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

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
            Text(title)
                .font(.title2.bold())

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
            .fill(.ultraThinMaterial)
    }

    private var codeExample: String {
        if selectedMode == .quick {
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
        } else {
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
}

// MARK: - Showcase Preset

@available(iOS 17.0, macOS 14.0, *)
private enum ShowcasePreset: String, CaseIterable, Identifiable {
    case `default`
    case restaurant
    case books
    case minimal

    var id: String { rawValue }

    var name: String {
        switch self {
        case .default: "Default"
        case .restaurant: "Restaurant"
        case .books: "Books"
        case .minimal: "Minimal"
        }
    }

    var configName: String {
        switch self {
        case .default: "default"
        case .restaurant: "restaurant"
        case .books: "books"
        case .minimal: "minimal"
        }
    }

    var description: String {
        switch self {
        case .default: "Amber accent, AI style"
        case .restaurant: "Orange accent for food apps"
        case .books: "Blue accent for reading apps"
        case .minimal: "Simplified display"
        }
    }

    var icon: String {
        switch self {
        case .default: "sparkles"
        case .restaurant: "fork.knife"
        case .books: "book.fill"
        case .minimal: "minus"
        }
    }

    var accentColor: Color {
        switch self {
        case .default: Color(red: 0.95, green: 0.75, blue: 0.3)
        case .restaurant: .orange
        case .books: .blue
        case .minimal: .gray
        }
    }

    var configuration: ARCAIRecommenderConfiguration {
        switch self {
        case .default: .default
        case .restaurant: .restaurant
        case .books: .books
        case .minimal: .minimal
        }
    }
}

// MARK: - Sample Data

@available(iOS 17.0, macOS 14.0, *)
private struct MockItem: AIRecommenderItem {
    let id: UUID
    let title: String
    let subtitle: String?
    let rating: Double?
    let imageSource: AIRecommenderImageSource?
    let aiReason: String?
}

@available(iOS 17.0, macOS 14.0, *)
extension ARCAIRecommenderShowcase {
    fileprivate var sampleItems: [MockItem] {
        [
            MockItem(
                id: UUID(),
                title: "La Tagliatella",
                subtitle: "Italiano · €€",
                rating: 8.5,
                imageSource: .system("fork.knife", color: .orange),
                aiReason: "Te encanta la cocina italiana"
            ),
            MockItem(
                id: UUID(),
                title: "Sushi Master",
                subtitle: "Japonés · €€€",
                rating: 9.2,
                imageSource: .system("fish.fill", color: .cyan),
                aiReason: "Similar a tus favoritos"
            ),
            MockItem(
                id: UUID(),
                title: "El Mexicano",
                subtitle: "Mexicano · €",
                rating: 7.8,
                imageSource: .system("flame.fill", color: .red),
                aiReason: "Muy bien valorado en tu zona"
            ),
            MockItem(
                id: UUID(),
                title: "Wok & Roll",
                subtitle: "Asiático · €€",
                rating: 8.1,
                imageSource: .system("leaf.fill", color: .green),
                aiReason: "Nuevo descubrimiento"
            )
        ]
    }

    fileprivate var sampleQuestions: [AIRecommenderQuestion] {
        [
            AIRecommenderQuestion(
                id: "preference",
                text: "¿Qué te apetece?",
                subtitle: "Selecciona una o varias opciones",
                options: [
                    .init(id: "option1", label: "Opción A", icon: "star.fill", color: .orange),
                    .init(id: "option2", label: "Opción B", icon: "heart.fill", color: .pink),
                    .init(id: "option3", label: "Opción C", icon: "bolt.fill", color: .yellow),
                    .init(id: "option4", label: "Sorpréndeme", icon: "sparkles", color: .purple)
                ],
                inputType: .multipleChoice,
                icon: "sparkles"
            ),
            AIRecommenderQuestion(
                id: "location",
                text: "¿Dónde te encuentras?",
                options: [
                    .init(id: "nearby", label: "Cerca de mí", icon: "location.fill", color: .blue),
                    .init(id: "center", label: "Centro", icon: "building.2.fill", color: .gray),
                    .init(id: "anywhere", label: "Donde sea", icon: "map.fill", color: .green)
                ],
                inputType: .singleChoice,
                icon: "location.fill"
            ),
            AIRecommenderQuestion(
                id: "budget",
                text: "¿Qué presupuesto tienes?",
                options: [
                    .init(id: "low", label: "Bajo", icon: "dollarsign", color: .green),
                    .init(id: "medium", label: "Medio", icon: "dollarsign", color: .yellow),
                    .init(id: "high", label: "Alto", icon: "dollarsign", color: .orange)
                ],
                inputType: .singleChoice,
                icon: "creditcard.fill"
            ),
            AIRecommenderQuestion(
                id: "mood",
                text: "¿Cómo te sientes?",
                subtitle: "Tu estado de ánimo influye en la recomendación",
                options: [
                    .init(id: "adventurous", label: "Aventurero", icon: "sparkles", color: .purple),
                    .init(id: "relaxed", label: "Relajado", icon: "leaf.fill", color: .green),
                    .init(id: "social", label: "Social", icon: "person.2.fill", color: .blue)
                ],
                inputType: .singleChoice,
                icon: "face.smiling.fill"
            )
        ]
    }
}

// MARK: - Previews

#Preview("Showcase - Light") {
    NavigationStack {
        ARCAIRecommenderShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    NavigationStack {
        ARCAIRecommenderShowcase()
    }
    .preferredColorScheme(.dark)
}
