//
//  ARCAuthDemoScreen.swift
//  ARCUIComponentsDemoApp
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCUIComponents
import SwiftUI

// MARK: - ARCAuthDemoScreen

/// Interactive demo for all ARCAuth screens.
///
/// Shows each screen in a labelled `NavigationLink` card so they can be
/// explored in full. All action closures are no-ops — no real auth backend needed.
struct ARCAuthDemoScreen: View {
    // MARK: Private Constants

    private let configuration = ARCAuthConfiguration(appIcon: "fork.knife.circle.fill",
                                                     appName: "FavRes",
                                                     appSubtitle: "Your favourite restaurants")

    // MARK: View

    var body: some View {
        List {
            splashSection
            welcomeSection
            signInSection
            signUpSection
            forgotPasswordSection
            showcaseSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("ARCAuth")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Private Sections

extension ARCAuthDemoScreen {
    private var splashSection: some View {
        Section {
            NavigationLink {
                ARCSplashView(configuration: configuration)
            } label: {
                Label("Splash Screen", systemImage: "sparkle")
            }
        } header: {
            Text("Loading")
        } footer: {
            Text("Shown while the app determines the initial authentication state.")
        }
    }

    private var welcomeSection: some View {
        Section {
            NavigationLink {
                NavigationStack {
                    ARCWelcomeView(configuration: configuration,
                                   onSignIn: {},
                                   onSignUp: {})
                }
            } label: {
                Label("Welcome Screen", systemImage: "hand.wave.fill")
            }
        } header: {
            Text("Landing")
        } footer: {
            Text("App branding with Sign In and Create Account CTAs.")
        }
    }

    private var signInSection: some View {
        Section {
            NavigationLink {
                NavigationStack {
                    ARCSignInView(viewModel: ARCSignInViewModel(onSignInWithEmail: { _, _ in },
                                                                onSignInWithApple: {},
                                                                onSignInWithGoogle: {}),
                                  onForgotPassword: {},
                                  onSignUp: {})
                }
            } label: {
                Label("Sign In (email only)", systemImage: "envelope.fill")
            }
        } header: {
            Text("Sign In")
        } footer: {
            Text("Email/password form. Inject social buttons via @ViewBuilder to add Apple or Google sign-in.")
        }
    }

    private var signUpSection: some View {
        Section {
            NavigationLink {
                NavigationStack {
                    ARCSignUpView(viewModel: ARCSignUpViewModel(onSignUpWithEmail: { _, _ in },
                                                                onSignInWithApple: {},
                                                                onSignInWithGoogle: {}))
                }
            } label: {
                Label("Sign Up (email only)", systemImage: "person.badge.plus.fill")
            }
        } header: {
            Text("Sign Up")
        } footer: {
            Text("Email, password, and confirm-password fields with strong-password validation.")
        }
    }

    private var forgotPasswordSection: some View {
        Section {
            NavigationLink {
                NavigationStack {
                    ARCForgotPasswordView(viewModel: ARCForgotPasswordViewModel(onSendReset: { _ in }))
                }
            } label: {
                Label("Forgot Password — Input", systemImage: "key.fill")
            }

            NavigationLink {
                NavigationStack {
                    ARCForgotPasswordView(viewModel: {
                        let vm = ARCForgotPasswordViewModel(onSendReset: { _ in })
                        vm.didSendReset = true
                        return vm
                    }())
                }
            } label: {
                Label("Forgot Password — Success", systemImage: "checkmark.circle.fill")
            }
        } header: {
            Text("Forgot Password")
        } footer: {
            Text("Input state collects the email; success state confirms dispatch.")
        }
    }

    private var showcaseSection: some View {
        Section {
            NavigationLink {
                ARCAuthShowcase()
            } label: {
                Label("Full Showcase", systemImage: "sparkles.rectangle.stack.fill")
            }
        } header: {
            Text("Showcase")
        } footer: {
            Text("Interactive showcase with a screen picker.")
        }
    }
}

// MARK: - Previews

#Preview("Auth Demo - Light") {
    NavigationStack {
        ARCAuthDemoScreen()
    }
}

#Preview("Auth Demo - Dark") {
    NavigationStack {
        ARCAuthDemoScreen()
    }
    .preferredColorScheme(.dark)
}
