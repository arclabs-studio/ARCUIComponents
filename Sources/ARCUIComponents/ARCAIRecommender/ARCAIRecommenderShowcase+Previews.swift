//
//  ARCAIRecommenderShowcase+Previews.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - Showcase Preset

@available(iOS 17.0, macOS 14.0, *)
enum ShowcasePreset: String, CaseIterable, Identifiable {
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
struct ShowcaseMockItem: AIRecommenderItem {
    let id: UUID
    let title: String
    let subtitle: String?
    let rating: Double?
    let imageSource: AIRecommenderImageSource?
    let aiReason: String?
}

@available(iOS 17.0, macOS 14.0, *)
extension ARCAIRecommenderShowcase {
    var sampleItems: [ShowcaseMockItem] {
        [
            ShowcaseMockItem(
                id: UUID(),
                title: "La Tagliatella",
                subtitle: "Italiano · €€",
                rating: 8.5,
                imageSource: .system("fork.knife", color: .orange),
                aiReason: "Te encanta la cocina italiana"
            ),
            ShowcaseMockItem(
                id: UUID(),
                title: "Sushi Master",
                subtitle: "Japonés · €€€",
                rating: 9.2,
                imageSource: .system("fish.fill", color: .cyan),
                aiReason: "Similar a tus favoritos"
            ),
            ShowcaseMockItem(
                id: UUID(),
                title: "El Mexicano",
                subtitle: "Mexicano · €",
                rating: 7.8,
                imageSource: .system("flame.fill", color: .red),
                aiReason: "Muy bien valorado en tu zona"
            ),
            ShowcaseMockItem(
                id: UUID(),
                title: "Wok & Roll",
                subtitle: "Asiático · €€",
                rating: 8.1,
                imageSource: .system("leaf.fill", color: .green),
                aiReason: "Nuevo descubrimiento"
            )
        ]
    }

    var sampleQuestions: [AIRecommenderQuestion] {
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
