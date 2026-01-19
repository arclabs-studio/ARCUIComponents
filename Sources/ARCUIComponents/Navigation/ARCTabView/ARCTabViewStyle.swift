//
//  ARCTabViewStyle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import SwiftUI

/// Style options for ARCTabView presentation
///
/// Determines how the tab view adapts across different platforms and
/// device configurations.
///
/// ## Overview
///
/// `ARCTabViewStyle` maps to SwiftUI's `TabViewStyle` options, providing
/// a simplified API for common tab bar configurations. The style affects
/// how tabs are presented on different platforms:
///
/// - **iPhone**: Always displays as a bottom tab bar
/// - **iPad**: Can display as tab bar or sidebar depending on style
/// - **visionOS**: Displays as a vertical sidebar
///
/// ## Topics
///
/// ### Style Options
///
/// - ``automatic``
/// - ``tabBarOnly``
/// - ``sidebarAdaptable``
///
/// ## Usage
///
/// ```swift
/// ARCTabView(
///     selection: $selectedTab,
///     configuration: .init(style: .sidebarAdaptable)
/// ) { tab in
///     // Tab content
/// }
/// ```
public enum ARCTabViewStyle: Sendable {
    /// Automatic style based on platform
    ///
    /// The system chooses the most appropriate style for the current
    /// platform and device configuration.
    case automatic

    /// Tab bar only style
    ///
    /// Always displays as a traditional tab bar at the bottom (iOS)
    /// or top (iPadOS) of the screen. Does not convert to a sidebar.
    case tabBarOnly

    /// Sidebar adaptable style
    ///
    /// On iPadOS, displays as a tab bar that can convert to a sidebar
    /// when expanded. On iPhone, displays as a standard bottom tab bar.
    /// Ideal for apps with complex navigation hierarchies.
    case sidebarAdaptable
}
