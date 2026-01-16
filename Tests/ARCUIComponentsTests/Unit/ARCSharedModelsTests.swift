//
//  ARCSharedModelsTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for shared models: ARCShadow and ARCBackgroundStyle
@Suite("ARCShadow Tests")
struct ARCShadowTests {

    // MARK: - Preset Tests

    @Test("default_hasNonZeroRadius")
    func default_hasNonZeroRadius() {
        let shadow = ARCShadow.default

        #expect(shadow.radius > 0)
    }

    @Test("subtle_hasLowerRadiusThanDefault")
    func subtle_hasLowerRadiusThanDefault() {
        let subtle = ARCShadow.subtle
        let defaultShadow = ARCShadow.default

        #expect(subtle.radius < defaultShadow.radius)
    }

    @Test("prominent_hasHigherRadiusThanDefault")
    func prominent_hasHigherRadiusThanDefault() {
        let prominent = ARCShadow.prominent
        let defaultShadow = ARCShadow.default

        #expect(prominent.radius > defaultShadow.radius)
    }

    @Test("none_hasZeroRadius")
    func none_hasZeroRadius() {
        let shadow = ARCShadow.none

        #expect(shadow.radius == 0)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomRadius_setsRadiusCorrectly")
    func init_withCustomRadius_setsRadiusCorrectly() {
        let shadow = ARCShadow(color: .black, radius: 20, x: 0, y: 5)

        #expect(shadow.radius == 20)
    }

    @Test("init_withCustomOffset_setsOffsetCorrectly")
    func init_withCustomOffset_setsOffsetCorrectly() {
        let shadow = ARCShadow(color: .black, radius: 10, x: 5, y: 10)

        #expect(shadow.x == 5)
        #expect(shadow.y == 10)
    }

    @Test("init_withCustomColor_setsColorCorrectly")
    func init_withCustomColor_setsColorCorrectly() {
        let shadow = ARCShadow(color: .blue, radius: 10, x: 0, y: 5)

        #expect(shadow.color == .blue)
    }

    // MARK: - Sendable Conformance Tests

    @Test("conformsToSendable_canBeSentAcrossBoundaries")
    func conformsToSendable_canBeSentAcrossBoundaries() async {
        let shadow = ARCShadow.default

        let result = await Task.detached {
            return shadow.radius
        }.value

        #expect(result == ARCShadow.default.radius)
    }
}

// MARK: - ARCBackgroundStyle Tests

@Suite("ARCBackgroundStyle Tests")
struct ARCBackgroundStyleTests {

    @Test("liquidGlass_isValidCase")
    func liquidGlass_isValidCase() {
        let style = ARCBackgroundStyle.liquidGlass

        if case .liquidGlass = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected liquidGlass case")
        }
    }

    @Test("translucent_isValidCase")
    func translucent_isValidCase() {
        let style = ARCBackgroundStyle.translucent

        if case .translucent = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected translucent case")
        }
    }

    @Test("solid_withColorAndOpacity_isValidCase")
    func solid_withColorAndOpacity_isValidCase() {
        let style = ARCBackgroundStyle.solid(.blue, opacity: 0.8)

        if case let .solid(color, opacity) = style {
            #expect(color == .blue)
            #expect(opacity == 0.8)
        } else {
            #expect(Bool(false), "Expected solid case")
        }
    }

    @Test("solid_withZeroOpacity_isTransparent")
    func solid_withZeroOpacity_isTransparent() {
        let style = ARCBackgroundStyle.solid(.red, opacity: 0)

        if case let .solid(_, opacity) = style {
            #expect(opacity == 0)
        } else {
            #expect(Bool(false), "Expected solid case")
        }
    }

    @Test("solid_withFullOpacity_isOpaque")
    func solid_withFullOpacity_isOpaque() {
        let style = ARCBackgroundStyle.solid(.green, opacity: 1.0)

        if case let .solid(_, opacity) = style {
            #expect(opacity == 1.0)
        } else {
            #expect(Bool(false), "Expected solid case")
        }
    }

    @Test("material_withUltraThinMaterial_isValidCase")
    func material_withUltraThinMaterial_isValidCase() {
        let style = ARCBackgroundStyle.material(.ultraThinMaterial)

        if case .material = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected material case")
        }
    }

    @Test("material_withThickMaterial_isValidCase")
    func material_withThickMaterial_isValidCase() {
        let style = ARCBackgroundStyle.material(.thickMaterial)

        if case .material = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected material case")
        }
    }

    // MARK: - Sendable Conformance Tests

    @Test("conformsToSendable_liquidGlass")
    func conformsToSendable_liquidGlass() async {
        let style = ARCBackgroundStyle.liquidGlass

        let result = await Task.detached { () -> Bool in
            if case .liquidGlass = style {
                return true
            }
            return false
        }.value

        #expect(result == true)
    }

    @Test("conformsToSendable_translucent")
    func conformsToSendable_translucent() async {
        let style = ARCBackgroundStyle.translucent

        let result = await Task.detached { () -> Bool in
            if case .translucent = style {
                return true
            }
            return false
        }.value

        #expect(result == true)
    }

    @Test("conformsToSendable_solid")
    func conformsToSendable_solid() async {
        let style = ARCBackgroundStyle.solid(.blue, opacity: 0.5)

        let result = await Task.detached { () -> Bool in
            if case .solid = style {
                return true
            }
            return false
        }.value

        #expect(result == true)
    }

    // MARK: - Material Variants Tests

    @Test("material_withThinMaterial_isValidCase")
    func material_withThinMaterial_isValidCase() {
        let style = ARCBackgroundStyle.material(.thinMaterial)

        if case .material = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected material case")
        }
    }

    @Test("material_withRegularMaterial_isValidCase")
    func material_withRegularMaterial_isValidCase() {
        let style = ARCBackgroundStyle.material(.regularMaterial)

        if case .material = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected material case")
        }
    }

    @Test("material_withUltraThickMaterial_isValidCase")
    func material_withUltraThickMaterial_isValidCase() {
        let style = ARCBackgroundStyle.material(.ultraThickMaterial)

        if case .material = style {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected material case")
        }
    }

    // MARK: - Solid Color Variants Tests

    @Test("solid_withVariousColors_preservesColor")
    func solid_withVariousColors_preservesColor() {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]

        for color in colors {
            let style = ARCBackgroundStyle.solid(color, opacity: 1.0)

            if case let .solid(resultColor, _) = style {
                #expect(resultColor == color)
            } else {
                #expect(Bool(false), "Expected solid case")
            }
        }
    }

    @Test("solid_withVariousOpacities_preservesOpacity")
    func solid_withVariousOpacities_preservesOpacity() {
        let opacities: [Double] = [0.0, 0.25, 0.5, 0.75, 1.0]

        for opacity in opacities {
            let style = ARCBackgroundStyle.solid(.blue, opacity: opacity)

            if case let .solid(_, resultOpacity) = style {
                #expect(resultOpacity == opacity)
            } else {
                #expect(Bool(false), "Expected solid case")
            }
        }
    }
}

// MARK: - ARCShadow Extended Tests

@Suite("ARCShadow Extended Tests")
struct ARCShadowExtendedTests {

    // MARK: - Preset Value Verification Tests

    @Test("default_hasExpectedValues")
    func default_hasExpectedValues() {
        let shadow = ARCShadow.default

        #expect(shadow.radius == 20)
        #expect(shadow.x == 0)
        #expect(shadow.y == 10)
    }

    @Test("subtle_hasExpectedValues")
    func subtle_hasExpectedValues() {
        let shadow = ARCShadow.subtle

        #expect(shadow.radius == 10)
        #expect(shadow.x == 0)
        #expect(shadow.y == 5)
    }

    @Test("prominent_hasExpectedValues")
    func prominent_hasExpectedValues() {
        let shadow = ARCShadow.prominent

        #expect(shadow.radius == 30)
        #expect(shadow.x == 0)
        #expect(shadow.y == 15)
    }

    @Test("none_hasExpectedValues")
    func none_hasExpectedValues() {
        let shadow = ARCShadow.none

        #expect(shadow.radius == 0)
        #expect(shadow.x == 0)
        #expect(shadow.y == 0)
        #expect(shadow.color == .clear)
    }

    // MARK: - Ordering Tests

    @Test("presets_areOrderedByIntensity")
    func presets_areOrderedByIntensity() {
        let none = ARCShadow.none
        let subtle = ARCShadow.subtle
        let defaultShadow = ARCShadow.default
        let prominent = ARCShadow.prominent

        #expect(none.radius < subtle.radius)
        #expect(subtle.radius < defaultShadow.radius)
        #expect(defaultShadow.radius < prominent.radius)
    }

    @Test("presets_verticalOffsetProportionalToRadius")
    func presets_verticalOffsetProportionalToRadius() {
        let subtle = ARCShadow.subtle
        let defaultShadow = ARCShadow.default
        let prominent = ARCShadow.prominent

        // Verify y offset scales with radius
        #expect(subtle.y < defaultShadow.y)
        #expect(defaultShadow.y < prominent.y)
    }

    // MARK: - Custom Shadow Tests

    @Test("customShadow_withNegativeOffset_isAllowed")
    func customShadow_withNegativeOffset_isAllowed() {
        let shadow = ARCShadow(color: .black, radius: 10, x: -5, y: -5)

        #expect(shadow.x == -5)
        #expect(shadow.y == -5)
    }

    @Test("customShadow_withLargeRadius_isAllowed")
    func customShadow_withLargeRadius_isAllowed() {
        let shadow = ARCShadow(color: .black, radius: 100, x: 0, y: 50)

        #expect(shadow.radius == 100)
        #expect(shadow.y == 50)
    }

    @Test("customShadow_withTransparentColor_isAllowed")
    func customShadow_withTransparentColor_isAllowed() {
        let shadow = ARCShadow(color: .clear, radius: 10, x: 0, y: 5)

        #expect(shadow.color == .clear)
        #expect(shadow.radius == 10)
    }
}
