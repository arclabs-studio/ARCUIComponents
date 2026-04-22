//
//  ARCSignInView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSignInView

/// Sign-in screen supporting email/password plus an optional social sign-in section.
///
/// The social sign-in section (Apple, Google, etc.) is injected via a generic
/// `@ViewBuilder` parameter so the package stays free of authentication-framework
/// dependencies. When no social content is provided the "or" divider is hidden.
///
/// Navigation to Forgot Password and Sign Up is delegated to the provided closures.
///
/// ## Usage — with social buttons
///
/// ```swift
/// ARCSignInView(
///     viewModel: signInViewModel,
///     onForgotPassword: { path.append(.forgotPassword) },
///     onSignUp: { path.append(.signUp) }
/// ) {
///     AppleSignInButton(type: .signIn) { Task { await viewModel.signInWithApple() } }
///     GoogleSignInButton { Task { await viewModel.signInWithGoogle() } }
/// }
/// ```
///
/// ## Usage — email only
///
/// ```swift
/// ARCSignInView(
///     viewModel: signInViewModel,
///     onForgotPassword: { path.append(.forgotPassword) },
///     onSignUp: { path.append(.signUp) }
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCSignInView<SocialContent: View>: View {
    // MARK: Properties

    @Bindable private var viewModel: ARCSignInViewModel

    // MARK: Private Properties

    private let navigationTitle: String
    private let emailPlaceholder: String
    private let passwordPlaceholder: String
    private let signInLabel: String
    private let forgotPasswordLabel: String
    private let noAccountLabel: String
    private let signUpLabel: String
    private let errorAlertTitle: String
    private let errorAlertDismissLabel: String
    private let onForgotPassword: () -> Void
    private let onSignUp: () -> Void
    private let socialContent: SocialContent

    // MARK: Initialization

    /// Creates a sign-in view with an optional social sign-in section.
    ///
    /// - Parameters:
    ///   - viewModel: The observable view model driving this screen.
    ///   - navigationTitle: Navigation bar title (default: `"Sign In"`).
    ///   - emailPlaceholder: Email field placeholder (default: `"Email"`).
    ///   - passwordPlaceholder: Password field placeholder (default: `"Password"`).
    ///   - signInLabel: Primary button label (default: `"Sign In"`).
    ///   - forgotPasswordLabel: Ghost button label for password recovery (default: `"Forgot password?"`).
    ///   - noAccountLabel: Inline label before the sign-up link (default: `"Don't have an account?"`).
    ///   - signUpLabel: Ghost button label for sign-up (default: `"Create account"`).
    ///   - onForgotPassword: Called when the user taps the forgot-password button.
    ///   - onSignUp: Called when the user taps the create-account button.
    ///   - errorAlertTitle: Title of the error alert (default: `"Error"`).
    ///   - errorAlertDismissLabel: Dismiss button label of the error alert (default: `"OK"`).
    ///   - socialContent: Additional sign-in buttons (Apple, Google, etc.). Pass `EmptyView()` or omit for email-only.
    public init(viewModel: ARCSignInViewModel,
                navigationTitle: String = "Sign In",
                emailPlaceholder: String = "Email",
                passwordPlaceholder: String = "Password",
                signInLabel: String = "Sign In",
                forgotPasswordLabel: String = "Forgot password?",
                noAccountLabel: String = "Don't have an account?",
                signUpLabel: String = "Create account",
                errorAlertTitle: String = "Error",
                errorAlertDismissLabel: String = "OK",
                onForgotPassword: @escaping () -> Void,
                onSignUp: @escaping () -> Void,
                @ViewBuilder socialContent: () -> SocialContent) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        self.emailPlaceholder = emailPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.signInLabel = signInLabel
        self.forgotPasswordLabel = forgotPasswordLabel
        self.noAccountLabel = noAccountLabel
        self.signUpLabel = signUpLabel
        self.errorAlertTitle = errorAlertTitle
        self.errorAlertDismissLabel = errorAlertDismissLabel
        self.onForgotPassword = onForgotPassword
        self.onSignUp = onSignUp
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
                footerLinks
            }
            .padding(.horizontal, .arcSpacingXLarge)
            .padding(.vertical, .arcSpacingXLarge)
        }
        .navigationTitle(navigationTitle)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .disabled(viewModel.isLoading)
            .alert(errorAlertTitle,
                   isPresented: Binding(get: { viewModel.errorMessage != nil },
                                        set: { if !$0 { viewModel.errorMessage = nil } })) {
                Button(errorAlertDismissLabel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
    }
}

// MARK: - Convenience Init (no social)

@available(iOS 17.0, macOS 14.0, *) extension ARCSignInView where SocialContent == EmptyView {
    /// Creates a sign-in view with email/password only — no social section.
    ///
    /// - Parameters:
    ///   - viewModel: The observable view model driving this screen.
    ///   - navigationTitle: Navigation bar title (default: `"Sign In"`).
    ///   - emailPlaceholder: Email field placeholder (default: `"Email"`).
    ///   - passwordPlaceholder: Password field placeholder (default: `"Password"`).
    ///   - signInLabel: Primary button label (default: `"Sign In"`).
    ///   - forgotPasswordLabel: Ghost button label for password recovery (default: `"Forgot password?"`).
    ///   - noAccountLabel: Inline label before the sign-up link (default: `"Don't have an account?"`).
    ///   - signUpLabel: Ghost button label for sign-up (default: `"Create account"`).
    ///   - onForgotPassword: Called when the user taps the forgot-password button.
    ///   - onSignUp: Called when the user taps the create-account button.
    ///   - errorAlertTitle: Title of the error alert (default: `"Error"`).
    ///   - errorAlertDismissLabel: Dismiss button label of the error alert (default: `"OK"`).
    public init(viewModel: ARCSignInViewModel,
                navigationTitle: String = "Sign In",
                emailPlaceholder: String = "Email",
                passwordPlaceholder: String = "Password",
                signInLabel: String = "Sign In",
                forgotPasswordLabel: String = "Forgot password?",
                noAccountLabel: String = "Don't have an account?",
                signUpLabel: String = "Create account",
                errorAlertTitle: String = "Error",
                errorAlertDismissLabel: String = "OK",
                onForgotPassword: @escaping () -> Void,
                onSignUp: @escaping () -> Void) {
        self.init(viewModel: viewModel,
                  navigationTitle: navigationTitle,
                  emailPlaceholder: emailPlaceholder,
                  passwordPlaceholder: passwordPlaceholder,
                  signInLabel: signInLabel,
                  forgotPasswordLabel: forgotPasswordLabel,
                  noAccountLabel: noAccountLabel,
                  signUpLabel: signUpLabel,
                  errorAlertTitle: errorAlertTitle,
                  errorAlertDismissLabel: errorAlertDismissLabel,
                  onForgotPassword: onForgotPassword,
                  onSignUp: onSignUp,
                  socialContent: { EmptyView() })
    }
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *) extension ARCSignInView {
    private var emailSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            ARCTextField(emailPlaceholder,
                         text: $viewModel.email,
                         configuration: ARCTextFieldConfiguration(inputType: .email,
                                                                  label: emailPlaceholder,
                                                                  leadingIcon: "envelope",
                                                                  validation: .email,
                                                                  validateOnChange: true,
                                                                  autocapitalization: .never,
                                                                  autocorrection: false,
                                                                  submitLabel: .next))

            ARCSecureField(passwordPlaceholder,
                           text: $viewModel.password,
                           configuration: ARCTextFieldConfiguration(inputType: .password,
                                                                    label: passwordPlaceholder,
                                                                    leadingIcon: "lock",
                                                                    autocapitalization: .never,
                                                                    autocorrection: false,
                                                                    clearButton: .never))

            ARCButton(signInLabel,
                      isLoading: $viewModel.isLoading,
                      configuration: ARCButtonConfiguration(size: .large, isFullWidth: true)) {
                Task { await viewModel.signInWithEmail() }
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

    private var footerLinks: some View {
        VStack(spacing: .arcSpacingMedium) {
            ARCButton(forgotPasswordLabel,
                      configuration: ARCButtonConfiguration(style: .ghost, size: .small)) {
                onForgotPassword()
            }

            HStack(spacing: .arcSpacingXSmall) {
                Text(noAccountLabel)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                ARCButton(signUpLabel,
                          configuration: ARCButtonConfiguration(style: .ghost, size: .small)) {
                    onSignUp()
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Sign In - Dark") {
    let viewModel = ARCSignInViewModel(onSignInWithEmail: { _, _ in },
                                       onSignInWithApple: {},
                                       onSignInWithGoogle: {})
    return NavigationStack {
        ARCSignInView(viewModel: viewModel, onForgotPassword: {}, onSignUp: {})
    }
    .preferredColorScheme(.dark)
}

#Preview("Sign In - Light") {
    let viewModel = ARCSignInViewModel(onSignInWithEmail: { _, _ in },
                                       onSignInWithApple: {},
                                       onSignInWithGoogle: {})
    return NavigationStack {
        ARCSignInView(viewModel: viewModel, onForgotPassword: {}, onSignUp: {})
    }
    .preferredColorScheme(.light)
}
