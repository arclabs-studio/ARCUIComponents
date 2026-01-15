//
//  ARCListCardConfigurationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCListCardConfiguration
///
/// Tests cover default values, presets, and LiquidGlassConfigurable conformance.
@Suite("ARCListCardConfiguration Tests")
struct ARCListCardConfigurationTests {

    // MARK: - Default Configuration Tests

    @Test("default_hasTranslucentBackgroundStyle")
    func default_hasTranslucentBackgroundStyle() {
        let config = ARCListCardConfiguration.default

        if case .translucent = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected translucent background style")
        }
    }

    @Test("default_hasPositiveCornerRadius")
    func default_hasPositiveCornerRadius() {
        let config = ARCListCardConfiguration.default

        #expect(config.cornerRadius > 0)
    }

    @Test("default_hasPositiveSpacing")
    func default_hasPositiveSpacing() {
        let config = ARCListCardConfiguration.default

        #expect(config.spacing > 0)
    }

    // MARK: - Preset Configuration Tests

    @Test("prominent_hasLiquidGlassBackgroundStyle")
    func prominent_hasLiquidGlassBackgroundStyle() {
        let config = ARCListCardConfiguration.prominent

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("glassmorphic_hasLiquidGlassBackgroundStyle")
    func glassmorphic_hasLiquidGlassBackgroundStyle() {
        let config = ARCListCardConfiguration.glassmorphic

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomCornerRadius_setsRadiusCorrectly")
    func init_withCustomCornerRadius_setsRadiusCorrectly() {
        let config = ARCListCardConfiguration(cornerRadius: 20)

        #expect(config.cornerRadius == 20)
    }

    @Test("init_withCustomSpacing_setsSpacingCorrectly")
    func init_withCustomSpacing_setsSpacingCorrectly() {
        let config = ARCListCardConfiguration(spacing: 24)

        #expect(config.spacing == 24)
    }

    @Test("init_withLiquidGlassStyle_setsStyleCorrectly")
    func init_withLiquidGlassStyle_setsStyleCorrectly() {
        let config = ARCListCardConfiguration(backgroundStyle: .liquidGlass)

        if case .liquidGlass = config.backgroundStyle {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    // MARK: - LiquidGlassConfigurable Conformance Tests

    @Test("conformsToLiquidGlassConfigurable_hasAccentColor")
    func conformsToLiquidGlassConfigurable_hasAccentColor() {
        let config: any LiquidGlassConfigurable = ARCListCardConfiguration.default

        #expect(config.accentColor != nil)
    }

    @Test("conformsToLiquidGlassConfigurable_hasShadow")
    func conformsToLiquidGlassConfigurable_hasShadow() {
        let config: any LiquidGlassConfigurable = ARCListCardConfiguration.default

        #expect(config.shadow.radius >= 0)
    }
}
