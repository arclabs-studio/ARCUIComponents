//
//  ARCMenuAppInfo.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import Foundation

// MARK: - ARCMenuAppInfo

/// Data model for About and Feedback screens
///
/// Provides all the information needed by ``ARCMenuAboutView`` and ``ARCMenuFeedbackView``
/// to render app-specific content. Similar to ``ARCMenuUser`` — a pure data container
/// with no persistence or business logic.
///
/// Usage:
/// ```swift
/// let appInfo = ARCMenuAppInfo(
///     appName: "FavRes",
///     appIcon: "fork.knife.circle.fill",
///     appSubtitle: "Tus restaurantes favoritos",
///     feedbackEmail: "feedback@arclabs.studio",
///     privacyURL: URL(string: "https://arclabs.studio/privacy"),
///     termsURL: URL(string: "https://arclabs.studio/terms")
/// )
/// ```
public struct ARCMenuAppInfo: Sendable {
    // MARK: Public Properties

    /// App display name (e.g., "FavRes")
    public let appName: String

    /// SF Symbol name for the app icon (e.g., "fork.knife.circle.fill"). Fallback when `appIconAssetName` is nil.
    public let appIcon: String

    /// Asset catalog image name for the app icon. When set, takes precedence over `appIcon`.
    public let appIconAssetName: String?

    /// Optional subtitle shown below the app name (e.g., "Tus restaurantes favoritos")
    public let appSubtitle: String?

    /// Email address for feedback (e.g., "feedback@arclabs.studio")
    public let feedbackEmail: String

    /// Optional URL to privacy policy
    public let privacyURL: URL?

    /// Optional URL to terms of service
    public let termsURL: URL?

    /// Studio name shown in the footer
    public let studioName: String

    // MARK: Computed Properties

    /// App version from main bundle (e.g., "1.0.0")
    public var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    /// Build number from main bundle (e.g., "42")
    public var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }

    // MARK: Lifecycle

    public init(appName: String,
                appIcon: String,
                appIconAssetName: String? = nil,
                appSubtitle: String? = nil,
                feedbackEmail: String,
                privacyURL: URL? = nil,
                termsURL: URL? = nil,
                studioName: String = "ARC Labs Studio") {
        self.appName = appName
        self.appIcon = appIcon
        self.appIconAssetName = appIconAssetName
        self.appSubtitle = appSubtitle
        self.feedbackEmail = feedbackEmail
        self.privacyURL = privacyURL
        self.termsURL = termsURL
        self.studioName = studioName
    }
}
