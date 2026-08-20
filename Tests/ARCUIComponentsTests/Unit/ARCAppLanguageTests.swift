//
//  ARCAppLanguageTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import SwiftUI
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

    @Test("system title is System LocalizedStringKey") func systemTitle() {
        let expected: LocalizedStringKey = "System"
        #expect(ARCAppLanguage.system.title == expected)
    }

    @Test("spanish title is Spanish LocalizedStringKey") func spanishTitle() {
        let expected: LocalizedStringKey = "Spanish"
        #expect(ARCAppLanguage.spanish.title == expected)
    }

    @Test("english title is English LocalizedStringKey") func englishTitle() {
        let expected: LocalizedStringKey = "English"
        #expect(ARCAppLanguage.english.title == expected)
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
