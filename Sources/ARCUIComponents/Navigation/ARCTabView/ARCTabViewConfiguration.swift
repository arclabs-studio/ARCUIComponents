//
//  ARCTabViewConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import SwiftUI

/// Configuration for ARCTabView appearance and behavior
///
/// Provides customization options for tab view presentation while maintaining
/// Apple's Human Interface Guidelines for tab bars.
///
/// ## Overview
///
/// `ARCTabViewConfiguration` allows you to customize the tab view style,
/// minimize behavior, and customization options. Use presets for common
/// configurations or create custom configurations for specific needs.
///
/// ## Topics
///
/// ### Creating Configurations
///
/// - ``init(style:allowsCustomization:)``
///
/// ### Properties
///
/// - ``style``
/// - ``allowsCustomization``
///
/// ### Presets
///
/// - ``default``
/// - ``sidebarAdaptable``
/// - ``customizable``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// ARCTabView(selection: $selectedTab) { tab in
///     TabContent(for: tab)
/// }
///
/// // Use sidebar adaptable preset
/// ARCTabView(
///     selection: $selectedTab,
///     configuration: .sidebarAdaptable
/// ) { tab in
///     TabContent(for: tab)
/// }
///
/// // Custom configuration
/// ARCTabView(
///     selection: $selectedTab,
///     configuration: ARCTabViewConfiguration(
///         style: .sidebarAdaptable,
///         allowsCustomization: true
///     )
/// ) { tab in
///     TabContent(for: tab)
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
public struct ARCTabViewConfiguration: Sendable {
    // MARK: - Properties

    /// The presentation style for the tab view
    ///
    /// Determines how tabs are displayed across different platforms.
    /// See ``ARCTabViewStyle`` for available options.
    public let style: ARCTabViewStyle

    /// Whether to enable tab customization on iPadOS
    ///
    /// When enabled, users can drag and drop tabs to reorder them,
    /// hide tabs, or add tabs to the tab bar from the sidebar.
    /// This feature is primarily useful on iPadOS.
    public let allowsCustomization: Bool

    // MARK: - Initialization

    /// Creates a new tab view configuration
    ///
    /// - Parameters:
    ///   - style: The presentation style for the tab view
    ///   - allowsCustomization: Whether to enable tab customization
    public init(
        style: ARCTabViewStyle = .automatic,
        allowsCustomization: Bool = false
    ) {
        self.style = style
        self.allowsCustomization = allowsCustomization
    }

    // MARK: - Presets

    /// Default configuration with automatic style
    ///
    /// Uses automatic style adaptation and disables customization.
    /// Suitable for most apps with simple tab navigation.
    public static let `default` = ARCTabViewConfiguration()

    /// Configuration for sidebar adaptable presentation
    ///
    /// On iPadOS, the tab bar can convert to a sidebar for expanded
    /// navigation. Customization is disabled by default.
    public static let sidebarAdaptable = ARCTabViewConfiguration(
        style: .sidebarAdaptable
    )

    /// Configuration with customization enabled
    ///
    /// Uses sidebar adaptable style with customization enabled,
    /// allowing users to personalize their tab bar on iPadOS.
    public static let customizable = ARCTabViewConfiguration(
        style: .sidebarAdaptable,
        allowsCustomization: true
    )
}
