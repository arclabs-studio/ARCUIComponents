//
//  ARCSignInViewModelTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import Testing
@testable import ARCUIComponents

// MARK: - Spy helper

private final class Spy<T: Sendable>: @unchecked Sendable {
    private(set) var values: [T] = []
    var callCount: Int {
        values.count
    }

    var wasCalled: Bool {
        !values.isEmpty
    }

    func record(_ value: T) {
        values.append(value)
    }
}

private final class Flag: @unchecked Sendable {
    private(set) var count = 0
    var wasCalled: Bool {
        !isEmpty
    }

    func increment() {
        count += 1
    }
}

// MARK: - Tests

@Suite("ARCSignInViewModel Tests")
@MainActor struct ARCSignInViewModelTests {
    // MARK: - Helpers

    private enum TestError: Error {
        case signInFailed
    }

    private func makeSUT(onSignInWithEmail: @escaping @Sendable (String, String) async throws -> Void = { _, _ in },
                         onSignInWithApple: @escaping @Sendable () async throws -> Void = {},
                         onSignInWithGoogle: @escaping @Sendable () async throws -> Void = {}) -> ARCSignInViewModel
    {
        ARCSignInViewModel(onSignInWithEmail: onSignInWithEmail,
                           onSignInWithApple: onSignInWithApple,
                           onSignInWithGoogle: onSignInWithGoogle)
    }

    // MARK: - Initialization

    @Test("init_withDefaultValues_setsCorrectInitialState") func init_withDefaultValues_setsCorrectInitialState() {
        let sut = makeSUT()

        #expect(sut.email.isEmpty)
        #expect(sut.password.isEmpty)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    // MARK: - signInWithEmail

    @Test("signInWithEmail_whenSucceeds_resetsLoadingState")
    func signInWithEmail_whenSucceeds_resetsLoadingState() async {
        let sut = makeSUT()
        sut.email = "user@example.com"
        sut.password = "password123"

        await sut.signInWithEmail()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("signInWithEmail_whenFails_setsErrorMessage") func signInWithEmail_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSignInWithEmail: { _, _ in throw TestError.signInFailed })

        await sut.signInWithEmail()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage != nil)
    }

    @Test("signInWithEmail_whenAlreadyLoading_doesNothing")
    func signInWithEmail_whenAlreadyLoading_doesNothing() async {
        let flag = Flag()
        let sut = makeSUT(onSignInWithEmail: { _, _ in flag.increment() })
        sut.isLoading = true

        await sut.signInWithEmail()

        #expect(flag.isEmpty)
    }

    @Test("signInWithEmail_passesEmailAndPasswordToAction")
    func signInWithEmail_passesEmailAndPasswordToAction() async {
        let spy = Spy<(String, String)>()
        let sut = makeSUT(onSignInWithEmail: { email, password in spy.record((email, password)) })
        sut.email = "test@arc.io"
        sut.password = "secret"

        await sut.signInWithEmail()

        #expect(spy.values.first?.0 == "test@arc.io")
        #expect(spy.values.first?.1 == "secret")
    }

    // MARK: - signInWithApple

    @Test("signInWithApple_whenSucceeds_resetsLoadingState")
    func signInWithApple_whenSucceeds_resetsLoadingState() async {
        let sut = makeSUT()

        await sut.signInWithApple()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("signInWithApple_whenFails_setsErrorMessage") func signInWithApple_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSignInWithApple: { throw TestError.signInFailed })

        await sut.signInWithApple()

        #expect(sut.errorMessage != nil)
    }

    @Test("signInWithApple_whenAlreadyLoading_doesNothing")
    func signInWithApple_whenAlreadyLoading_doesNothing() async {
        let flag = Flag()
        let sut = makeSUT(onSignInWithApple: { flag.increment() })
        sut.isLoading = true

        await sut.signInWithApple()

        #expect(flag.isEmpty)
    }

    // MARK: - signInWithGoogle

    @Test("signInWithGoogle_whenSucceeds_resetsLoadingState")
    func signInWithGoogle_whenSucceeds_resetsLoadingState() async {
        let sut = makeSUT()

        await sut.signInWithGoogle()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("signInWithGoogle_whenFails_setsErrorMessage") func signInWithGoogle_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSignInWithGoogle: { throw TestError.signInFailed })

        await sut.signInWithGoogle()

        #expect(sut.errorMessage != nil)
    }

    // MARK: - errorMessage dismissal

    @Test("errorMessage_canBeDismissedBySettingToNil") func errorMessage_canBeDismissedBySettingToNil() async {
        let sut = makeSUT(onSignInWithEmail: { _, _ in throw TestError.signInFailed })
        await sut.signInWithEmail()
        #expect(sut.errorMessage != nil)

        sut.errorMessage = nil

        #expect(sut.errorMessage == nil)
    }
}
