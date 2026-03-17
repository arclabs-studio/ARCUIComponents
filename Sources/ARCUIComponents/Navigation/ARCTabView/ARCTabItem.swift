//
//  ARCTabItem.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import SwiftUI

/// Protocol that defines the requirements for tab items in ARCTabView
///
/// Conforming types represent individual tabs in a tab bar navigation.
/// Each tab must provide a title, icon, and optional badge count.
///
/// ## Overview
///
/// `ARCTabItem` provides a type-safe way to define tabs for `ARCTabView`.
/// Typically implemented as an enum, it ensures compile-time safety for
/// tab navigation while following Apple's Human Interface Guidelines.
///
/// ## Topics
///
/// ### Required Properties
///
/// - ``title``
/// - ``icon``
///
/// ### Optional Properties
///
/// - ``badge``
///
/// ## Usage
///
/// ```swift
/// enum AppTab: String, ARCTabItem {
///     case home, favorites, settings
///
///     var id: String { rawValue }
///
///     var title: String {
///         switch self {
///         case .home: "Home"
///         case .favorites: "Favorites"
///         case .settings: "Settings"
///         }
///     }
///
///     var icon: String {
///         switch self {
///         case .home: "house.fill"
///         case .favorites: "heart.fill"
///         case .settings: "gearshape.fill"
///         }
///     }
///
///     var badge: Int? {
///         switch self {
///         case .favorites: 3  // Show badge with count
///         default: nil
///         }
///     }
/// }
/// ```
///
/// - Note: Use SF Symbols filled variants for tab icons per Apple HIG.
///   The system automatically uses outline variants for unselected tabs.
public protocol ARCTabItem: Hashable, CaseIterable, Identifiable where AllCases: RandomAccessCollection {
    /// The display title for the tab
    ///
    /// Keep titles short (preferably one word) for optimal display
    /// in the tab bar. The title is used for accessibility labels.
    var title: String { get }

    /// The SF Symbol name for the tab icon
    ///
    /// Use filled variants (e.g., "house.fill") for consistency with
    /// Apple's tab bar design. The system automatically handles
    /// selected/unselected states.
    var icon: String { get }

    /// Optional badge count to display on the tab
    ///
    /// Use badges sparingly to indicate important information that
    /// requires attention. Return `nil` to hide the badge.
    var badge: Int? { get }
}

// MARK: - Default Implementation

public extension ARCTabItem {
    /// Default implementation returns nil (no badge)
    var badge: Int? { nil }
}
