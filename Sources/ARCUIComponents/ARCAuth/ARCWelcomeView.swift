//
//  ARCWelcomeView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCWelcomeView

/// App landing screen shown to unauthenticated users.
///
/// Displays the app branding (icon, name, subtitle) from `ARCAuthConfiguration`
/// plus two primary CTAs — Sign In and Create Account. Navigation is handled
/// entirely through the provided closures so the caller's `NavigationStack` owns
/// the push.
///
/// ## Usage
///
/// ```swift
/// ARCWelcomeView(
///     configuration: ARCAuthConfiguration(
///         appIcon: "fork.knife.circle.fill",
///         appName: "FavRes",
///         appSubtitle: "Your favourite restaurants"
///     ),
///     signInLabel: "Sign In",
///     signUpLabel: "Create Account",
///     onSignIn: { navigationPath.append(.signIn) },
///     onSignUp: { navigationPath.append(.signUp) }
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCWelcomeView: View {
    // MARK: Private Properties

    private let configuration: ARCAuthConfiguration
    private let signInLabel: String
    private let signUpLabel: String
    private let onSignIn: () -> Void
    private let onSignUp: () -> Void

    // MARK: Initialization

    /// Creates a welcome screen.
    ///
    /// - Parameters:
    ///   - configuration: Branding configuration (icon, app name, subtitle).
    ///   - signInLabel: Label for the primary Sign In button (default: `"Sign In"`).
    ///   - signUpLabel: Label for the secondary Create Account button (default: `"Create Account"`).
    ///   - onSignIn: Called when the user taps Sign In.
    ///   - onSignUp: Called when the user taps Create Account.
    public init(configuration: ARCAuthConfiguration,
                signInLabel: String = "Sign In",
                signUpLabel: String = "Create Account",
                onSignIn: @escaping () -> Void,
                onSignUp: @escaping () -> Void)
    {
        self.configuration = configuration
        self.signInLabel = signInLabel
        self.signUpLabel = signUpLabel
        self.onSignIn = onSignIn
        self.onSignUp = onSignUp
    }

    // MARK: View

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            brandingSection
            Spacer()
            ctaSection
        }
    }
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *) extension ARCWelcomeView {
    private var brandingSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            Image(systemName: configuration.appIcon)
                .font(.system(size: configuration.heroIconSize))
                .foregroundStyle(.tint)

            Text(configuration.appName)
                .font(.largeTitle.bold())

            if let subtitle = configuration.appSubtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, .arcSpacingXLarge)
    }

    private var ctaSection: some View {
        VStack(spacing: .arcSpacingMedium) {
            ARCButton(signInLabel,
                      configuration: ARCButtonConfiguration(size: .large, isFullWidth: true))
            {
                onSignIn()
            }

            ARCButton(signUpLabel,
                      configuration: ARCButtonConfiguration(style: .outlined, size: .large, isFullWidth: true))
            {
                onSignUp()
            }
        }
        .padding(.horizontal, .arcSpacingXLarge)
        .padding(.bottom, .arcSpacingXLarge)
    }
}

// MARK: - Previews

#Preview("Welcome - Dark") {
    NavigationStack {
        ARCWelcomeView(configuration: ARCAuthConfiguration(appIcon: "fork.knife.circle.fill",
                                                           appName: "FavRes",
                                                           appSubtitle: "Your favourite restaurants"),
                       onSignIn: {},
                       onSignUp: {})
    }
    .preferredColorScheme(.dark)
}

#Preview("Welcome - Light") {
    NavigationStack {
        ARCWelcomeView(configuration: ARCAuthConfiguration(appIcon: "fork.knife.circle.fill",
                                                           appName: "FavRes",
                                                           appSubtitle: "Your favourite restaurants"),
                       onSignIn: {},
                       onSignUp: {})
    }
    .preferredColorScheme(.light)
}
