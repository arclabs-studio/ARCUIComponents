//
//  ARCMenuViewModelTests.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 15/01/26.
//

import Testing
@testable import ARCUIComponents

/// Unit tests for ARCMenuViewModel
///
/// Tests cover state management, data storage, and factory methods
/// following Swift Testing best practices.
@Suite("ARCMenuViewModel Tests")
@MainActor
struct ARCMenuViewModelTests {
    // MARK: - Initialization Tests

    @Test("init_withDefaultValues_setsCorrectInitialState")
    func init_withDefaultValues_setsCorrectInitialState() {
        let viewModel = ARCMenuViewModel()

        #expect(viewModel.dragOffset == 0)
        #expect(viewModel.user == nil)
        #expect(viewModel.menuItems.isEmpty)
    }

    @Test("init_withUser_setsUserCorrectly")
    func init_withUser_setsUserCorrectly() {
        let user = ARCMenuUser(
            name: "Test User",
            email: "test@example.com",
            avatarImage: .initials("TU")
        )

        let viewModel = ARCMenuViewModel(user: user)

        #expect(viewModel.user?.name == "Test User")
        #expect(viewModel.user?.email == "test@example.com")
    }

    @Test("init_withMenuItems_setsItemsCorrectly")
    func init_withMenuItems_setsItemsCorrectly() {
        let items: [ARCMenuItem] = [
            .Common.settings(action: {}),
            .Common.profile(action: {})
        ]

        let viewModel = ARCMenuViewModel(menuItems: items)

        #expect(viewModel.menuItems.count == 2)
    }

    @Test("init_withConfiguration_setsConfigurationCorrectly")
    func init_withConfiguration_setsConfigurationCorrectly() {
        let config = ARCMenuConfiguration(accentColor: .green)

        let viewModel = ARCMenuViewModel(configuration: config)

        #expect(viewModel.configuration.accentColor == config.accentColor)
    }

    // MARK: - Property Mutation Tests

    @Test("dragOffset_canBeUpdated")
    func dragOffset_canBeUpdated() {
        let viewModel = ARCMenuViewModel()

        viewModel.dragOffset = 50

        #expect(viewModel.dragOffset == 50)
    }

    @Test("user_canBeUpdated")
    func user_canBeUpdated() {
        let viewModel = ARCMenuViewModel()
        let user = ARCMenuUser(name: "Updated", avatarImage: .initials("U"))

        viewModel.user = user

        #expect(viewModel.user?.name == "Updated")
    }

    @Test("menuItems_canBeUpdated")
    func menuItems_canBeUpdated() {
        let viewModel = ARCMenuViewModel()
        let items: [ARCMenuItem] = [.Common.settings(action: {})]

        viewModel.menuItems = items

        #expect(viewModel.menuItems.count == 1)
    }

    @Test("configuration_canBeUpdated")
    func configuration_canBeUpdated() {
        let viewModel = ARCMenuViewModel()
        let newConfig = ARCMenuConfiguration(accentColor: .purple)

        viewModel.configuration = newConfig

        #expect(viewModel.configuration.accentColor == .purple)
    }

    // MARK: - withDefaultItems Factory Tests

    @Test("withDefaultItems_createsAllDefaultMenuItems")
    func withDefaultItems_createsAllDefaultMenuItems() {
        let viewModel = ARCMenuViewModel.withDefaultItems(
            user: nil,
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        #expect(viewModel.menuItems.count == 6)
    }

    @Test("withDefaultItems_withUser_setsUserCorrectly")
    func withDefaultItems_withUser_setsUserCorrectly() {
        let user = ARCMenuUser(
            name: "Test",
            avatarImage: .initials("T")
        )

        let viewModel = ARCMenuViewModel.withDefaultItems(
            user: user,
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        #expect(viewModel.user?.name == "Test")
    }

    @Test("withDefaultItems_withConfiguration_setsConfigurationCorrectly")
    func withDefaultItems_withConfiguration_setsConfigurationCorrectly() {
        let config = ARCMenuConfiguration(accentColor: .orange)

        let viewModel = ARCMenuViewModel.withDefaultItems(
            user: nil,
            configuration: config,
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        #expect(viewModel.configuration.accentColor == .orange)
    }

    // MARK: - Default Items Factory Tests

    @Test("defaultItems_createsProfileItem")
    func defaultItems_createsProfileItem() {
        let items = ARCMenuItem.defaultItems(
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        #expect(items.first?.title == "Profile")
    }

    @Test("defaultItems_createsLogoutAsLastItem")
    func defaultItems_createsLogoutAsLastItem() {
        let items = ARCMenuItem.defaultItems(
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        #expect(items.last?.title == "Logout")
        #expect(items.last?.isDestructive == true)
    }

    @Test("defaultItems_containsFeedbackItem")
    func defaultItems_containsFeedbackItem() {
        let items = ARCMenuItem.defaultItems(
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        let feedbackItem = items.first { $0.title == "Feedback" }
        #expect(feedbackItem != nil)
    }

    @Test("defaultItems_containsSubscriptionsItem")
    func defaultItems_containsSubscriptionsItem() {
        let items = ARCMenuItem.defaultItems(
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )

        let subscriptionsItem = items.first { $0.title == "Subscriptions" }
        #expect(subscriptionsItem != nil)
    }
}
