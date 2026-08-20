//
//  ARCMenuFeedbackView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCMenuFeedbackView

/// Standalone Feedback screen with mailto options for suggestions and bug reports
///
/// Uses ``ARCMenuAppInfo`` for app name and feedback email.
/// Bug reports automatically include debug info (version, OS, device model).
/// This is a **leaf view** — no NavigationStack, no routing knowledge.
///
/// Usage:
/// ```swift
/// NavigationStack {
///     ARCMenuFeedbackView(appInfo: appInfo)
/// }
/// ```
public struct ARCMenuFeedbackView: View {
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
            Section {
                Text("Your feedback helps us improve \(appInfo.appName). Choose an option to contact us.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Options") {
                Button {
                    openMailto(subject: "Suggestion for \(appInfo.appName)",
                               includeDebugInfo: false)
                } label: {
                    HStack(spacing: .arcSpacingSmall) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Send Suggestion")
                                .foregroundStyle(.primary)
                            Text("Ideas for new features or improvements")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .buttonStyle(.plain)

                Button {
                    openMailto(subject: "Bug Report - \(appInfo.appName)",
                               includeDebugInfo: true)
                } label: {
                    HStack(spacing: .arcSpacingSmall) {
                        Image(systemName: "ladybug.fill")
                            .foregroundStyle(.orange)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Report a Problem")
                                .foregroundStyle(.primary)
                            Text("Automatically includes debug information")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Feedback")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: Private Methods

    private func openMailto(subject: String, includeDebugInfo: Bool) {
        var body = ""
        if includeDebugInfo {
            let version = appInfo.appVersion
            let build = appInfo.buildNumber
            let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString

            body = """


            ---
            Debug Info:
            App: \(appInfo.appName) v\(version) (\(build))
            System: \(systemVersion)
            Device: \(Self.deviceModel())
            """
        }

        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? body

        if let url = URL(string: "mailto:\(appInfo.feedbackEmail)?subject=\(encodedSubject)&body=\(encodedBody)") {
            openURL(url)
        }
    }

    private static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingCString: $0) ?? "Unknown"
            }
        }
    }
}

// MARK: - Previews

#Preview("Feedback - Dark") {
    NavigationStack {
        ARCMenuFeedbackView(appInfo: ARCMenuAppInfo(appName: "FavRes",
                                                    appIcon: "fork.knife.circle.fill",
                                                    feedbackEmail: "feedback@arclabs.studio"))
    }
    .preferredColorScheme(.dark)
}

#Preview("Feedback - Light") {
    NavigationStack {
        ARCMenuFeedbackView(appInfo: ARCMenuAppInfo(appName: "FavRes",
                                                    appIcon: "fork.knife.circle.fill",
                                                    feedbackEmail: "feedback@arclabs.studio"))
    }
    .preferredColorScheme(.light)
}
