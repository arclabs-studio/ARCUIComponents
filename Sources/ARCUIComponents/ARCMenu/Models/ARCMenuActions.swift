//
//  ARCMenuActions.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 28/01/26.
//

import Foundation

/// Action handlers for default ARCMenu items
///
/// Encapsulates all action closures for the standard menu items,
/// reducing parameter count in factory methods.
///
/// ## Usage
///
/// ```swift
/// let actions = ARCMenuActions(
///     onProfile: { navigateToProfile() },
///     onSettings: { navigateToSettings() },
///     onFeedback: { showFeedbackSheet() },
///     onSubscriptions: { navigateToSubscriptions() },
///     onAbout: { navigateToAbout() },
///     onLogout: { performLogout() }
/// )
///
/// let menuItems = ARCMenuItem.defaultItems(actions: actions)
/// ```
public struct ARCMenuActions: Sendable {
    // MARK: - Properties

    /// Action when Profile menu item is tapped
    public let onProfile: @Sendable () -> Void

    /// Action when Settings menu item is tapped
    public let onSettings: @Sendable () -> Void

    /// Action when Feedback menu item is tapped
    public let onFeedback: @Sendable () -> Void

    /// Action when Subscriptions menu item is tapped
    public let onSubscriptions: @Sendable () -> Void

    /// Action when About menu item is tapped
    public let onAbout: @Sendable () -> Void

    /// Action when Logout menu item is tapped
    public let onLogout: @Sendable () -> Void

    // MARK: - Initialization

    /// Creates a new ARCMenuActions instance
    ///
    /// - Parameters:
    ///   - onProfile: Action for Profile menu item
    ///   - onSettings: Action for Settings menu item
    ///   - onFeedback: Action for Feedback menu item
    ///   - onSubscriptions: Action for Subscriptions menu item
    ///   - onAbout: Action for About menu item
    ///   - onLogout: Action for Logout menu item
    public init(
        onProfile: @escaping @Sendable () -> Void,
        onSettings: @escaping @Sendable () -> Void,
        onFeedback: @escaping @Sendable () -> Void,
        onSubscriptions: @escaping @Sendable () -> Void,
        onAbout: @escaping @Sendable () -> Void,
        onLogout: @escaping @Sendable () -> Void
    ) {
        self.onProfile = onProfile
        self.onSettings = onSettings
        self.onFeedback = onFeedback
        self.onSubscriptions = onSubscriptions
        self.onAbout = onAbout
        self.onLogout = onLogout
    }
}

// MARK: - Convenience Initializers

extension ARCMenuActions {
    /// Creates actions with empty handlers (useful for previews)
    public static var empty: ARCMenuActions {
        ARCMenuActions(
            onProfile: {},
            onSettings: {},
            onFeedback: {},
            onSubscriptions: {},
            onAbout: {},
            onLogout: {}
        )
    }
}
