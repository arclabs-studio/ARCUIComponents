//
//  ARCFavoriteButtonConfigurationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCFavoriteButtonConfiguration
///
/// Tests cover default values, presets, and custom initialization.
@Suite("ARCFavoriteButtonConfiguration Tests")
struct ARCFavoriteButtonConfigurationTests {
    // MARK: - Default Configuration Tests

    @Test("default_hasPinkFavoriteColor")
    func default_hasPinkFavoriteColor() {
        let config = ARCFavoriteButtonConfiguration.default

        #expect(config.favoriteColor == .pink)
    }

    @Test("default_hasMediumSize")
    func default_hasMediumSize() {
        let config = ARCFavoriteButtonConfiguration.default

        #expect(config.size.iconSize == 24) // medium = 24pt
    }

    @Test("default_hasHapticFeedbackEnabled")
    func default_hasHapticFeedbackEnabled() {
        let config = ARCFavoriteButtonConfiguration.default

        #expect(config.hapticFeedback == true)
    }

    @Test("default_hasHeartFillAsFavoriteIcon")
    func default_hasHeartFillAsFavoriteIcon() {
        let config = ARCFavoriteButtonConfiguration.default

        #expect(config.favoriteIcon == "heart.fill")
    }

    @Test("default_hasHeartAsUnfavoriteIcon")
    func default_hasHeartAsUnfavoriteIcon() {
        let config = ARCFavoriteButtonConfiguration.default

        #expect(config.unfavoriteIcon == "heart")
    }

    // MARK: - Size Tests

    @Test("sizeSmall_hasCorrectIconSize")
    func sizeSmall_hasCorrectIconSize() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.small

        #expect(size.iconSize == 20)
    }

    @Test("sizeMedium_hasCorrectIconSize")
    func sizeMedium_hasCorrectIconSize() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.medium

        #expect(size.iconSize == 24)
    }

    @Test("sizeLarge_hasCorrectIconSize")
    func sizeLarge_hasCorrectIconSize() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.large

        #expect(size.iconSize == 28)
    }

    @Test("sizeSmall_hasTouchTargetAtLeast44")
    func sizeSmall_hasTouchTargetAtLeast44() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.small

        #expect(size.touchTargetSize >= 44)
    }

    @Test("sizeMedium_hasTouchTargetAtLeast44")
    func sizeMedium_hasTouchTargetAtLeast44() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.medium

        #expect(size.touchTargetSize >= 44)
    }

    @Test("sizeLarge_hasTouchTargetAtLeast44")
    func sizeLarge_hasTouchTargetAtLeast44() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.large

        #expect(size.touchTargetSize >= 44)
    }

    @Test("sizeCustom_hasCorrectIconSize")
    func sizeCustom_hasCorrectIconSize() {
        let size = ARCFavoriteButtonConfiguration.ButtonSize.custom(32)

        #expect(size.iconSize == 32)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomFavoriteColor_setsColorCorrectly")
    func init_withCustomFavoriteColor_setsColorCorrectly() {
        let config = ARCFavoriteButtonConfiguration(favoriteColor: .blue)

        #expect(config.favoriteColor == .blue)
    }

    @Test("init_withSmallSize_setsSizeCorrectly")
    func init_withSmallSize_setsSizeCorrectly() {
        let config = ARCFavoriteButtonConfiguration(size: .small)

        #expect(config.size.iconSize == 20)
    }

    @Test("init_withLargeSize_setsSizeCorrectly")
    func init_withLargeSize_setsSizeCorrectly() {
        let config = ARCFavoriteButtonConfiguration(size: .large)

        #expect(config.size.iconSize == 28)
    }

    @Test("init_withDisabledHaptics_disablesHapticFeedback")
    func init_withDisabledHaptics_disablesHapticFeedback() {
        let config = ARCFavoriteButtonConfiguration(hapticFeedback: false)

        #expect(config.hapticFeedback == false)
    }

    @Test("init_withCustomIcons_setsIconsCorrectly")
    func init_withCustomIcons_setsIconsCorrectly() {
        let config = ARCFavoriteButtonConfiguration(
            favoriteIcon: "star.fill",
            unfavoriteIcon: "star"
        )

        #expect(config.favoriteIcon == "star.fill")
        #expect(config.unfavoriteIcon == "star")
    }

    @Test("init_withCustomAnimationDuration_setsDurationCorrectly")
    func init_withCustomAnimationDuration_setsDurationCorrectly() {
        let config = ARCFavoriteButtonConfiguration(animationDuration: 0.5)

        #expect(config.animationDuration == 0.5)
    }

    // MARK: - Preset Tests

    @Test("large_hasLargeSize")
    func large_hasLargeSize() {
        let config = ARCFavoriteButtonConfiguration.large

        #expect(config.size.iconSize == 28)
    }

    @Test("subtle_hasSmallSize")
    func subtle_hasSmallSize() {
        let config = ARCFavoriteButtonConfiguration.subtle

        #expect(config.size.iconSize == 20)
    }

    // MARK: - LiquidGlassConfigurable Conformance Tests

    @Test("conformsToLiquidGlassConfigurable_hasBackgroundStyle")
    func conformsToLiquidGlassConfigurable_hasBackgroundStyle() {
        let config: any LiquidGlassConfigurable = ARCFavoriteButtonConfiguration.default

        if case .translucent = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected translucent background style")
        }
    }

    @Test("conformsToLiquidGlassConfigurable_hasCornerRadius")
    func conformsToLiquidGlassConfigurable_hasCornerRadius() {
        let config: any LiquidGlassConfigurable = ARCFavoriteButtonConfiguration.default

        #expect(config.cornerRadius > 0)
    }

    @Test("conformsToLiquidGlassConfigurable_hasShadow")
    func conformsToLiquidGlassConfigurable_hasShadow() {
        let config: any LiquidGlassConfigurable = ARCFavoriteButtonConfiguration.default

        #expect(config.shadow.radius >= 0)
    }

    @Test("conformsToLiquidGlassConfigurable_accentColorMatchesFavoriteColor")
    func conformsToLiquidGlassConfigurable_accentColorMatchesFavoriteColor() {
        let config = ARCFavoriteButtonConfiguration(favoriteColor: .orange)

        #expect(config.accentColor == config.favoriteColor)
    }

    @Test("glassmorphic_hasLiquidGlassBackgroundStyle")
    func glassmorphic_hasLiquidGlassBackgroundStyle() {
        let config = ARCFavoriteButtonConfiguration.glassmorphic

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("glassmorphic_hasLargeSize")
    func glassmorphic_hasLargeSize() {
        let config = ARCFavoriteButtonConfiguration.glassmorphic

        #expect(config.size.iconSize == 28)
    }

    @Test("init_withLiquidGlassStyle_setsStyleCorrectly")
    func init_withLiquidGlassStyle_setsStyleCorrectly() {
        let config = ARCFavoriteButtonConfiguration(
            backgroundStyle: .liquidGlass,
            cornerRadius: 20,
            shadow: .prominent
        )

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
        #expect(config.cornerRadius == 20)
        #expect(config.shadow.radius == ARCShadow.prominent.radius)
    }
}
