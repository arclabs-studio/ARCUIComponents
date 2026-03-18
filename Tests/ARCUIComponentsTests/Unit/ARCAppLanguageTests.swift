//
//  ARCAppLanguageTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import Testing
@testable import ARCUIComponents

@Suite("ARCAppLanguage Tests")
struct ARCAppLanguageTests {
    // MARK: - Cases

    @Test("All cases exist") func allCasesExist() {
        #expect(ARCAppLanguage.allCases.count == 3)
        #expect(ARCAppLanguage.allCases.contains(.system))
        #expect(ARCAppLanguage.allCases.contains(.spanish))
        #expect(ARCAppLanguage.allCases.contains(.english))
    }

    // MARK: - Identifiable

    @Test("id equals rawValue", arguments: ARCAppLanguage.allCases) func idEqualsRawValue(language: ARCAppLanguage) {
        #expect(language.id == language.rawValue)
    }

    // MARK: - Title

    @Test("system title is Sistema") func systemTitle() {
        #expect(ARCAppLanguage.system.title == "Sistema")
    }

    @Test("spanish title is Español") func spanishTitle() {
        #expect(ARCAppLanguage.spanish.title == "Español")
    }

    @Test("english title is English") func englishTitle() {
        #expect(ARCAppLanguage.english.title == "English")
    }

    // MARK: - Icon

    @Test("Each language has a non-empty icon", arguments: ARCAppLanguage.allCases)
    func iconIsNonEmpty(language: ARCAppLanguage) {
        #expect(!language.icon.isEmpty)
    }

    @Test("system icon is iphone") func systemIcon() {
        #expect(ARCAppLanguage.system.icon == "iphone")
    }

    @Test("spanish icon is globe.americas.fill") func spanishIcon() {
        #expect(ARCAppLanguage.spanish.icon == "globe.americas.fill")
    }

    @Test("english icon is globe.europe.africa.fill") func englishIcon() {
        #expect(ARCAppLanguage.english.icon == "globe.europe.africa.fill")
    }

    // MARK: - Raw Value

    @Test("Raw value round-trip", arguments: ARCAppLanguage.allCases) func rawValueRoundTrip(language: ARCAppLanguage) {
        #expect(ARCAppLanguage(rawValue: language.rawValue) == language)
    }
}
