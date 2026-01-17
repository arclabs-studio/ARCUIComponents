//
//  ARCMenuPresentationStyleTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 01/16/26.
//

import SwiftUI
import Testing

@testable import ARCUIComponents

/// Unit tests for ARCMenuPresentationStyle
///
/// Tests cover presentation style properties and behaviors.
@Suite("ARCMenuPresentationStyle Tests")
struct ARCMenuPresentationStyleTests {
    // MARK: - Entering Edge Tests

    @Test("bottomSheet_hasBottomEnteringEdge")
    func bottomSheet_hasBottomEnteringEdge() {
        let style = ARCMenuPresentationStyle.bottomSheet

        #expect(style.enteringEdge == .bottom)
    }

    @Test("trailingPanel_hasTrailingEnteringEdge")
    func trailingPanel_hasTrailingEnteringEdge() {
        let style = ARCMenuPresentationStyle.trailingPanel

        #expect(style.enteringEdge == .trailing)
    }

    // MARK: - Content Alignment Tests

    @Test("bottomSheet_hasBottomContentAlignment")
    func bottomSheet_hasBottomContentAlignment() {
        let style = ARCMenuPresentationStyle.bottomSheet

        #expect(style.contentAlignment == .bottom)
    }

    @Test("trailingPanel_hasTopTrailingContentAlignment")
    func trailingPanel_hasTopTrailingContentAlignment() {
        let style = ARCMenuPresentationStyle.trailingPanel

        #expect(style.contentAlignment == .topTrailing)
    }

    // MARK: - Drag Direction Tests

    @Test("bottomSheet_isVerticalDrag")
    func bottomSheet_isVerticalDrag() {
        let style = ARCMenuPresentationStyle.bottomSheet

        #expect(style.isVerticalDrag == true)
    }

    @Test("trailingPanel_isHorizontalDrag")
    func trailingPanel_isHorizontalDrag() {
        let style = ARCMenuPresentationStyle.trailingPanel

        #expect(style.isVerticalDrag == false)
    }

    // MARK: - Equatable Conformance Tests

    @Test("equatable_sameStyles_areEqual")
    func equatable_sameStyles_areEqual() {
        #expect(ARCMenuPresentationStyle.bottomSheet == ARCMenuPresentationStyle.bottomSheet)
        #expect(ARCMenuPresentationStyle.trailingPanel == ARCMenuPresentationStyle.trailingPanel)
    }

    @Test("equatable_differentStyles_areNotEqual")
    func equatable_differentStyles_areNotEqual() {
        #expect(ARCMenuPresentationStyle.bottomSheet != ARCMenuPresentationStyle.trailingPanel)
    }

    // MARK: - Sendable Conformance Tests

    @Test("sendable_canBeSentAcrossConcurrencyBoundaries")
    func sendable_canBeSentAcrossConcurrencyBoundaries() async {
        let style: ARCMenuPresentationStyle = .bottomSheet

        // This should compile without warnings due to Sendable conformance
        await Task {
            _ = style
        }.value

        #expect(true)
    }
}
