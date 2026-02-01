//
//  ARCRatingInputConfigurationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/2/26.
//

import Testing
@testable import ARCUIComponents

/// Unit tests for ARCRatingInputConfiguration
///
/// Tests cover presets and custom initialization.
@Suite("ARCRatingInputConfiguration Tests")
struct ARCRatingInputConfigurationTests {
    // MARK: - Preset Tests: Slider

    @Test("slider_hasSliderStyle")
    func slider_hasSliderStyle() {
        let config = ARCRatingInputConfiguration.slider

        #expect(config.style == .slider)
    }

    @Test("slider_showsLabel")
    func slider_showsLabel() {
        let config = ARCRatingInputConfiguration.slider

        #expect(config.showLabel == true)
    }

    @Test("slider_isAnimated")
    func slider_isAnimated() {
        let config = ARCRatingInputConfiguration.slider

        #expect(config.animated == true)
    }

    // MARK: - Preset Tests: Circular Drag

    @Test("circularDrag_hasCircularDragStyle")
    func circularDrag_hasCircularDragStyle() {
        let config = ARCRatingInputConfiguration.circularDrag

        #expect(config.style == .circularDrag)
    }

    @Test("circularDrag_showsLabel")
    func circularDrag_showsLabel() {
        let config = ARCRatingInputConfiguration.circularDrag

        #expect(config.showLabel == true)
    }

    @Test("circularDrag_isAnimated")
    func circularDrag_isAnimated() {
        let config = ARCRatingInputConfiguration.circularDrag

        #expect(config.animated == true)
    }

    // MARK: - Preset Tests: Compact

    @Test("compact_hasCircularDragStyle")
    func compact_hasCircularDragStyle() {
        let config = ARCRatingInputConfiguration.compact

        #expect(config.style == .circularDrag)
    }

    @Test("compact_doesNotShowLabel")
    func compact_doesNotShowLabel() {
        let config = ARCRatingInputConfiguration.compact

        #expect(config.showLabel == false)
    }

    @Test("compact_isAnimated")
    func compact_isAnimated() {
        let config = ARCRatingInputConfiguration.compact

        #expect(config.animated == true)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withSliderStyle_setsStyleCorrectly")
    func init_withSliderStyle_setsStyleCorrectly() {
        let config = ARCRatingInputConfiguration(style: .slider)

        #expect(config.style == .slider)
    }

    @Test("init_withCircularDragStyle_setsStyleCorrectly")
    func init_withCircularDragStyle_setsStyleCorrectly() {
        let config = ARCRatingInputConfiguration(style: .circularDrag)

        #expect(config.style == .circularDrag)
    }

    @Test("init_withShowLabelFalse_setsShowLabelCorrectly")
    func init_withShowLabelFalse_setsShowLabelCorrectly() {
        let config = ARCRatingInputConfiguration(showLabel: false)

        #expect(config.showLabel == false)
    }

    @Test("init_withAnimatedFalse_setsAnimatedCorrectly")
    func init_withAnimatedFalse_setsAnimatedCorrectly() {
        let config = ARCRatingInputConfiguration(animated: false)

        #expect(config.animated == false)
    }

    @Test("init_withDefaultValues_hasCorrectDefaults")
    func init_withDefaultValues_hasCorrectDefaults() {
        let config = ARCRatingInputConfiguration()

        #expect(config.style == .slider)
        #expect(config.showLabel == true)
        #expect(config.animated == true)
    }

    @Test("init_withAllCustomValues_setsAllCorrectly")
    func init_withAllCustomValues_setsAllCorrectly() {
        let config = ARCRatingInputConfiguration(
            style: .circularDrag,
            showLabel: false,
            animated: false
        )

        #expect(config.style == .circularDrag)
        #expect(config.showLabel == false)
        #expect(config.animated == false)
    }
}

// MARK: - ARCRatingInputStyle Tests

@Suite("ARCRatingInputStyle Tests")
struct ARCRatingInputStyleTests {
    @Test("allCases_containsSlider")
    func allCases_containsSlider() {
        #expect(ARCRatingInputStyle.allCases.contains(.slider))
    }

    @Test("allCases_containsCircularDrag")
    func allCases_containsCircularDrag() {
        #expect(ARCRatingInputStyle.allCases.contains(.circularDrag))
    }

    @Test("allCases_hasTwoStyles")
    func allCases_hasTwoStyles() {
        #expect(ARCRatingInputStyle.allCases.count == 2)
    }

    @Test("slider_rawValue_isCorrect")
    func slider_rawValue_isCorrect() {
        #expect(ARCRatingInputStyle.slider.rawValue == "slider")
    }

    @Test("circularDrag_rawValue_isCorrect")
    func circularDrag_rawValue_isCorrect() {
        #expect(ARCRatingInputStyle.circularDrag.rawValue == "circularDrag")
    }
}
