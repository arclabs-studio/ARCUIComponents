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
        case .system(let name, let renderingMode):
            Image(systemName: name)
                .symbolRenderingMode(renderingMode)
                .font(.title3)
                .foregroundStyle(isDestructive ? Color.red : .arcTextPrimary)

        case .image(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(isDestructive ? Color.red : .arcTextPrimary)
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

        /// Creates a Plan/Subscription menu item
        public static func plan(badge: String? = nil, action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Plan",
                subtitle: "Manage subscription",
                icon: .system("crown.fill", renderingMode: .multicolor),
                badge: badge,
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Contact menu item
        public static func contact(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Contact",
                subtitle: "Get in touch",
                icon: .system("envelope.fill", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates an About menu item
        public static func about(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "About",
                subtitle: "App information",
                icon: .system("info.circle.fill", renderingMode: .hierarchical),
                showsDisclosure: true,
                action: action
            )
        }

        /// Creates a Help menu item
        public static func help(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Help",
                subtitle: "Support and documentation",
                icon: .system("questionmark.circle.fill", renderingMode: .hierarchical),
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
                icon: .system("bell.fill", renderingMode: .hierarchical),
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
                icon: .system("lock.shield.fill", renderingMode: .hierarchical),
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

        /// Creates a Delete Account menu item (destructive)
        public static func deleteAccount(action: @escaping @Sendable () -> Void) -> ARCMenuItem {
            ARCMenuItem(
                title: "Delete Account",
                subtitle: "Permanently remove account",
                icon: .system("trash.fill", renderingMode: .hierarchical),
                isDestructive: true,
                action: action
            )
        }
    }
}
