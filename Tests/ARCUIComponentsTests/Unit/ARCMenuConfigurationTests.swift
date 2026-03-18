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

    @Test("default_hasExpectedMenuWidth") func default_hasExpectedMenuWidth() {
        let config = ARCMenuConfiguration.default

        #expect(config.menuWidth == 320)
    }

    @Test("default_hasExpectedCornerRadius") func default_hasExpectedCornerRadius() {
        let config = ARCMenuConfiguration.default

        #expect(config.cornerRadius > 0)
    }

    @Test("default_hasBottomSheetPresentationStyle") func default_hasBottomSheetPresentationStyle() {
        let config = ARCMenuConfiguration.default

        #expect(config.presentationStyle == .bottomSheet)
    }

    @Test("default_showsGrabber") func default_showsGrabber() {
        let config = ARCMenuConfiguration.default

        #expect(config.showsGrabber == true)
    }

    @Test("default_showsCloseButton") func default_showsCloseButton() {
        let config = ARCMenuConfiguration.default

        #expect(config.showsCloseButton == true)
    }

    @Test("default_hasNilSheetTitle") func default_hasNilSheetTitle() {
        let config = ARCMenuConfiguration.default

        #expect(config.sheetTitle == nil)
    }

    @Test("default_hasMediumHapticFeedback") func default_hasMediumHapticFeedback() {
        let config = ARCMenuConfiguration.default

        if case .medium = config.hapticFeedback {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected medium haptic feedback")
        }
    }

    @Test("default_hasSubtleIconStyle") func default_hasSubtleIconStyle() {
        let config = ARCMenuConfiguration.default

        #expect(config.iconStyle == .subtle)
    }

    @Test("default_hasDetents") func default_hasDetents() {
        let config = ARCMenuConfiguration.default

        #expect(config.detents.isEmpty == false)
    }

    @Test("default_allowsBackgroundInteraction") func default_allowsBackgroundInteraction() {
        let config = ARCMenuConfiguration.default

        #expect(config.allowsBackgroundInteraction == false)
    }

    @Test("default_hasFlatLayoutStyle") func default_hasFlatLayoutStyle() {
        let config = ARCMenuConfiguration.default

        if case .flat = config.layoutStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected flat layout style")
        }
    }

    // MARK: - Sectioned Configuration Tests

    @Test("sectioned_hasGroupedLayoutStyle") func sectioned_hasGroupedLayoutStyle() {
        let config = ARCMenuConfiguration.sectioned

        if case .grouped = config.layoutStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected grouped layout style")
        }
    }

    @Test("sectioned_hasBottomSheetPresentationStyle") func sectioned_hasBottomSheetPresentationStyle() {
        let config = ARCMenuConfiguration.sectioned

        #expect(config.presentationStyle == .bottomSheet)
    }

    @Test("sectioned_showsGrabber") func sectioned_showsGrabber() {
        let config = ARCMenuConfiguration.sectioned

        #expect(config.showsGrabber == true)
    }

    // MARK: - Trailing Panel Configuration Tests

    @Test("trailingPanel_hasTrailingPanelPresentationStyle") func trailingPanel_hasTrailingPanelPresentationStyle() {
        let config = ARCMenuConfiguration.trailingPanel

        #expect(config.presentationStyle == .trailingPanel)
    }

    @Test("trailingPanel_hidesGrabber") func trailingPanel_hidesGrabber() {
        let config = ARCMenuConfiguration.trailingPanel

        #expect(config.showsGrabber == false)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomMenuWidth_setsCorrectWidth") func init_withCustomMenuWidth_setsCorrectWidth() {
        let config = ARCMenuConfiguration(menuWidth: 400)

        #expect(config.menuWidth == 400)
    }

    @Test("init_withCustomCornerRadius_setsCorrectRadius") func init_withCustomCornerRadius_setsCorrectRadius() {
        let config = ARCMenuConfiguration(cornerRadius: 20)

        #expect(config.cornerRadius == 20)
    }

    @Test("init_withCustomSectionSpacing_setsCorrectSpacing") func init_withCustomSectionSpacing_setsCorrectSpacing() {
        let config = ARCMenuConfiguration(sectionSpacing: 30)

        #expect(config.sectionSpacing == 30)
    }

    @Test("init_withTrailingPanelStyle_setsCorrectStyle") func init_withTrailingPanelStyle_setsCorrectStyle() {
        let config = ARCMenuConfiguration(presentationStyle: .trailingPanel)

        #expect(config.presentationStyle == .trailingPanel)
    }

    @Test("init_withSheetTitle_setsCorrectTitle") func init_withSheetTitle_setsCorrectTitle() {
        let config = ARCMenuConfiguration(sheetTitle: "Cuenta")

        #expect(config.sheetTitle == "Cuenta")
    }

    @Test("init_withDisabledGrabber_hidesGrabber") func init_withDisabledGrabber_hidesGrabber() {
        let config = ARCMenuConfiguration(showsGrabber: false)

        #expect(config.showsGrabber == false)
    }

    @Test("init_withDisabledCloseButton_hidesCloseButton") func init_withDisabledCloseButton_hidesCloseButton() {
        let config = ARCMenuConfiguration(showsCloseButton: false)

        #expect(config.showsCloseButton == false)
    }

    @Test("init_withProminentIconStyle_setsCorrectStyle") func init_withProminentIconStyle_setsCorrectStyle() {
        let config = ARCMenuConfiguration(iconStyle: .prominent)

        #expect(config.iconStyle == .prominent)
    }

    @Test("init_withBackgroundInteraction_setsCorrectValue") func init_withBackgroundInteraction_setsCorrectValue() {
        let config = ARCMenuConfiguration(allowsBackgroundInteraction: true)

        #expect(config.allowsBackgroundInteraction == true)
    }

    @Test("init_withCustomAccentColor_setsCorrectColor") func init_withCustomAccentColor_setsCorrectColor() {
        let config = ARCMenuConfiguration(accentColor: .red)

        #expect(config.accentColor == .red)
    }

    @Test("init_withGroupedLayoutStyle_setsCorrectStyle") func init_withGroupedLayoutStyle_setsCorrectStyle() {
        let config = ARCMenuConfiguration(layoutStyle: .grouped)

        if case .grouped = config.layoutStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected grouped layout style")
        }
    }

    @Test("init_withDefaultLayoutStyle_usesFlatLayout") func init_withDefaultLayoutStyle_usesFlatLayout() {
        let config = ARCMenuConfiguration()

        if case .flat = config.layoutStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected flat layout style as default")
        }
    }
}

// MARK: - ARCMenuHapticStyle Tests

@Suite("ARCMenuHapticStyle Tests")
struct ARCMenuHapticStyleTests {
    @Test("none_isValidCase") func none_isValidCase() {
        let style = ARCMenuHapticStyle.none
        if case .none = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("light_isValidCase") func light_isValidCase() {
        let style = ARCMenuHapticStyle.light
        if case .light = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("medium_isValidCase") func medium_isValidCase() {
        let style = ARCMenuHapticStyle.medium
        if case .medium = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("heavy_isValidCase") func heavy_isValidCase() {
        let style = ARCMenuHapticStyle.heavy
        if case .heavy = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("soft_isValidCase") func soft_isValidCase() {
        let style = ARCMenuHapticStyle.soft
        if case .soft = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("rigid_isValidCase") func rigid_isValidCase() {
        let style = ARCMenuHapticStyle.rigid
        if case .rigid = style {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }
}

// MARK: - ARCMenuIconStyle Tests

@Suite("ARCMenuIconStyle Tests")
struct ARCMenuIconStyleTests {
    @Test("subtle_isValidCase") func subtle_isValidCase() {
        let style = ARCMenuIconStyle.subtle

        #expect(style == .subtle)
    }

    @Test("prominent_isValidCase") func prominent_isValidCase() {
        let style = ARCMenuIconStyle.prominent

        #expect(style == .prominent)
    }
}
