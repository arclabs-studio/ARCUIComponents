//
//  ARCTextField.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - ARCTextField

/// An advanced text field with validation, floating labels, icons, and multiple visual styles
///
/// Provides outlined, filled, underlined, and glass styles with animated floating labels,
/// built-in validation with error states, leading/trailing icons, clear button, and character counting.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTextField: View {
    // MARK: - ValidationState

    /// Current validation state of the text field
    public enum ValidationState: Equatable {
        /// No validation performed yet
        case idle

        /// Validation is in progress
        case validating

        /// Validation passed
        case valid

        /// Validation failed with error message
        case invalid(String)
    }

    // MARK: - Properties

    @Binding var text: String

    let placeholder: String
    let configuration: ARCTextFieldConfiguration
    let onSubmit: (() -> Void)?

    @FocusState var isFocused: Bool
    @State var validationState: ValidationState = .idle

    // MARK: - Environment

    @Environment(\.isEnabled) var isEnabled
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Initialization

    /// Creates a text field with the specified placeholder, binding, and configuration
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text shown when empty
    ///   - text: Binding to the text value
    ///   - configuration: Text field configuration (default: .default)
    ///   - onSubmit: Action to perform on submit
    public init(
        _ placeholder: String,
        text: Binding<String>,
        configuration: ARCTextFieldConfiguration = .default,
        onSubmit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        _text = text
        self.configuration = configuration
        self.onSubmit = onSubmit
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            fieldContainer
            bottomContent
        }
        .opacity(isEnabled ? 1.0 : 0.5)
        .onChange(of: text) { _, newValue in
            handleTextChange(newValue)
        }
    }

    // MARK: - Field Container

    @ViewBuilder var fieldContainer: some View {
        ZStack(alignment: .leading) {
            backgroundView
            fieldContent
        }
        .frame(height: configuration.isMultiline ? nil : configuration.height)
        .frame(minHeight: configuration.isMultiline ? configuration.height : nil)
    }

    // MARK: - Computed Properties

    var hasFloatingLabel: Bool {
        configuration.label != nil
    }

    var shouldFloatLabel: Bool {
        isFocused || !text.isEmpty
    }

    var shouldShowClearButton: Bool {
        guard !text.isEmpty else { return false }

        switch configuration.clearButton {
        case .never:
            return false
        case .whileEditing:
            return isFocused
        case .always:
            return true
        }
    }

    var isErrorState: Bool {
        if case .invalid = validationState {
            return true
        }
        return false
    }

    var errorMessage: String? {
        if case let .invalid(message) = validationState {
            return message
        }
        return nil
    }

    var isOverCharacterLimit: Bool {
        guard let limit = configuration.characterLimit else { return false }
        return text.count > limit
    }

    var currentBorderColor: Color {
        if isErrorState {
            return configuration.errorBorderColor
        } else if case .valid = validationState {
            return configuration.successBorderColor
        } else if isFocused {
            return configuration.focusedBorderColor
        }
        return configuration.borderColor
    }

    var currentBorderWidth: CGFloat {
        isFocused || isErrorState ? configuration.focusedBorderWidth : configuration.borderWidth
    }

    var iconColor: Color {
        if isErrorState {
            return configuration.errorBorderColor
        } else if isFocused {
            return configuration.focusedBorderColor
        }
        return .secondary
    }

    var labelColor: Color {
        if isErrorState {
            return configuration.errorBorderColor
        } else if isFocused {
            return configuration.focusedBorderColor
        }
        return .secondary
    }

    var filledBackgroundColor: Color {
        if colorScheme == .dark {
            return Color.gray.opacity(0.25)
        }
        return configuration.backgroundColor != .clear ? configuration.backgroundColor : Color.gray.opacity(0.15)
    }

    // MARK: - Validation

    func handleTextChange(_ newValue: String) {
        if let limit = configuration.characterLimit, newValue.count > limit {
            text = String(newValue.prefix(limit))
            return
        }

        if configuration.validateOnChange {
            validate(newValue)
        }
    }

    func handleSubmit() {
        if configuration.validateOnSubmit {
            validate(text)
        }
        onSubmit?()
    }

    func validate(_ value: String) {
        guard let validation = configuration.validation else {
            validationState = .idle
            return
        }

        validationState = .validating

        if let error = validation.validate(value) {
            validationState = .invalid(error)
        } else {
            validationState = .valid
        }
    }

    // MARK: - Public Methods

    /// Manually triggers validation
    public func validate() {
        validate(text)
    }
}
