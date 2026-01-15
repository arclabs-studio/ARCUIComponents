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
/// Tests cover state management, presentation logic, drag gestures,
/// and action execution following Swift Testing best practices.
@Suite("ARCMenuViewModel Tests")
@MainActor
struct ARCMenuViewModelTests {

    // MARK: - Initialization Tests

    @Test("init_withDefaultValues_setsCorrectInitialState")
    func init_withDefaultValues_setsCorrectInitialState() {
        let viewModel = ARCMenuViewModel()

        #expect(viewModel.isPresented == false)
        #expect(viewModel.dragOffset == 0)
        #expect(viewModel.backdropOpacity == 0)
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
        let config = ARCMenuConfiguration.fitness

        let viewModel = ARCMenuViewModel(configuration: config)

        #expect(viewModel.configuration.accentColor == config.accentColor)
    }

    // MARK: - Present Tests

    @Test("present_whenCalled_setsIsPresentedToTrue")
    func present_whenCalled_setsIsPresentedToTrue() {
        let viewModel = ARCMenuViewModel()

        viewModel.present()

        #expect(viewModel.isPresented == true)
    }

    @Test("present_whenCalled_setsBackdropOpacityToOne")
    func present_whenCalled_setsBackdropOpacityToOne() {
        let viewModel = ARCMenuViewModel()

        viewModel.present()

        #expect(viewModel.backdropOpacity == 1.0)
    }

    // MARK: - Dismiss Tests

    @Test("dismiss_whenPresented_setsIsPresentedToFalse")
    func dismiss_whenPresented_setsIsPresentedToFalse() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()

        viewModel.dismiss()

        #expect(viewModel.isPresented == false)
    }

    @Test("dismiss_whenPresented_setsBackdropOpacityToZero")
    func dismiss_whenPresented_setsBackdropOpacityToZero() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()

        viewModel.dismiss()

        #expect(viewModel.backdropOpacity == 0)
    }

    @Test("dismiss_whenPresented_resetsDragOffset")
    func dismiss_whenPresented_resetsDragOffset() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()
        viewModel.updateDragOffset(50)

        viewModel.dismiss()

        #expect(viewModel.dragOffset == 0)
    }

    // MARK: - Toggle Tests

    @Test("toggle_whenNotPresented_presentsMenu")
    func toggle_whenNotPresented_presentsMenu() {
        let viewModel = ARCMenuViewModel()

        viewModel.toggle()

        #expect(viewModel.isPresented == true)
    }

    @Test("toggle_whenPresented_dismissesMenu")
    func toggle_whenPresented_dismissesMenu() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()

        viewModel.toggle()

        #expect(viewModel.isPresented == false)
    }

    @Test("toggle_calledTwice_returnsToInitialState")
    func toggle_calledTwice_returnsToInitialState() {
        let viewModel = ARCMenuViewModel()
        let initialState = viewModel.isPresented

        viewModel.toggle()
        viewModel.toggle()

        #expect(viewModel.isPresented == initialState)
    }

    // MARK: - Drag Offset Tests

    @Test("updateDragOffset_withPositiveValue_updatesOffset")
    func updateDragOffset_withPositiveValue_updatesOffset() {
        let viewModel = ARCMenuViewModel()

        viewModel.updateDragOffset(50)

        #expect(viewModel.dragOffset == 50)
    }

    @Test("updateDragOffset_withNegativeValue_doesNotUpdateOffset")
    func updateDragOffset_withNegativeValue_doesNotUpdateOffset() {
        let viewModel = ARCMenuViewModel()

        viewModel.updateDragOffset(-50)

        #expect(viewModel.dragOffset == 0)
    }

    @Test("updateDragOffset_withPositiveValue_updatesBackdropOpacity")
    func updateDragOffset_withPositiveValue_updatesBackdropOpacity() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()

        viewModel.updateDragOffset(50)

        #expect(viewModel.backdropOpacity < 1.0)
    }

    // MARK: - End Drag Tests

    @Test("endDrag_belowThreshold_resetsOffset")
    func endDrag_belowThreshold_resetsOffset() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()
        viewModel.updateDragOffset(50)

        viewModel.endDrag(at: 50)

        #expect(viewModel.dragOffset == 0)
        #expect(viewModel.isPresented == true)
    }

    @Test("endDrag_aboveThreshold_dismissesMenu")
    func endDrag_aboveThreshold_dismissesMenu() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()

        viewModel.endDrag(at: 150)

        #expect(viewModel.isPresented == false)
    }

    @Test("endDrag_atExactThreshold_dismissesMenu")
    func endDrag_atExactThreshold_dismissesMenu() {
        let viewModel = ARCMenuViewModel()
        viewModel.present()
        let threshold = viewModel.configuration.dragDismissalThreshold

        viewModel.endDrag(at: threshold)

        #expect(viewModel.isPresented == false)
    }

    // MARK: - Standard Factory Tests

    @Test("standard_withAllActions_createsCorrectNumberOfItems")
    func standard_withAllActions_createsCorrectNumberOfItems() {
        let viewModel = ARCMenuViewModel.standard(
            user: nil,
            onSettings: {},
            onProfile: {},
            onPlan: {},
            onContact: {},
            onAbout: {},
            onLogout: {}
        )

        #expect(viewModel.menuItems.count == 6)
    }

    @Test("standard_withOnlyRequiredActions_createsCorrectNumberOfItems")
    func standard_withOnlyRequiredActions_createsCorrectNumberOfItems() {
        let viewModel = ARCMenuViewModel.standard(
            user: nil,
            onSettings: {},
            onLogout: {}
        )

        #expect(viewModel.menuItems.count == 2)
    }

    @Test("standard_withNoActions_createsEmptyItems")
    func standard_withNoActions_createsEmptyItems() {
        let viewModel = ARCMenuViewModel.standard(user: nil)

        #expect(viewModel.menuItems.isEmpty)
    }

    @Test("standard_withUser_setsUserCorrectly")
    func standard_withUser_setsUserCorrectly() {
        let user = ARCMenuUser(
            name: "Test",
            avatarImage: .initials("T")
        )

        let viewModel = ARCMenuViewModel.standard(
            user: user,
            onSettings: {}
        )

        #expect(viewModel.user?.name == "Test")
    }

    @Test("standard_withConfiguration_setsConfigurationCorrectly")
    func standard_withConfiguration_setsConfigurationCorrectly() {
        let viewModel = ARCMenuViewModel.standard(
            user: nil,
            configuration: .premium
        )

        #expect(viewModel.configuration.accentColor == ARCMenuConfiguration.premium.accentColor)
    }
}
