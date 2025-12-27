//
//  ARCMenuDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCMenu component.
///
/// Shows the menu in a realistic app context with various configurations.
struct ARCMenuDemoScreen: View {
    // MARK: Properties

    @State private var menuViewModel = ARCMenuViewModel.standard(
        user: ARCMenuUser(
            name: "Demo User",
            email: "demo@arclabs.studio",
            subtitle: "Premium Member",
            avatarImage: .initials("DU")
        ),
        configuration: .default,
        onSettings: { print("Settings tapped") },
        onProfile: { print("Profile tapped") },
        onPlan: { print("Plan tapped") },
        onContact: { print("Contact tapped") },
        onAbout: { print("About tapped") },
        onLogout: { print("Logout tapped") }
    )

    @State private var selectedStyle: MenuStyle = .default

    // MARK: Body

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: selectedStyle.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Content
            VStack(spacing: 24) {
                Text("ARCMenu Demo")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text("Tap the menu button in the toolbar")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))

                // Style Picker
                Picker("Style", selection: $selectedStyle) {
                    ForEach(MenuStyle.allCases) { style in
                        Text(style.name).tag(style)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 32)

                Spacer()

                // Instructions
                VStack(spacing: 12) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.6))

                    Text("Features")
                        .font(.headline)
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "rectangle.portrait.and.arrow.right", text: "Slide-in animation")
                        FeatureRow(icon: "hand.draw", text: "Drag to dismiss")
                        FeatureRow(icon: "person.crop.circle", text: "User profile header")
                        FeatureRow(icon: "paintbrush", text: "Liquid glass effect")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 60)
        }
        .navigationTitle("ARCMenu")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    ARCMenuButton(
                        viewModel: menuViewModel,
                        showsBadge: true,
                        badgeCount: 3
                    )
                }
                #else
                ToolbarItem(placement: .automatic) {
                    ARCMenuButton(
                        viewModel: menuViewModel,
                        showsBadge: true,
                        badgeCount: 3
                    )
                }
                #endif
            }
            .arcMenu(viewModel: menuViewModel)
            .onChange(of: selectedStyle) { _, newStyle in
                menuViewModel.configuration = newStyle.configuration
            }
    }
}

// MARK: - Supporting Types

private enum MenuStyle: String, CaseIterable, Identifiable {
    case `default`
    case fitness
    case premium
    case dark

    var id: String { rawValue }

    var name: String {
        switch self {
        case .default: "Default"
        case .fitness: "Fitness"
        case .premium: "Premium"
        case .dark: "Dark"
        }
    }

    var configuration: ARCMenuConfiguration {
        switch self {
        case .default: .default
        case .fitness: .fitness
        case .premium: .premium
        case .dark: .dark
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .default: [.blue, .purple]
        case .fitness: [.green, .mint]
        case .premium: [.orange, .red]
        case .dark: [.gray, .black]
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.white.opacity(0.8))

            Text(text)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}

#Preview {
    NavigationStack {
        ARCMenuDemoScreen()
    }
}
