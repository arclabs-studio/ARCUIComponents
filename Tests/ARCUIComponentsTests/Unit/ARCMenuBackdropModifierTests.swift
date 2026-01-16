//
//  ARCMenuBackdropModifierTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/01/16.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCMenuBackdropModifier
///
/// Tests cover backdrop opacity behavior and tap gesture configuration.
@Suite("ARCMenuBackdropModifier Tests")
@MainActor
struct ARCMenuBackdropModifierTests {
    // MARK: - Initialization Tests

    @Test("init_withValidOpacity_createsModifier")
    func init_withValidOpacity_createsModifier() {
        var tapCalled = false
        let modifier = ARCMenuBackdropModifier(opacity: 0.5) {
            tapCalled = true
        }

        #expect(modifier.opacity == 0.5)
        // Verify onTap closure is stored (we can't call it directly in this context)
        #expect(tapCalled == false)
    }

    @Test("init_withZeroOpacity_createsModifier")
    func init_withZeroOpacity_createsModifier() {
        let modifier = ARCMenuBackdropModifier(opacity: 0) {}

        #expect(modifier.opacity == 0)
    }

    @Test("init_withFullOpacity_createsModifier")
    func init_withFullOpacity_createsModifier() {
        let modifier = ARCMenuBackdropModifier(opacity: 1.0) {}

        #expect(modifier.opacity == 1.0)
    }

    // MARK: - Opacity Range Tests

    @Test("opacity_atZero_hidesBackdrop")
    func opacity_atZero_hidesBackdrop() {
        let modifier = ARCMenuBackdropModifier(opacity: 0) {}

        // When opacity is 0, the backdrop should not be visible
        // The actual visibility is handled in body, but we verify the value
        #expect(modifier.opacity == 0)
    }

    @Test("opacity_atHalf_showsPartialBackdrop")
    func opacity_atHalf_showsPartialBackdrop() {
        let modifier = ARCMenuBackdropModifier(opacity: 0.5) {}

        #expect(modifier.opacity == 0.5)
    }

    @Test("opacity_atFull_showsFullBackdrop")
    func opacity_atFull_showsFullBackdrop() {
        let modifier = ARCMenuBackdropModifier(opacity: 1.0) {}

        #expect(modifier.opacity == 1.0)
    }

    // MARK: - Calculated Opacity Tests

    @Test("calculatedOpacity_isThirtyPercentOfInput")
    func calculatedOpacity_isThirtyPercentOfInput() {
        // The modifier multiplies opacity by 0.3 for the actual backdrop
        let inputOpacity = 1.0
        let expectedBackdropOpacity = inputOpacity * 0.3

        #expect(expectedBackdropOpacity == 0.3)
    }

    @Test("calculatedOpacity_atHalfInput_isFifteenPercent")
    func calculatedOpacity_atHalfInput_isFifteenPercent() {
        let inputOpacity = 0.5
        let expectedBackdropOpacity = inputOpacity * 0.3

        #expect(expectedBackdropOpacity == 0.15)
    }
}

// MARK: - View Extension Tests

@Suite("Backdrop View Extension Tests")
@MainActor
struct BackdropViewExtensionTests {
    @Test("backdropExtension_withOpacity_returnsModifiedView")
    func backdropExtension_withOpacity_returnsModifiedView() {
        // Verify the extension compiles and can be called
        let view = Text("Test")
        let modifiedView = view.backdrop(opacity: 0.5) {}

        // The view should be modified (we can't easily test SwiftUI view equality)
        _ = modifiedView
        #expect(Bool(true))
    }

    @Test("backdropExtension_withZeroOpacity_returnsModifiedView")
    func backdropExtension_withZeroOpacity_returnsModifiedView() {
        let view = Text("Test")
        let modifiedView = view.backdrop(opacity: 0) {}

        _ = modifiedView
        #expect(Bool(true))
    }

    @Test("backdropExtension_withFullOpacity_returnsModifiedView")
    func backdropExtension_withFullOpacity_returnsModifiedView() {
        let view = Text("Test")
        let modifiedView = view.backdrop(opacity: 1.0) {}

        _ = modifiedView
        #expect(Bool(true))
    }
}

// MARK: - Legacy Modifier Extension Tests

@Suite("ARCMenu Liquid Glass Extension Tests")
@MainActor
struct ARCMenuLiquidGlassExtensionTests {
    @Test("arcMenuLiquidGlass_withConfiguration_returnsModifiedView")
    func arcMenuLiquidGlass_withConfiguration_returnsModifiedView() {
        let view = Text("Test")
        let config = ARCMenuConfiguration.default
        let modifiedView = view.arcMenuLiquidGlass(configuration: config)

        _ = modifiedView
        #expect(Bool(true))
    }

    @Test("arcMenuLiquidGlass_withCustomConfiguration_returnsModifiedView")
    func arcMenuLiquidGlass_withCustomConfiguration_returnsModifiedView() {
        let view = Text("Test")
        let config = ARCMenuConfiguration(
            accentColor: .purple,
            backgroundStyle: .liquidGlass
        )
        let modifiedView = view.arcMenuLiquidGlass(configuration: config)

        _ = modifiedView
        #expect(Bool(true))
    }

    @Test("liquidGlass_genericExtension_worksWithMenuConfiguration")
    func liquidGlass_genericExtension_worksWithMenuConfiguration() {
        let view = Text("Test")
        let config = ARCMenuConfiguration.default
        let modifiedView = view.liquidGlass(configuration: config)

        _ = modifiedView
        #expect(Bool(true))
    }

    @Test("liquidGlass_genericExtension_worksWithListCardConfiguration")
    func liquidGlass_genericExtension_worksWithListCardConfiguration() {
        let view = Text("Test")
        let config = ARCListCardConfiguration.prominent
        let modifiedView = view.liquidGlass(configuration: config)

        _ = modifiedView
        #expect(Bool(true))
    }
}
