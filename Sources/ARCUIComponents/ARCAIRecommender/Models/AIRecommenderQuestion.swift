//
//  AIRecommenderQuestion.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import SwiftUI

/// A question for the AI recommendation questionnaire
///
/// Questions can have different input types (single choice, multiple choice, slider)
/// and are used to gather user preferences for generating AI recommendations.
///
/// ## Example
///
/// ```swift
/// let moodQuestion = AIRecommenderQuestion(
///     id: "mood",
///     text: "¿Cómo te sientes hoy?",
///     subtitle: "Selecciona tu estado de ánimo",
///     options: [
///         .init(id: "adventurous", label: "Aventurero", icon: "sparkles"),
///         .init(id: "relaxed", label: "Relajado", icon: "leaf.fill"),
///         .init(id: "social", label: "Social", icon: "person.2.fill"),
///         .init(id: "romantic", label: "Romántico", icon: "heart.fill")
///     ],
///     inputType: .singleChoice
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct AIRecommenderQuestion: Identifiable, Sendable, Equatable, Hashable {
    // MARK: - Properties

    /// Unique identifier for the question
    public let id: String

    /// Main question text
    public let text: String

    /// Optional subtitle or hint
    public let subtitle: String?

    /// Available answer options
    public let options: [Option]

    /// Type of input expected
    public let inputType: InputType

    /// Whether this question is required
    public let isRequired: Bool

    /// Optional SF Symbol icon for the question
    public let icon: String?

    // MARK: - Initialization

    public init(
        id: String,
        text: String,
        subtitle: String? = nil,
        options: [Option],
        inputType: InputType = .singleChoice,
        isRequired: Bool = false,
        icon: String? = nil
    ) {
        self.id = id
        self.text = text
        self.subtitle = subtitle
        self.options = options
        self.inputType = inputType
        self.isRequired = isRequired
        self.icon = icon
    }
}

// MARK: - Input Type

@available(iOS 17.0, macOS 14.0, *)
extension AIRecommenderQuestion {
    /// The type of input for a question
    public enum InputType: String, Sendable, Equatable, Hashable {
        /// User selects exactly one option
        case singleChoice

        /// User can select multiple options
        case multipleChoice

        /// User selects a value on a scale (uses first two options as min/max labels)
        case slider
    }
}

// MARK: - Option

@available(iOS 17.0, macOS 14.0, *)
extension AIRecommenderQuestion {
    /// An answer option for a question
    public struct Option: Identifiable, Sendable, Equatable, Hashable {
        /// Unique identifier for the option
        public let id: String

        /// Display label
        public let label: String

        /// Optional SF Symbol icon
        public let icon: String?

        /// Optional description or hint
        public let description: String?

        /// Optional color for visual styling
        public let color: Color?

        public init(
            id: String,
            label: String,
            icon: String? = nil,
            description: String? = nil,
            color: Color? = nil
        ) {
            self.id = id
            self.label = label
            self.icon = icon
            self.description = description
            self.color = color
        }
    }
}
