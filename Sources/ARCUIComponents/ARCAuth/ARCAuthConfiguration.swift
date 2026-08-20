//
//  ARCAuthConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import SwiftUI

// MARK: - ARCAuthConfiguration

/// Branding configuration for the authentication screen group.
///
/// Pass this configuration to every `ARCAuth` view so they share the same
/// icon, app name, subtitle, and icon sizing. Only presentation-level values
/// live here — auth logic is wired through action closures on each view.
///
/// ## Usage
///
/// ```swift
/// let config = ARCAuthConfiguration(
///     appIcon: "fork.knife.circle.fill",
///     appName: "FavRes",
///     appSubtitle: "Your favourite restaurants"
/// )
///
/// ARCSplashView(configuration: config)
/// ARCWelcomeView(configuration: config, onSignIn: { ... }, onSignUp: { ... })
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCAuthConfiguration: Sendable {
    // MARK: Properties

    /// SF Symbol name used as the app hero icon (fallback when `appIconAssetName` is nil).
    public let appIcon: String

    /// Asset catalog image name used as the app hero icon.
    /// When set, takes precedence over `appIcon`. Use this to show the real app icon.
    public let appIconAssetName: String?

    /// App name displayed on the Welcome screen.
    public let appName: String

    /// Optional subtitle displayed below the app name on the Welcome screen.
    public let appSubtitle: String?

    /// Font size for the hero icon. Defaults to `80`.
    public let heroIconSize: CGFloat

    // MARK: Initialization

    /// Creates an authentication branding configuration.
    ///
    /// - Parameters:
    ///   - appIcon: SF Symbol name used as the hero icon (default: `"person.circle.fill"`).
    ///   - appIconAssetName: Asset catalog image name. When set, renders the real app icon instead of the SF Symbol.
    ///   - appName: App name shown on the Welcome screen.
    ///   - appSubtitle: Optional subtitle shown below the app name.
    ///   - heroIconSize: Font size of the hero icon (default: `80`).
    public init(appIcon: String = "person.circle.fill",
                appIconAssetName: String? = nil,
                appName: String,
                appSubtitle: String? = nil,
                heroIconSize: CGFloat = 80) {
        self.appIcon = appIcon
        self.appIconAssetName = appIconAssetName
        self.appName = appName
        self.appSubtitle = appSubtitle
        self.heroIconSize = heroIconSize
    }

    // MARK: Presets

    /// Creates a default configuration for the given app name and optional subtitle.
    ///
    /// - Parameters:
    ///   - appName: App name shown on the Welcome screen.
    ///   - appSubtitle: Optional subtitle shown below the app name.
    public static func `default`(appName: String, appSubtitle: String? = nil) -> ARCAuthConfiguration {
        ARCAuthConfiguration(appName: appName, appSubtitle: appSubtitle)
    }
}
