//
//  ARCSignUpViewModelTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import Testing
@testable import ARCUIComponents

// MARK: - Tests

@Suite("ARCSignUpViewModel Tests")
@MainActor
struct ARCSignUpViewModelTests {
    // MARK: - Helpers

    private enum TestError: Error {
        case signUpFailed
    }

    private func makeSUT(onSignUpWithEmail: @escaping @Sendable (String, String) async throws -> Void = { _, _ in },
                         onSignInWithApple: @escaping @Sendable () async throws -> Void = {},
                         onSignInWithGoogle: @escaping @Sendable () async throws -> Void = {}) -> ARCSignUpViewModel {
        ARCSignUpViewModel(onSignUpWithEmail: onSignUpWithEmail,
                           onSignInWithApple: onSignInWithApple,
                           onSignInWithGoogle: onSignInWithGoogle)
    }

    // MARK: - Initialization

    @Test("init_withDefaultValues_setsCorrectInitialState") func init_withDefaultValues_setsCorrectInitialState() {
        let sut = makeSUT()

        #expect(sut.email.isEmpty)
        #expect(sut.password.isEmpty)
        #expect(sut.confirmPassword.isEmpty)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    // MARK: - signUpWithEmail — password validation

    @Test("signUpWithEmail_whenPasswordsDontMatch_setsErrorMessage")
    func signUpWithEmail_whenPasswordsDontMatch_setsErrorMessage() async {
        let sut = makeSUT()
        sut.email = "user@example.com"
        sut.password = "password123"
        sut.confirmPassword = "different"

        await sut.signUpWithEmail()

        #expect(sut.errorMessage != nil)
        #expect(sut.isLoading == false)
    }

    @Test("signUpWithEmail_whenPasswordsDontMatch_doesNotCallAction")
    func signUpWithEmail_whenPasswordsDontMatch_doesNotCallAction() async {
        let flag = Flag()
        let sut = makeSUT(onSignUpWithEmail: { _, _ in flag.increment() })
        sut.password = "abc"
        sut.confirmPassword = "xyz"

        await sut.signUpWithEmail()

        #expect(flag.isEmpty)
    }

    @Test("signUpWithEmail_whenPasswordsMatch_callsAction")
    func signUpWithEmail_whenPasswordsMatch_callsAction() async {
        let flag = Flag()
        let sut = makeSUT(onSignUpWithEmail: { _, _ in flag.increment() })
        sut.email = "user@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"

        await sut.signUpWithEmail()

        #expect(flag.count == 1)
    }

    @Test("signUpWithEmail_whenSucceeds_resetsLoadingState")
    func signUpWithEmail_whenSucceeds_resetsLoadingState() async {
        let sut = makeSUT()
        sut.password = "pass"
        sut.confirmPassword = "pass"

        await sut.signUpWithEmail()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("signUpWithEmail_whenFails_setsErrorMessage") func signUpWithEmail_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSignUpWithEmail: { _, _ in throw TestError.signUpFailed })
        sut.password = "pass"
        sut.confirmPassword = "pass"

        await sut.signUpWithEmail()

        #expect(sut.errorMessage != nil)
        #expect(sut.isLoading == false)
    }

    @Test("signUpWithEmail_whenAlreadyLoading_doesNothing")
    func signUpWithEmail_whenAlreadyLoading_doesNothing() async {
        let flag = Flag()
        let sut = makeSUT(onSignUpWithEmail: { _, _ in flag.increment() })
        sut.isLoading = true
        sut.password = "pass"
        sut.confirmPassword = "pass"

        await sut.signUpWithEmail()

        #expect(flag.isEmpty)
    }

    @Test("signUpWithEmail_passesEmailAndPasswordToAction")
    func signUpWithEmail_passesEmailAndPasswordToAction() async {
        let spy = Spy<(String, String)>()
        let sut = makeSUT(onSignUpWithEmail: { email, password in spy.record((email, password)) })
        sut.email = "new@arc.io"
        sut.password = "mySecret"
        sut.confirmPassword = "mySecret"

        await sut.signUpWithEmail()

        #expect(spy.values.first?.0 == "new@arc.io")
        #expect(spy.values.first?.1 == "mySecret")
    }

    // MARK: - signInWithApple

    @Test("signInWithApple_whenAlreadyLoading_doesNothing")
    func signInWithApple_whenAlreadyLoading_doesNothing() async {
        let flag = Flag()
        let sut = makeSUT(onSignInWithApple: { flag.increment() })
        sut.isLoading = true

        await sut.signInWithApple()

        #expect(flag.isEmpty)
    }

    @Test("signInWithApple_whenSucceeds_resetsLoadingState")
    func signInWithApple_whenSucceeds_resetsLoadingState() async {
        let sut = makeSUT()

        await sut.signInWithApple()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("signInWithApple_whenFails_setsErrorMessage") func signInWithApple_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSignInWithApple: { throw TestError.signUpFailed })

        await sut.signInWithApple()

        #expect(sut.errorMessage != nil)
    }

    // MARK: - signInWithGoogle

    @Test("signInWithGoogle_whenAlreadyLoading_doesNothing")
    func signInWithGoogle_whenAlreadyLoading_doesNothing() async {
        let flag = Flag()
        let sut = makeSUT(onSignInWithGoogle: { flag.increment() })
        sut.isLoading = true

        await sut.signInWithGoogle()

        #expect(flag.isEmpty)
    }

    @Test("signInWithGoogle_whenSucceeds_resetsLoadingState")
    func signInWithGoogle_whenSucceeds_resetsLoadingState() async {
        let sut = makeSUT()

        await sut.signInWithGoogle()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("signInWithGoogle_whenFails_setsErrorMessage") func signInWithGoogle_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSignInWithGoogle: { throw TestError.signUpFailed })

        await sut.signInWithGoogle()

        #expect(sut.errorMessage != nil)
    }

    // MARK: - errorMessage dismissal

    @Test("errorMessage_canBeDismissedBySettingToNil") func errorMessage_canBeDismissedBySettingToNil() async {
        let sut = makeSUT(onSignUpWithEmail: { _, _ in throw TestError.signUpFailed })
        sut.password = "pass"
        sut.confirmPassword = "pass"
        await sut.signUpWithEmail()
        #expect(sut.errorMessage != nil)

        sut.errorMessage = nil

        #expect(sut.errorMessage == nil)
    }
}
