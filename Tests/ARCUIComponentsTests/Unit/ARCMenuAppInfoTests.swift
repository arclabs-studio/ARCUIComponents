//
//  ARCMenuAppInfoTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import Foundation
import Testing
@testable import ARCUIComponents

@Suite("ARCMenuAppInfo Tests")
struct ARCMenuAppInfoTests {
    // MARK: - Initialization

    @Test("Init with all parameters stores values correctly") func initWithAllParameters() {
        // Given
        let privacyURL = URL(string: "https://example.com/privacy")
        let termsURL = URL(string: "https://example.com/terms")

        // When
        let sut = ARCMenuAppInfo(appName: "TestApp",
                                 appIcon: "star.fill",
                                 appSubtitle: "A test app",
                                 feedbackEmail: "test@example.com",
                                 privacyURL: privacyURL,
                                 termsURL: termsURL,
                                 studioName: "Test Studio")

        // Then
        #expect(sut.appName == "TestApp")
        #expect(sut.appIcon == "star.fill")
        #expect(sut.appSubtitle == "A test app")
        #expect(sut.feedbackEmail == "test@example.com")
        #expect(sut.privacyURL == privacyURL)
        #expect(sut.termsURL == termsURL)
        #expect(sut.studioName == "Test Studio")
    }

    @Test("Init with defaults provides correct studioName") func initWithDefaults() {
        // When
        let sut = ARCMenuAppInfo(appName: "App",
                                 appIcon: "gear",
                                 feedbackEmail: "email@test.com")

        // Then
        #expect(sut.studioName == "ARC Labs Studio")
        #expect(sut.appSubtitle == nil)
        #expect(sut.privacyURL == nil)
        #expect(sut.termsURL == nil)
    }

    // MARK: - Computed Properties

    @Test("appVersion returns a non-empty string") func appVersionReturnsValue() {
        // Given
        let sut = makeSUT()

        // When
        let version = sut.appVersion

        // Then
        #expect(!version.isEmpty)
    }

    @Test("buildNumber returns a non-empty string") func buildNumberReturnsValue() {
        // Given
        let sut = makeSUT()

        // When
        let build = sut.buildNumber

        // Then
        #expect(!build.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT() -> ARCMenuAppInfo {
        ARCMenuAppInfo(appName: "TestApp",
                       appIcon: "star.fill",
                       feedbackEmail: "test@example.com")
    }
}
