//
//  ARCTextFieldDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCTextField component.
///
/// Shows text fields with various styles, validation states, and interactive examples.
@available(iOS 17.0, *)
struct ARCTextFieldDemoScreen: View {
    // MARK: - State

    @State private var basicText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var confirmPassword = ""
    @State private var usernameText = ""
    @State private var searchText = ""
    @State private var bioText = ""
    @State private var phoneText = ""
    @State private var urlText = ""
    @State private var filledText = ""
    @State private var underlinedText = ""
    @State private var glassText = ""

    @State private var isFormValid = false

    // MARK: - Body

    var body: some View {
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
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCTextFieldDemoScreen {
    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("TextField Styles", subtitle: "Different visual treatments")

            VStack(spacing: 16) {
                styleRow("Outlined", description: "Default bordered style") {
                    ARCTextField("Enter text", text: $basicText)
                }

                styleRow("Filled", description: "Solid background") {
                    ARCTextField("Enter text", text: $filledText, configuration: .filled)
                }

                styleRow("Underlined", description: "Minimal bottom line") {
                    ARCTextField("Enter text", text: $underlinedText, configuration: .underlined)
                }

                styleRow("Glass", description: "Premium liquid glass effect") {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 80)

                        ARCTextField("Search", text: $glassText, configuration: .glass)
                            .padding(.horizontal, 12)
                    }
                }
            }
        }
    }

    // MARK: - Input Types Section

    private var inputTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Input Types", subtitle: "Specialized keyboard and validation")

            VStack(spacing: 16) {
                styleRow("Email", description: "Email keyboard with validation") {
                    ARCTextField("Email address", text: $emailText, configuration: .email)
                }

                styleRow("Password", description: "Secure entry with toggle") {
                    ARCSecureField("Password", text: $passwordText, configuration: .password)
                }

                styleRow("Phone", description: "Numeric keyboard") {
                    ARCTextField("Phone number", text: $phoneText, configuration: .phone)
                }

                styleRow("URL", description: "URL keyboard") {
                    ARCTextField("Website URL", text: $urlText, configuration: .url)
                }

                styleRow("Search", description: "Search keyboard with clear") {
                    ARCTextField("Search", text: $searchText, configuration: .search)
                }

                styleRow("Multiline", description: "Multi-line with character limit") {
                    ARCTextField("Bio", text: $bioText, configuration: .multiline)
                }
            }
        }
    }

    // MARK: - Validation Section

    private var validationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Validation", subtitle: "Real-time input validation")

            VStack(spacing: 16) {
                styleRow("Username", description: "3-20 chars, alphanumeric") {
                    ARCTextField(
                        "Username",
                        text: $usernameText,
                        configuration: ARCTextFieldConfiguration(
                            label: "Username",
                            leadingIcon: "person",
                            helperText: "Letters, numbers, and underscores only",
                            validation: ARCTextFieldValidation.username,
                            validateOnChange: true
                        )
                    )
                }

                styleRow("Strong Password", description: "Complex password rules") {
                    ARCSecureField(
                        "Password",
                        text: $passwordText,
                        configuration: ARCTextFieldConfiguration(
                            label: "Strong Password",
                            leadingIcon: "lock.shield",
                            helperText: "Min 8 chars: upper, lower, digit, special",
                            validation: ARCTextFieldValidation.strongPassword,
                            validateOnChange: true,
                            showValidationIcon: true
                        )
                    )
                }

                styleRow("Character Limit", description: "With counter display") {
                    ARCTextField(
                        "Tweet",
                        text: $bioText,
                        configuration: ARCTextFieldConfiguration(
                            inputType: ARCTextFieldConfiguration.InputType.multiline(lineLimit: 3),
                            characterLimit: 280,
                            showCharacterCount: true,
                            height: 80
                        )
                    )
                }
            }
        }
    }

    // MARK: - States Section

    private var statesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("States", subtitle: "Visual feedback states")

            VStack(spacing: 16) {
                styleRow("Normal", description: "Default idle state") {
                    ARCTextField("Enter text", text: .constant(""))
                }

                styleRow("Filled", description: "With content") {
                    ARCTextField("Enter text", text: .constant("Hello World"))
                }

                styleRow("Disabled", description: "Non-interactive") {
                    ARCTextField("Cannot edit", text: .constant("Disabled"))
                        .disabled(true)
                }

                styleRow("With Icons", description: "Leading and trailing") {
                    ARCTextField(
                        "Search",
                        text: $searchText,
                        configuration: ARCTextFieldConfiguration(
                            leadingIcon: "magnifyingglass",
                            trailingIcon: "mic.fill",
                            clearButton: ARCTextFieldConfiguration.ClearButtonMode.never
                        )
                    )
                }

                styleRow("With Helper", description: "Additional info below") {
                    ARCTextField(
                        "Email",
                        text: $emailText,
                        configuration: ARCTextFieldConfiguration(
                            label: "Email",
                            leadingIcon: "envelope",
                            helperText: "We'll never share your email with anyone"
                        )
                    )
                }
            }
        }
    }

    // MARK: - Form Example Section

    private var formExampleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Form Example", subtitle: "Complete registration form")

            VStack(spacing: 20) {
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

                ARCActionButton(
                    "Create Account",
                    icon: "person.badge.plus",
                    configuration: ARCActionButtonConfiguration(isFullWidth: true)
                ) {
                    // Form submission
                }
                .padding(.top, 8)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func styleRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCTextFieldDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCTextFieldDemoScreen()
    }
    .preferredColorScheme(.dark)
}
