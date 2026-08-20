//
//  ARCMenuSectionTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/25/26.
//

import Testing
@testable import ARCUIComponents

/// Unit tests for ARCMenuSection
@Suite("ARCMenuSection Tests")
struct ARCMenuSectionTests {
    // MARK: - Initialization Tests

    @Test("init_withItems_setsItemsCorrectly") func init_withItems_setsItemsCorrectly() {
        let items: [ARCMenuItem] = [.Common.settings(action: {}),
                                    .Common.profile(action: {})]

        let section = ARCMenuSection(items: items)

        #expect(section.items.count == 2)
    }

    @Test("init_withTitle_setsTitleCorrectly") func init_withTitle_setsTitleCorrectly() {
        let section = ARCMenuSection(title: "Settings", items: [])

        #expect(section.title == "Settings")
    }

    @Test("init_withoutTitle_hasNilTitle") func init_withoutTitle_hasNilTitle() {
        let section = ARCMenuSection(items: [])

        #expect(section.title == nil)
    }

    @Test("init_withFooter_setsFooterCorrectly") func init_withFooter_setsFooterCorrectly() {
        let section = ARCMenuSection(footer: "Customize your experience", items: [])

        #expect(section.footer == "Customize your experience")
    }

    @Test("init_withoutFooter_hasNilFooter") func init_withoutFooter_hasNilFooter() {
        let section = ARCMenuSection(items: [])

        #expect(section.footer == nil)
    }

    @Test("init_generatesUniqueIDs") func init_generatesUniqueIDs() {
        let section1 = ARCMenuSection(items: [])
        let section2 = ARCMenuSection(items: [])

        #expect(section1.id != section2.id)
    }

    @Test("init_withCustomID_usesProvidedID") func init_withCustomID_usesProvidedID() {
        let customID = UUID()
        let section = ARCMenuSection(id: customID, items: [])

        #expect(section.id == customID)
    }

    @Test("init_withAllParameters_setsAllCorrectly") func init_withAllParameters_setsAllCorrectly() {
        let items: [ARCMenuItem] = [.Common.settings(action: {})]

        let section = ARCMenuSection(title: "Support",
                                     footer: "Get help and feedback",
                                     items: items)

        #expect(section.title == "Support")
        #expect(section.footer == "Get help and feedback")
        #expect(section.items.count == 1)
    }
}

// MARK: - ARCMenuLayoutStyle Tests

@Suite("ARCMenuLayoutStyle Tests")
struct ARCMenuLayoutStyleTests {
    @Test("flat_isValidCase") func flat_isValidCase() {
        let style = ARCMenuLayoutStyle.flat

        if case .flat = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected flat layout style")
        }
    }

    @Test("grouped_isValidCase") func grouped_isValidCase() {
        let style = ARCMenuLayoutStyle.grouped

        if case .grouped = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected grouped layout style")
        }
    }
}
