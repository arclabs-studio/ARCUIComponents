//
//  ARCForgotPasswordViewModel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import Foundation

// MARK: - ARCForgotPasswordViewModel

/// ViewModel for the forgot-password screen.
///
/// Manages the email field, loading state, error messages, and the
/// `didSendReset` flag that switches the view from the input state to the
/// success confirmation state.
///
/// ## Usage
///
/// ```swift
/// let viewModel = ARCForgotPasswordViewModel(
///     onSendReset: { email in
///         try await authRepository.sendPasswordReset(to: email)
///     }
/// )
/// ```
@Observable @MainActor public final class ARCForgotPasswordViewModel { // swiftlint:disable:this observable_viewmodel
    // MARK: Properties

    /// Email address field value.
    public var email = ""

    /// `true` while the password-reset request is in progress.
    public var isLoading = false

    /// Localised error message to display in an alert. Set to `nil` to dismiss.
    public var errorMessage: String?

    /// `true` after a successful password-reset email dispatch.
    /// When `true`, the view switches to the success confirmation state.
    public var didSendReset = false

    // MARK: Private Properties

    private let onSendReset: @Sendable (String) async throws -> Void

    // MARK: Initialization

    /// Creates a forgot-password view model.
    ///
    /// - Parameter onSendReset: Called with the user's email address to trigger the password-reset flow.
    public init(onSendReset: @escaping @Sendable (String) async throws -> Void) {
        self.onSendReset = onSendReset
    }

    // MARK: Actions

    /// Sends a password-reset email to the address in `email`.
    public func sendReset() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await onSendReset(email)
            didSendReset = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
