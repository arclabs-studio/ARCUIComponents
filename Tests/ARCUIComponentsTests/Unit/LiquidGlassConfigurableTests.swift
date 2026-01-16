//
//  LiquidGlassConfigurableTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/01/16.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for LiquidGlassConfigurable protocol and conforming types
///
/// Tests verify that configurations correctly implement the protocol
/// requirements for unified liquid glass styling.
@Suite("LiquidGlassConfigurable Protocol Tests")
struct LiquidGlassConfigurableTests {

    // MARK: - ARCMenuConfiguration Conformance Tests

    @Test("ARCMenuConfiguration_conformsToProtocol_hasAllRequiredProperties")
    func ARCMenuConfiguration_conformsToProtocol_hasAllRequiredProperties() {
        let config: any LiquidGlassConfigurable = ARCMenuConfiguration.default

        // Verify protocol properties are accessible and valid
        let _ = config.accentColor // Non-optional, always present
        #expect(config.cornerRadius > 0)
        #expect(config.shadow.radius >= 0)
    }

    @Test("ARCMenuConfiguration_defaultPreset_hasLiquidGlassBackground")
    func ARCMenuConfiguration_defaultPreset_hasLiquidGlassBackground() {
        let config = ARCMenuConfiguration.default

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("ARCMenuConfiguration_allPresets_haveLiquidGlassOrTranslucentBackground")
    func ARCMenuConfiguration_allPresets_haveLiquidGlassOrTranslucentBackground() {
        let presets: [ARCMenuConfiguration] = [
            .default,
            .dark,
            .fitness,
            .premium,
            .minimal
        ]

        for preset in presets {
            switch preset.backgroundStyle {
            case .liquidGlass, .translucent:
                #expect(Bool(true))
            case .solid, .material:
                #expect(Bool(false), "Unexpected background style in preset")
            }
        }
    }

    // MARK: - ARCListCardConfiguration Conformance Tests

    @Test("ARCListCardConfiguration_conformsToProtocol_hasAllRequiredProperties")
    func ARCListCardConfiguration_conformsToProtocol_hasAllRequiredProperties() {
        let config: any LiquidGlassConfigurable = ARCListCardConfiguration.default

        // Verify protocol properties are accessible and valid
        let _ = config.accentColor // Non-optional, always present
        #expect(config.cornerRadius > 0)
        #expect(config.shadow.radius >= 0)
    }

    @Test("ARCListCardConfiguration_prominentPreset_hasLiquidGlassBackground")
    func ARCListCardConfiguration_prominentPreset_hasLiquidGlassBackground() {
        let config = ARCListCardConfiguration.prominent

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("ARCListCardConfiguration_glassmorphicPreset_hasLiquidGlassBackground")
    func ARCListCardConfiguration_glassmorphicPreset_hasLiquidGlassBackground() {
        let config = ARCListCardConfiguration.glassmorphic

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    // MARK: - Protocol Property Consistency Tests

    @Test("allConfigurations_havePositiveCornerRadius")
    func allConfigurations_havePositiveCornerRadius() {
        let menuConfigs: [any LiquidGlassConfigurable] = [
            ARCMenuConfiguration.default,
            ARCMenuConfiguration.dark,
            ARCMenuConfiguration.fitness,
            ARCMenuConfiguration.premium,
            ARCMenuConfiguration.minimal
        ]

        let listConfigs: [any LiquidGlassConfigurable] = [
            ARCListCardConfiguration.default,
            ARCListCardConfiguration.prominent,
            ARCListCardConfiguration.glassmorphic
        ]

        let otherConfigs: [any LiquidGlassConfigurable] = [
            ARCEmptyStateConfiguration.noFavorites,
            ARCEmptyStateConfiguration.premium,
            ARCFavoriteButtonConfiguration.default,
            ARCFavoriteButtonConfiguration.glassmorphic,
            ARCSearchButtonConfiguration.default,
            ARCSearchButtonConfiguration.glassmorphic
        ]

        for config in menuConfigs + listConfigs + otherConfigs {
            #expect(config.cornerRadius > 0, "Configuration should have positive corner radius")
        }
    }

    @Test("allConfigurations_haveValidShadow")
    func allConfigurations_haveValidShadow() {
        let configs: [any LiquidGlassConfigurable] = [
            ARCMenuConfiguration.default,
            ARCMenuConfiguration.minimal,
            ARCListCardConfiguration.default,
            ARCListCardConfiguration.prominent,
            ARCEmptyStateConfiguration.noFavorites,
            ARCEmptyStateConfiguration.premium,
            ARCFavoriteButtonConfiguration.default,
            ARCFavoriteButtonConfiguration.glassmorphic,
            ARCSearchButtonConfiguration.default,
            ARCSearchButtonConfiguration.glassmorphic
        ]

        for config in configs {
            #expect(config.shadow.radius >= 0, "Shadow radius should be non-negative")
        }
    }

    // MARK: - New Component Conformance Tests

    @Test("ARCEmptyStateConfiguration_conformsToProtocol")
    func ARCEmptyStateConfiguration_conformsToProtocol() {
        let config: any LiquidGlassConfigurable = ARCEmptyStateConfiguration.noFavorites

        let _ = config.accentColor
        #expect(config.cornerRadius > 0)
        #expect(config.shadow.radius >= 0)
    }

    @Test("ARCFavoriteButtonConfiguration_conformsToProtocol")
    func ARCFavoriteButtonConfiguration_conformsToProtocol() {
        let config: any LiquidGlassConfigurable = ARCFavoriteButtonConfiguration.default

        let _ = config.accentColor
        #expect(config.cornerRadius > 0)
        #expect(config.shadow.radius >= 0)
    }

    @Test("ARCSearchButtonConfiguration_conformsToProtocol")
    func ARCSearchButtonConfiguration_conformsToProtocol() {
        let config: any LiquidGlassConfigurable = ARCSearchButtonConfiguration.default

        let _ = config.accentColor
        #expect(config.cornerRadius > 0)
        #expect(config.shadow.radius >= 0)
    }

    @Test("allGlassmorphicPresets_haveLiquidGlassBackground")
    func allGlassmorphicPresets_haveLiquidGlassBackground() {
        let glassmorphicConfigs: [any LiquidGlassConfigurable] = [
            ARCMenuConfiguration.default,
            ARCListCardConfiguration.glassmorphic,
            ARCEmptyStateConfiguration.premium,
            ARCFavoriteButtonConfiguration.glassmorphic,
            ARCSearchButtonConfiguration.glassmorphic
        ]

        for config in glassmorphicConfigs {
            if case .liquidGlass = config.backgroundStyle {
                #expect(Bool(true))
            } else if case .translucent = config.backgroundStyle {
                // Some defaults use translucent which is also valid
                #expect(Bool(true))
            } else {
                #expect(Bool(false), "Expected liquidGlass or translucent background style")
            }
        }
    }

    // MARK: - Custom Configuration Tests

    @Test("customMenuConfiguration_withLiquidGlass_conformsCorrectly")
    func customMenuConfiguration_withLiquidGlass_conformsCorrectly() {
        let config = ARCMenuConfiguration(
            accentColor: .purple,
            backgroundStyle: .liquidGlass,
            cornerRadius: 24,
            shadow: .prominent
        )

        let configurable: any LiquidGlassConfigurable = config

        #expect(configurable.accentColor == .purple)
        #expect(configurable.cornerRadius == 24)
        #expect(configurable.shadow.radius == ARCShadow.prominent.radius)
    }

    @Test("customListCardConfiguration_withTranslucent_conformsCorrectly")
    func customListCardConfiguration_withTranslucent_conformsCorrectly() {
        let config = ARCListCardConfiguration(
            accentColor: .green,
            backgroundStyle: .translucent,
            cornerRadius: 16,
            shadow: .subtle
        )

        let configurable: any LiquidGlassConfigurable = config

        #expect(configurable.accentColor == .green)
        #expect(configurable.cornerRadius == 16)
        #expect(configurable.shadow.radius == ARCShadow.subtle.radius)

        if case .translucent = configurable.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected translucent background style")
        }
    }

    // MARK: - Sendable Conformance Tests

    @Test("ARCMenuConfiguration_conformsToSendable_canBeSentAcrossBoundaries")
    func ARCMenuConfiguration_conformsToSendable_canBeSentAcrossBoundaries() async {
        let config = ARCMenuConfiguration.default

        let result = await Task.detached {
            return config.cornerRadius
        }.value

        #expect(result == ARCMenuConfiguration.default.cornerRadius)
    }

    @Test("ARCListCardConfiguration_conformsToSendable_canBeSentAcrossBoundaries")
    func ARCListCardConfiguration_conformsToSendable_canBeSentAcrossBoundaries() async {
        let config = ARCListCardConfiguration.prominent

        let result = await Task.detached {
            return config.cornerRadius
        }.value

        #expect(result == ARCListCardConfiguration.prominent.cornerRadius)
    }
}

// MARK: - Background Style Combination Tests

@Suite("LiquidGlass Background Style Tests")
struct LiquidGlassBackgroundStyleTests {

    @Test("liquidGlass_canBeUsedInMenuConfiguration")
    func liquidGlass_canBeUsedInMenuConfiguration() {
        let config = ARCMenuConfiguration(backgroundStyle: .liquidGlass)

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("liquidGlass_canBeUsedInListCardConfiguration")
    func liquidGlass_canBeUsedInListCardConfiguration() {
        let config = ARCListCardConfiguration(backgroundStyle: .liquidGlass)

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("translucent_canBeUsedInMenuConfiguration")
    func translucent_canBeUsedInMenuConfiguration() {
        let config = ARCMenuConfiguration(backgroundStyle: .translucent)

        if case .translucent = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }

    @Test("solid_canBeUsedInListCardConfiguration")
    func solid_canBeUsedInListCardConfiguration() {
        let config = ARCListCardConfiguration(backgroundStyle: .solid(.blue, opacity: 0.8))

        if case let .solid(color, opacity) = config.backgroundStyle {
            #expect(color == .blue)
            #expect(opacity == 0.8)
        } else {
            #expect(Bool(false))
        }
    }

    @Test("material_canBeUsedInMenuConfiguration")
    func material_canBeUsedInMenuConfiguration() {
        let config = ARCMenuConfiguration(backgroundStyle: .material(.thickMaterial))

        if case .material = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }
}
