//
//  ARCAIRecommenderQuestionCollapseTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 10/23/26.
//

import Testing
@testable import ARCUIComponents

// MARK: - Collapsible Options Tests

struct AIRecommenderQuestionCollapseTests {
    @Test("visibleOptions_withoutCollapsedCount_returnsAllOptions")
    func visibleOptions_withoutCollapsedCount_returnsAllOptions() {
        // Given
        let sut = makeSUT(optionCount: 5, collapsedOptionCount: nil)

        // When
        let visible = sut.visibleOptions(isExpanded: false, selectedIds: [])

        // Then
        #expect(ids(visible) == ["o0", "o1", "o2", "o3", "o4"])
        #expect(!sut.isCollapsible)
    }

    @Test("visibleOptions_collapsed_returnsFirstNInOrder") func visibleOptions_collapsed_returnsFirstNInOrder() {
        // Given
        let sut = makeSUT(optionCount: 6, collapsedOptionCount: 3)

        // When
        let visible = sut.visibleOptions(isExpanded: false, selectedIds: [])

        // Then
        #expect(ids(visible) == ["o0", "o1", "o2"])
        #expect(sut.isCollapsible)
    }

    @Test("visibleOptions_expanded_returnsAllOptions") func visibleOptions_expanded_returnsAllOptions() {
        // Given
        let sut = makeSUT(optionCount: 6, collapsedOptionCount: 3)

        // When
        let visible = sut.visibleOptions(isExpanded: true, selectedIds: [])

        // Then
        #expect(ids(visible) == ["o0", "o1", "o2", "o3", "o4", "o5"])
    }

    @Test("visibleOptions_collapsed_keepsSelectedBeyondNInOriginalOrder")
    func visibleOptions_collapsed_keepsSelectedBeyondNInOriginalOrder() {
        // Given
        let sut = makeSUT(optionCount: 8, collapsedOptionCount: 3)

        // When
        let visible = sut.visibleOptions(isExpanded: false, selectedIds: ["o6", "o1", "o4"])

        // Then
        #expect(ids(visible) == ["o0", "o1", "o2", "o4", "o6"])
    }

    @Test("visibleOptions_countAtLeastOptionCount_returnsAllAndIsNotCollapsible")
    func visibleOptions_countAtLeastOptionCount_returnsAllAndIsNotCollapsible() {
        // Given
        let exact = makeSUT(optionCount: 4, collapsedOptionCount: 4)
        let larger = makeSUT(optionCount: 4, collapsedOptionCount: 10)

        // When
        let exactVisible = exact.visibleOptions(isExpanded: false, selectedIds: [])
        let largerVisible = larger.visibleOptions(isExpanded: false, selectedIds: [])

        // Then
        #expect(ids(exactVisible) == ["o0", "o1", "o2", "o3"])
        #expect(ids(largerVisible) == ["o0", "o1", "o2", "o3"])
        #expect(!exact.isCollapsible)
        #expect(!larger.isCollapsible)
    }

    @Test("visibleOptions_zeroCountWithSelection_returnsOnlySelected")
    func visibleOptions_zeroCountWithSelection_returnsOnlySelected() {
        // Given
        let sut = makeSUT(optionCount: 5, collapsedOptionCount: 0)

        // When
        let visible = sut.visibleOptions(isExpanded: false, selectedIds: ["o3"])

        // Then
        #expect(ids(visible) == ["o3"])
        #expect(sut.isCollapsible)
    }
}

// MARK: - Helpers

extension AIRecommenderQuestionCollapseTests {
    private func makeSUT(optionCount: Int, collapsedOptionCount: Int?) -> AIRecommenderQuestion {
        AIRecommenderQuestion(id: "cuisine",
                              text: "Cuisine",
                              options: (0 ..< optionCount).map { .init(id: "o\($0)", label: "Option \($0)") },
                              inputType: .multipleChoice,
                              collapsedOptionCount: collapsedOptionCount)
    }

    private func ids(_ options: [AIRecommenderQuestion.Option]) -> [String] {
        options.map(\.id)
    }
}
