//
//  ARCAIRecommenderAnswersFreeTextTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 8/10/26.
//

import Testing
@testable import ARCUIComponents

// MARK: - Free Text Answer Tests

struct AIRecommenderAnswersFreeTextTests {
    @Test("freeText_returnsNil_whenNotSet") func freeText_returnsNil_whenNotSet() {
        let answers = AIRecommenderAnswers()

        #expect(answers.freeText(for: "cuisine") == nil)
    }

    @Test("setFreeText_storesText") func setFreeText_storesText() {
        var answers = AIRecommenderAnswers()

        answers.setFreeText("with terrace", for: "cuisine")

        #expect(answers.freeText(for: "cuisine") == "with terrace")
    }

    @Test("setFreeText_whitespaceOnly_clearsValue") func setFreeText_whitespaceOnly_clearsValue() {
        var answers = AIRecommenderAnswers()
        answers.setFreeText("with terrace", for: "cuisine")

        answers.setFreeText("   \n ", for: "cuisine")

        #expect(answers.freeText(for: "cuisine") == nil)
    }

    @Test("hasAnswer_isTrue_withOnlyFreeText") func hasAnswer_isTrue_withOnlyFreeText() {
        var answers = AIRecommenderAnswers()

        answers.setFreeText("gluten free", for: "budget")

        #expect(answers.hasAnswer(for: "budget"))
    }

    @Test("count_includesFreeTextQuestions") func count_includesFreeTextQuestions() {
        var answers = AIRecommenderAnswers()
        answers.selectSingle("italian", for: "cuisine")

        answers.setFreeText("rooftop", for: "mood")

        #expect(answers.count == 2)
    }

    @Test("isEmpty_isFalse_withOnlyFreeText") func isEmpty_isFalse_withOnlyFreeText() {
        var answers = AIRecommenderAnswers()

        answers.setFreeText("rooftop", for: "mood")

        #expect(!answers.isEmpty)
    }

    @Test("answeredQuestionIds_includesFreeTextQuestions") func answeredQuestionIds_includesFreeTextQuestions() {
        var answers = AIRecommenderAnswers()

        answers.setFreeText("rooftop", for: "mood")

        #expect(answers.answeredQuestionIds.contains("mood"))
    }

    @Test("reset_clearsFreeTexts") func reset_clearsFreeTexts() {
        var answers = AIRecommenderAnswers()
        answers.setFreeText("rooftop", for: "mood")

        answers.reset()

        #expect(answers.freeText(for: "mood") == nil)
        #expect(answers.isEmpty)
    }

    @Test("toDictionary_exportsFreeTextWithSuffixedKey") func toDictionary_exportsFreeTextWithSuffixedKey() {
        var answers = AIRecommenderAnswers()
        answers.setFreeText("rooftop", for: "mood")

        let dictionary = answers.toDictionary()

        #expect(dictionary["mood.freeText"] as? String == "rooftop")
    }

    @Test("equatable_considersFreeTexts") func equatable_considersFreeTexts() {
        var lhs = AIRecommenderAnswers()
        var rhs = AIRecommenderAnswers()
        lhs.setFreeText("rooftop", for: "mood")

        #expect(lhs != rhs)

        rhs.setFreeText("rooftop", for: "mood")

        #expect(lhs == rhs)
    }
}

// MARK: - Question Placeholder Tests

struct AIRecommenderQuestionFreeTextPlaceholderTests {
    @Test("freeTextPlaceholder_defaultsToNil") func freeTextPlaceholder_defaultsToNil() {
        let question = AIRecommenderQuestion(id: "mood",
                                             text: "How do you feel?",
                                             options: [.init(id: "happy", label: "Happy")])

        #expect(question.freeTextPlaceholder == nil)
    }

    @Test("freeTextPlaceholder_storesProvidedValue") func freeTextPlaceholder_storesProvidedValue() {
        let question = AIRecommenderQuestion(id: "mood",
                                             text: "How do you feel?",
                                             options: [.init(id: "happy", label: "Happy")],
                                             freeTextPlaceholder: "Add something specific (optional)")

        #expect(question.freeTextPlaceholder == "Add something specific (optional)")
    }
}
