//
//  ARCMenuAboutView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCMenuAboutView

/// Standalone About screen displaying app version, build info, and legal links
///
/// Renders app information from ``ARCMenuAppInfo``. Legal links (privacy, terms)
/// are shown only when their URLs are provided.
/// This is a **leaf view** — no NavigationStack, no routing knowledge.
///
/// Usage:
/// ```swift
/// NavigationStack {
///     ARCMenuAboutView(appInfo: appInfo)
/// }
/// ```
public struct ARCMenuAboutView: View {
    // MARK: Public Properties

    public let appInfo: ARCMenuAppInfo

    // MARK: Private Properties

    @Environment(\.openURL) private var openURL

    // MARK: Lifecycle

    public init(appInfo: ARCMenuAppInfo) {
        self.appInfo = appInfo
    }

    // MARK: View

    public var body: some View {
        Form {
            appHeaderSection
            versionSection

            if appInfo.privacyURL != nil || appInfo.termsURL != nil {
                linksSection
            }
        }
        .navigationTitle("Acerca de")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .safeAreaInset(edge: .bottom) {
                Text("Hecho con amor por \(appInfo.studioName)")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, .arcSpacingMedium)
            }
    }

    // MARK: Private Views

    private var appHeaderSection: some View {
        Section {
            HStack(spacing: .arcSpacingMedium) {
                Image(systemName: appInfo.appIcon)
                    .font(.system(size: 56))
                    .foregroundStyle(Color.accentColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(appInfo.appName)
                        .font(.title2.bold())

                    if let subtitle = appInfo.appSubtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.vertical, .arcSpacingSmall)
        }
    }

    private var versionSection: some View {
        Section("Informacion") {
            LabeledContent("Version", value: appInfo.appVersion)
            LabeledContent("Build", value: appInfo.buildNumber)
        }
    }

    private var linksSection: some View {
        Section("Legal") {
            if let privacyURL = appInfo.privacyURL {
                Button {
                    openURL(privacyURL)
                } label: {
                    HStack {
                        Label("Politica de privacidad", systemImage: "hand.raised.fill")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .foregroundStyle(.primary)
            }

            if let termsURL = appInfo.termsURL {
                Button {
                    openURL(termsURL)
                } label: {
                    HStack {
                        Label("Terminos de servicio", systemImage: "doc.text.fill")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - Previews

#Preview("About - Dark") {
    NavigationStack {
        ARCMenuAboutView(appInfo: ARCMenuAppInfo(appName: "FavRes",
                                                 appIcon: "fork.knife.circle.fill",
                                                 appSubtitle: "Tus restaurantes favoritos",
                                                 feedbackEmail: "feedback@arclabs.studio",
                                                 privacyURL: URL(string: "https://arclabs.studio/privacy"),
                                                 termsURL: URL(string: "https://arclabs.studio/terms")))
    }
    .preferredColorScheme(.dark)
}

#Preview("About - Light") {
    NavigationStack {
        ARCMenuAboutView(appInfo: ARCMenuAppInfo(appName: "FavRes",
                                                 appIcon: "fork.knife.circle.fill",
                                                 appSubtitle: "Tus restaurantes favoritos",
                                                 feedbackEmail: "feedback@arclabs.studio",
                                                 privacyURL: URL(string: "https://arclabs.studio/privacy"),
                                                 termsURL: URL(string: "https://arclabs.studio/terms")))
    }
    .preferredColorScheme(.light)
}
