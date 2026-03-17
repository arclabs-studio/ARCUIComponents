//
//  AIRecommenderQuestionnaire.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Interactive questionnaire view for gathering AI recommendation preferences
///
/// Displays a series of questions with chip-based answers, following Apple HIG
/// guidelines for "teaching through interactivity" and "offering choices instead
/// of requiring text entry."
///
/// ## Features
/// - Animated question cards with smooth transitions
/// - Single and multiple choice options via chips
/// - Slider inputs for scale-based questions
/// - Progress indicator showing completion status
/// - Submit button enabled when required questions are answered
@available(iOS 17.0, macOS 14.0, *)
struct AIRecommenderQuestionnaire: View {
    // MARK: - Properties

    let questions: [AIRecommenderQuestion]
    @Binding var answers: AIRecommenderAnswers
    let configuration: ARCAIRecommenderConfiguration
    let onSubmit: ((AIRecommenderAnswers) -> Void)?

    // MARK: - Private State

    @State private var expandedQuestions: Set<String> = []
    @State private var hasAppeared = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Questions scroll view
            ScrollView {
                VStack(spacing: .arcSpacingMedium) {
                    // Progress indicator
                    progressIndicator

                    // Question cards
                    ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                        AIRecommenderQuestionCard(
                            question: question,
                            answers: $answers,
                            configuration: configuration
                        )
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(
                            .arcSpring.delay(Double(index) * 0.1),
                            value: hasAppeared
                        )
                    }
                }
                .padding(.horizontal, .arcSpacingLarge)
                .padding(.bottom, 100) // Space for submit button
            }

            // Submit button
            submitButton
        }
        .onAppear {
            arcWithAnimation(.arcSpring) {
                hasAppeared = true
            }
        }
    }

    // MARK: - Progress Indicator

    @ViewBuilder private var progressIndicator: some View {
        HStack(spacing: .arcSpacingSmall) {
            Image(systemName: "sparkles")
                .foregroundStyle(configuration.accentColor)

            Text(progressText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            // Progress dots
            HStack(spacing: 4) {
                ForEach(questions) { question in
                    Circle()
                        .fill(
                            answers.hasAnswer(for: question.id)
                                ? configuration.accentColor
                                : Color.gray.opacity(0.3)
                        )
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.vertical, .arcSpacingSmall)
    }

    private var progressText: String {
        let answered = answers.count
        let total = questions.count
        if answered == 0 {
            return "Cuéntame qué buscas"
        } else if answered == total {
            return "¡Perfecto! Listo para recomendar"
        } else {
            return "\(answered) de \(total) respondidas"
        }
    }

    // MARK: - Submit Button

    @ViewBuilder private var submitButton: some View {
        VStack(spacing: 0) {
            Divider()

            Button {
                onSubmit?(answers)
            } label: {
                HStack(spacing: .arcSpacingSmall) {
                    Image(systemName: "sparkles")
                    Text(submitButtonText)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, .arcSpacingMedium)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSubmitEnabled ? configuration.accentColor : Color.gray.opacity(0.3))
                )
                .foregroundStyle(isSubmitEnabled ? .white : .secondary)
            }
            .disabled(!isSubmitEnabled)
            .padding(.horizontal, .arcSpacingLarge)
            .padding(.vertical, .arcSpacingMedium)
            #if os(iOS)
                .background(.ultraThinMaterial)
            #else
                .background(Color(nsColor: .controlBackgroundColor))
            #endif
        }
    }

    private var isSubmitEnabled: Bool {
        // Enable if at least one answer or all required are answered
        let hasAnyAnswer = !answers.isEmpty
        let requiredAnswered = answers.isComplete(for: questions)
        return hasAnyAnswer || requiredAnswered
    }

    private var submitButtonText: String {
        if answers.isEmpty {
            "Responde al menos una pregunta"
        } else {
            "Obtener recomendaciones"
        }
    }
}

// MARK: - Preview Mock Data

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

// MARK: - Previews

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *)
#Preview("Questionnaire") {
    @Previewable @State var answers = AIRecommenderAnswers()

    NavigationStack {
        AIRecommenderQuestionnaire(
            questions: previewQuestions,
            answers: $answers,
            configuration: .default,
            onSubmit: { finalAnswers in
                print("Submitted: \(finalAnswers.toDictionary())")
            }
        )
        .navigationTitle("Preferencias")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    @Previewable @State var answers = AIRecommenderAnswers()

    NavigationStack {
        AIRecommenderQuestionnaire(
            questions: previewQuestions,
            answers: $answers,
            configuration: .default,
            onSubmit: nil
        )
        .navigationTitle("Preferencias")
        .navigationBarTitleDisplayMode(.inline)
    }
    .preferredColorScheme(.dark)
}
#endif
