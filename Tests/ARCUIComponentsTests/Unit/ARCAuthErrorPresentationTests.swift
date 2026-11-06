//
//  ARCAuthErrorPresentationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 06/11/26.
//

import Testing
@testable import ARCUIComponents

@Suite("Auth view models error presentation")
@MainActor
struct ARCAuthErrorPresentationTests {
    @Test("signIn_isShowingError_tracksAndClearsErrorMessage") func signIn_isShowingError_tracksAndClearsErrorMessage() {
        let sut = ARCSignInViewModel(onSignInWithEmail: { _, _ in },
                                     onSignInWithApple: {},
                                     onSignInWithGoogle: {})
        #expect(sut.isShowingError == false)

        sut.errorMessage = "Failed"
        #expect(sut.isShowingError)

        sut.isShowingError = false
        #expect(sut.errorMessage == nil)
    }

    @Test("signUp_isShowingError_tracksAndClearsErrorMessage") func signUp_isShowingError_tracksAndClearsErrorMessage() {
        let sut = ARCSignUpViewModel(onSignUpWithEmail: { _, _ in },
                                     onSignInWithApple: {},
                                     onSignInWithGoogle: {})
        sut.errorMessage = "Failed"
        #expect(sut.isShowingError)

        sut.isShowingError = false
        #expect(sut.errorMessage == nil)
    }

    @Test("forgotPassword_isShowingError_tracksAndClearsErrorMessage")
    func forgotPassword_isShowingError_tracksAndClearsErrorMessage() {
        let sut = ARCForgotPasswordViewModel(onSendReset: { _ in })
        sut.errorMessage = "Failed"
        #expect(sut.isShowingError)

        sut.isShowingError = true
        #expect(sut.errorMessage == "Failed")

        sut.isShowingError = false
        #expect(sut.errorMessage == nil)
    }
}
