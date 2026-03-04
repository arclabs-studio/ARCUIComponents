//
//  ARCToastTypeTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCToastType
///
/// Tests icon, color, accessibilityPrefix, Equatable, and Hashable.
@Suite("ARCToastType Tests")
struct ARCToastTypeTests {
    // MARK: - Icon Tests

    @Test("success_hasCheckmarkIcon") func success_hasCheckmarkIcon() {
        #expect(ARCToastType.success.icon == "checkmark.circle.fill")
    }

    @Test("error_hasXmarkIcon") func error_hasXmarkIcon() {
        #expect(ARCToastType.error.icon == "xmark.circle.fill")
    }

    @Test("warning_hasTriangleIcon") func warning_hasTriangleIcon() {
        #expect(ARCToastType.warning.icon == "exclamationmark.triangle.fill")
    }

    @Test("info_hasInfoIcon") func info_hasInfoIcon() {
        #expect(ARCToastType.info.icon == "info.circle.fill")
    }

    @Test("custom_hasCustomIcon") func custom_hasCustomIcon() {
        let sut = ARCToastType.custom(icon: "star.fill", color: .purple)

        #expect(sut.icon == "star.fill")
    }

    // MARK: - Color Tests

    @Test("success_hasGreenColor") func success_hasGreenColor() {
        #expect(ARCToastType.success.color == .green)
    }

    @Test("error_hasRedColor") func error_hasRedColor() {
        #expect(ARCToastType.error.color == .red)
    }

    @Test("warning_hasOrangeColor") func warning_hasOrangeColor() {
        #expect(ARCToastType.warning.color == .orange)
    }

    @Test("info_hasBlueColor") func info_hasBlueColor() {
        #expect(ARCToastType.info.color == .blue)
    }

    @Test("custom_hasCustomColor") func custom_hasCustomColor() {
        let sut = ARCToastType.custom(icon: "star", color: .purple)

        #expect(sut.color == .purple)
    }

    // MARK: - Accessibility Prefix Tests

    @Test("success_hasSuccessPrefix") func success_hasSuccessPrefix() {
        #expect(ARCToastType.success.accessibilityPrefix == "Success")
    }

    @Test("error_hasErrorPrefix") func error_hasErrorPrefix() {
        #expect(ARCToastType.error.accessibilityPrefix == "Error")
    }

    @Test("warning_hasWarningPrefix") func warning_hasWarningPrefix() {
        #expect(ARCToastType.warning.accessibilityPrefix == "Warning")
    }

    @Test("info_hasInformationPrefix") func info_hasInformationPrefix() {
        #expect(ARCToastType.info.accessibilityPrefix == "Information")
    }

    @Test("custom_hasNotificationPrefix") func custom_hasNotificationPrefix() {
        let sut = ARCToastType.custom(icon: "star", color: .purple)

        #expect(sut.accessibilityPrefix == "Notification")
    }

    // MARK: - Equatable Tests

    @Test("equatable_sameCase_areEqual") func equatable_sameCase_areEqual() {
        #expect(ARCToastType.success == ARCToastType.success)
        #expect(ARCToastType.error == ARCToastType.error)
        #expect(ARCToastType.warning == ARCToastType.warning)
        #expect(ARCToastType.info == ARCToastType.info)
    }

    @Test("equatable_differentCases_areNotEqual") func equatable_differentCases_areNotEqual() {
        #expect(ARCToastType.success != ARCToastType.error)
        #expect(ARCToastType.warning != ARCToastType.info)
    }

    @Test("equatable_customSameIcon_areEqual") func equatable_customSameIcon_areEqual() {
        let lhs = ARCToastType.custom(icon: "star", color: .red)
        let rhs = ARCToastType.custom(icon: "star", color: .blue)

        // Equatable compares by icon only, not color
        #expect(lhs == rhs)
    }

    @Test("equatable_customDifferentIcon_areNotEqual") func equatable_customDifferentIcon_areNotEqual() {
        let lhs = ARCToastType.custom(icon: "star", color: .red)
        let rhs = ARCToastType.custom(icon: "heart", color: .red)

        #expect(lhs != rhs)
    }

    @Test("equatable_customVsPredefined_areNotEqual") func equatable_customVsPredefined_areNotEqual() {
        let custom = ARCToastType.custom(icon: "checkmark.circle.fill", color: .green)

        #expect(custom != ARCToastType.success)
    }

    // MARK: - Hashable Tests

    @Test("hashable_sameCases_produceSameHash") func hashable_sameCases_produceSameHash() {
        var set: Set<ARCToastType> = []
        set.insert(.success)
        set.insert(.success)

        #expect(set.count == 1)
    }

    @Test("hashable_differentCases_produceDifferentHash") func hashable_differentCases_produceDifferentHash() {
        let set: Set<ARCToastType> = [.success, .error, .warning, .info]

        #expect(set.count == 4)
    }

    @Test("hashable_customSameIcon_produceSameHash") func hashable_customSameIcon_produceSameHash() {
        var set: Set<ARCToastType> = []
        set.insert(.custom(icon: "star", color: .red))
        set.insert(.custom(icon: "star", color: .blue))

        #expect(set.count == 1)
    }

    @Test("hashable_customDifferentIcons_produceDifferentHash")
    func hashable_customDifferentIcons_produceDifferentHash() {
        let set: Set<ARCToastType> = [.custom(icon: "star", color: .red),
                                      .custom(icon: "heart", color: .red)]

        #expect(set.count == 2)
    }
}
