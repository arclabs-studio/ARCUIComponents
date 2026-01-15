//
//  ARCSearchButtonConfigurationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCSearchButtonConfiguration
///
/// Tests cover default values, styles, sizes, and presets.
@Suite("ARCSearchButtonConfiguration Tests")
struct ARCSearchButtonConfigurationTests {

    // MARK: - Default Configuration Tests

    @Test("default_hasPlainStyle")
    func default_hasPlainStyle() {
        let config = ARCSearchButtonConfiguration.default

        // Verify by checking behavior characteristics
        #expect(config.showsBackgroundWhenIdle == false)
    }

    @Test("default_hasMediumSize")
    func default_hasMediumSize() {
        let config = ARCSearchButtonConfiguration.default

        #expect(config.size.iconSize == 20) // medium = 20pt
    }

    @Test("default_hasMagnifyingglassIcon")
    func default_hasMagnifyingglassIcon() {
        let config = ARCSearchButtonConfiguration.default

        #expect(config.icon == "magnifyingglass")
    }

    // MARK: - Size Tests

    @Test("sizeSmall_hasCorrectIconSize")
    func sizeSmall_hasCorrectIconSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.small

        #expect(size.iconSize == 18)
    }

    @Test("sizeMedium_hasCorrectIconSize")
    func sizeMedium_hasCorrectIconSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.medium

        #expect(size.iconSize == 20)
    }

    @Test("sizeLarge_hasCorrectIconSize")
    func sizeLarge_hasCorrectIconSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.large

        #expect(size.iconSize == 24)
    }

    @Test("sizeSmall_hasCorrectFrameSize")
    func sizeSmall_hasCorrectFrameSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.small

        #expect(size.frameSize == 36)
    }

    @Test("sizeMedium_hasFrameSizeAtLeast44")
    func sizeMedium_hasFrameSizeAtLeast44() {
        let size = ARCSearchButtonConfiguration.ButtonSize.medium

        #expect(size.frameSize >= 44)
    }

    @Test("sizeLarge_hasCorrectFrameSize")
    func sizeLarge_hasCorrectFrameSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.large

        #expect(size.frameSize == 52)
    }

    @Test("sizesAreOrdered_smallLessThanMediumLessThanLarge")
    func sizesAreOrdered_smallLessThanMediumLessThanLarge() {
        let small = ARCSearchButtonConfiguration.ButtonSize.small
        let medium = ARCSearchButtonConfiguration.ButtonSize.medium
        let large = ARCSearchButtonConfiguration.ButtonSize.large

        #expect(small.iconSize < medium.iconSize)
        #expect(medium.iconSize < large.iconSize)
    }

    @Test("sizeCustom_hasCorrectIconSize")
    func sizeCustom_hasCorrectIconSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.custom(30)

        #expect(size.iconSize == 30)
    }

    @Test("sizeCustom_hasCorrectFrameSize")
    func sizeCustom_hasCorrectFrameSize() {
        let size = ARCSearchButtonConfiguration.ButtonSize.custom(30)

        #expect(size.frameSize == 50) // size + 20
    }

    // MARK: - Preset Tests

    @Test("prominent_hasFilledStyleBehavior")
    func prominent_hasFilledStyleBehavior() {
        let config = ARCSearchButtonConfiguration.prominent

        #expect(config.showsBackgroundWhenIdle == true)
        #expect(config.accentColor == .white)
    }

    @Test("minimal_hasSmallSize")
    func minimal_hasSmallSize() {
        let config = ARCSearchButtonConfiguration.minimal

        #expect(config.size.iconSize == 18) // small
    }

    @Test("toolbar_showsBackgroundWhenIdle")
    func toolbar_showsBackgroundWhenIdle() {
        let config = ARCSearchButtonConfiguration.toolbar

        #expect(config.showsBackgroundWhenIdle == true)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomAccentColor_setsColorCorrectly")
    func init_withCustomAccentColor_setsColorCorrectly() {
        let config = ARCSearchButtonConfiguration(accentColor: .blue)

        #expect(config.accentColor == .blue)
    }

    @Test("init_withSmallSize_setsSizeCorrectly")
    func init_withSmallSize_setsSizeCorrectly() {
        let config = ARCSearchButtonConfiguration(size: .small)

        #expect(config.size.iconSize == 18)
    }

    @Test("init_withCustomIcon_setsIconCorrectly")
    func init_withCustomIcon_setsIconCorrectly() {
        let config = ARCSearchButtonConfiguration(icon: "doc.text.magnifyingglass")

        #expect(config.icon == "doc.text.magnifyingglass")
    }

    @Test("init_withShowsBackgroundWhenIdleTrue_setsCorrectly")
    func init_withShowsBackgroundWhenIdleTrue_setsCorrectly() {
        let config = ARCSearchButtonConfiguration(showsBackgroundWhenIdle: true)

        #expect(config.showsBackgroundWhenIdle == true)
    }
}
