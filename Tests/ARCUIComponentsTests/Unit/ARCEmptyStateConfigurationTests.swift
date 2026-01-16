//
//  ARCEmptyStateConfigurationTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCEmptyStateConfiguration
///
/// Tests cover presets and custom initialization.
@Suite("ARCEmptyStateConfiguration Tests")
struct ARCEmptyStateConfigurationTests {
    // MARK: - Preset Tests: No Favorites

    @Test("noFavorites_hasCorrectIcon")
    func noFavorites_hasCorrectIcon() {
        let config = ARCEmptyStateConfiguration.noFavorites

        #expect(config.icon == "heart")
    }

    @Test("noFavorites_hasCorrectTitle")
    func noFavorites_hasCorrectTitle() {
        let config = ARCEmptyStateConfiguration.noFavorites

        #expect(config.title == "No Favorites Yet")
    }

    @Test("noFavorites_showsAction")
    func noFavorites_showsAction() {
        let config = ARCEmptyStateConfiguration.noFavorites

        #expect(config.showsAction == true)
    }

    @Test("noFavorites_hasPinkAccentColor")
    func noFavorites_hasPinkAccentColor() {
        let config = ARCEmptyStateConfiguration.noFavorites

        #expect(config.accentColor == .pink)
    }

    // MARK: - Preset Tests: No Results

    @Test("noResults_hasCorrectIcon")
    func noResults_hasCorrectIcon() {
        let config = ARCEmptyStateConfiguration.noResults

        #expect(config.icon == "magnifyingglass")
    }

    @Test("noResults_hasCorrectTitle")
    func noResults_hasCorrectTitle() {
        let config = ARCEmptyStateConfiguration.noResults

        #expect(config.title == "No Results")
    }

    @Test("noResults_doesNotShowAction")
    func noResults_doesNotShowAction() {
        let config = ARCEmptyStateConfiguration.noResults

        #expect(config.showsAction == false)
    }

    // MARK: - Preset Tests: Error

    @Test("error_hasCorrectIcon")
    func error_hasCorrectIcon() {
        let config = ARCEmptyStateConfiguration.error

        #expect(config.icon == "exclamationmark.triangle")
    }

    @Test("error_hasCorrectTitle")
    func error_hasCorrectTitle() {
        let config = ARCEmptyStateConfiguration.error

        #expect(config.title == "Something Went Wrong")
    }

    @Test("error_showsAction")
    func error_showsAction() {
        let config = ARCEmptyStateConfiguration.error

        #expect(config.showsAction == true)
    }

    @Test("error_hasRetryActionTitle")
    func error_hasRetryActionTitle() {
        let config = ARCEmptyStateConfiguration.error

        #expect(config.actionTitle == "Try Again")
    }

    @Test("error_hasOrangeAccentColor")
    func error_hasOrangeAccentColor() {
        let config = ARCEmptyStateConfiguration.error

        #expect(config.accentColor == .orange)
    }

    // MARK: - Preset Tests: Offline

    @Test("offline_hasCorrectIcon")
    func offline_hasCorrectIcon() {
        let config = ARCEmptyStateConfiguration.offline

        #expect(config.icon == "wifi.slash")
    }

    @Test("offline_hasCorrectTitle")
    func offline_hasCorrectTitle() {
        let config = ARCEmptyStateConfiguration.offline

        #expect(config.title == "No Connection")
    }

    @Test("offline_showsAction")
    func offline_showsAction() {
        let config = ARCEmptyStateConfiguration.offline

        #expect(config.showsAction == true)
    }

    @Test("offline_hasSettingsActionTitle")
    func offline_hasSettingsActionTitle() {
        let config = ARCEmptyStateConfiguration.offline

        #expect(config.actionTitle == "Settings")
    }

    // MARK: - Preset Tests: No Data

    @Test("noData_hasCorrectIcon")
    func noData_hasCorrectIcon() {
        let config = ARCEmptyStateConfiguration.noData

        #expect(config.icon == "tray")
    }

    @Test("noData_hasCorrectTitle")
    func noData_hasCorrectTitle() {
        let config = ARCEmptyStateConfiguration.noData

        #expect(config.title == "No Data")
    }

    @Test("noData_doesNotShowAction")
    func noData_doesNotShowAction() {
        let config = ARCEmptyStateConfiguration.noData

        #expect(config.showsAction == false)
    }

    // MARK: - Custom Initialization Tests

    @Test("init_withCustomIcon_setsIconCorrectly")
    func init_withCustomIcon_setsIconCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "photo",
            title: "No Photos",
            message: "Add photos to get started"
        )

        #expect(config.icon == "photo")
    }

    @Test("init_withCustomTitle_setsTitleCorrectly")
    func init_withCustomTitle_setsTitleCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Custom Title",
            message: "Custom message"
        )

        #expect(config.title == "Custom Title")
    }

    @Test("init_withCustomMessage_setsMessageCorrectly")
    func init_withCustomMessage_setsMessageCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Title",
            message: "Custom message here"
        )

        #expect(config.message == "Custom message here")
    }

    @Test("init_withShowsActionTrue_showsAction")
    func init_withShowsActionTrue_showsAction() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Title",
            message: "Message",
            showsAction: true
        )

        #expect(config.showsAction == true)
    }

    @Test("init_withCustomActionTitle_setsActionTitleCorrectly")
    func init_withCustomActionTitle_setsActionTitleCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Title",
            message: "Message",
            actionTitle: "Custom Action",
            showsAction: true
        )

        #expect(config.actionTitle == "Custom Action")
    }

    @Test("init_withCustomAccentColor_setsColorCorrectly")
    func init_withCustomAccentColor_setsColorCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Title",
            message: "Message",
            accentColor: .green
        )

        #expect(config.accentColor == .green)
    }

    @Test("init_withCustomIconColor_setsIconColorCorrectly")
    func init_withCustomIconColor_setsIconColorCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            iconColor: .purple,
            title: "Title",
            message: "Message"
        )

        #expect(config.iconColor == .purple)
    }

    @Test("init_withCustomSpacing_setsSpacingCorrectly")
    func init_withCustomSpacing_setsSpacingCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Title",
            message: "Message",
            spacing: 30
        )

        #expect(config.spacing == 30)
    }

    @Test("init_withDefaultValues_hasCorrectDefaults")
    func init_withDefaultValues_hasCorrectDefaults() {
        let config = ARCEmptyStateConfiguration(
            icon: "doc",
            title: "Title",
            message: "Message"
        )

        #expect(config.iconColor == .secondary)
        #expect(config.actionTitle == "Get Started")
        #expect(config.showsAction == false)
        #expect(config.accentColor == .blue)
    }

    // MARK: - LiquidGlassConfigurable Conformance Tests

    @Test("conformsToLiquidGlassConfigurable_hasBackgroundStyle")
    func conformsToLiquidGlassConfigurable_hasBackgroundStyle() {
        let config: any LiquidGlassConfigurable = ARCEmptyStateConfiguration.noFavorites

        if case .translucent = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected translucent background style")
        }
    }

    @Test("conformsToLiquidGlassConfigurable_hasCornerRadius")
    func conformsToLiquidGlassConfigurable_hasCornerRadius() {
        let config: any LiquidGlassConfigurable = ARCEmptyStateConfiguration.noFavorites

        #expect(config.cornerRadius > 0)
    }

    @Test("conformsToLiquidGlassConfigurable_hasShadow")
    func conformsToLiquidGlassConfigurable_hasShadow() {
        let config: any LiquidGlassConfigurable = ARCEmptyStateConfiguration.noFavorites

        #expect(config.shadow.radius >= 0)
    }

    @Test("premium_hasLiquidGlassBackgroundStyle")
    func premium_hasLiquidGlassBackgroundStyle() {
        let config = ARCEmptyStateConfiguration.premium

        if case .liquidGlass = config.backgroundStyle {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected liquidGlass background style")
        }
    }

    @Test("premium_hasPurpleAccentColor")
    func premium_hasPurpleAccentColor() {
        let config = ARCEmptyStateConfiguration.premium

        #expect(config.accentColor == .purple)
    }

    @Test("init_withLiquidGlassStyle_setsStyleCorrectly")
    func init_withLiquidGlassStyle_setsStyleCorrectly() {
        let config = ARCEmptyStateConfiguration(
            icon: "star",
            title: "Test",
            message: "Test message",
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
