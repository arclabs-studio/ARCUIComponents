//
//  ARCRatingColorMapperTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCRatingColorMapper
///
/// Validates that the shared color mapping, gradient mapping, and
/// formatting logic works correctly at all boundary thresholds.
@Suite("ARCRatingColorMapper Tests")
struct ARCRatingColorMapperTests {
    // MARK: - Color Tests

    @Test("color_forLowRating_returnsRed")
    func color_forLowRating_returnsRed() {
        // Given: rating in the 0-30% range (1.0 / 10.0 = 10%)
        let color = ARCRatingColorMapper.color(for: 1.0)

        // Then
        #expect(color == .red)
    }

    @Test("color_forFairRating_returnsOrange")
    func color_forFairRating_returnsOrange() {
        // Given: rating in the 30-50% range (4.0 / 10.0 = 40%)
        let color = ARCRatingColorMapper.color(for: 4.0)

        // Then
        #expect(color == .orange)
    }

    @Test("color_forGoodRating_returnsYellow")
    func color_forGoodRating_returnsYellow() {
        // Given: rating in the 50-65% range (5.5 / 10.0 = 55%)
        let color = ARCRatingColorMapper.color(for: 5.5)

        // Then
        #expect(color == .yellow)
    }

    @Test("color_forGreatRating_returnsLimeGreen")
    func color_forGreatRating_returnsLimeGreen() {
        // Given: rating in the 65-75% range (7.0 / 10.0 = 70%)
        let color = ARCRatingColorMapper.color(for: 7.0)

        // Then
        #expect(color == Color(red: 0.6, green: 0.75, blue: 0.2))
    }

    @Test("color_forVeryGoodRating_returnsGreen")
    func color_forVeryGoodRating_returnsGreen() {
        // Given: rating in the 75-85% range (8.0 / 10.0 = 80%)
        let color = ARCRatingColorMapper.color(for: 8.0)

        // Then
        #expect(color == Color(red: 0.3, green: 0.75, blue: 0.3))
    }

    @Test("color_forExcellentRating_returnsStrongGreen")
    func color_forExcellentRating_returnsStrongGreen() {
        // Given: rating in the 85-100% range (9.5 / 10.0 = 95%)
        let color = ARCRatingColorMapper.color(for: 9.5)

        // Then
        #expect(color == Color(red: 0.1, green: 0.65, blue: 0.2))
    }

    // MARK: - Color Boundary Tests

    @Test("color_atExactly30Percent_returnsOrange")
    func color_atExactly30Percent_returnsOrange() {
        // Given: exactly at the 30% boundary (3.0 / 10.0)
        let color = ARCRatingColorMapper.color(for: 3.0)

        // Then: 0.3 is in [0.3, 0.5) range
        #expect(color == .orange)
    }

    @Test("color_atExactly50Percent_returnsYellow")
    func color_atExactly50Percent_returnsYellow() {
        // Given: exactly at the 50% boundary (5.0 / 10.0)
        let color = ARCRatingColorMapper.color(for: 5.0)

        // Then: 0.5 is in [0.5, 0.65) range
        #expect(color == .yellow)
    }

    @Test("color_atExactly85Percent_returnsStrongGreen")
    func color_atExactly85Percent_returnsStrongGreen() {
        // Given: exactly at the 85% boundary (8.5 / 10.0)
        let color = ARCRatingColorMapper.color(for: 8.5)

        // Then: 0.85 falls into the default (>=0.85) range
        #expect(color == Color(red: 0.1, green: 0.65, blue: 0.2))
    }

    // MARK: - Custom Max Rating Tests

    @Test("color_withCustomMaxRating_normalizesCorrectly")
    func color_withCustomMaxRating_normalizesCorrectly() {
        // Given: rating of 4 out of 5 = 80%, which is in the 75-85% range
        let color = ARCRatingColorMapper.color(for: 4.0, maxRating: 5.0)

        // Then
        #expect(color == Color(red: 0.3, green: 0.75, blue: 0.3))
    }

    @Test("color_withZeroMaxRating_returnsRed")
    func color_withZeroMaxRating_returnsRed() {
        // Given: edge case — zero max rating
        let color = ARCRatingColorMapper.color(for: 5.0, maxRating: 0)

        // Then: normalized = 0, falls in 0 ..< 0.3
        #expect(color == .red)
    }

    // MARK: - Formatting Tests

    @Test("formatted_wholeNumber_omitsDecimal")
    func formatted_wholeNumber_omitsDecimal() {
        #expect(ARCRatingColorMapper.formatted(9.0) == "9")
    }

    @Test("formatted_halfStep_showsOneDecimal")
    func formatted_halfStep_showsOneDecimal() {
        #expect(ARCRatingColorMapper.formatted(8.5) == "8.5")
    }

    @Test("formatted_one_showsWithoutDecimal")
    func formatted_one_showsWithoutDecimal() {
        #expect(ARCRatingColorMapper.formatted(1.0) == "1")
    }

    @Test("formatted_ten_showsWithoutDecimal")
    func formatted_ten_showsWithoutDecimal() {
        #expect(ARCRatingColorMapper.formatted(10.0) == "10")
    }

    @Test("formatted_halfValue_showsDecimal")
    func formatted_halfValue_showsDecimal() {
        #expect(ARCRatingColorMapper.formatted(5.5) == "5.5")
    }

    // MARK: - Gradient Tests

    //
    // LinearGradient does not conform to Equatable, so we verify
    // that gradient returns a value for each threshold range.
    // The underlying normalization logic is validated by the color tests.

    @Test("gradient_forEachRange_returnsGradient")
    func gradient_forEachRange_returnsGradient() {
        // Verify gradient is produced for each color range without crashing
        let ratings: [Double] = [1.0, 4.0, 5.5, 7.0, 8.0, 9.5]
        for rating in ratings {
            let _: LinearGradient = ARCRatingColorMapper.gradient(for: rating)
        }
    }

    @Test("gradient_withCustomMaxRating_returnsGradient")
    func gradient_withCustomMaxRating_returnsGradient() {
        let _: LinearGradient = ARCRatingColorMapper.gradient(for: 2.0, maxRating: 5.0)
    }
}
