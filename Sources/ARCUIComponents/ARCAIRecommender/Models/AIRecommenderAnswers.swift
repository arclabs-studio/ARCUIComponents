//
//  AIRecommenderAnswers.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import Foundation

/// Collection of user answers from the AI recommendation questionnaire
///
/// Use this to access user responses and build AI prompts or filter recommendations.
///
/// ## Example
///
/// ```swift
/// @State private var answers = AIRecommenderAnswers()
///
/// // In your view
/// ARCAIRecommender(
///     mode: .questionnaire(questions: questions),
///     answers: $answers,
///     ...
/// )
///
/// // After questionnaire completion
/// func buildPrompt() -> String {
///     var prompt = "Recommend restaurants where: "
///     if let cuisine = answers.selectedOptions(for: "craving").first {
///         prompt += "cuisine is \(cuisine), "
///     }
///     if let budget = answers.selectedOptions(for: "budget").first {
///         prompt += "price range is \(budget)"
///     }
///     return prompt
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct AIRecommenderAnswers: Sendable, Equatable {
    // MARK: - Properties

    /// Dictionary mapping question IDs to selected option IDs
    private var selections: [String: Set<String>]

    /// Dictionary mapping question IDs to slider values (0.0 to 1.0)
    private var sliderValues: [String: Double]

    // MARK: - Initialization

    public init() {
        selections = [:]
        sliderValues = [:]
    }

    // MARK: - Selection Methods

    /// Gets selected option IDs for a question
    /// - Parameter questionId: The question identifier
    /// - Returns: Array of selected option IDs
    public func selectedOptions(for questionId: String) -> [String] {
        Array(selections[questionId] ?? [])
    }

    /// Checks if an option is selected for a question
    /// - Parameters:
    ///   - optionId: The option identifier
    ///   - questionId: The question identifier
    /// - Returns: True if the option is selected
    public func isSelected(_ optionId: String, for questionId: String) -> Bool {
        selections[questionId]?.contains(optionId) ?? false
    }

    /// Sets a single selection for a question (replaces existing)
    /// - Parameters:
    ///   - optionId: The option identifier to select
    ///   - questionId: The question identifier
    public mutating func selectSingle(_ optionId: String, for questionId: String) {
        selections[questionId] = [optionId]
    }

    /// Toggles an option selection for multiple choice questions
    /// - Parameters:
    ///   - optionId: The option identifier to toggle
    ///   - questionId: The question identifier
    public mutating func toggleSelection(_ optionId: String, for questionId: String) {
        var current = selections[questionId] ?? []
        if current.contains(optionId) {
            current.remove(optionId)
        } else {
            current.insert(optionId)
        }
        selections[questionId] = current
    }

    /// Clears all selections for a question
    /// - Parameter questionId: The question identifier
    public mutating func clearSelections(for questionId: String) {
        selections.removeValue(forKey: questionId)
    }

    // MARK: - Slider Methods

    /// Gets the slider value for a question
    /// - Parameter questionId: The question identifier
    /// - Returns: Slider value (0.0 to 1.0) or nil if not set
    public func sliderValue(for questionId: String) -> Double? {
        sliderValues[questionId]
    }

    /// Sets the slider value for a question
    /// - Parameters:
    ///   - value: The slider value (0.0 to 1.0)
    ///   - questionId: The question identifier
    public mutating func setSliderValue(_ value: Double, for questionId: String) {
        sliderValues[questionId] = max(0, min(1, value))
    }

    // MARK: - Utility Methods

    /// Checks if any answer exists for a question
    /// - Parameter questionId: The question identifier
    /// - Returns: True if the question has any answer
    public func hasAnswer(for questionId: String) -> Bool {
        if let selected = selections[questionId], !selected.isEmpty {
            return true
        }
        return sliderValues[questionId] != nil
    }

    /// Checks if all required questions have answers
    /// - Parameter questions: Array of questions to check
    /// - Returns: True if all required questions are answered
    public func isComplete(for questions: [AIRecommenderQuestion]) -> Bool {
        questions.filter(\.isRequired).allSatisfy { hasAnswer(for: $0.id) }
    }

    /// Gets all question IDs that have answers
    public var answeredQuestionIds: [String] {
        var ids = Set(selections.keys)
        ids.formUnion(sliderValues.keys)
        return Array(ids)
    }

    /// Clears all answers
    public mutating func reset() {
        selections = [:]
        sliderValues = [:]
    }

    /// Total number of questions answered
    public var count: Int {
        var ids = Set(selections.keys.filter { !(selections[$0]?.isEmpty ?? true) })
        ids.formUnion(sliderValues.keys)
        return ids.count
    }

    /// Whether no questions have been answered
    public var isEmpty: Bool {
        let hasSelections = selections.values.contains { !$0.isEmpty }
        return !hasSelections && sliderValues.isEmpty
    }

    // MARK: - Export

    /// Exports answers as a dictionary for prompt building
    /// - Returns: Dictionary with question IDs as keys and answer descriptions as values
    public func toDictionary() -> [String: Any] {
        var result: [String: Any] = [:]

        for (questionId, optionIds) in selections where !optionIds.isEmpty {
            result[questionId] = Array(optionIds)
        }

        for (questionId, value) in sliderValues {
            result[questionId] = value
        }

        return result
    }
}
