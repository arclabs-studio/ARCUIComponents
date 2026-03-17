//
//  ARCAuthShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCAuthShowcase

/// Interactive showcase demonstrating all five ARCAuth screens.
///
/// Provides a tab-style picker to switch between Splash, Welcome, Sign In,
/// Sign Up, and Forgot Password views — all wired with no-op closures so the
/// showcase runs standalone without a real auth backend.
@available(iOS 17.0, macOS 14.0, *) public struct ARCAuthShowcase: View {
    // MARK: Private State

    @State private var selectedScreen: AuthShowcaseScreen = .welcome

    // MARK: Private Constants

    private let configuration = ARCAuthConfiguration(appIcon: "person.crop.circle.fill",
                                                     appName: "MyApp",
                                                     appSubtitle: "Welcome back")

    // MARK: View

    public var body: some View {
        VStack(spacing: 0) {
            screenPicker
                .padding(.horizontal, .arcSpacingMedium)
                .padding(.vertical, .arcSpacingSmall)

            Divider()

            NavigationStack {
                screenContent
            }
        }
        .navigationTitle("ARCAuth Showcase")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: Initialization

    public init() {}
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *) extension ARCAuthShowcase {
    private var screenPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .arcSpacingSmall) {
                ForEach(AuthShowcaseScreen.allCases) { screen in
                    Button {
                        withAnimation(.arcSnappy) { selectedScreen = screen }
                    } label: {
                        Text(screen.label)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, .arcSpacingSmall)
                            .padding(.vertical, 6)
                            .background(Capsule()
                                .fill(selectedScreen == screen ? Color.accentColor : Color(.secondarySystemFill)))
                            .foregroundStyle(selectedScreen == screen ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder private var screenContent: some View {
        switch selectedScreen {
        case .splash:
            ARCSplashView(configuration: configuration)
        case .welcome:
            ARCWelcomeView(configuration: configuration, onSignIn: {}, onSignUp: {})
        case .signIn:
            ARCSignInView(viewModel: ARCSignInViewModel(onSignInWithEmail: { _, _ in },
                                                        onSignInWithApple: {},
                                                        onSignInWithGoogle: {}),
                          onForgotPassword: {},
                          onSignUp: {})
        case .signUp:
            ARCSignUpView(viewModel: ARCSignUpViewModel(onSignUpWithEmail: { _, _ in },
                                                        onSignInWithApple: {},
                                                        onSignInWithGoogle: {}))
        case .forgotPassword:
            ARCForgotPasswordView(viewModel: ARCForgotPasswordViewModel(onSendReset: { _ in }))
        }
    }
}

// MARK: - AuthShowcaseScreen

@available(iOS 17.0, macOS 14.0, *) private enum AuthShowcaseScreen: String, CaseIterable, Identifiable {
    case splash
    case welcome
    case signIn
    case signUp
    case forgotPassword

    var id: String {
        rawValue
    }

    var label: String {
        switch self {
        case .splash: "Splash"
        case .welcome: "Welcome"
        case .signIn: "Sign In"
        case .signUp: "Sign Up"
        case .forgotPassword: "Forgot Password"
        }
    }
}

// MARK: - Previews

#Preview("Auth Showcase - Dark") {
    NavigationStack {
        ARCAuthShowcase()
    }
    .preferredColorScheme(.dark)
}

#Preview("Auth Showcase - Light") {
    NavigationStack {
        ARCAuthShowcase()
    }
    .preferredColorScheme(.light)
}
