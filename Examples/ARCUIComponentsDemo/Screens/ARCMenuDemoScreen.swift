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
        onSettings: {},
        onProfile: {},
        onPlan: {},
        onContact: {},
        onAbout: {},
        onLogout: {}
    )

    @State private var selectedStyle: MenuStyleOption = .arcBrand

    // MARK: Body

    var body: some View {
        ZStack {
            backgroundGradient
            contentView
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

// MARK: - Private Views

private extension ARCMenuDemoScreen {

    var backgroundGradient: some View {
        LinearGradient(
            colors: selectedStyle.gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var contentView: some View {
        VStack(spacing: 24) {
            Text("ARCMenu Demo")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("Tap the menu button in the toolbar")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))

            stylePicker

            Spacer()

            featuresCard

            Spacer()
        }
        .padding(.top, 60)
    }

    var stylePicker: some View {
        Picker("Style", selection: $selectedStyle) {
            ForEach(MenuStyleOption.allCases) { style in
                Text(style.name).tag(style)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 32)
    }

    var featuresCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.arcBrandGold)

            Text("Features")
                .font(.headline)
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 8) {
                FeatureRowView(icon: "rectangle.portrait.and.arrow.right", text: "Slide-in animation")
                FeatureRowView(icon: "hand.draw", text: "Drag to dismiss")
                FeatureRowView(icon: "person.crop.circle", text: "User profile header")
                FeatureRowView(icon: "paintbrush", text: "Liquid glass effect")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Supporting Types

private enum MenuStyleOption: String, CaseIterable, Identifiable {
    case arcBrand
    case fitness
    case premium
    case dark

    var id: String { rawValue }

    var name: String {
        switch self {
        case .arcBrand: "ARC Brand"
        case .fitness: "Fitness"
        case .premium: "Premium"
        case .dark: "Dark"
        }
    }

    var configuration: ARCMenuConfiguration {
        switch self {
        case .arcBrand: .default
        case .fitness: .fitness
        case .premium: .premium
        case .dark: .dark
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .arcBrand: [.arcBrandBurgundy, .arcBrandBurgundy.opacity(0.7)]
        case .fitness: [.green, .mint]
        case .premium: [Color.arcBrandGold, Color.arcBrandBurgundy]
        case .dark: [.gray, Color.arcBrandBlack]
        }
    }
}

private struct FeatureRowView: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Color.arcBrandGold)

            Text(text)
                .foregroundStyle(.primary.opacity(0.9))
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCMenuDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCMenuDemoScreen()
    }
    .preferredColorScheme(.dark)
}
