//
//  ARCMenuConfigurationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCMenuConfiguration
///
/// Tests cover preset configurations, default values, and custom initialization.
@Suite("ARCMenuConfiguration Tests")
struct ARCMenuConfigurationTests {
    // MARK: - Default Configuration Tests

    @Test("default_hasExpectedMenuWidth")
    func default_hasExpectedMenuWidth() {
        let config = ARCMenuConfiguration.default

        #expect(config.menuWidth == 320)
    }

    @Test("default_hasExpectedCornerRadius")
    func default_hasExpectedCornerRadius() {
        let config = ARCMenuConfiguration.default

        #expect(config.cornerRadius > 0)
    }

    @Test("default_allowsDragToDismiss")
    func default_allowsDragToDismiss() {
        let config = ARCMenuConfiguration.default

        #expect(config.allowsDragToDismiss == true)
    }

    @Test("default_dismissesOnOutsideTap")
    func default_dismissesOnOutsideTap() {
        let config = ARCMenuConfiguration.default

        #expect(config.dismissOnOutsideTap == true)
    }

    @Test("default_hasLiquidGlassBackgroundStyle")
    func default_hasLiquidGlassBackgroundStyle() {
        let config = ARCMenuConfiguration.default

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("default_hasMediumHapticFeedback")
    func default_hasMediumHapticFeedback() {
        let config = ARCMenuConfiguration.default

        if case .medium = config.hapticFeedback {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected medium haptic feedback")
        }
    }

    @Test("default_hasExpectedDragDismissalThreshold")
    func default_hasExpectedDragDismissalThreshold() {
        let config = ARCMenuConfiguration.default

        #expect(config.dragDismissalThreshold == 100)
    }

    @Test("default_hasBottomSheetPresentationStyle")
    func default_hasBottomSheetPresentationStyle() {
        let config = ARCMenuConfiguration.default

        #expect(config.presentationStyle == .bottomSheet)
    }

    @Test("default_showsGrabber")
    func default_showsGrabber() {
        let config = ARCMenuConfiguration.default

        #expect(config.showsGrabber == true)
    }

    @Test("default_showsCloseButton")
    func default_showsCloseButton() {
        let config = ARCMenuConfiguration.default

        #expect(config.showsCloseButton == true)
    }

    @Test("default_hasNilSheetTitle")
    func default_hasNilSheetTitle() {
        let config = ARCMenuConfiguration.default

        #expect(config.sheetTitle == nil)
    }

    // MARK: - Preset Configuration Tests

    @Test("dark_hasLiquidGlassBackgroundStyle")
    func dark_hasLiquidGlassBackgroundStyle() {
        let config = ARCMenuConfiguration.dark

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("fitness_hasLiquidGlassBackgroundStyle")
    func fitness_hasLiquidGlassBackgroundStyle() {
        let config = ARCMenuConfiguration.fitness

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("premium_hasLiquidGlassBackgroundStyle")
    func premium_hasLiquidGlassBackgroundStyle() {
        let config = ARCMenuConfiguration.premium

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("minimal_hasTranslucentBackgroundStyle")
    func minimal_hasTranslucentBackgroundStyle() {
        let config = ARCMenuConfiguration.minimal

        if case .translucent = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected translucent background style")
        }
    }

    @Test("minimal_hasSubtleShadow")
    func minimal_hasSubtleShadow() {
        let config = ARCMenuConfiguration.minimal

        #expect(config.shadow.radius == ARCShadow.subtle.radius)
    }

    @Test("trailingPanel_hasTrailingPanelPresentationStyle")
    func trailingPanel_hasTrailingPanelPresentationStyle() {
        let config = ARCMenuConfiguration.trailingPanel

        #expect(config.presentationStyle == .trailingPanel)
    }

    @Test("trailingPanel_hidesGrabber")
    func trailingPanel_hidesGrabber() {
        let config = ARCMenuConfiguration.trailingPanel

        #expect(config.showsGrabber == false)
    }

    @Test("trailingPanel_hidesCloseButton")
    func trailingPanel_hidesCloseButton() {
        let config = ARCMenuConfiguration.trailingPanel

        #expect(config.showsCloseButton == false)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomMenuWidth_setsCorrectWidth")
    func init_withCustomMenuWidth_setsCorrectWidth() {
        let config = ARCMenuConfiguration(menuWidth: 400)

        #expect(config.menuWidth == 400)
    }

    @Test("init_withCustomCornerRadius_setsCorrectRadius")
    func init_withCustomCornerRadius_setsCorrectRadius() {
        let config = ARCMenuConfiguration(cornerRadius: 20)

        #expect(config.cornerRadius == 20)
    }

    @Test("init_withDisabledDragToDismiss_disablesDrag")
    func init_withDisabledDragToDismiss_disablesDrag() {
        let config = ARCMenuConfiguration(allowsDragToDismiss: false)

        #expect(config.allowsDragToDismiss == false)
    }

    @Test("init_withDisabledOutsideTap_disablesTap")
    func init_withDisabledOutsideTap_disablesTap() {
        let config = ARCMenuConfiguration(dismissOnOutsideTap: false)

        #expect(config.dismissOnOutsideTap == false)
    }

    @Test("init_withCustomDragThreshold_setsCorrectThreshold")
    func init_withCustomDragThreshold_setsCorrectThreshold() {
        let config = ARCMenuConfiguration(dragDismissalThreshold: 200)

        #expect(config.dragDismissalThreshold == 200)
    }

    @Test("init_withTopPadding_setsCorrectPadding")
    func init_withTopPadding_setsCorrectPadding() {
        let config = ARCMenuConfiguration(topPadding: 50)

        #expect(config.topPadding == 50)
    }

    @Test("init_withCustomSectionSpacing_setsCorrectSpacing")
    func init_withCustomSectionSpacing_setsCorrectSpacing() {
        let config = ARCMenuConfiguration(sectionSpacing: 30)

        #expect(config.sectionSpacing == 30)
    }

    @Test("init_withTrailingPanelStyle_setsCorrectStyle")
    func init_withTrailingPanelStyle_setsCorrectStyle() {
        let config = ARCMenuConfiguration(presentationStyle: .trailingPanel)

        #expect(config.presentationStyle == .trailingPanel)
    }

    @Test("init_withSheetTitle_setsCorrectTitle")
    func init_withSheetTitle_setsCorrectTitle() {
        let config = ARCMenuConfiguration(sheetTitle: "Cuenta")

        #expect(config.sheetTitle == "Cuenta")
    }

    @Test("init_withDisabledGrabber_hidesGrabber")
    func init_withDisabledGrabber_hidesGrabber() {
        let config = ARCMenuConfiguration(showsGrabber: false)

        #expect(config.showsGrabber == false)
    }

    @Test("init_withDisabledCloseButton_hidesCloseButton")
    func init_withDisabledCloseButton_hidesCloseButton() {
        let config = ARCMenuConfiguration(showsCloseButton: false)

        #expect(config.showsCloseButton == false)
    }

    // MARK: - LiquidGlassConfigurable Conformance Tests

    @Test("conformsToLiquidGlassConfigurable_hasAccentColor")
    func conformsToLiquidGlassConfigurable_hasAccentColor() {
        let config: any LiquidGlassConfigurable = ARCMenuConfiguration.default

        #expect(config.accentColor != nil)
    }

    @Test("conformsToLiquidGlassConfigurable_hasBackgroundStyle")
    func conformsToLiquidGlassConfigurable_hasBackgroundStyle() {
        let config: any LiquidGlassConfigurable = ARCMenuConfiguration.default

        // Just verify it compiles and has a value
        _ = config.backgroundStyle
        #expect(true)
    }

    @Test("conformsToLiquidGlassConfigurable_hasCornerRadius")
    func conformsToLiquidGlassConfigurable_hasCornerRadius() {
        let config: any LiquidGlassConfigurable = ARCMenuConfiguration.default

        #expect(config.cornerRadius > 0)
    }

    @Test("conformsToLiquidGlassConfigurable_hasShadow")
    func conformsToLiquidGlassConfigurable_hasShadow() {
        let config: any LiquidGlassConfigurable = ARCMenuConfiguration.default

        #expect(config.shadow.radius >= 0)
    }
}

// MARK: - ARCMenuHapticStyle Tests

@Suite("ARCMenuHapticStyle Tests")
struct ARCMenuHapticStyleTests {
    @Test("none_isValidCase")
    func none_isValidCase() {
        let style = ARCMenuHapticStyle.none
        if case .none = style {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test("light_isValidCase")
    func light_isValidCase() {
        let style = ARCMenuHapticStyle.light
        if case .light = style {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test("medium_isValidCase")
    func medium_isValidCase() {
        let style = ARCMenuHapticStyle.medium
        if case .medium = style {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test("heavy_isValidCase")
    func heavy_isValidCase() {
        let style = ARCMenuHapticStyle.heavy
        if case .heavy = style {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test("soft_isValidCase")
    func soft_isValidCase() {
        let style = ARCMenuHapticStyle.soft
        if case .soft = style {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test("rigid_isValidCase")
    func rigid_isValidCase() {
        let style = ARCMenuHapticStyle.rigid
        if case .rigid = style {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }
}
