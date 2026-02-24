//
//  ARCAIRecommenderDemoScreen.swift
//  ARCUIComponentsDemoApp
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen showing ARCAIRecommender in action with both modes
struct ARCAIRecommenderDemoScreen: View {
    // MARK: - State

    @State private var mode: AIRecommenderMode = .quick
    @State private var selectedCategory: AIRecommenderCategory = .favorites
    @State private var questionnaireAnswers = AIRecommenderAnswers()
    @State private var selectedItem: MockRecommendation?
    @State private var showingDetail = false
    @State private var showingAnswers = false

    // MARK: - Body

    var body: some View {
        ARCAIRecommender(mode: $mode,
                         categories: AIRecommenderCategory.defaultCategories,
                         selectedCategory: $selectedCategory,
                         questions: Self.demoQuestions,
                         answers: $questionnaireAnswers,
                         items: itemsForCategory(selectedCategory),
                         configuration: .default)
        { category in
            // Category changed - in a real app, fetch new data
            print("Selected category: \(category.label)")
        } onItemSelected: { item in
            selectedItem = item
            showingDetail = true
        } onQuestionnaireSubmit: { answers in
            print("Questionnaire submitted: \(answers.toDictionary())")
            showingAnswers = true
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Recomendador IA")
                    .font(.headline)
                    .bold()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        questionnaireAnswers.reset()
                    } label: {
                        Label("Reiniciar respuestas", systemImage: "arrow.counterclockwise")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Seleccionado",
               isPresented: $showingDetail)
        {
            Button("OK") {}
        } message: {
            if let item = selectedItem {
                Text("Has seleccionado: \(item.title)")
            }
        }
        .alert("Respuestas recibidas",
               isPresented: $showingAnswers)
        {
            Button("OK") {}
            } message: {
                Text(answersReceivedMessage)
            }
    }

    // MARK: - Private

    private var answersReceivedMessage: String {
        """
        Se han recibido \(questionnaireAnswers.count) respuestas.

        En una app real, estas se usarían para generar un prompt de IA.
        """
    }

    private func itemsForCategory(_ category: AIRecommenderCategory) -> [MockRecommendation] {
        switch category {
        case .favorites: Self.favoritesItems
        case .trending: Self.trendingItems
        case .nearYou: Self.nearYouItems
        case .new: Self.newItems
        case .custom: []
        }
    }
}

// MARK: - Mock Data Model

private struct MockRecommendation: AIRecommenderItem {
    let id: UUID
    let title: String
    let subtitle: String?
    let rating: Double?
    let imageSource: AIRecommenderImageSource?
    let aiReason: String?
    let location: String?
    let highlightDetail: String?
}

// MARK: - Sample Data

extension ARCAIRecommenderDemoScreen {
    fileprivate static var favoritesItems: [MockRecommendation] {
        [MockRecommendation(id: UUID(),
                            title: "Mercado Nishiki",
                            subtitle: "Japonesa · $",
                            rating: 9.1,
                            imageSource: .system("fish.fill", color: .cyan),
                            aiReason: "Tu opcion perfecta",
                            location: "Malasana, Madrid \u{00B7} 0.3 km",
                            highlightDetail: "Omakase del chef"),
         MockRecommendation(id: UUID(),
                            title: "La Tagliatella",
                            subtitle: "Italiano · €€",
                            rating: 8.5,
                            imageSource: .system("fork.knife", color: .orange),
                            aiReason: "Te encanta la cocina italiana",
                            location: "Centro, Madrid \u{00B7} 0.5 km",
                            highlightDetail: "Pasta Carbonara"),
         MockRecommendation(id: UUID(),
                            title: "Pizzeria Napoli",
                            subtitle: "Italiano · €€",
                            rating: 8.9,
                            imageSource: .system("flame.fill", color: .red),
                            aiReason: "Basado en tus preferencias",
                            location: "Chamberi, Madrid \u{00B7} 1.1 km",
                            highlightDetail: "Pizza Margherita")]
    }

    fileprivate static var trendingItems: [MockRecommendation] {
        [MockRecommendation(id: UUID(),
                            title: "Burger Lab",
                            subtitle: "Americana · €€",
                            rating: 9.1,
                            imageSource: .system("flame.fill", color: .orange),
                            aiReason: "En tendencia esta semana",
                            location: "Chueca, Madrid \u{00B7} 0.7 km",
                            highlightDetail: "Smash Burger doble"),
         MockRecommendation(id: UUID(),
                            title: "Taco Loco",
                            subtitle: "Mexicano · €",
                            rating: 8.7,
                            imageSource: .system("leaf.fill", color: .green),
                            aiReason: "Muy popular en tu zona",
                            location: "Lavapies, Madrid \u{00B7} 0.4 km",
                            highlightDetail: "Tacos al Pastor"),
         MockRecommendation(id: UUID(),
                            title: "Ramen Ichiban",
                            subtitle: "Japones · €€",
                            rating: 8.8,
                            imageSource: .system("cup.and.saucer.fill", color: .brown),
                            aiReason: "Subiendo en popularidad",
                            location: "Sol, Madrid \u{00B7} 0.9 km",
                            highlightDetail: "Tonkotsu Ramen")]
    }

    fileprivate static var nearYouItems: [MockRecommendation] {
        [MockRecommendation(id: UUID(),
                            title: "Cafe del Barrio",
                            subtitle: "Cafeteria · €",
                            rating: 8.3,
                            imageSource: .system("cup.and.saucer.fill", color: .brown),
                            aiReason: "A 200m de ti",
                            location: "Tu barrio \u{00B7} 0.2 km",
                            highlightDetail: "Tostada con tomate"),
         MockRecommendation(id: UUID(),
                            title: "El Rincon Castizo",
                            subtitle: "Espanol · €€",
                            rating: 8.8,
                            imageSource: .system("mappin.and.ellipse", color: .red),
                            aiReason: "El mejor valorado cerca de ti",
                            location: "Tu barrio \u{00B7} 0.35 km",
                            highlightDetail: "Croquetas caseras"),
         MockRecommendation(id: UUID(),
                            title: "Wok & Roll",
                            subtitle: "Asiatico · €€",
                            rating: 8.1,
                            imageSource: .system("wok.fill", color: .orange),
                            aiReason: "Nuevo descubrimiento en tu barrio",
                            location: "Tu barrio \u{00B7} 0.5 km",
                            highlightDetail: nil)]
    }

    fileprivate static var newItems: [MockRecommendation] {
        [MockRecommendation(id: UUID(),
                            title: "Poke Paradise",
                            subtitle: "Hawaiano · €€",
                            rating: 8.0,
                            imageSource: .system("leaf.fill", color: .purple),
                            aiReason: "Nuevo en la zona",
                            location: "Arguelles, Madrid \u{00B7} 1.3 km",
                            highlightDetail: "Poke de salmon"),
         MockRecommendation(id: UUID(),
                            title: "Thai Garden",
                            subtitle: "Tailandes · €€",
                            rating: 7.9,
                            imageSource: .system("leaf.fill", color: .green),
                            aiReason: "Abierto hace 2 semanas",
                            location: "Retiro, Madrid \u{00B7} 1.8 km",
                            highlightDetail: "Pad Thai"),
         MockRecommendation(id: UUID(),
                            title: "Brunch & Co",
                            subtitle: "Internacional · €€€",
                            rating: 8.4,
                            imageSource: .system("sun.max.fill", color: .yellow),
                            aiReason: "Perfecto para tu estilo",
                            location: "Salamanca, Madrid \u{00B7} 2.0 km",
                            highlightDetail: "Eggs Benedict")]
    }
}

// MARK: - Demo Questions

extension ARCAIRecommenderDemoScreen {
    // swiftlint:disable:next function_body_length
    static let demoQuestions: [AIRecommenderQuestion] = [AIRecommenderQuestion(id: "preferences",
                                                                               text: "¿Qué te apetece?",
                                                                               subtitle: "Selecciona una o varias opciones",
                                                                               options: [.init(id: "option1",
                                                                                               label: "Opción A",
                                                                                               icon: "star.fill",
                                                                                               color: .orange),
                                                                                         .init(id: "option2",
                                                                                               label: "Opción B",
                                                                                               icon: "heart.fill",
                                                                                               color: .pink),
                                                                                         .init(id: "option3",
                                                                                               label: "Opción C",
                                                                                               icon: "bolt.fill",
                                                                                               color: .yellow),
                                                                                         .init(id: "option4",
                                                                                               label: "Sorpréndeme",
                                                                                               icon: "sparkles",
                                                                                               color: .purple)],
                                                                               inputType: .multipleChoice,
                                                                               icon: "sparkles"),
                                                         AIRecommenderQuestion(id: "location",
                                                                               text: "¿Dónde te encuentras?",
                                                                               options: [.init(id: "nearby",
                                                                                               label: "Cerca de mí",
                                                                                               icon: "location.fill",
                                                                                               color: .blue),
                                                                                         .init(id: "center",
                                                                                               label: "Centro",
                                                                                               icon: "building.2.fill",
                                                                                               color: .gray),
                                                                                         .init(id: "anywhere",
                                                                                               label: "Donde sea",
                                                                                               icon: "map.fill",
                                                                                               color: .green)],
                                                                               inputType: .singleChoice,
                                                                               icon: "location.fill"),
                                                         AIRecommenderQuestion(id: "budget",
                                                                               text: "¿Qué presupuesto tienes?",
                                                                               options: [.init(id: "low", label: "Bajo",
                                                                                               icon: "dollarsign",
                                                                                               color: .green),
                                                                                         .init(id: "medium",
                                                                                               label: "Medio",
                                                                                               icon: "dollarsign",
                                                                                               color: .yellow),
                                                                                         .init(id: "high",
                                                                                               label: "Alto",
                                                                                               icon: "dollarsign",
                                                                                               color: .orange)],
                                                                               inputType: .singleChoice,
                                                                               icon: "creditcard.fill"),
                                                         AIRecommenderQuestion(id: "mood",
                                                                               text: "¿Cómo te sientes?",
                                                                               subtitle: "Tu estado de ánimo influye en la recomendación",
                                                                               options: [.init(id: "adventurous",
                                                                                               label: "Aventurero",
                                                                                               icon: "sparkles",
                                                                                               color: .purple),
                                                                                         .init(id: "relaxed",
                                                                                               label: "Relajado",
                                                                                               icon: "leaf.fill",
                                                                                               color: .green),
                                                                                         .init(id: "social",
                                                                                               label: "Social",
                                                                                               icon: "person.2.fill",
                                                                                               color: .blue)],
                                                                               inputType: .singleChoice,
                                                                               icon: "face.smiling.fill")]
}

// MARK: - Previews

#Preview("Demo Screen") {
    NavigationStack {
        ARCAIRecommenderDemoScreen()
    }
}

#Preview("Demo Screen - Dark") {
    NavigationStack {
        ARCAIRecommenderDemoScreen()
    }
    .preferredColorScheme(.dark)
}
