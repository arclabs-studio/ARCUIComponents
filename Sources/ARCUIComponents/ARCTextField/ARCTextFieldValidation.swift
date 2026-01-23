//
//  ARCTextFieldValidation.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import Foundation

// MARK: - ARCTextFieldValidation

/// Validation configuration for ARCTextField with built-in and custom rules
///
/// `ARCTextFieldValidation` provides a flexible system for validating text input
/// with support for multiple rules, different validation modes, and localized error messages.
///
/// ## Overview
///
/// Per Apple HIG: "Validate fields when it makes sense. The appropriate time to check
/// the data depends on the context: when entering an email address, it's best to validate
/// when people switch to another field."
///
/// ## Topics
///
/// ### Validation Mode
///
/// - ``ValidationMode-swift.enum``
///
/// ### Validation Rules
///
/// - ``ValidationRule``
///
/// ### Built-in Rules
///
/// - ``required(_:)``
/// - ``minLength(_:message:)``
/// - ``maxLength(_:message:)``
/// - ``email(_:)``
/// - ``regex(_:message:)``
/// - ``custom(_:message:)``
///
/// ### Presets
///
/// - ``email``
/// - ``password``
/// - ``required``
///
/// ## Usage
///
/// ```swift
/// // Using a preset
/// ARCTextField("Email", text: $email, configuration: .init(validation: .email))
///
/// // Custom validation
/// let validation = ARCTextFieldValidation(
///     rules: [
///         .required("Username is required"),
///         .minLength(3, message: "At least 3 characters"),
///         .regex("^[a-zA-Z0-9_]+$", message: "Letters, numbers, and underscore only")
///     ],
///     mode: .all
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTextFieldValidation: Sendable {
    // MARK: - ValidationMode

    /// Mode for combining multiple validation rules
    public enum ValidationMode: Sendable {
        /// All rules must pass for validation to succeed
        case all

        /// At least one rule must pass for validation to succeed
        case any
    }

    // MARK: - ValidationRule

    /// A single validation rule with a validation function and error message
    public struct ValidationRule: Sendable {
        /// The validation function that returns true if the value is valid
        let validate: @Sendable (String) -> Bool

        /// The error message to display when validation fails
        public let errorMessage: String

        /// Creates a validation rule with a custom validation function
        ///
        /// - Parameters:
        ///   - errorMessage: The error message to display when validation fails
        ///   - validate: A closure that returns true if the input is valid
        public init(
            errorMessage: String,
            validate: @escaping @Sendable (String) -> Bool
        ) {
            self.errorMessage = errorMessage
            self.validate = validate
        }
    }

    // MARK: - Properties

    /// The validation rules to apply
    public let rules: [ValidationRule]

    /// The mode for combining multiple rules
    public let mode: ValidationMode

    // MARK: - Initialization

    /// Creates a validation configuration with the specified rules and mode
    ///
    /// - Parameters:
    ///   - rules: The validation rules to apply
    ///   - mode: How to combine multiple rules (default: .all)
    public init(
        rules: [ValidationRule],
        mode: ValidationMode = .all
    ) {
        self.rules = rules
        self.mode = mode
    }

    // MARK: - Validation

    /// Validates the given value against all rules
    ///
    /// - Parameter value: The string value to validate
    /// - Returns: The first error message if validation fails, nil if valid
    public func validate(_ value: String) -> String? {
        switch mode {
        case .all:
            if let failedRule = rules.first(where: { !$0.validate(value) }) {
                return failedRule.errorMessage
            }
            return nil

        case .any:
            for rule in rules where rule.validate(value) {
                return nil
            }
            return rules.first?.errorMessage
        }
    }

    /// Returns whether the given value is valid
    ///
    /// - Parameter value: The string value to validate
    /// - Returns: True if the value passes validation
    public func isValid(_ value: String) -> Bool {
        validate(value) == nil
    }
}

// MARK: - Built-in Rules

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextFieldValidation {
    /// Creates a rule requiring the field to have a non-empty value
    ///
    /// - Parameter message: The error message (default: "This field is required")
    /// - Returns: A validation rule
    public static func required(_ message: String = "This field is required") -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    /// Creates a rule requiring a minimum character length
    ///
    /// - Parameters:
    ///   - length: The minimum number of characters
    ///   - message: Custom error message (default: auto-generated)
    /// - Returns: A validation rule
    public static func minLength(_ length: Int, message: String? = nil) -> ValidationRule {
        let errorMessage = message ?? "Must be at least \(length) characters"
        return ValidationRule(errorMessage: errorMessage) { value in
            value.count >= length
        }
    }

    /// Creates a rule requiring a maximum character length
    ///
    /// - Parameters:
    ///   - length: The maximum number of characters
    ///   - message: Custom error message (default: auto-generated)
    /// - Returns: A validation rule
    public static func maxLength(_ length: Int, message: String? = nil) -> ValidationRule {
        let errorMessage = message ?? "Must be no more than \(length) characters"
        return ValidationRule(errorMessage: errorMessage) { value in
            value.count <= length
        }
    }

    /// Creates a rule validating email format
    ///
    /// - Parameter message: The error message (default: "Invalid email address")
    /// - Returns: A validation rule
    public static func email(_ message: String = "Invalid email address") -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            guard !value.isEmpty else { return true }
            let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            return value.range(of: emailRegex, options: .regularExpression) != nil
        }
    }

    /// Creates a rule validating against a regular expression pattern
    ///
    /// - Parameters:
    ///   - pattern: The regex pattern to match
    ///   - message: The error message when pattern doesn't match
    /// - Returns: A validation rule
    public static func regex(_ pattern: String, message: String) -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            guard !value.isEmpty else { return true }
            return value.range(of: pattern, options: .regularExpression) != nil
        }
    }

    /// Creates a rule with a custom validation closure
    ///
    /// - Parameters:
    ///   - validate: Custom validation function
    ///   - message: The error message when validation fails
    /// - Returns: A validation rule
    public static func custom(
        _ validate: @escaping @Sendable (String) -> Bool,
        message: String
    ) -> ValidationRule {
        ValidationRule(errorMessage: message, validate: validate)
    }

    /// Creates a rule validating phone number format
    ///
    /// - Parameter message: The error message (default: "Invalid phone number")
    /// - Returns: A validation rule
    public static func phone(_ message: String = "Invalid phone number") -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            guard !value.isEmpty else { return true }
            let digitsOnly = value.filter(\.isNumber)
            return digitsOnly.count >= 10 && digitsOnly.count <= 15
        }
    }

    /// Creates a rule validating URL format
    ///
    /// - Parameter message: The error message (default: "Invalid URL")
    /// - Returns: A validation rule
    public static func url(_ message: String = "Invalid URL") -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            guard !value.isEmpty else { return true }
            guard let url = URL(string: value) else { return false }
            return url.scheme != nil && url.host != nil
        }
    }

    /// Creates a rule requiring at least one uppercase letter
    ///
    /// - Parameter message: The error message
    /// - Returns: A validation rule
    public static func containsUppercase(_ message: String = "Must contain at least one uppercase letter")
    -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            value.contains { $0.isUppercase }
        }
    }

    /// Creates a rule requiring at least one lowercase letter
    ///
    /// - Parameter message: The error message
    /// - Returns: A validation rule
    public static func containsLowercase(_ message: String = "Must contain at least one lowercase letter")
    -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            value.contains { $0.isLowercase }
        }
    }

    /// Creates a rule requiring at least one digit
    ///
    /// - Parameter message: The error message
    /// - Returns: A validation rule
    public static func containsDigit(_ message: String = "Must contain at least one number") -> ValidationRule {
        ValidationRule(errorMessage: message) { value in
            value.contains { $0.isNumber }
        }
    }

    /// Creates a rule requiring at least one special character
    ///
    /// - Parameter message: The error message
    /// - Returns: A validation rule
    public static func containsSpecialCharacter(_ message: String = "Must contain at least one special character")
    -> ValidationRule {
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;':\",./<>?")
        return ValidationRule(errorMessage: message) { value in
            value.unicodeScalars.contains { specialCharacters.contains($0) }
        }
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextFieldValidation {
    /// Email validation preset
    ///
    /// Validates that the input is a properly formatted email address.
    public static var email: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [
                required("Email is required"),
                Self.email()
            ],
            mode: .all
        )
    }

    /// Password validation preset
    ///
    /// Requires minimum 8 characters with at least one letter and one number.
    public static var password: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [
                required("Password is required"),
                minLength(8, message: "Password must be at least 8 characters"),
                containsDigit("Password must contain at least one number"),
                regex("[A-Za-z]", message: "Password must contain at least one letter")
            ],
            mode: .all
        )
    }

    /// Strong password validation preset
    ///
    /// Requires minimum 8 characters with uppercase, lowercase, digit, and special character.
    public static var strongPassword: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [
                required("Password is required"),
                minLength(8, message: "Password must be at least 8 characters"),
                containsUppercase(),
                containsLowercase(),
                containsDigit(),
                containsSpecialCharacter()
            ],
            mode: .all
        )
    }

    /// Required field validation preset
    ///
    /// Simply validates that the field is not empty.
    public static var required: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [Self.required()],
            mode: .all
        )
    }

    /// Username validation preset
    ///
    /// Requires 3-20 characters, alphanumeric and underscores only.
    public static var username: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [
                required("Username is required"),
                minLength(3, message: "Username must be at least 3 characters"),
                maxLength(20, message: "Username must be no more than 20 characters"),
                regex("^[a-zA-Z0-9_]+$", message: "Only letters, numbers, and underscores allowed")
            ],
            mode: .all
        )
    }

    /// Phone number validation preset
    ///
    /// Validates phone number format (10-15 digits).
    public static var phoneNumber: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [
                required("Phone number is required"),
                phone()
            ],
            mode: .all
        )
    }

    /// URL validation preset
    ///
    /// Validates URL format with scheme and host.
    public static var urlValidation: ARCTextFieldValidation {
        ARCTextFieldValidation(
            rules: [
                required("URL is required"),
                url()
            ],
            mode: .all
        )
    }
}
