//
//  ARCMenuViewModel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import Observation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// View model for ARCMenu
///
/// Manages menu state and configuration. With native sheet presentation,
/// this view model primarily handles data and configuration while SwiftUI
/// manages presentation state via bindings.
///
/// ## Usage
///
/// ```swift
/// @State private var showMenu = false
/// @State private var viewModel = ARCMenuViewModel(
///     user: ARCMenuUser(name: "John", avatarImage: .initials("JD")),
///     menuItems: ARCMenuItem.defaultItems(...)
/// )
///
/// ContentView()
///     .arcMenu(isPresented: $showMenu, viewModel: viewModel)
/// ```
///
/// - Note: Uses `@Observable` for Swift 6 compatibility
@Observable @MainActor
public final class ARCMenuViewModel { // swiftlint:disable:this observable_viewmodel
    // MARK: - State

    /// Current drag offset for trailing panel dismissal gesture
    public var dragOffset: CGFloat = 0

    // MARK: - Data

    /// Menu user information
    public var user: ARCMenuUser?

    /// Menu items to display (flat layout)
    public var menuItems: [ARCMenuItem]

    /// Menu sections to display (grouped layout)
    public var sections: [ARCMenuSection]

    /// Menu configuration
    public var configuration: ARCMenuConfiguration

    // MARK: - Initialization

    /// Creates a new ARCMenu view model for flat layout
    ///
    /// - Parameters:
    ///   - user: User information to display in header
    ///   - menuItems: Items to show in the menu
    ///   - configuration: Menu configuration
    public init(user: ARCMenuUser? = nil,
                menuItems: [ARCMenuItem] = [],
                configuration: ARCMenuConfiguration = .default) {
        self.user = user
        self.menuItems = menuItems
        sections = []
        self.configuration = configuration
    }

    /// Creates a new ARCMenu view model for grouped/sectioned layout
    ///
    /// - Parameters:
    ///   - user: User information to display in header
    ///   - sections: Sections to show in the menu
    ///   - configuration: Menu configuration (defaults to `.sectioned`)
    public init(user: ARCMenuUser? = nil,
                sections: [ARCMenuSection],
                configuration: ARCMenuConfiguration = .sectioned) {
        self.user = user
        menuItems = []
        self.sections = sections
        self.configuration = configuration
    }
}

// MARK: - Convenience Initializers

extension ARCMenuViewModel {
    /// Creates a view model with default menu items
    ///
    /// Includes: Profile, Settings, Feedback, Subscriptions, About, Logout
    ///
    /// - Parameters:
    ///   - user: User information
    ///   - configuration: Menu configuration
    ///   - actions: Action handlers for menu items
    /// - Returns: Configured view model with default menu items
    ///
    /// ## Example
    ///
    /// ```swift
    /// let viewModel = ARCMenuViewModel.withDefaultItems(
    ///     user: currentUser,
    ///     actions: ARCMenuActions(
    ///         onProfile: { router.navigate(to: .profile) },
    ///         onSettings: { router.navigate(to: .settings) },
    ///         onFeedback: { showFeedbackSheet = true },
    ///         onSubscriptions: { router.navigate(to: .subscriptions) },
    ///         onAbout: { router.navigate(to: .about) },
    ///         onLogout: { authService.logout() }
    ///     )
    /// )
    /// ```
    public static func withDefaultItems(user: ARCMenuUser?,
                                        configuration: ARCMenuConfiguration = .default,
                                        actions: ARCMenuActions) -> ARCMenuViewModel {
        ARCMenuViewModel(user: user,
                         menuItems: ARCMenuItem.defaultItems(actions: actions),
                         configuration: configuration)
    }
}
