//
//  CollectionBindingsTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 06/11/26.
//

import Testing
@testable import ARCUIComponents

@Suite("Collection binding subscripts")
struct CollectionBindingsTests {
    // MARK: - Set Membership

    @Test("setContains_whenSetTrue_insertsElement") func setContains_whenSetTrue_insertsElement() {
        var sut: Set<String> = []

        sut[contains: "a"] = true

        #expect(sut == ["a"])
        #expect(sut[contains: "a"])
    }

    @Test("setContains_whenSetFalse_removesElement") func setContains_whenSetFalse_removesElement() {
        var sut: Set = ["a", "b"]

        sut[contains: "a"] = false

        #expect(sut == ["b"])
        #expect(sut[contains: "a"] == false)
    }

    // MARK: - Dictionary Flag

    @Test("dictionaryFlag_missingKey_readsFalse") func dictionaryFlag_missingKey_readsFalse() {
        let sut: [String: Bool] = [:]

        #expect(sut[flag: "missing"] == false)
    }

    @Test("dictionaryFlag_write_storesValue") func dictionaryFlag_write_storesValue() {
        var sut: [String: Bool] = [:]

        sut[flag: "a"] = true
        sut[flag: "b"] = false

        #expect(sut == ["a": true, "b": false])
    }

    // MARK: - Chip Selection

    @Test("chipSelection_multipleMode_insertsAlongsideExisting") func chipSelection_multipleMode_insertsAlongsideExisting() {
        var sut: Set = ["a"]

        sut[chip: "b", replacesSelection: false] = true

        #expect(sut == ["a", "b"])
    }

    @Test("chipSelection_singleMode_replacesSelection") func chipSelection_singleMode_replacesSelection() {
        var sut: Set = ["a", "c"]

        sut[chip: "b", replacesSelection: true] = true

        #expect(sut == ["b"])
    }

    @Test("chipSelection_deselect_removesOnlyThatChip") func chipSelection_deselect_removesOnlyThatChip() {
        var sut: Set = ["a", "b"]

        sut[chip: "a", replacesSelection: true] = false

        #expect(sut == ["b"])
    }
}
