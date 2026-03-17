//
//  ARCAIRecommender+Previews.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - Preview Mock Data

@available(iOS 17.0, macOS 14.0, *)
private struct MockRecommendation: AIRecommenderItem {
    let id: UUID
    let title: String
    let subtitle: String?
    let rating: Double?
    let imageSource: AIRecommenderImageSource?
    let aiReason: String?
}

@available(iOS 17.0, macOS 14.0, *)
private let previewQuestions: [AIRecommenderQuestion] = [
    AIRecommenderQuestion(
        id: "preferences",
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
    )
]

// MARK: - Previews

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *)
#Preview("AI Recommender - Quick Mode") {
    @Previewable @State var selected: AIRecommenderCategory = .favorites

    let items: [MockRecommendation] = [
        MockRecommendation(
            id: UUID(),
            title: "Item 1",
            subtitle: "Categoría · €€",
            rating: 8.5,
            imageSource: .system("star.fill", color: .orange),
            aiReason: "Basado en tus preferencias"
        ),
        MockRecommendation(
            id: UUID(),
            title: "Item 2",
            subtitle: "Categoría · €€€",
            rating: 9.2,
            imageSource: .system("heart.fill", color: .pink),
            aiReason: "Similar a tus favoritos"
        )
    ]

    NavigationStack {
        ARCAIRecommender(
            selectedCategory: $selected,
            items: items
        )
        .navigationTitle("Recomendaciones")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("AI Recommender - Questionnaire Mode") {
    @Previewable @State var answers = AIRecommenderAnswers()

    NavigationStack {
        ARCAIRecommender<MockRecommendation>(
            questions: previewQuestions,
            answers: $answers,
            configuration: .default
        ) { finalAnswers in
            print("Submitted: \(finalAnswers.toDictionary())")
        }
        .navigationTitle("Preferencias")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("AI Recommender - Dual Mode") {
    @Previewable @State var mode: AIRecommenderMode = .quick
    @Previewable @State var selected: AIRecommenderCategory = .favorites
    @Previewable @State var answers = AIRecommenderAnswers()

    let items: [MockRecommendation] = [
        MockRecommendation(
            id: UUID(),
            title: "Item 1",
            subtitle: "Categoría · €€",
            rating: 8.5,
            imageSource: .system("star.fill", color: .orange),
            aiReason: "Basado en tus preferencias"
        )
    ]

    NavigationStack {
        ARCAIRecommender(
            mode: $mode,
            selectedCategory: $selected,
            questions: previewQuestions,
            answers: $answers,
            items: items,
            configuration: .default
        )
        .navigationTitle("Recomendaciones")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("AI Recommender - Dark Mode") {
    @Previewable @State var mode: AIRecommenderMode = .questionnaire
    @Previewable @State var selected: AIRecommenderCategory = .favorites
    @Previewable @State var answers = AIRecommenderAnswers()

    NavigationStack {
        ARCAIRecommender<MockRecommendation>(
            mode: $mode,
            selectedCategory: $selected,
            questions: previewQuestions,
            answers: $answers,
            items: [],
            configuration: .default
        )
        .navigationTitle("Recomendaciones")
        .navigationBarTitleDisplayMode(.inline)
    }
    .preferredColorScheme(.dark)
}
#endif
