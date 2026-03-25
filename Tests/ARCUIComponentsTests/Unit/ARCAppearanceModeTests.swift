//
//  ARCAppearanceModeTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

@Suite("ARCAppearanceMode Tests")
struct ARCAppearanceModeTests {
    // MARK: - Cases

    @Test("All cases exist") func allCasesExist() {
        #expect(ARCAppearanceMode.allCases.count == 3)
        #expect(ARCAppearanceMode.allCases.contains(.system))
        #expect(ARCAppearanceMode.allCases.contains(.light))
        #expect(ARCAppearanceMode.allCases.contains(.dark))
    }

    // MARK: - Identifiable

    @Test("id equals rawValue", arguments: ARCAppearanceMode.allCases) func idEqualsRawValue(mode: ARCAppearanceMode) {
        #expect(mode.id == mode.rawValue)
    }

    // MARK: - Title

    @Test("system title is System LocalizedStringKey") func systemTitle() {
        let expected: LocalizedStringKey = "System"
        #expect(ARCAppearanceMode.system.title == expected)
    }

    @Test("light title is Light LocalizedStringKey") func lightTitle() {
        let expected: LocalizedStringKey = "Light"
        #expect(ARCAppearanceMode.light.title == expected)
    }

    @Test("dark title is Dark LocalizedStringKey") func darkTitle() {
        let expected: LocalizedStringKey = "Dark"
        #expect(ARCAppearanceMode.dark.title == expected)
    }

    // MARK: - Icon

    @Test("Each mode has a non-empty icon", arguments: ARCAppearanceMode.allCases)
    func iconIsNonEmpty(mode: ARCAppearanceMode) {
        #expect(!mode.icon.isEmpty)
    }

    @Test("system icon is circle.lefthalf.filled") func systemIcon() {
        #expect(ARCAppearanceMode.system.icon == "circle.lefthalf.filled")
    }

    @Test("light icon is sun.max.fill") func lightIcon() {
        #expect(ARCAppearanceMode.light.icon == "sun.max.fill")
    }

    @Test("dark icon is moon.fill") func darkIcon() {
        #expect(ARCAppearanceMode.dark.icon == "moon.fill")
    }

    // MARK: - ColorScheme

    @Test("system colorScheme is nil") func systemColorSchemeIsNil() {
        #expect(ARCAppearanceMode.system.colorScheme == nil)
    }

    @Test("light colorScheme is .light") func lightColorScheme() {
        #expect(ARCAppearanceMode.light.colorScheme == .light)
    }

    @Test("dark colorScheme is .dark") func darkColorScheme() {
        #expect(ARCAppearanceMode.dark.colorScheme == .dark)
    }

    // MARK: - Raw Value

    @Test("Raw value round-trip", arguments: ARCAppearanceMode.allCases)
    func rawValueRoundTrip(mode: ARCAppearanceMode) {
        #expect(ARCAppearanceMode(rawValue: mode.rawValue) == mode)
    }
}
