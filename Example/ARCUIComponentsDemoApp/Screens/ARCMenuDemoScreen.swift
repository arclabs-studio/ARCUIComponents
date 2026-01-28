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
            name: "ARC Labs",
            email: "hello@arclabs.studio",
            subtitle: "Premium Member",
            avatarImage: .imageName("ARC_Icon")
        ),
        configuration: ARCMenuConfiguration(sheetTitle: "Cuenta"),
        onSettings: {},
        onProfile: {},
        onPlan: {},
        onContact: {},
        onAbout: {},
        onLogout: {}
    )

    @State private var selectedPresentationStyle: PresentationStyleOption = .bottomSheet
    @State private var selectedTheme: MenuThemeOption = .arcBrand

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
            .onChange(of: selectedPresentationStyle) { _, _ in
                updateConfiguration()
            }
            .onChange(of: selectedTheme) { _, _ in
                updateConfiguration()
            }
    }

    // MARK: Private Methods

    private func updateConfiguration() {
        menuViewModel.configuration = ARCMenuConfiguration(
            presentationStyle: selectedPresentationStyle.style,
            accentColor: selectedTheme.accentColor,
            showsGrabber: selectedPresentationStyle == .bottomSheet,
            showsCloseButton: selectedPresentationStyle == .bottomSheet,
            sheetTitle: selectedPresentationStyle == .bottomSheet ? "Cuenta" : nil
        )
    }
}

// MARK: - Private Views

extension ARCMenuDemoScreen {
    private var backgroundGradient: some View {
        LinearGradient(
            colors: selectedTheme.gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                presentationStylePicker
                themePicker
                featuresCard
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image("ARC_Symbol")
                .resizable()
                .scaledToFit()
                .frame(height: 60)

            Text("ARCMenu Demo")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("Tap the menu button in the toolbar")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
    }

    private var presentationStylePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Presentation Style")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 4)

            Picker("Presentation", selection: $selectedPresentationStyle) {
                ForEach(PresentationStyleOption.allCases) { style in
                    Text(style.name).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 32)
    }

    private var themePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Theme")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 4)

            Picker("Theme", selection: $selectedTheme) {
                ForEach(MenuThemeOption.allCases) { theme in
                    Text(theme.name).tag(theme)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 32)
    }

    private var featuresCard: some View {
        VStack(spacing: 16) {
            Image(systemName: selectedPresentationStyle.icon)
                .font(.system(size: 40))
                .foregroundStyle(Color.arcBrandGold)

            Text(selectedPresentationStyle.title)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(selectedPresentationStyle.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Divider()
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(selectedPresentationStyle.features, id: \.text) { feature in
                    FeatureRowView(icon: feature.icon, text: feature.text)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Supporting Types

private enum PresentationStyleOption: String, CaseIterable, Identifiable {
    case bottomSheet
    case trailingPanel

    var id: String { rawValue }

    var name: String {
        switch self {
        case .bottomSheet: "Bottom Sheet"
        case .trailingPanel: "Trailing Panel"
        }
    }

    var style: ARCMenuPresentationStyle {
        switch self {
        case .bottomSheet: .bottomSheet
        case .trailingPanel: .trailingPanel
        }
    }

    var icon: String {
        switch self {
        case .bottomSheet: "rectangle.bottomhalf.inset.filled"
        case .trailingPanel: "rectangle.righthalf.inset.filled"
        }
    }

    var title: String {
        switch self {
        case .bottomSheet: "Bottom Sheet (Apple Standard)"
        case .trailingPanel: "Trailing Panel (Drawer)"
        }
    }

    var description: String {
        switch self {
        case .bottomSheet:
            "Slides up from the bottom like Apple Music, Apple TV, and Slack. Includes grabber and close button."
        case .trailingPanel:
            "Slides in from the right edge like a drawer. Great for iPad or desktop layouts."
        }
    }

    var features: [(icon: String, text: String)] {
        switch self {
        case .bottomSheet:
            [
                ("arrow.up.doc", "Slides up from bottom"),
                ("hand.draw", "Swipe down to dismiss"),
                ("minus.rectangle", "Grabber handle"),
                ("xmark.circle", "Close button"),
                ("text.justify.leading", "Centered title")
            ]
        case .trailingPanel:
            [
                ("arrow.right.doc", "Slides in from right"),
                ("hand.draw", "Swipe right to dismiss"),
                ("person.crop.circle", "User profile header"),
                ("paintbrush", "Liquid glass effect")
            ]
        }
    }
}

private enum MenuThemeOption: String, CaseIterable, Identifiable {
    case arcBrand
    case fitness
    case premium
    case dark

    var id: String { rawValue }

    var name: String {
        switch self {
        case .arcBrand: "ARC"
        case .fitness: "Fitness"
        case .premium: "Premium"
        case .dark: "Dark"
        }
    }

    var accentColor: Color {
        switch self {
        case .arcBrand: .arcBrandGold
        case .fitness: .green
        case .premium: .orange
        case .dark: .purple
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
