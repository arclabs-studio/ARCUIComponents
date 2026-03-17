//
//  ARCTextFieldShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCTextFieldShowcase

/// Comprehensive showcase view for ARCTextField demonstrating all configurations and states
///
/// Use this view to preview all ARCTextField variants, styles, and validation states
/// in both light and dark mode.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTextFieldShowcase: View {
    // MARK: - State

    @State private var basicText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var confirmPassword = ""
    @State private var searchText = ""
    @State private var bioText = ""
    @State private var phoneText = ""
    @State private var urlText = ""
    @State private var usernameText = ""
    @State private var filledText = ""
    @State private var underlinedText = ""
    @State private var glassText = ""

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                stylesSection
                inputTypesSection
                validationSection
                statesSection
                formExampleSection
            }
            .padding()
        }
        .navigationTitle("ARCTextField")
    }

    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Styles")

            ARCTextField("Outlined (Default)", text: $basicText)

            ARCTextField("Filled", text: $filledText, configuration: .filled)

            ARCTextField("Underlined", text: $underlinedText, configuration: .underlined)

            glassStyleExample
        }
    }

    private var glassStyleExample: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 100)

            ARCTextField("Glass Style", text: $glassText, configuration: .glass)
                .padding(.horizontal)
        }
    }

    // MARK: - Input Types Section

    private var inputTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Input Types")

            ARCTextField("Email", text: $emailText, configuration: .email)

            ARCSecureField("Password", text: $passwordText, configuration: .password)

            ARCTextField("Phone", text: $phoneText, configuration: .phone)

            ARCTextField("URL", text: $urlText, configuration: .url)

            ARCTextField("Search", text: $searchText, configuration: .search)

            ARCTextField(
                "Bio",
                text: $bioText,
                configuration: .multiline
            )
        }
    }

    // MARK: - Validation Section

    private var validationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Validation")

            ARCTextField(
                "Username",
                text: $usernameText,
                configuration: ARCTextFieldConfiguration(
                    label: "Username",
                    leadingIcon: "person",
                    helperText: "3-20 characters, letters, numbers, underscore",
                    validation: ARCTextFieldValidation.username,
                    validateOnChange: true
                )
            )

            ARCTextField(
                "Email with validation",
                text: $emailText,
                configuration: ARCTextFieldConfiguration(
                    label: "Email",
                    leadingIcon: "envelope",
                    validation: ARCTextFieldValidation.email,
                    validateOnChange: true
                )
            )

            ARCSecureField(
                "Strong Password",
                text: $passwordText,
                configuration: ARCTextFieldConfiguration(
                    label: "Password",
                    leadingIcon: "lock",
                    helperText: "Min 8 chars, upper, lower, number, special",
                    validation: ARCTextFieldValidation.strongPassword,
                    validateOnChange: true
                )
            )
        }
    }

    // MARK: - States Section

    private var statesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("States")

            // Normal
            ARCTextField("Normal State", text: .constant(""))

            // Filled
            ARCTextField("Filled State", text: .constant("John Doe"))

            // Disabled
            ARCTextField("Disabled State", text: .constant("Cannot edit"))
                .disabled(true)

            // With Icons
            ARCTextField(
                "With Icons",
                text: .constant(""),
                configuration: ARCTextFieldConfiguration(
                    leadingIcon: "magnifyingglass",
                    trailingIcon: "mic.fill"
                )
            )

            // With Helper Text
            ARCTextField(
                "With Helper",
                text: .constant(""),
                configuration: ARCTextFieldConfiguration(
                    helperText: "This is helper text below the field"
                )
            )

            // With Character Count
            ARCTextField(
                "Character Limit",
                text: $bioText,
                configuration: ARCTextFieldConfiguration(
                    characterLimit: 50,
                    showCharacterCount: true
                )
            )
        }
    }

    // MARK: - Form Example Section

    private var formExampleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Form Example")

            VStack(spacing: 16) {
                ARCTextField(
                    "Username",
                    text: $usernameText,
                    configuration: ARCTextFieldConfiguration(
                        label: "Username",
                        leadingIcon: "person",
                        validation: ARCTextFieldValidation.username,
                        validateOnSubmit: true,
                        submitLabel: .next
                    )
                )

                ARCTextField(
                    "Email",
                    text: $emailText,
                    configuration: ARCTextFieldConfiguration(
                        label: "Email",
                        leadingIcon: "envelope",
                        validation: ARCTextFieldValidation.email,
                        validateOnSubmit: true,
                        submitLabel: .next
                    )
                )

                ARCSecureField(
                    "Password",
                    text: $passwordText,
                    configuration: ARCTextFieldConfiguration(
                        label: "Password",
                        leadingIcon: "lock",
                        validation: ARCTextFieldValidation.password,
                        validateOnSubmit: true,
                        submitLabel: .next
                    )
                )

                ARCSecureField(
                    "Confirm Password",
                    text: $confirmPassword,
                    configuration: ARCTextFieldConfiguration(
                        label: "Confirm Password",
                        leadingIcon: "lock.rotation",
                        validation: ARCTextFieldValidation(
                            rules: [
                                ARCTextFieldValidation.required("Please confirm your password")
                            ],
                            mode: ARCTextFieldValidation.ValidationMode.all
                        ),
                        validateOnSubmit: true,
                        submitLabel: .done
                    )
                )
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(white: 0.98))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 8)
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCTextFieldShowcase()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCTextFieldShowcase()
    }
    .preferredColorScheme(.dark)
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("All Styles") {
    ScrollView {
        VStack(spacing: 20) {
            ARCTextField("Outlined", text: .constant(""))
            ARCTextField("Filled", text: .constant(""), configuration: .filled)
            ARCTextField("Underlined", text: .constant(""), configuration: .underlined)

            ZStack {
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 80)
                .clipShape(.rect(cornerRadius: 12))

                ARCTextField("Glass", text: .constant(""), configuration: .glass)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Input Types") {
    ScrollView {
        VStack(spacing: 20) {
            ARCTextField("Text", text: .constant(""))
            ARCTextField("Email", text: .constant(""), configuration: .email)
            ARCSecureField("Password", text: .constant(""))
            ARCTextField("Phone", text: .constant(""), configuration: .phone)
            ARCTextField("URL", text: .constant(""), configuration: .url)
            ARCTextField("Search", text: .constant(""), configuration: .search)
            ARCTextField("Multiline", text: .constant(""), configuration: .multiline)
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Validation States") {
    VStack(spacing: 20) {
        // Idle
        ARCTextField("Idle", text: .constant(""))

        // Valid (simulated)
        ARCTextField(
            "Valid",
            text: .constant("valid@email.com"),
            configuration: .email
        )

        // Invalid (simulated)
        ARCTextField(
            "Invalid",
            text: .constant("invalid"),
            configuration: .email
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Secure Field") {
    VStack(spacing: 20) {
        ARCSecureField("Password", text: .constant(""))
        ARCSecureField("Password", text: .constant("secretpassword"))
        ARCSecureField(
            "Strong Password",
            text: .constant(""),
            configuration: ARCTextFieldConfiguration(
                label: "Password",
                leadingIcon: "lock.shield",
                helperText: "Must include uppercase, lowercase, number, and special character",
                validation: ARCTextFieldValidation.strongPassword
            )
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Character Limit") {
    VStack(spacing: 20) {
        ARCTextField(
            "Username",
            text: .constant("john_doe"),
            configuration: ARCTextFieldConfiguration(
                characterLimit: 20,
                showCharacterCount: true
            )
        )

        ARCTextField(
            "Bio",
            text: .constant("Hello, I'm a software developer passionate about creating great user experiences."),
            configuration: ARCTextFieldConfiguration(
                inputType: .multiline(lineLimit: 4),
                characterLimit: 150,
                showCharacterCount: true,
                height: 100
            )
        )
    }
    .padding()
}
