//
//  ARCForgotPasswordView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCForgotPasswordView

/// Forgot-password screen that collects an email address and sends a reset link.
///
/// The view transitions from an input state to a success confirmation state
/// automatically when `viewModel.didSendReset` becomes `true`. The back button
/// from the `NavigationStack` owned by the caller handles dismissal.
///
/// ## Usage
///
/// ```swift
/// let viewModel = ARCForgotPasswordViewModel(
///     onSendReset: { email in
///         try await authRepository.sendPasswordReset(to: email)
///     }
/// )
///
/// ARCForgotPasswordView(viewModel: viewModel)
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCForgotPasswordView<FooterContent: View>: View {
    // MARK: Properties

    @Bindable private var viewModel: ARCForgotPasswordViewModel

    // MARK: Private Properties

    private let navigationTitle: String
    private let instructionText: String
    private let emailPlaceholder: String
    private let sendLabel: String
    private let successTitle: String
    private let successMessage: String
    private let successIcon: String
    private let successIconColor: Color
    private let errorAlertTitle: String
    private let errorAlertDismissLabel: String
    private let footerContent: FooterContent

    // MARK: Initialization

    /// Creates a forgot-password view with an optional footer below the send button.
    ///
    /// - Parameters:
    ///   - viewModel: The observable view model driving this screen.
    ///   - navigationTitle: Navigation bar title (default: `"Reset Password"`).
    ///   - instructionText: Instruction text shown above the email field.
    ///   - emailPlaceholder: Email field placeholder (default: `"Email"`).
    ///   - sendLabel: Primary button label (default: `"Send Reset Link"`).
    ///   - successTitle: Title shown on the success screen (default: `"Link sent"`).
    ///   - successMessage: Body shown on the success screen.
    ///   - successIcon: SF Symbol name for the success state icon (default: `"checkmark.circle.fill"`).
    ///   - successIconColor: Color of the success state icon (default: `.green`).
    ///   - errorAlertTitle: Title of the error alert (default: `"Error"`).
    ///   - errorAlertDismissLabel: Dismiss button label of the error alert (default: `"OK"`).
    ///   - footerContent: Additional content rendered below the send button (e.g. a "Contact support" link).
    public init(viewModel: ARCForgotPasswordViewModel,
                navigationTitle: String = "Reset Password",
                instructionText: String = "Enter your email address and we'll send you a link to reset your password.",
                emailPlaceholder: String = "Email",
                sendLabel: String = "Send Reset Link",
                successTitle: String = "Link sent",
                successMessage: String = "Check your email and follow the instructions to reset your password.",
                successIcon: String = "checkmark.circle.fill",
                successIconColor: Color = .green,
                errorAlertTitle: String = "Error",
                errorAlertDismissLabel: String = "OK",
                @ViewBuilder footerContent: () -> FooterContent) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        self.instructionText = instructionText
        self.emailPlaceholder = emailPlaceholder
        self.sendLabel = sendLabel
        self.successTitle = successTitle
        self.successMessage = successMessage
        self.successIcon = successIcon
        self.successIconColor = successIconColor
        self.errorAlertTitle = errorAlertTitle
        self.errorAlertDismissLabel = errorAlertDismissLabel
        self.footerContent = footerContent()
    }

    // MARK: View

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXLarge) {
                if viewModel.didSendReset {
                    successState
                } else {
                    inputState
                }
                if FooterContent.self != EmptyView.self {
                    footerContent
                }
            }
            .padding(.horizontal, .arcSpacingXLarge)
            .padding(.vertical, .arcSpacingXLarge)
        }
        .navigationTitle(navigationTitle)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .disabled(viewModel.isLoading)
            .alert(errorAlertTitle, isPresented: .constant(viewModel.errorMessage != nil)) {
                Button(errorAlertDismissLabel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
    }
}

// MARK: - Convenience Init (no footer)

@available(iOS 17.0, macOS 14.0, *) extension ARCForgotPasswordView where FooterContent == EmptyView {
    /// Creates a forgot-password view with no footer content.
    ///
    /// - Parameters:
    ///   - viewModel: The observable view model driving this screen.
    ///   - navigationTitle: Navigation bar title (default: `"Reset Password"`).
    ///   - instructionText: Instruction text shown above the email field.
    ///   - emailPlaceholder: Email field placeholder (default: `"Email"`).
    ///   - sendLabel: Primary button label (default: `"Send Reset Link"`).
    ///   - successTitle: Title shown on the success screen (default: `"Link sent"`).
    ///   - successMessage: Body shown on the success screen.
    ///   - successIcon: SF Symbol name for the success state icon (default: `"checkmark.circle.fill"`).
    ///   - successIconColor: Color of the success state icon (default: `.green`).
    ///   - errorAlertTitle: Title of the error alert (default: `"Error"`).
    ///   - errorAlertDismissLabel: Dismiss button label of the error alert (default: `"OK"`).
    public init(viewModel: ARCForgotPasswordViewModel,
                navigationTitle: String = "Reset Password",
                instructionText: String = "Enter your email address and we'll send you a link to reset your password.",
                emailPlaceholder: String = "Email",
                sendLabel: String = "Send Reset Link",
                successTitle: String = "Link sent",
                successMessage: String = "Check your email and follow the instructions to reset your password.",
                successIcon: String = "checkmark.circle.fill",
                successIconColor: Color = .green,
                errorAlertTitle: String = "Error",
                errorAlertDismissLabel: String = "OK") {
        self.init(viewModel: viewModel,
                  navigationTitle: navigationTitle,
                  instructionText: instructionText,
                  emailPlaceholder: emailPlaceholder,
                  sendLabel: sendLabel,
                  successTitle: successTitle,
                  successMessage: successMessage,
                  successIcon: successIcon,
                  successIconColor: successIconColor,
                  errorAlertTitle: errorAlertTitle,
                  errorAlertDismissLabel: errorAlertDismissLabel,
                  footerContent: { EmptyView() })
    }
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *) extension ARCForgotPasswordView {
    private var inputState: some View {
        VStack(spacing: .arcSpacingMedium) {
            Text(instructionText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            ARCTextField(emailPlaceholder,
                         text: $viewModel.email,
                         configuration: ARCTextFieldConfiguration(inputType: .email,
                                                                  label: emailPlaceholder,
                                                                  leadingIcon: "envelope",
                                                                  autocapitalization: .never,
                                                                  autocorrection: false,
                                                                  submitLabel: .send))

            ARCButton(sendLabel,
                      isLoading: $viewModel.isLoading,
                      configuration: ARCButtonConfiguration(size: .large, isFullWidth: true)) {
                Task { await viewModel.sendReset() }
            }
        }
    }

    private var successState: some View {
        VStack(spacing: .arcSpacingLarge) {
            Image(systemName: successIcon)
                .font(.system(size: 60))
                .foregroundStyle(successIconColor)

            Text(successTitle)
                .font(.title2.bold())

            Text(successMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Previews

#Preview("Forgot Password - Input") {
    NavigationStack {
        ARCForgotPasswordView(viewModel: ARCForgotPasswordViewModel(onSendReset: { _ in }))
    }
}

#Preview("Forgot Password - Success") {
    let viewModel = ARCForgotPasswordViewModel(onSendReset: { _ in })
    viewModel.didSendReset = true
    return NavigationStack {
        ARCForgotPasswordView(viewModel: viewModel)
    }
}
