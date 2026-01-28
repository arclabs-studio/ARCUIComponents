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
@MainActor
@Observable
// swiftlint:disable:next observable_viewmodel
public final class ARCMenuViewModel {
    // MARK: - State

    /// Whether the menu is currently presented (for backward compatibility)
    @available(*, deprecated, message: "Use external @State binding with arcMenu(isPresented:viewModel:)")
    public private(set) var isPresented = false

    /// Current drag offset for trailing panel dismissal gesture
    public var dragOffset: CGFloat = 0

    // MARK: - Data

    /// Menu user information
    public var user: ARCMenuUser?

    /// Menu items to display
    public var menuItems: [ARCMenuItem]

    /// Menu configuration
    public var configuration: ARCMenuConfiguration

    // MARK: - Initialization

    /// Creates a new ARCMenu view model
    ///
    /// - Parameters:
    ///   - user: User information to display in header
    ///   - menuItems: Items to show in the menu
    ///   - configuration: Menu configuration
    public init(
        user: ARCMenuUser? = nil,
        menuItems: [ARCMenuItem] = [],
        configuration: ARCMenuConfiguration = .default
    ) {
        self.user = user
        self.menuItems = menuItems
        self.configuration = configuration
    }

    // MARK: - Deprecated Methods (Backward Compatibility)

    /// Presents the menu with animation
    @available(*, deprecated, message: "Use external @State binding instead")
    public func present() {
        configuration.hapticFeedback.perform()
        isPresented = true
    }

    /// Dismisses the menu with animation
    @available(*, deprecated, message: "Use external @State binding instead")
    public func dismiss() {
        configuration.hapticFeedback.perform()
        isPresented = false
        dragOffset = 0
    }

    /// Toggles the menu presentation state
    @available(*, deprecated, message: "Use external @State binding instead")
    public func toggle() {
        if isPresented {
            dismiss()
        } else {
            present()
        }
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
    public static func withDefaultItems(
        user: ARCMenuUser?,
        configuration: ARCMenuConfiguration = .default,
        actions: ARCMenuActions
    ) -> ARCMenuViewModel {
        ARCMenuViewModel(
            user: user,
            menuItems: ARCMenuItem.defaultItems(actions: actions),
            configuration: configuration
        )
    }

    /// Creates a view model with default menu items (legacy)
    ///
    /// - Note: Deprecated in favor of `withDefaultItems(user:configuration:actions:)`
    @available(*, deprecated, message: "Use withDefaultItems(user:configuration:actions:) with ARCMenuActions")
    public static func withDefaultItems(
        user: ARCMenuUser?,
        configuration: ARCMenuConfiguration = .default,
        onProfile: @escaping @Sendable () -> Void,
        onSettings: @escaping @Sendable () -> Void,
        onFeedback: @escaping @Sendable () -> Void,
        onSubscriptions: @escaping @Sendable () -> Void,
        onAbout: @escaping @Sendable () -> Void,
        onLogout: @escaping @Sendable () -> Void
    ) -> ARCMenuViewModel {
        withDefaultItems(
            user: user,
            configuration: configuration,
            actions: ARCMenuActions(
                onProfile: onProfile,
                onSettings: onSettings,
                onFeedback: onFeedback,
                onSubscriptions: onSubscriptions,
                onAbout: onAbout,
                onLogout: onLogout
            )
        )
    }

    /// Creates a view model with common menu items (legacy)
    ///
    /// - Note: Deprecated in favor of `withDefaultItems`
    @available(*, deprecated, renamed: "withDefaultItems")
    public static func standard(
        user: ARCMenuUser?,
        configuration: ARCMenuConfiguration = .default,
        onSettings: (@Sendable () -> Void)? = nil,
        onProfile: (@Sendable () -> Void)? = nil,
        onPlan: (@Sendable () -> Void)? = nil,
        onContact: (@Sendable () -> Void)? = nil,
        onAbout: (@Sendable () -> Void)? = nil,
        onLogout: (@Sendable () -> Void)? = nil
    ) -> ARCMenuViewModel {
        var items: [ARCMenuItem] = []

        if let onProfile {
            items.append(.Common.profile(action: onProfile))
        }

        if let onSettings {
            items.append(.Common.settings(action: onSettings))
        }

        if let onPlan {
            items.append(.Common.subscriptions(action: onPlan))
        }

        if let onContact {
            items.append(.Common.contact(action: onContact))
        }

        if let onAbout {
            items.append(.Common.about(action: onAbout))
        }

        if let onLogout {
            items.append(.Common.logout(action: onLogout))
        }

        return ARCMenuViewModel(
            user: user,
            menuItems: items,
            configuration: configuration
        )
    }
}
