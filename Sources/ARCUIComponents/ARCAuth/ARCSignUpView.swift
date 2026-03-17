//
//  ARCSignUpView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSignUpView

/// Sign-up screen for creating a new account via email/password or social providers.
///
/// The social sign-in section (Apple, Google, etc.) is injected via a generic
/// `@ViewBuilder` parameter so the package stays free of authentication-framework
/// dependencies. When no social content is provided the "or" divider is hidden.
///
/// ## Usage — with social buttons
///
/// ```swift
/// ARCSignUpView(viewModel: signUpViewModel) {
///     AppleSignInButton(type: .signUp) { Task { await viewModel.signInWithApple() } }
///     GoogleSignInButton { Task { await viewModel.signInWithGoogle() } }
/// }
/// ```
///
/// ## Usage — email only
///
/// ```swift
/// ARCSignUpView(viewModel: signUpViewModel)
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCSignUpView<SocialContent: View>: View {
    // MARK: Properties

    @Bindable private var viewModel: ARCSignUpViewModel

    // MARK: Private Properties

    private let navigationTitle: String
    private let emailPlaceholder: String
    private let passwordPlaceholder: String
    private let confirmPasswordPlaceholder: String
    private let signUpLabel: String
    private let errorAlertTitle: String
    private let errorAlertDismissLabel: String
    private let socialContent: SocialContent

    // MARK: Initialization

    /// Creates a sign-up view with an optional social sign-in section.
    ///
    /// - Parameters:
    ///   - viewModel: The observable view model driving this screen.
    ///   - navigationTitle: Navigation bar title (default: `"Create Account"`).
    ///   - emailPlaceholder: Email field placeholder (default: `"Email"`).
    ///   - passwordPlaceholder: Password field placeholder (default: `"Password"`).
    ///   - confirmPasswordPlaceholder: Confirm-password field placeholder (default: `"Confirm password"`).
    ///   - signUpLabel: Primary button label (default: `"Create Account"`).
    ///   - errorAlertTitle: Title of the error alert (default: `"Error"`).
    ///   - errorAlertDismissLabel: Dismiss button label of the error alert (default: `"OK"`).
    ///   - socialContent: Additional sign-in buttons (Apple, Google, etc.). Omit for email-only.
    public init(viewModel: ARCSignUpViewModel,
                navigationTitle: String = "Create Account",
                emailPlaceholder: String = "Email",
                passwordPlaceholder: String = "Password",
                confirmPasswordPlaceholder: String = "Confirm password",
                signUpLabel: String = "Create Account",
                errorAlertTitle: String = "Error",
                errorAlertDismissLabel: String = "OK",
                @ViewBuilder socialContent: () -> SocialContent) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        self.emailPlaceholder = emailPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.confirmPasswordPlaceholder = confirmPasswordPlaceholder
        self.signUpLabel = signUpLabel
        self.errorAlertTitle = errorAlertTitle
        self.errorAlertDismissLabel = errorAlertDismissLabel
        self.socialContent = socialContent()
    }

    // MARK: View

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXLarge) {
                emailSection
                if SocialContent.self != EmptyView.self {
                    socialSection
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

// MARK: - Convenience Init (no social)

@available(iOS 17.0, macOS 14.0, *) extension ARCSignUpView where SocialContent == EmptyView {
    /// Creates a sign-up view with email/password only — no social section.
    ///
    /// - Parameters:
    ///   - viewModel: The observable view model driving this screen.
    ///   - navigationTitle: Navigation bar title (default: `"Create Account"`).
    ///   - emailPlaceholder: Email field placeholder (default: `"Email"`).
    ///   - passwordPlaceholder: Password field placeholder (default: `"Password"`).
    ///   - confirmPasswordPlaceholder: Confirm-password field placeholder (default: `"Confirm password"`).
    ///   - signUpLabel: Primary button label (default: `"Create Account"`).
    ///   - errorAlertTitle: Title of the error alert (default: `"Error"`).
    ///   - errorAlertDismissLabel: Dismiss button label of the error alert (default: `"OK"`).
    public init(viewModel: ARCSignUpViewModel,
                navigationTitle: String = "Create Account",
                emailPlaceholder: String = "Email",
                passwordPlaceholder: String = "Password",
                confirmPasswordPlaceholder: String = "Confirm password",
                signUpLabel: String = "Create Account",
                errorAlertTitle: String = "Error",
                errorAlertDismissLabel: String = "OK") {
        self.init(viewModel: viewModel,
                  navigationTitle: navigationTitle,
                  emailPlaceholder: emailPlaceholder,
                  passwordPlaceholder: passwordPlaceholder,
                  confirmPasswordPlaceholder: confirmPasswordPlaceholder,
                  signUpLabel: signUpLabel,
                  errorAlertTitle: errorAlertTitle,
                  errorAlertDismissLabel: errorAlertDismissLabel,
                  socialContent: { EmptyView() })
    }
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *) extension ARCSignUpView {
    private var emailSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            ARCTextField(emailPlaceholder,
                         text: $viewModel.email,
                         configuration: ARCTextFieldConfiguration(inputType: .email,
                                                                  label: emailPlaceholder,
                                                                  leadingIcon: "envelope",
                                                                  autocapitalization: .never,
                                                                  autocorrection: false,
                                                                  submitLabel: .next))

            ARCSecureField(passwordPlaceholder,
                           text: $viewModel.password,
                           configuration: ARCTextFieldConfiguration(inputType: .password,
                                                                    label: passwordPlaceholder,
                                                                    leadingIcon: "lock",
                                                                    validation: .strongPassword,
                                                                    autocapitalization: .never,
                                                                    autocorrection: false,
                                                                    clearButton: .never))

            ARCSecureField(confirmPasswordPlaceholder,
                           text: $viewModel.confirmPassword,
                           configuration: ARCTextFieldConfiguration(inputType: .password,
                                                                    label: confirmPasswordPlaceholder,
                                                                    leadingIcon: "lock.rotation",
                                                                    autocapitalization: .never,
                                                                    autocorrection: false,
                                                                    clearButton: .never))

            ARCButton(signUpLabel,
                      isLoading: $viewModel.isLoading,
                      configuration: ARCButtonConfiguration(size: .large, isFullWidth: true)) {
                Task { await viewModel.signUpWithEmail() }
            }
        }
    }

    private var socialSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            orDivider
            socialContent
        }
    }

    private var orDivider: some View {
        HStack {
            Rectangle()
                .fill(.separator)
                .frame(height: 1)
            Text("or")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, .arcSpacingSmall)
            Rectangle()
                .fill(.separator)
                .frame(height: 1)
        }
    }
}

// MARK: - Previews

#Preview("Sign Up - Dark") {
    let viewModel = ARCSignUpViewModel(onSignUpWithEmail: { _, _ in },
                                       onSignInWithApple: {},
                                       onSignInWithGoogle: {})
    return NavigationStack {
        ARCSignUpView(viewModel: viewModel)
    }
    .preferredColorScheme(.dark)
}

#Preview("Sign Up - Light") {
    let viewModel = ARCSignUpViewModel(onSignUpWithEmail: { _, _ in },
                                       onSignInWithApple: {},
                                       onSignInWithGoogle: {})
    return NavigationStack {
        ARCSignUpView(viewModel: viewModel)
    }
    .preferredColorScheme(.light)
}
