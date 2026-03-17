//
//  ARCSignUpViewModel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import Foundation

// MARK: - ARCSignUpViewModel

/// ViewModel for the sign-up screen.
///
/// Manages email, password, and confirm-password fields, loading state, and error messages.
/// Validates that both password fields match before calling the registration closure.
/// Social sign-in closures allow the same screen to onboard users via Apple or Google.
///
/// ## Usage
///
/// ```swift
/// let viewModel = ARCSignUpViewModel(
///     onSignUpWithEmail: { email, password in
///         try await authRepository.signUp(email: email, password: password)
///     },
///     onSignInWithApple: {
///         try await authRepository.signInWithApple()
///     },
///     onSignInWithGoogle: {
///         try await authRepository.signInWithGoogle()
///     }
/// )
/// ```
@Observable @MainActor public final class ARCSignUpViewModel { // swiftlint:disable:this observable_viewmodel
    // MARK: Properties

    /// Email address field value.
    public var email = ""

    /// Password field value.
    public var password = ""

    /// Confirm password field value.
    public var confirmPassword = ""

    /// `true` while an auth operation is in progress.
    public var isLoading = false

    /// Localised error message to display in an alert. Set to `nil` to dismiss.
    public var errorMessage: String?

    // MARK: Private Properties

    private let onSignUpWithEmail: @Sendable (String, String) async throws -> Void
    private let onSignInWithApple: @Sendable () async throws -> Void
    private let onSignInWithGoogle: @Sendable () async throws -> Void
    private let mapError: (Error) -> String

    // MARK: Initialization

    /// Creates a sign-up view model.
    ///
    /// - Parameters:
    ///   - onSignUpWithEmail: Called with `(email, password)` when the user submits the registration form.
    ///   - onSignInWithApple: Called when the user taps Sign up with Apple.
    ///   - onSignInWithGoogle: Called when the user taps Sign up with Google.
    ///   - errorMessage: Maps an `Error` to the string shown in the alert. Defaults to `localizedDescription`.
    public init(onSignUpWithEmail: @escaping @Sendable (String, String) async throws -> Void,
                onSignInWithApple: @escaping @Sendable () async throws -> Void,
                onSignInWithGoogle: @escaping @Sendable () async throws -> Void,
                errorMessage: @escaping @Sendable (Error) -> String = { $0.localizedDescription }) {
        self.onSignUpWithEmail = onSignUpWithEmail
        self.onSignInWithApple = onSignInWithApple
        self.onSignInWithGoogle = onSignInWithGoogle
        mapError = errorMessage
    }

    // MARK: Actions

    /// Validates matching passwords then initiates email/password registration.
    public func signUpWithEmail() async {
        guard !isLoading else { return }
        guard password == confirmPassword else {
            errorMessage = String(localized: "Passwords do not match")
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await onSignUpWithEmail(email, password)
        } catch {
            errorMessage = mapError(error)
        }
    }

    /// Initiates Sign in with Apple.
    public func signInWithApple() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await onSignInWithApple()
        } catch {
            errorMessage = mapError(error)
        }
    }

    /// Initiates Sign in with Google.
    public func signInWithGoogle() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await onSignInWithGoogle()
        } catch {
            errorMessage = mapError(error)
        }
    }
}
