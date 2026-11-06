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

    @Test("cardAccessibilityLabel_withLegacyFormat_honoursFormat") func cardAccessibilityLabel_withLegacyFormat_honoursFormat() {
        // Given
        let sut = ARCAIRecommenderConfiguration(cardAccessibilityLabelFormat: "Result %lld of %lld")

        // When
        let label = sut.cardAccessibilityLabel(1, 4)

        // Then
        #expect(label == "Result 1 of 4")
    }

    @Test("cardAccessibilityLabel_withClosureAndFormat_prefersClosure") func cardAccessibilityLabel_withClosureAndFormat_prefersClosure() {
        // Given
        let sut = ARCAIRecommenderConfiguration(cardAccessibilityLabelFormat: "Result %lld of %lld",
                                                cardAccessibilityLabel: { position, _ in "Card \(position)" })

        // When
        let label = sut.cardAccessibilityLabel(2, 9)

        // Then
        #expect(label == "Card 2")
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

    @Test("questionnaireProgress_withLegacyFormat_honoursFormat") func questionnaireProgress_withLegacyFormat_honoursFormat() {
        // Given
        let sut = ARCAIRecommenderConfiguration(questionnaireProgressFormat: "%lld answered out of %lld")

        // When
        let text = sut.questionnaireProgress(4, 6)

        // Then
        #expect(text == "4 answered out of 6")
    }

    // MARK: - Deprecated Accessors

    @available(*, deprecated, message: "Exercises the deprecated format-string accessors")
    @Test("deprecatedFormatAccessors_returnLegacyFormatOrDefault") func deprecatedFormatAccessors_returnLegacyFormatOrDefault() {
        // Given
        let custom = ARCAIRecommenderConfiguration(cardAccessibilityLabelFormat: "Item %lld of %lld",
                                                   questionnaireProgressFormat: "%lld/%lld")
        let defaults = ARCAIRecommenderConfiguration()

        // Then
        #expect(custom.cardAccessibilityLabelFormat == "Item %lld of %lld")
        #expect(custom.questionnaireProgressFormat == "%lld/%lld")
        #expect(defaults.cardAccessibilityLabelFormat == "Recommendations, card %lld of %lld")
        #expect(defaults.questionnaireProgressFormat == "%lld of %lld answered")
    }
}
