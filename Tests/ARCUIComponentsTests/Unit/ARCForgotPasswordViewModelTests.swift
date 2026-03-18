//
//  ARCForgotPasswordViewModelTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import Testing
@testable import ARCUIComponents

// MARK: - Tests

@Suite("ARCForgotPasswordViewModel Tests")
@MainActor
struct ARCForgotPasswordViewModelTests {
    // MARK: - Helpers

    private enum TestError: Error {
        case resetFailed
    }

    private func makeSUT(onSendReset: @escaping @Sendable (String) async throws -> Void = { _ in
    }) -> ARCForgotPasswordViewModel {
        ARCForgotPasswordViewModel(onSendReset: onSendReset)
    }

    // MARK: - Initialization

    @Test("init_withDefaultValues_setsCorrectInitialState") func init_withDefaultValues_setsCorrectInitialState() {
        let sut = makeSUT()

        #expect(sut.email.isEmpty)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        #expect(sut.didSendReset == false)
    }

    // MARK: - sendReset

    @Test("sendReset_whenSucceeds_setsDIdSendResetToTrue") func sendReset_whenSucceeds_setsDIdSendResetToTrue() async {
        let sut = makeSUT()
        sut.email = "user@example.com"

        await sut.sendReset()

        #expect(sut.didSendReset == true)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("sendReset_whenFails_setsErrorMessage") func sendReset_whenFails_setsErrorMessage() async {
        let sut = makeSUT(onSendReset: { _ in throw TestError.resetFailed })
        sut.email = "user@example.com"

        await sut.sendReset()

        #expect(sut.didSendReset == false)
        #expect(sut.errorMessage != nil)
        #expect(sut.isLoading == false)
    }

    @Test("sendReset_whenAlreadyLoading_doesNothing") func sendReset_whenAlreadyLoading_doesNothing() async {
        let flag = Flag()
        let sut = makeSUT(onSendReset: { _ in flag.increment() })
        sut.isLoading = true

        await sut.sendReset()

        #expect(flag.isEmpty)
    }

    @Test("sendReset_passesEmailToAction") func sendReset_passesEmailToAction() async {
        let spy = Spy<String>()
        let sut = makeSUT(onSendReset: { email in spy.record(email) })
        sut.email = "reset@arc.io"

        await sut.sendReset()

        #expect(spy.values.first == "reset@arc.io")
    }

    // MARK: - errorMessage dismissal

    @Test("errorMessage_canBeDismissedBySettingToNil") func errorMessage_canBeDismissedBySettingToNil() async {
        let sut = makeSUT(onSendReset: { _ in throw TestError.resetFailed })
        await sut.sendReset()
        #expect(sut.errorMessage != nil)

        sut.errorMessage = nil

        #expect(sut.errorMessage == nil)
    }
}
