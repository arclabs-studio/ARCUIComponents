//
//  ARCSignInViewModel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import Foundation

// MARK: - ARCSignInViewModel

/// ViewModel for the sign-in screen.
///
/// Manages email/password fields, loading state, and error messages. Auth operations
/// are delegated to the closures supplied at init — wire them to your use cases or
/// repository calls in the consumer app.
///
/// ## Usage
///
/// ```swift
/// let viewModel = ARCSignInViewModel(
///     onSignInWithEmail: { email, password in
///         try await authRepository.signIn(email: email, password: password)
///     },
///     onSignInWithApple: {
///         try await authRepository.signInWithApple()
///     },
///     onSignInWithGoogle: {
///         try await authRepository.signInWithGoogle()
///     }
/// )
/// ```
@Observable @MainActor public final class ARCSignInViewModel { // swiftlint:disable:this observable_viewmodel
    // MARK: Properties

    /// Email address field value.
    public var email = ""

    /// Password field value.
    public var password = ""

    /// `true` while an auth operation is in progress.
    public var isLoading = false

    /// Localised error message to display in an alert. Set to `nil` to dismiss.
    public var errorMessage: String?

    // MARK: Private Properties

    private let onSignInWithEmail: @Sendable (String, String) async throws -> Void
    private let onSignInWithApple: @Sendable () async throws -> Void
    private let onSignInWithGoogle: @Sendable () async throws -> Void
    private let mapError: (Error) -> String

    // MARK: Initialization

    /// Creates a sign-in view model.
    ///
    /// - Parameters:
    ///   - onSignInWithEmail: Called with `(email, password)` when the user submits the email form.
    ///   - onSignInWithApple: Called when the user taps Sign in with Apple.
    ///   - onSignInWithGoogle: Called when the user taps Sign in with Google.
    ///   - errorMessage: Maps an `Error` to the string shown in the alert. Defaults to `localizedDescription`.
    public init(onSignInWithEmail: @escaping @Sendable (String, String) async throws -> Void,
                onSignInWithApple: @escaping @Sendable () async throws -> Void,
                onSignInWithGoogle: @escaping @Sendable () async throws -> Void,
                errorMessage: @escaping @Sendable (Error) -> String = { $0.localizedDescription }) {
        self.onSignInWithEmail = onSignInWithEmail
        self.onSignInWithApple = onSignInWithApple
        self.onSignInWithGoogle = onSignInWithGoogle
        mapError = errorMessage
    }

    // MARK: Actions

    /// Initiates email/password sign-in using the stored `email` and `password` values.
    public func signInWithEmail() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await onSignInWithEmail(email, password)
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
