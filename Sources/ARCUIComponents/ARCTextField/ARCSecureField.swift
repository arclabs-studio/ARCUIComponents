//
//  ARCSecureField.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - ARCSecureField

/// A secure text field for password entry with visibility toggle
///
/// `ARCSecureField` provides a password input field with the ability to
/// toggle visibility between secure (dots) and plain text modes.
///
/// ## Overview
///
/// Per Apple HIG: "Always use a secure text field when your app asks for
/// sensitive data, such as a password."
///
/// ARCSecureField provides:
/// - Secure text entry by default
/// - Toggle button to show/hide password
/// - Same styling options as ARCTextField
/// - Built-in password validation support
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating Secure Fields
///
/// - ``init(_:text:configuration:onSubmit:)``
///
/// ## Usage
///
/// ```swift
/// @State private var password = ""
///
/// // Basic usage
/// ARCSecureField("Password", text: $password)
///
/// // With validation
/// ARCSecureField(
///     "Password",
///     text: $password,
///     configuration: .password
/// )
///
/// // Custom configuration
/// ARCSecureField(
///     "Confirm Password",
///     text: $confirmPassword,
///     configuration: ARCTextFieldConfiguration(
///         label: "Confirm Password",
///         leadingIcon: "lock.fill",
///         validation: .strongPassword
///     )
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSecureField: View {
    // MARK: - Properties

    @Binding private var text: String

    private let placeholder: String
    private let configuration: ARCTextFieldConfiguration
    private let onSubmit: (() -> Void)?

    @State private var isSecure = true
    @FocusState private var isFocused: Bool
    @State private var validationState: ARCTextField.ValidationState = .idle

    // MARK: - Environment

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a secure text field with the specified placeholder, binding, and configuration
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text shown when empty
    ///   - text: Binding to the text value
    ///   - configuration: Text field configuration (default: .password)
    ///   - onSubmit: Action to perform on submit
    public init(
        _ placeholder: String,
        text: Binding<String>,
        configuration: ARCTextFieldConfiguration = .password,
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

    @ViewBuilder private var fieldContainer: some View {
        ZStack(alignment: .leading) {
            backgroundView
            fieldContent
        }
        .frame(height: configuration.height)
    }

    // MARK: - Background View

    @ViewBuilder private var backgroundView: some View {
        switch configuration.style {
        case .outlined:
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.backgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .strokeBorder(currentBorderColor, lineWidth: currentBorderWidth)
                }

        case .filled:
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(filledBackgroundColor)
                .overlay {
                    if isErrorState {
                        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                            .strokeBorder(configuration.errorBorderColor, lineWidth: configuration.borderWidth)
                    }
                }

        case .underlined:
            VStack {
                Spacer()
                Rectangle()
                    .fill(currentBorderColor)
                    .frame(height: currentBorderWidth)
            }

        case .glass:
            glassBackground
        }
    }

    @ViewBuilder private var glassBackground: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .overlay {
                if isErrorState {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .strokeBorder(configuration.errorBorderColor, lineWidth: currentBorderWidth)
                } else {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isFocused ? 0.5 : 0.3),
                                    Color.white.opacity(isFocused ? 0.2 : 0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: currentBorderWidth
                        )
                }
            }
            .shadow(
                color: configuration.shadow.color,
                radius: configuration.shadow.radius,
                x: configuration.shadow.x,
                y: configuration.shadow.y
            )
    }

    // MARK: - Field Content

    @ViewBuilder private var fieldContent: some View {
        HStack(spacing: 12) {
            leadingContent
            textFieldContent
            trailingContent
        }
        .padding(.horizontal, configuration.horizontalPadding)
    }

    @ViewBuilder private var leadingContent: some View {
        if let icon = configuration.leadingIcon {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 24, height: 24)
        }
    }

    @ViewBuilder private var textFieldContent: some View {
        if let label = configuration.label {
            VStack(alignment: .leading, spacing: 0) {
                if shouldFloatLabel {
                    Text(label)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(labelColor)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                secureInputView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: shouldFloatLabel)
        } else {
            secureInputView
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private var secureInputView: some View {
        Group {
            if isSecure {
                SecureField(shouldFloatLabel ? "" : placeholder, text: $text)
            } else {
                TextField(shouldFloatLabel ? "" : placeholder, text: $text)
            }
        }
        .font(.body)
        .foregroundStyle(.primary)
        .focused($isFocused)
        .autocorrectionDisabled()
        .submitLabel(configuration.submitLabel)
        .onSubmit {
            handleSubmit()
        }
        #if os(iOS)
        .textInputAutocapitalization(.never)
        .textContentType(.password)
        #endif
    }

    @ViewBuilder private var trailingContent: some View {
        HStack(spacing: 8) {
            visibilityToggle

            if configuration.showValidationIcon {
                validationIcon
            }
        }
    }

    @ViewBuilder private var visibilityToggle: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isSecure.toggle()
            }
        } label: {
            Image(systemName: isSecure ? "eye.slash" : "eye")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.secondary)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSecure ? "Show password" : "Hide password")
    }

    @ViewBuilder private var validationIcon: some View {
        Group {
            switch validationState {
            case .idle, .validating:
                EmptyView()

            case .valid:
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(configuration.successBorderColor)

            case .invalid:
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(configuration.errorBorderColor)
            }
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.spring(response: 0.3), value: validationState)
    }

    // MARK: - Bottom Content

    @ViewBuilder private var bottomContent: some View {
        HStack {
            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(configuration.errorBorderColor)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else if let helperText = configuration.helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 4)
        .animation(.easeInOut(duration: 0.2), value: validationState)
    }

    // MARK: - Computed Properties

    private var shouldFloatLabel: Bool {
        isFocused || !text.isEmpty
    }

    private var isErrorState: Bool {
        if case .invalid = validationState {
            return true
        }
        return false
    }

    private var errorMessage: String? {
        if case let .invalid(message) = validationState {
            return message
        }
        return nil
    }

    private var currentBorderColor: Color {
        if isErrorState {
            return configuration.errorBorderColor
        } else if case .valid = validationState {
            return configuration.successBorderColor
        } else if isFocused {
            return configuration.focusedBorderColor
        }
        return configuration.borderColor
    }

    private var currentBorderWidth: CGFloat {
        isFocused || isErrorState ? configuration.focusedBorderWidth : configuration.borderWidth
    }

    private var iconColor: Color {
        if isErrorState {
            return configuration.errorBorderColor
        } else if isFocused {
            return configuration.focusedBorderColor
        }
        return .secondary
    }

    private var labelColor: Color {
        if isErrorState {
            return configuration.errorBorderColor
        } else if isFocused {
            return configuration.focusedBorderColor
        }
        return .secondary
    }

    private var filledBackgroundColor: Color {
        if colorScheme == .dark {
            return Color.gray.opacity(0.25)
        }
        return configuration.backgroundColor != .clear ? configuration.backgroundColor : Color.gray.opacity(0.15)
    }

    // MARK: - Validation

    private func handleTextChange(_ newValue: String) {
        if configuration.validateOnChange {
            validate(newValue)
        }
    }

    private func handleSubmit() {
        if configuration.validateOnSubmit {
            validate(text)
        }
        onSubmit?()
    }

    private func validate(_ value: String) {
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
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Basic") {
    VStack(spacing: 20) {
        ARCSecureField("Password", text: .constant(""))
        ARCSecureField("Password", text: .constant("secretpass"))
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Configuration") {
    VStack(spacing: 20) {
        ARCSecureField("Password", text: .constant(""), configuration: .password)
        ARCSecureField(
            "Confirm Password",
            text: .constant(""),
            configuration: ARCTextFieldConfiguration(
                label: "Confirm Password",
                leadingIcon: "lock.rotation",
                validation: .strongPassword
            )
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Glass Style") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ARCSecureField(
            "Password",
            text: .constant(""),
            configuration: ARCTextFieldConfiguration(
                style: ARCTextFieldConfiguration.Style.glass,
                label: "Password",
                leadingIcon: "lock"
            )
        )
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    VStack(spacing: 20) {
        ARCSecureField("Password", text: .constant(""), configuration: .password)
        ARCSecureField("Password", text: .constant("mypassword123"), configuration: .password)
    }
    .padding()
    .preferredColorScheme(.dark)
}
