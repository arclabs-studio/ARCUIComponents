//
//  ARCBottomSheetDetentTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import Testing
@testable import ARCUIComponents

/// Unit tests for ARCBottomSheetDetent
///
/// Tests height calculations, accessibility descriptions,
/// Comparable ordering, and Identifiable conformance.
@Suite("ARCBottomSheetDetent Tests") struct ARCBottomSheetDetentTests {
    // MARK: - Constants

    private let containerHeight: CGFloat = 1000

    // MARK: - Height Calculation: Predefined Detents

    @Test("small_height_returnsMaxOf120OrFifteenPercent") func small_height_returnsMaxOf120OrFifteenPercent() {
        // 15% of 1000 = 150, max(120, 150) = 150
        #expect(ARCBottomSheetDetent.small.height(in: containerHeight) == 150)
    }

    @Test("small_height_inSmallContainer_returns120Minimum") func small_height_inSmallContainer_returns120Minimum() {
        // 15% of 400 = 60, max(120, 60) = 120
        #expect(ARCBottomSheetDetent.small.height(in: 400) == 120)
    }

    @Test("medium_height_returnsFiftyPercent") func medium_height_returnsFiftyPercent() {
        #expect(ARCBottomSheetDetent.medium.height(in: containerHeight) == 500)
    }

    @Test("large_height_returnsNinetyPercent") func large_height_returnsNinetyPercent() {
        #expect(ARCBottomSheetDetent.large.height(in: containerHeight) == 900)
    }

    // MARK: - Height Calculation: Custom Detents

    @Test("fraction_height_returnsPercentOfContainer") func fraction_height_returnsPercentOfContainer() {
        let detent = ARCBottomSheetDetent.fraction(0.6)

        #expect(detent.height(in: containerHeight) == 600)
    }

    @Test("fraction_belowMinimum_clampsToTenPercent") func fraction_belowMinimum_clampsToTenPercent() {
        let detent = ARCBottomSheetDetent.fraction(0.0)

        // Clamped to 0.1 → 10% of 1000 = 100
        #expect(detent.height(in: containerHeight) == 100)
    }

    @Test("fraction_aboveMaximum_clampsToOneHundredPercent") func fraction_aboveMaximum_clampsToOneHundredPercent() {
        let detent = ARCBottomSheetDetent.fraction(1.5)

        // Clamped to 1.0 → 100% of 1000 = 1000
        #expect(detent.height(in: containerHeight) == 1000)
    }

    @Test("height_fixedValue_returnsExactHeight") func height_fixedValue_returnsExactHeight() {
        let detent = ARCBottomSheetDetent.height(300)

        #expect(detent.height(in: containerHeight) == 300)
    }

    @Test("height_exceedsContainer_clampsToNinetyFivePercent")
    func height_exceedsContainer_clampsToNinetyFivePercent() {
        let detent = ARCBottomSheetDetent.height(2000)

        // min(2000, 1000 * 0.95) = 950
        #expect(detent.height(in: containerHeight) == 950)
    }

    // MARK: - Accessibility Description

    @Test("small_accessibilityDescription_isCollapsed") func small_accessibilityDescription_isCollapsed() {
        #expect(ARCBottomSheetDetent.small.accessibilityDescription == "collapsed")
    }

    @Test("medium_accessibilityDescription_isHalfHeight") func medium_accessibilityDescription_isHalfHeight() {
        #expect(ARCBottomSheetDetent.medium.accessibilityDescription == "half height")
    }

    @Test("large_accessibilityDescription_isExpanded") func large_accessibilityDescription_isExpanded() {
        #expect(ARCBottomSheetDetent.large.accessibilityDescription == "expanded")
    }

    @Test("fraction_accessibilityDescription_showsPercentage")
    func fraction_accessibilityDescription_showsPercentage() {
        #expect(ARCBottomSheetDetent.fraction(0.75).accessibilityDescription == "75 percent")
    }

    @Test("height_accessibilityDescription_showsPoints") func height_accessibilityDescription_showsPoints() {
        #expect(ARCBottomSheetDetent.height(300).accessibilityDescription == "300 points")
    }

    // MARK: - Comparable Tests

    @Test("comparable_smallLessThanMedium") func comparable_smallLessThanMedium() {
        #expect(ARCBottomSheetDetent.small < ARCBottomSheetDetent.medium)
    }

    @Test("comparable_mediumLessThanLarge") func comparable_mediumLessThanLarge() {
        #expect(ARCBottomSheetDetent.medium < ARCBottomSheetDetent.large)
    }

    @Test("comparable_sortedArray_ordersCorrectly") func comparable_sortedArray_ordersCorrectly() {
        let detents: [ARCBottomSheetDetent] = [.large, .small, .medium]
        let sorted = detents.sorted()

        #expect(sorted == [.small, .medium, .large])
    }

    @Test("comparable_fractionBetweenPredefined") func comparable_fractionBetweenPredefined() {
        let fraction = ARCBottomSheetDetent.fraction(0.7)

        #expect(fraction > ARCBottomSheetDetent.medium)
        #expect(fraction < ARCBottomSheetDetent.large)
    }

    // MARK: - Identifiable Tests

    @Test("id_small_returnsSmall") func id_small_returnsSmall() {
        #expect(ARCBottomSheetDetent.small.id == "small")
    }

    @Test("id_medium_returnsMedium") func id_medium_returnsMedium() {
        #expect(ARCBottomSheetDetent.medium.id == "medium")
    }

    @Test("id_large_returnsLarge") func id_large_returnsLarge() {
        #expect(ARCBottomSheetDetent.large.id == "large")
    }

    @Test("id_fraction_returnsFractionPrefix") func id_fraction_returnsFractionPrefix() {
        #expect(ARCBottomSheetDetent.fraction(0.5).id == "fraction-0.5")
    }

    @Test("id_height_returnsHeightPrefix") func id_height_returnsHeightPrefix() {
        #expect(ARCBottomSheetDetent.height(300).id == "height-300.0")
    }

    // MARK: - Hashable Tests

    @Test("hashable_sameDetents_areEqual") func hashable_sameDetents_areEqual() {
        #expect(ARCBottomSheetDetent.small == ARCBottomSheetDetent.small)
        #expect(ARCBottomSheetDetent.medium == ARCBottomSheetDetent.medium)
        #expect(ARCBottomSheetDetent.large == ARCBottomSheetDetent.large)
    }

    @Test("hashable_differentDetents_areNotEqual") func hashable_differentDetents_areNotEqual() {
        #expect(ARCBottomSheetDetent.small != ARCBottomSheetDetent.medium)
    }

    @Test("hashable_sameFractions_areEqual") func hashable_sameFractions_areEqual() {
        #expect(ARCBottomSheetDetent.fraction(0.5) == ARCBottomSheetDetent.fraction(0.5))
    }

    @Test("hashable_differentFractions_areNotEqual") func hashable_differentFractions_areNotEqual() {
        #expect(ARCBottomSheetDetent.fraction(0.3) != ARCBottomSheetDetent.fraction(0.7))
    }
}
