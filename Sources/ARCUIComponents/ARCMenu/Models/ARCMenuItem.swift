//
//  ARCMenuItem.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import Foundation
import SwiftUI

/// Represents a menu item in the ARCMenu
///
/// Follows Apple's Human Interface Guidelines for menu items,
/// supporting icons, badges, disclosure indicators, and destructive actions.
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
public struct ARCMenuItem: Identifiable, Sendable {
    // MARK: - Properties

    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let icon: ARCMenuIcon
    public let badge: String?
    public let isDestructive: Bool
    public let showsDisclosure: Bool
    public let action: @Sendable () -> Void

    // MARK: - Initialization

    /// Creates a new menu item
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - title: Item title
    ///   - subtitle: Optional subtitle for additional context
    ///   - icon: Item icon
    ///   - badge: Optional badge text (e.g., "New", count)
    ///   - isDestructive: Whether this is a destructive action (e.g., Logout, Delete)
    ///   - showsDisclosure: Whether to show a disclosure indicator (chevron)
    ///   - action: Closure executed when item is tapped
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        icon: ARCMenuIcon,
        badge: String? = nil,
        isDestructive: Bool = false,
        showsDisclosure: Bool = false,
        action: @escaping @Sendable () -> Void
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.badge = badge
        self.isDestructive = isDestructive
        self.showsDisclosure = showsDisclosure
        self.action = action
    }
}

// MARK: - ARCMenuIcon

/// Represents different types of menu icons
///
/// Supports SF Symbols and custom images for maximum flexibility.
public enum ARCMenuIcon: Sendable {
    case system(String, renderingMode: SymbolRenderingMode = .monochrome)
    case image(String)

    // MARK: - Computed Properties

    @ViewBuilder
    public func iconView(isDestructive: Bool = false) -> some View {
        switch self {
        case let .system(name, renderingMode):
            Image(systemName: name)
                .symbolRenderingMode(renderingMode)
                .font(.title3)
                .foregroundStyle(isDestructive ? Color.red : Color.primary)

        case let .image(name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(isDestructive ? Color.red : Color.primary)
        }
    }
}

// MARK: - Common Menu Items Factory

extension ARCMenuItem {
    /// Factory methods for common menu items
    ///
    /// Provides pre-configured menu items following Apple's conventions
    /// for consistent UX across different apps.
    public enum Common {
        /// Creates a Profile menu item
        public static func profile(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Profile",
                subtitle: "Edit your information",
                icon: .system("person.circle", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Settings menu item
        public static func settings(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Settings",
                subtitle: "Preferences and options",
                icon: .system("gear", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Feedback menu item
        public static func feedback(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Feedback",
                subtitle: "Share your thoughts",
                icon: .system("bubble.left.and.bubble.right", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Subscriptions menu item
        public static func subscriptions(badge: String? = nil, action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Subscriptions",
                subtitle: "Manage your plan",
                icon: .system("creditcard", renderingMode: .hierarchical),
                badge: badge,
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates an About menu item
        public static func about(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "About",
                subtitle: "App information",
                icon: .system("info.circle", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Logout menu item (destructive)
        public static func logout(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Logout",
                icon: .system("rectangle.portrait.and.arrow.right", renderingMode: .hierarchical),
                isDestructive: true,
                action: action
            )
        }

        // MARK: - Additional Items

        /// Creates a Help menu item
        public static func help(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Help",
                subtitle: "Support and documentation",
                icon: .system("questionmark.circle", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Share menu item
        public static func share(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Share",
                subtitle: "Share with friends",
                icon: .system("square.and.arrow.up", renderingMode: .hierarchical),
                action: action
            )
        }

        /// Creates a Notifications menu item
        public static func notifications(badge: String? = nil, action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Notifications",
                subtitle: "Manage alerts",
                icon: .system("bell", renderingMode: .hierarchical),
                badge: badge,
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Privacy menu item
        public static func privacy(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Privacy",
                subtitle: "Data and security",
                icon: .system("lock.shield", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Contact menu item
        public static func contact(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Contact",
                subtitle: "Get in touch",
                icon: .system("envelope", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Delete Account menu item (destructive)
        public static func deleteAccount(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Delete Account",
                subtitle: "Permanently remove account",
                icon: .system("trash", renderingMode: .hierarchical),
                isDestructive: true,
                action: action
            )
        }

        // MARK: - Legacy (Deprecated)

        /// Creates a Plan/Subscription menu item
        @available(*, deprecated, renamed: "subscriptions")
        public static func plan(badge: String? = nil, action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            subscriptions(badge: badge, action: action)
        }
    }

    // MARK: - Default Items

    /// Default menu items shown in all apps implementing ARCMenu
    ///
    /// Includes: Profile, Settings, Feedback, Subscriptions, About, Logout
    ///
    /// - Parameter actions: Action handlers for each menu item
    /// - Returns: Array of configured menu items
    ///
    /// ## Example
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
    /// let items = ARCMenuItem.defaultItems(actions: actions)
    /// ```
    public static func defaultItems(actions: ARCMenuActions) -> [ARCMenuItem] {
        [
            .Common.profile(action: actions.onProfile),
            .Common.settings(action: actions.onSettings),
            .Common.feedback(action: actions.onFeedback),
            .Common.subscriptions(action: actions.onSubscriptions),
            .Common.about(action: actions.onAbout),
            .Common.logout(action: actions.onLogout)
        ]
    }

    /// Default menu items shown in all apps implementing ARCMenu (legacy)
    ///
    /// - Note: Deprecated in favor of `defaultItems(actions:)`
    @available(*, deprecated, message: "Use defaultItems(actions:) with ARCMenuActions struct")
    // swiftlint:disable:next function_parameter_count
    public static func defaultItems(
        onProfile: @escaping @Sendable () -> Void,
        onSettings: @escaping @Sendable () -> Void,
        onFeedback: @escaping @Sendable () -> Void,
        onSubscriptions: @escaping @Sendable () -> Void,
        onAbout: @escaping @Sendable () -> Void,
        onLogout: @escaping @Sendable () -> Void
    ) -> [ARCMenuItem] {
        defaultItems(actions: ARCMenuActions(
            onProfile: onProfile,
            onSettings: onSettings,
            onFeedback: onFeedback,
            onSubscriptions: onSubscriptions,
            onAbout: onAbout,
            onLogout: onLogout
        ))
    }
}
