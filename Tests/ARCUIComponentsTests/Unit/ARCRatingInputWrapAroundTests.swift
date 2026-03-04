//
//  ARCRatingInputWrapAroundTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/10/26.
//

import Testing
@testable import ARCUIComponents

/// Unit tests for circular drag wrap-around prevention in ARCRatingInputView
///
/// When the user drags across the 12 o'clock boundary in circular drag mode,
/// the calculated rating jumps abruptly (e.g. 10→1 or 1→10). The
/// `applyWrapAroundClamping` function detects these jumps and clamps
/// to the nearest boundary instead.
@Suite("ARCRatingInputView Wrap-Around Tests")
@MainActor
struct ARCRatingInputWrapAroundTests {
    // MARK: - Constants

    private let minRating: Double = 1.0
    private let maxRating: Double = 10.0

    // MARK: - SUT

    private func makeSUT(newRating: Double,
                         currentRating: Double) -> Double {
        ARCRatingInputView.applyWrapAroundClamping(newRating: newRating,
                                                   currentRating: currentRating,
                                                   minRating: minRating,
                                                   maxRating: maxRating)
    }

    // MARK: - Boundary Crossing Tests

    @Test("applyWrapAroundClamping_currentNearMax_newNearMin_clampsToMax")
    func applyWrapAroundClamping_currentNearMax_newNearMin_clampsToMax() {
        // Given: user is at 9.5, drag crosses 12 o'clock → calculated rating jumps to 1.5
        // delta = 1.5 - 9.5 = -8.0, which is < -4.5

        // When
        let result = makeSUT(newRating: 1.5, currentRating: 9.5)

        // Then: clamps to maxRating instead of wrapping
        #expect(result == maxRating)
    }

    @Test("applyWrapAroundClamping_currentNearMin_newNearMax_clampsToMin")
    func applyWrapAroundClamping_currentNearMin_newNearMax_clampsToMin() {
        // Given: user is at 1.5, drag crosses 12 o'clock → calculated rating jumps to 9.5
        // delta = 9.5 - 1.5 = 8.0, which is > 4.5

        // When
        let result = makeSUT(newRating: 9.5, currentRating: 1.5)

        // Then: clamps to minRating instead of wrapping
        #expect(result == minRating)
    }

    // MARK: - Normal Drag Tests

    @Test("applyWrapAroundClamping_normalIncrementalDrag_updatesNormally")
    func applyWrapAroundClamping_normalIncrementalDrag_updatesNormally() {
        // Given: small incremental drag from 5.0 to 5.5
        // delta = 0.5, well within threshold

        // When
        let result = makeSUT(newRating: 5.5, currentRating: 5.0)

        // Then: passes through unchanged
        #expect(result == 5.5)
    }

    @Test("applyWrapAroundClamping_moderateJumpWithinThreshold_updatesNormally")
    func applyWrapAroundClamping_moderateJumpWithinThreshold_updatesNormally() {
        // Given: larger drag from 3.0 to 7.0
        // delta = 4.0, still within the 4.5 threshold

        // When
        let result = makeSUT(newRating: 7.0, currentRating: 3.0)

        // Then: passes through unchanged
        #expect(result == 7.0)
    }

    // MARK: - Threshold Boundary Tests

    @Test("applyWrapAroundClamping_deltaExactlyAtHalfRange_updatesNormally")
    func applyWrapAroundClamping_deltaExactlyAtHalfRange_updatesNormally() {
        // Given: delta is exactly 4.5 (half of range 9.0)
        // delta = 4.5, NOT greater than 4.5 → should pass through

        // When
        let result = makeSUT(newRating: 7.5, currentRating: 3.0)

        // Then: passes through (threshold is strictly greater-than)
        #expect(result == 7.5)
    }

    @Test("applyWrapAroundClamping_negativeDeltaExactlyAtHalfRange_updatesNormally")
    func applyWrapAroundClamping_negativeDeltaExactlyAtHalfRange_updatesNormally() {
        // Given: delta is exactly -4.5 (negative half of range)
        // delta = -4.5, NOT less than -4.5 → should pass through

        // When
        let result = makeSUT(newRating: 3.0, currentRating: 7.5)

        // Then: passes through (threshold is strictly less-than)
        #expect(result == 3.0)
    }

    @Test("applyWrapAroundClamping_deltaJustOverHalfRange_clampsToMin")
    func applyWrapAroundClamping_deltaJustOverHalfRange_clampsToMin() {
        // Given: delta is 5.0, just over the 4.5 threshold

        // When
        let result = makeSUT(newRating: 8.0, currentRating: 3.0)

        // Then: treated as boundary crossing, clamps to min
        #expect(result == minRating)
    }

    @Test("applyWrapAroundClamping_negativeDeltaJustOverHalfRange_clampsToMax")
    func applyWrapAroundClamping_negativeDeltaJustOverHalfRange_clampsToMax() {
        // Given: delta is -5.0, just past the -4.5 threshold

        // When
        let result = makeSUT(newRating: 3.0, currentRating: 8.0)

        // Then: treated as boundary crossing, clamps to max
        #expect(result == maxRating)
    }

    // MARK: - Edge Case Tests

    @Test("applyWrapAroundClamping_sameRating_updatesNormally")
    func applyWrapAroundClamping_sameRating_updatesNormally() {
        // Given: no change in rating

        // When
        let result = makeSUT(newRating: 5.0, currentRating: 5.0)

        // Then: passes through unchanged
        #expect(result == 5.0)
    }

    @Test("applyWrapAroundClamping_maxToMin_clampsToMax") func applyWrapAroundClamping_maxToMin_clampsToMax() {
        // Given: extreme case — exactly at max, new is exactly at min
        // delta = 1.0 - 10.0 = -9.0

        // When
        let result = makeSUT(newRating: 1.0, currentRating: 10.0)

        // Then: clamps to max
        #expect(result == maxRating)
    }

    @Test("applyWrapAroundClamping_minToMax_clampsToMin") func applyWrapAroundClamping_minToMax_clampsToMin() {
        // Given: extreme case — exactly at min, new is exactly at max
        // delta = 10.0 - 1.0 = 9.0

        // When
        let result = makeSUT(newRating: 10.0, currentRating: 1.0)

        // Then: clamps to min
        #expect(result == minRating)
    }
}
