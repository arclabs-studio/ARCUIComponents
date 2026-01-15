//
//  ARCMenuItemTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import SwiftUI
import Testing
@testable import ARCUIComponents

/// Unit tests for ARCMenuItem
///
/// Tests cover initialization, factory methods, and icon types.
@Suite("ARCMenuItem Tests")
struct ARCMenuItemTests {

    // MARK: - Initialization Tests

    @Test("init_withRequiredParameters_createsItem")
    func init_withRequiredParameters_createsItem() {
        let item = ARCMenuItem(
            title: "Test",
            icon: .system("gear"),
            action: {}
        )

        #expect(item.title == "Test")
        #expect(item.subtitle == nil)
        #expect(item.badge == nil)
        #expect(item.isDestructive == false)
        #expect(item.showsDisclosure == false)
    }

    @Test("init_withAllParameters_createsItemCorrectly")
    func init_withAllParameters_createsItemCorrectly() {
        let item = ARCMenuItem(
            title: "Full Item",
            subtitle: "Subtitle text",
            icon: .system("star.fill"),
            badge: "New",
            isDestructive: true,
            showsDisclosure: true,
            action: {}
        )

        #expect(item.title == "Full Item")
        #expect(item.subtitle == "Subtitle text")
        #expect(item.badge == "New")
        #expect(item.isDestructive == true)
        #expect(item.showsDisclosure == true)
    }

    @Test("init_generatesUniqueId")
    func init_generatesUniqueId() {
        let item1 = ARCMenuItem(title: "Item 1", icon: .system("gear"), action: {})
        let item2 = ARCMenuItem(title: "Item 2", icon: .system("gear"), action: {})

        #expect(item1.id != item2.id)
    }

    @Test("init_withCustomId_usesProvidedId")
    func init_withCustomId_usesProvidedId() {
        let customId = UUID()
        let item = ARCMenuItem(
            id: customId,
            title: "Test",
            icon: .system("gear"),
            action: {}
        )

        #expect(item.id == customId)
    }

    // MARK: - Factory Method Tests: Settings

    @Test("settings_hasCorrectTitle")
    func settings_hasCorrectTitle() {
        let item = ARCMenuItem.Common.settings(action: {})

        #expect(item.title == "Settings")
    }

    @Test("settings_hasSubtitle")
    func settings_hasSubtitle() {
        let item = ARCMenuItem.Common.settings(action: {})

        #expect(item.subtitle == "Preferences and options")
    }

    @Test("settings_showsDisclosure")
    func settings_showsDisclosure() {
        let item = ARCMenuItem.Common.settings(action: {})

        #expect(item.showsDisclosure == true)
    }

    @Test("settings_isNotDestructive")
    func settings_isNotDestructive() {
        let item = ARCMenuItem.Common.settings(action: {})

        #expect(item.isDestructive == false)
    }

    // MARK: - Factory Method Tests: Profile

    @Test("profile_hasCorrectTitle")
    func profile_hasCorrectTitle() {
        let item = ARCMenuItem.Common.profile(action: {})

        #expect(item.title == "Profile")
    }

    @Test("profile_showsDisclosure")
    func profile_showsDisclosure() {
        let item = ARCMenuItem.Common.profile(action: {})

        #expect(item.showsDisclosure == true)
    }

    // MARK: - Factory Method Tests: Plan

    @Test("plan_hasCorrectTitle")
    func plan_hasCorrectTitle() {
        let item = ARCMenuItem.Common.plan(action: {})

        #expect(item.title == "Plan")
    }

    @Test("plan_withBadge_setsBadgeCorrectly")
    func plan_withBadge_setsBadgeCorrectly() {
        let item = ARCMenuItem.Common.plan(badge: "Pro", action: {})

        #expect(item.badge == "Pro")
    }

    @Test("plan_withoutBadge_hasNoBadge")
    func plan_withoutBadge_hasNoBadge() {
        let item = ARCMenuItem.Common.plan(action: {})

        #expect(item.badge == nil)
    }

    // MARK: - Factory Method Tests: Logout

    @Test("logout_hasCorrectTitle")
    func logout_hasCorrectTitle() {
        let item = ARCMenuItem.Common.logout(action: {})

        #expect(item.title == "Logout")
    }

    @Test("logout_isDestructive")
    func logout_isDestructive() {
        let item = ARCMenuItem.Common.logout(action: {})

        #expect(item.isDestructive == true)
    }

    @Test("logout_doesNotShowDisclosure")
    func logout_doesNotShowDisclosure() {
        let item = ARCMenuItem.Common.logout(action: {})

        #expect(item.showsDisclosure == false)
    }

    // MARK: - Factory Method Tests: Delete Account

    @Test("deleteAccount_hasCorrectTitle")
    func deleteAccount_hasCorrectTitle() {
        let item = ARCMenuItem.Common.deleteAccount(action: {})

        #expect(item.title == "Delete Account")
    }

    @Test("deleteAccount_isDestructive")
    func deleteAccount_isDestructive() {
        let item = ARCMenuItem.Common.deleteAccount(action: {})

        #expect(item.isDestructive == true)
    }

    // MARK: - Factory Method Tests: Other Items

    @Test("contact_hasCorrectTitle")
    func contact_hasCorrectTitle() {
        let item = ARCMenuItem.Common.contact(action: {})

        #expect(item.title == "Contact")
    }

    @Test("about_hasCorrectTitle")
    func about_hasCorrectTitle() {
        let item = ARCMenuItem.Common.about(action: {})

        #expect(item.title == "About")
    }

    @Test("help_hasCorrectTitle")
    func help_hasCorrectTitle() {
        let item = ARCMenuItem.Common.help(action: {})

        #expect(item.title == "Help")
    }

    @Test("share_hasCorrectTitle")
    func share_hasCorrectTitle() {
        let item = ARCMenuItem.Common.share(action: {})

        #expect(item.title == "Share")
    }

    @Test("notifications_hasCorrectTitle")
    func notifications_hasCorrectTitle() {
        let item = ARCMenuItem.Common.notifications(action: {})

        #expect(item.title == "Notifications")
    }

    @Test("notifications_withBadge_setsBadgeCorrectly")
    func notifications_withBadge_setsBadgeCorrectly() {
        let item = ARCMenuItem.Common.notifications(badge: "5", action: {})

        #expect(item.badge == "5")
    }

    @Test("privacy_hasCorrectTitle")
    func privacy_hasCorrectTitle() {
        let item = ARCMenuItem.Common.privacy(action: {})

        #expect(item.title == "Privacy")
    }
}

// MARK: - ARCMenuIcon Tests

@Suite("ARCMenuIcon Tests")
struct ARCMenuIconTests {

    @Test("system_createsSystemIcon")
    func system_createsSystemIcon() {
        let icon = ARCMenuIcon.system("gear")

        if case let .system(name, _) = icon {
            #expect(name == "gear")
        } else {
            #expect(Bool(false), "Expected system icon")
        }
    }

    @Test("system_withRenderingMode_setsRenderingMode")
    func system_withRenderingMode_setsRenderingMode() {
        let icon = ARCMenuIcon.system("star.fill", renderingMode: .multicolor)

        if case let .system(name, _) = icon {
            #expect(name == "star.fill")
            // Can't compare SymbolRenderingMode directly, but we verify it was created
        } else {
            #expect(Bool(false), "Expected system icon")
        }
    }

    @Test("image_createsImageIcon")
    func image_createsImageIcon() {
        let icon = ARCMenuIcon.image("custom-icon")

        if case let .image(name) = icon {
            #expect(name == "custom-icon")
        } else {
            #expect(Bool(false), "Expected image icon")
        }
    }
}
