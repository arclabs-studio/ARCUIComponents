//
//  ARCAIRecommenderTextBuilderTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 06/11/26.
//

import Testing
@testable import ARCUIComponents

@Suite("ARCAIRecommenderConfiguration text builders")
struct ARCAIRecommenderTextBuilderTests {
    // MARK: - Card Accessibility Label

    @Test("cardAccessibilityLabel_default_readsPositionAndTotal") func cardAccessibilityLabel_default_readsPositionAndTotal() {
        // Given
        let sut = ARCAIRecommenderConfiguration()

        // When
        let label = sut.cardAccessibilityLabel(2, 5)

        // Then
        #expect(label == "Recommendations, card 2 of 5")
    }

    @Test("cardAccessibilityLabel_withClosure_usesClosure") func cardAccessibilityLabel_withClosure_usesClosure() {
        // Given
        let sut = ARCAIRecommenderConfiguration(cardAccessibilityLabel: { "Match \($0)/\($1)" })

        // When
        let label = sut.cardAccessibilityLabel(3, 7)

        // Then
        #expect(label == "Match 3/7")
    }

    // MARK: - Questionnaire Progress

    @Test("questionnaireProgress_default_readsAnsweredAndTotal") func questionnaireProgress_default_readsAnsweredAndTotal() {
        // Given
        let sut = ARCAIRecommenderConfiguration()

        // When
        let text = sut.questionnaireProgress(2, 5)

        // Then
        #expect(text == "2 of 5 answered")
    }

    @Test("questionnaireProgress_withClosure_usesClosure") func questionnaireProgress_withClosure_usesClosure() {
        // Given
        let sut = ARCAIRecommenderConfiguration(questionnaireProgress: { "\($0)/\($1) done" })

        // When
        let text = sut.questionnaireProgress(1, 3)

        // Then
        #expect(text == "1/3 done")
    }
}
