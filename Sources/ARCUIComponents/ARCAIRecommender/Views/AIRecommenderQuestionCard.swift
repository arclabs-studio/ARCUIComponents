//
//  AIRecommenderQuestionCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Card view for displaying a single question with selectable options
///
/// Supports single choice (chips), multiple choice (toggleable chips), and slider inputs.
/// Uses interactive chip-based selection following Apple HIG guidelines.
@available(iOS 17.0, macOS 14.0, *)
struct AIRecommenderQuestionCard: View {
    // MARK: - Properties

    let question: AIRecommenderQuestion
    @Binding var answers: AIRecommenderAnswers
    let configuration: ARCAIRecommenderConfiguration

    // MARK: - Private State

    @State private var sliderValue: Double = 0.5

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            // Question header
            questionHeader

            // Answer options based on input type
            answerSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.arcSpacingLarge)
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .onAppear {
            // Initialize slider value if exists
            if let existing = answers.sliderValue(for: question.id) {
                sliderValue = existing
            }
        }
    }

    // MARK: - Question Header

    @ViewBuilder private var questionHeader: some View {
        VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
            HStack(spacing: .arcSpacingSmall) {
                if let icon = question.icon {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(configuration.accentColor)
                }

                Text(question.text)
                    .font(.headline)
                    .fontWeight(.semibold)

                if question.isRequired {
                    Text("*")
                        .foregroundStyle(.red)
                }
            }

            if let subtitle = question.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Answer Section

    @ViewBuilder private var answerSection: some View {
        switch question.inputType {
        case .singleChoice:
            singleChoiceOptions
        case .multipleChoice:
            multipleChoiceOptions
        case .slider:
            sliderOption
        }
    }

    // MARK: - Single Choice

    @ViewBuilder private var singleChoiceOptions: some View {
        QuestionFlowLayout(spacing: .arcSpacingSmall) {
            ForEach(question.options) { option in
                OptionChip(
                    option: option,
                    isSelected: answers.isSelected(option.id, for: question.id),
                    configuration: configuration
                ) {
                    arcWithAnimation(configuration.categoryAnimation) {
                        answers.selectSingle(option.id, for: question.id)
                    }
                }
            }
        }
    }

    // MARK: - Multiple Choice

    @ViewBuilder private var multipleChoiceOptions: some View {
        QuestionFlowLayout(spacing: .arcSpacingSmall) {
            ForEach(question.options) { option in
                OptionChip(
                    option: option,
                    isSelected: answers.isSelected(option.id, for: question.id),
                    configuration: configuration
                ) {
                    arcWithAnimation(configuration.categoryAnimation) {
                        answers.toggleSelection(option.id, for: question.id)
                    }
                }
            }
        }
    }

    // MARK: - Slider

    @ViewBuilder private var sliderOption: some View {
        VStack(spacing: .arcSpacingSmall) {
            // Slider with labels
            HStack {
                if let first = question.options.first {
                    VStack {
                        if let icon = first.icon {
                            Image(systemName: icon)
                                .font(.title3)
                        }
                        Text(first.label)
                            .font(.caption)
                    }
                    .foregroundStyle(sliderValue < 0.33 ? configuration.accentColor : .secondary)
                }

                Slider(value: $sliderValue)
                    .tint(configuration.accentColor)
                    .onChange(of: sliderValue) { _, newValue in
                        answers.setSliderValue(newValue, for: question.id)
                    }

                if let last = question.options.last {
                    VStack {
                        if let icon = last.icon {
                            Image(systemName: icon)
                                .font(.title3)
                        }
                        Text(last.label)
                            .font(.caption)
                    }
                    .foregroundStyle(sliderValue > 0.66 ? configuration.accentColor : .secondary)
                }
            }

            // Middle option label if exists
            if question.options.count > 2,
               let middle = question.options[safe: question.options.count / 2]
            {
                Text(middle.label)
                    .font(.caption)
                    .foregroundStyle(
                        (sliderValue >= 0.33 && sliderValue <= 0.66)
                            ? configuration.accentColor
                            : .secondary
                    )
            }
        }
    }
}

// MARK: - Option Chip

@available(iOS 17.0, macOS 14.0, *)
private struct OptionChip: View {
    let option: AIRecommenderQuestion.Option
    let isSelected: Bool
    let configuration: ARCAIRecommenderConfiguration
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(isSelected ? .white : (option.color ?? configuration.accentColor))
                }

                Text(option.label)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal, .arcSpacingMedium)
            .padding(.vertical, .arcSpacingSmall)
            .background(
                Capsule()
                    .fill(
                        isSelected
                            ? (option.color ?? configuration.accentColor)
                            : Color.gray.opacity(0.15)
                    )
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.label)
        .accessibilityHint(option.description ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Question Flow Layout

@available(iOS 17.0, macOS 14.0, *)
private struct QuestionFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)

        for (index, placement) in result.placements.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + placement.origin.x, y: bounds.minY + placement.origin.y),
                proposal: ProposedViewSize(placement.size)
            )
        }
    }

    private func arrangeSubviews(
        proposal: ProposedViewSize,
        subviews: Subviews
    ) -> (size: CGSize, placements: [ViewPlacement]) {
        let maxWidth = proposal.width ?? .infinity
        var placements: [ViewPlacement] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth, currentX > 0 {
                // Move to next line
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            placements.append(ViewPlacement(origin: CGPoint(x: currentX, y: currentY), size: size))

            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            totalHeight = currentY + lineHeight
        }

        // Use the full proposed width to ensure consistent card widths
        let finalWidth = proposal.width ?? currentX - spacing
        return (CGSize(width: finalWidth, height: totalHeight), placements)
    }
}

/// Placement data for a view in the flow layout
private struct ViewPlacement {
    let origin: CGPoint
    let size: CGSize
}

// MARK: - Safe Array Access

extension Array {
    fileprivate subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview Mock Data

@available(iOS 17.0, macOS 14.0, *)
private enum PreviewQuestions {
    static let singleChoice = AIRecommenderQuestion(
        id: "location",
        text: "¿Dónde te encuentras?",
        options: [
            .init(id: "nearby", label: "Cerca de mí", icon: "location.fill", color: .blue),
            .init(id: "center", label: "Centro", icon: "building.2.fill", color: .gray),
            .init(id: "anywhere", label: "Donde sea", icon: "map.fill", color: .green)
        ],
        inputType: .singleChoice,
        icon: "location.fill"
    )

    static let multipleChoice = AIRecommenderQuestion(
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
    )

    static let slider = AIRecommenderQuestion(
        id: "intensity",
        text: "¿Qué intensidad prefieres?",
        options: [
            .init(id: "low", label: "Suave", icon: "leaf.fill"),
            .init(id: "medium", label: "Media", icon: "circle.fill"),
            .init(id: "high", label: "Intensa", icon: "flame.fill")
        ],
        inputType: .slider,
        icon: "slider.horizontal.3"
    )

    static let mood = AIRecommenderQuestion(
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
}

// MARK: - Previews

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *)
#Preview("Single Choice") {
    @Previewable @State var answers = AIRecommenderAnswers()

    AIRecommenderQuestionCard(
        question: PreviewQuestions.singleChoice,
        answers: $answers,
        configuration: .default
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Multiple Choice") {
    @Previewable @State var answers = AIRecommenderAnswers()

    AIRecommenderQuestionCard(
        question: PreviewQuestions.multipleChoice,
        answers: $answers,
        configuration: .default
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Slider") {
    @Previewable @State var answers = AIRecommenderAnswers()

    AIRecommenderQuestionCard(
        question: PreviewQuestions.slider,
        answers: $answers,
        configuration: .default
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    @Previewable @State var answers = AIRecommenderAnswers()

    AIRecommenderQuestionCard(
        question: PreviewQuestions.mood,
        answers: $answers,
        configuration: .default
    )
    .padding()
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
#endif
