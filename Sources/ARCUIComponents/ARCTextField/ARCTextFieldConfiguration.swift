//
//  ARCTextFieldConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - ARCTextFieldConfiguration

/// Configuration for ARCTextField appearance and behavior
///
/// Provides customization options for text field style, validation, and interaction
/// following Apple's Human Interface Guidelines.
///
/// ## Overview
///
/// Per Apple HIG: "Use a text field to request a small amount of information,
/// such as a name or an email address." ARCTextFieldConfiguration allows extensive
/// customization while maintaining HIG compliance.
///
/// ## Topics
///
/// ### Style
///
/// - ``Style-swift.enum``
///
/// ### Input Type
///
/// - ``InputType-swift.enum``
///
/// ### Clear Button
///
/// - ``ClearButtonMode-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``email``
/// - ``password``
/// - ``search``
/// - ``multiline``
/// - ``glass``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTextFieldConfiguration: LiquidGlassConfigurable, Sendable {
    // MARK: - Style

    /// Visual styles for text fields
    public enum Style: Sendable, Equatable {
        /// Border around the entire field
        case outlined

        /// Solid background fill
        case filled

        /// Line below only (minimal style)
        case underlined

        /// Liquid glass effect background
        case glass
    }

    // MARK: - InputType

    /// Input types determining keyboard and content behavior
    public enum InputType: Sendable, Equatable {
        /// Standard text input
        case text

        /// Email address input with appropriate keyboard
        case email

        /// Secure password input
        case password

        /// Phone number input with numeric keyboard
        case phone

        /// Numeric input only
        case number

        /// URL input with appropriate keyboard
        case url

        /// Multiline text input with optional line limit
        case multiline(lineLimit: Int?)
    }

    // MARK: - ClearButtonMode

    /// When to show the clear button
    public enum ClearButtonMode: Sendable, Equatable {
        /// Never show the clear button
        case never

        /// Show only while editing
        case whileEditing

        /// Always show when there is text
        case always
    }

    // MARK: - AutocapitalizationType

    /// Autocapitalization behavior for text input
    public enum AutocapitalizationType: Sendable, Equatable {
        /// No autocapitalization
        case never

        /// Capitalize words
        case words

        /// Capitalize sentences
        case sentences

        /// Capitalize all characters
        case characters
    }

    // MARK: - Appearance Properties

    /// Visual style of the text field
    public let style: Style

    /// Input type determining keyboard and behavior
    public let inputType: InputType

    /// Floating label text shown above the field when focused or filled
    public let label: String?

    /// SF Symbol name for leading icon
    public let leadingIcon: String?

    /// SF Symbol name for trailing icon
    public let trailingIcon: String?

    /// Helper text shown below the field
    public let helperText: String?

    // MARK: - Validation Properties

    /// Validation configuration
    public let validation: ARCTextFieldValidation?

    /// Whether to validate on each text change
    public let validateOnChange: Bool

    /// Whether to validate on submit
    public let validateOnSubmit: Bool

    /// Whether to show validation icon in trailing position
    public let showValidationIcon: Bool

    // MARK: - Character Limit Properties

    /// Maximum character limit (nil for unlimited)
    public let characterLimit: Int?

    /// Whether to show character count below field
    public let showCharacterCount: Bool

    // MARK: - Behavior Properties

    /// Text autocapitalization behavior
    public let autocapitalization: AutocapitalizationType

    /// Whether autocorrection is enabled
    public let autocorrection: Bool

    /// Submit button label
    public let submitLabel: SubmitLabel

    /// When to show the clear button
    public let clearButton: ClearButtonMode

    // MARK: - Color Properties

    /// Border color in normal state
    public let borderColor: Color

    /// Border color when focused
    public let focusedBorderColor: Color

    /// Border color in error state
    public let errorBorderColor: Color

    /// Border color in success state
    public let successBorderColor: Color

    /// Background color of the field
    public let backgroundColor: Color

    // MARK: - LiquidGlassConfigurable Properties

    /// Accent color for glass effect
    public let accentColor: Color

    /// Background style for glass effect
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius of the text field
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Size Properties

    /// Height of the text field (excluding label and helper)
    public let height: CGFloat

    /// Horizontal padding inside the field
    public let horizontalPadding: CGFloat

    /// Border width
    public let borderWidth: CGFloat

    /// Focused border width
    public let focusedBorderWidth: CGFloat

    // MARK: - Initialization

    /// Creates a text field configuration with the specified options
    public init(
        style: Style = .outlined,
        inputType: InputType = .text,
        label: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        helperText: String? = nil,
        validation: ARCTextFieldValidation? = nil,
        validateOnChange: Bool = false,
        validateOnSubmit: Bool = true,
        showValidationIcon: Bool = true,
        characterLimit: Int? = nil,
        showCharacterCount: Bool = false,
        autocapitalization: AutocapitalizationType = .sentences,
        autocorrection: Bool = true,
        submitLabel: SubmitLabel = .done,
        clearButton: ClearButtonMode = .whileEditing,
        borderColor: Color = .secondary.opacity(0.3),
        focusedBorderColor: Color = .accentColor,
        errorBorderColor: Color = .red,
        successBorderColor: Color = .green,
        backgroundColor: Color = .clear,
        accentColor: Color = .accentColor,
        cornerRadius: CGFloat = 12,
        shadow: ARCShadow = .none,
        height: CGFloat = 56,
        horizontalPadding: CGFloat = 16,
        borderWidth: CGFloat = 1,
        focusedBorderWidth: CGFloat = 2
    ) {
        self.style = style
        self.inputType = inputType
        self.label = label
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.helperText = helperText
        self.validation = validation
        self.validateOnChange = validateOnChange
        self.validateOnSubmit = validateOnSubmit
        self.showValidationIcon = showValidationIcon
        self.characterLimit = characterLimit
        self.showCharacterCount = showCharacterCount
        self.autocapitalization = autocapitalization
        self.autocorrection = autocorrection
        self.submitLabel = submitLabel
        self.clearButton = clearButton
        self.borderColor = borderColor
        self.focusedBorderColor = focusedBorderColor
        self.errorBorderColor = errorBorderColor
        self.successBorderColor = successBorderColor
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        backgroundStyle = style == .glass ? .liquidGlass : .solid(backgroundColor, opacity: 1.0)
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.borderWidth = borderWidth
        self.focusedBorderWidth = focusedBorderWidth
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextFieldConfiguration {
    /// Default text field configuration
    public static var `default`: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration()
    }

    /// Email input configuration
    public static var email: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            inputType: InputType.email,
            label: "Email",
            leadingIcon: "envelope",
            validation: ARCTextFieldValidation.email,
            validateOnSubmit: true,
            autocapitalization: AutocapitalizationType.never,
            autocorrection: false,
            submitLabel: .next
        )
    }

    /// Password input configuration
    public static var password: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            inputType: InputType.password,
            label: "Password",
            leadingIcon: "lock",
            validation: ARCTextFieldValidation.password,
            validateOnSubmit: true,
            showValidationIcon: false,
            autocapitalization: AutocapitalizationType.never,
            autocorrection: false,
            clearButton: ClearButtonMode.never
        )
    }

    /// Search input configuration
    public static var search: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            style: Style.filled,
            leadingIcon: "magnifyingglass",
            autocapitalization: AutocapitalizationType.never,
            submitLabel: .search,
            clearButton: ClearButtonMode.whileEditing,
            backgroundColor: Color.gray.opacity(0.15),
            cornerRadius: 10
        )
    }

    /// Multiline text configuration
    public static var multiline: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            inputType: InputType.multiline(lineLimit: 5),
            characterLimit: 500,
            showCharacterCount: true,
            submitLabel: .return,
            height: 120
        )
    }

    /// Glass style configuration
    public static var glass: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            style: Style.glass,
            shadow: ARCShadow.subtle
        )
    }

    /// Phone number input configuration
    public static var phone: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            inputType: InputType.phone,
            label: "Phone",
            leadingIcon: "phone",
            validation: ARCTextFieldValidation.phoneNumber,
            autocapitalization: AutocapitalizationType.never,
            autocorrection: false,
            submitLabel: .next
        )
    }

    /// URL input configuration
    public static var url: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            inputType: InputType.url,
            label: "URL",
            leadingIcon: "link",
            validation: ARCTextFieldValidation.urlValidation,
            autocapitalization: AutocapitalizationType.never,
            autocorrection: false,
            submitLabel: .go
        )
    }

    /// Underlined style configuration
    public static var underlined: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            style: Style.underlined,
            cornerRadius: 0
        )
    }

    /// Filled style configuration
    public static var filled: ARCTextFieldConfiguration {
        ARCTextFieldConfiguration(
            style: Style.filled,
            backgroundColor: Color.gray.opacity(0.15),
            cornerRadius: 10
        )
    }
}

// MARK: - Helper Extensions

@available(iOS 17.0, macOS 14.0, *)
extension ARCTextFieldConfiguration {
    /// Returns whether this configuration is for multiline input
    public var isMultiline: Bool {
        if case .multiline = inputType {
            return true
        }
        return false
    }

    /// Returns the line limit for multiline input, or nil for single line
    public var lineLimit: Int? {
        if case let .multiline(limit) = inputType {
            return limit
        }
        return 1
    }

    #if os(iOS)
    /// Returns the appropriate keyboard type for the input type
    public var keyboardType: UIKeyboardType {
        switch inputType {
        case .text, .multiline:
            .default
        case .email:
            .emailAddress
        case .password:
            .default
        case .phone:
            .phonePad
        case .number:
            .numberPad
        case .url:
            .URL
        }
    }

    /// Returns the appropriate text content type for the input type
    public var textContentType: UITextContentType? {
        switch inputType {
        case .email:
            .emailAddress
        case .password:
            .password
        case .phone:
            .telephoneNumber
        case .url:
            .URL
        default:
            nil
        }
    }

    /// Returns the SwiftUI TextInputAutocapitalization for this configuration
    public var textInputAutocapitalization: TextInputAutocapitalization {
        switch autocapitalization {
        case .never:
            .never
        case .words:
            .words
        case .sentences:
            .sentences
        case .characters:
            .characters
        }
    }
    #endif
}
