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
/// Demonstrates both **flat** and **sectioned** menu layouts, plus
/// presentation style and theme customization.
///
/// ## Key Concepts
///
/// 1. **Flat Layout** — Simple VStack with dividers (default)
/// 2. **Sectioned Layout** — Native Form with grouped sections (new)
/// 3. **External Binding** — `@State var showMenu` controls presentation
/// 4. **Architecture Agnostic** — Works with any SwiftUI pattern
struct ARCMenuDemoScreen: View {
    // MARK: - Properties

    @State private var showMenu = false
    @State private var menuViewModel = makeFlatViewModel()

    @State private var selectedLayout: MenuLayoutOption = .flat
    @State private var selectedPresentationStyle: PresentationStyleOption = .bottomSheet
    @State private var selectedTheme: MenuThemeOption = .arcBrand
    @State private var showBadge = true
    @State private var badgeCount = 3

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundGradient
            contentView
        }
        .navigationTitle("ARCMenu")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .arcMenuToolbarButton(isPresented: $showMenu,
                                  viewModel: menuViewModel,
                                  showsBadge: showBadge,
                                  badgeCount: badgeCount)
            .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
            .onChange(of: selectedLayout) { _, _ in rebuildViewModel() }
            .onChange(of: selectedPresentationStyle) { _, _ in rebuildViewModel() }
            .onChange(of: selectedTheme) { _, _ in rebuildViewModel() }
    }

    // MARK: - ViewModel Builders

    private static let demoUser = ARCMenuUser(name: "ARC Labs",
                                              email: "hello@arclabs.studio",
                                              subtitle: "Premium Member",
                                              avatarImage: .imageName("ARC_Icon"))

    private static func makeFlatViewModel() -> ARCMenuViewModel {
        ARCMenuViewModel.withDefaultItems(user: demoUser,
                                          configuration: ARCMenuConfiguration(sheetTitle: "Account"),
                                          actions: ARCMenuActions(onProfile: { print("Profile") },
                                                                  onSettings: { print("Settings") },
                                                                  onFeedback: { print("Feedback") },
                                                                  onSubscriptions: { print("Subscriptions") },
                                                                  onAbout: { print("About") },
                                                                  onLogout: { print("Logout") }))
    }

    private static func makeSectionedViewModel(accentColor: Color = .arcBrandGold,
                                               presentationStyle: ARCMenuPresentationStyle = .bottomSheet)
        -> ARCMenuViewModel
    {
        ARCMenuViewModel(user: demoUser,
                         sections: [ARCMenuSection(title: "Account",
                                                   items: [.Common.profile { print("Profile") },
                                                           .Common.settings { print("Settings") }]),
                                    ARCMenuSection(title: "Preferences",
                                                   items: [.Common.notifications(badge: "3") { print("Notifications") },
                                                           .Common.privacy { print("Privacy") }]),
                                    ARCMenuSection(title: "Support",
                                                   footer: "We'd love to hear from you",
                                                   items: [.Common.feedback { print("Feedback") },
                                                           .Common.help { print("Help") },
                                                           .Common.about { print("About") }]),
                                    ARCMenuSection(items: [.Common.logout { print("Logout") }])],
                         configuration: ARCMenuConfiguration(presentationStyle: presentationStyle,
                                                             accentColor: accentColor,
                                                             showsGrabber: presentationStyle == .bottomSheet,
                                                             showsCloseButton: true,
                                                             sheetTitle: "Account",
                                                             layoutStyle: .grouped,
                                                             contentInteraction: .scrolls))
    }

    private func rebuildViewModel() {
        let accent = selectedTheme.accentColor
        let presentation = selectedPresentationStyle.style

        switch selectedLayout {
        case .flat:
            menuViewModel = Self.makeFlatViewModel()
            menuViewModel.configuration = ARCMenuConfiguration(presentationStyle: presentation,
                                                               accentColor: accent,
                                                               showsGrabber: presentation == .bottomSheet,
                                                               showsCloseButton: true,
                                                               sheetTitle: presentation == .bottomSheet
                                                                   ? "Account"
                                                                   : nil)
        case .sectioned:
            menuViewModel = Self.makeSectionedViewModel(accentColor: accent,
                                                        presentationStyle: presentation)
        }
    }
}

// MARK: - Private Views

extension ARCMenuDemoScreen {
    private var backgroundGradient: some View {
        LinearGradient(colors: selectedTheme.gradientColors,
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                layoutPicker
                presentationStylePicker
                themePicker
                badgeOptions
                codeExampleCard
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

    // MARK: - Pickers

    private var layoutPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Layout Style")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 4)

            Picker("Layout", selection: $selectedLayout) {
                ForEach(MenuLayoutOption.allCases) { layout in
                    Text(layout.name).tag(layout)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 32)
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

    private var badgeOptions: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Badge Options")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 4)

            HStack(spacing: 16) {
                Toggle("Show Badge", isOn: $showBadge)
                    .toggleStyle(.button)
                    .tint(showBadge ? .red : .gray)

                if showBadge {
                    Stepper("Count: \(badgeCount)", value: $badgeCount, in: 1 ... 99)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 32)
    }

    // MARK: - Info Cards

    private var codeExampleCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: selectedLayout.icon)
                    .foregroundStyle(selectedTheme.accentColor)
                Text(selectedLayout.cardTitle)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(selectedLayout.codeSnippets, id: \.label) { snippet in
                    CodeSnippetRow(label: snippet.label, code: snippet.code)
                }
            }

            Text(selectedLayout.cardDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var featuresCard: some View {
        VStack(spacing: 16) {
            Image(systemName: selectedLayout.featureIcon)
                .font(.system(size: 40))
                .foregroundStyle(selectedTheme.accentColor)

            Text(selectedLayout.featureTitle)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(selectedLayout.featureDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Divider()
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(selectedLayout.features, id: \.text) { feature in
                    FeatureRowView(icon: feature.icon,
                                   text: feature.text,
                                   accentColor: selectedTheme.accentColor)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Code Snippet Row

private struct CodeSnippetRow: View {
    let label: String
    let code: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .trailing)

            Text(code)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.primary)
        }
    }
}

private struct FeatureRowView: View {
    let icon: String
    let text: String
    var accentColor: Color = .arcBrandGold

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(accentColor)

            Text(text)
                .foregroundStyle(.primary.opacity(0.9))
        }
    }
}

// MARK: - Menu Layout Option

private enum MenuLayoutOption: String, CaseIterable, Identifiable {
    case flat = "Flat"
    case sectioned = "Sectioned"

    var id: String {
        rawValue
    }

    var name: String {
        rawValue
    }

    var icon: String {
        switch self {
        case .flat: "list.bullet"
        case .sectioned: "list.bullet.indent"
        }
    }

    var cardTitle: String {
        switch self {
        case .flat: "Flat Layout (Default)"
        case .sectioned: "Sectioned Layout (New)"
        }
    }

    var cardDescription: String {
        switch self {
        case .flat: "VStack with dividers — use ARCMenuViewModel(menuItems:)"
        case .sectioned: "Native Form with sections — use ARCMenuViewModel(sections:)"
        }
    }

    var codeSnippets: [(label: String, code: String)] {
        switch self {
        case .flat:
            [("Init", "ARCMenuViewModel(menuItems: [...])"),
             ("Config", ".default"),
             ("Layout", ".flat (VStack + dividers)")]
        case .sectioned:
            [("Init", "ARCMenuViewModel(sections: [...])"),
             ("Config", ".sectioned"),
             ("Layout", ".grouped (Form + sections)")]
        }
    }

    var featureIcon: String {
        switch self {
        case .flat: "rectangle.bottomhalf.inset.filled"
        case .sectioned: "list.bullet.rectangle"
        }
    }

    var featureTitle: String {
        switch self {
        case .flat: "Flat Menu"
        case .sectioned: "Sectioned Menu"
        }
    }

    var featureDescription: String {
        switch self {
        case .flat:
            "Simple list of items with dividers. Best for short, uniform menus."
        case .sectioned:
            "Items grouped into titled sections using native Form. Best for menus with distinct categories."
        }
    }

    var features: [(icon: String, text: String)] {
        switch self {
        case .flat:
            [("list.bullet", "VStack with dividers"),
             ("arrow.up.doc", "Native .sheet() presentation"),
             ("hand.draw", "Swipe down to dismiss"),
             ("person.circle", "User profile header"),
             ("sparkles", "iOS 26+ Liquid Glass ready")]
        case .sectioned:
            [("list.bullet.indent", "Sections with title & footer"),
             ("rectangle.on.rectangle", "Native Form + .grouped style"),
             ("scroll", "Scrollable within medium detent"),
             ("tag", "Badge and destructive support"),
             ("accessibility", "Full VoiceOver support")]
        }
    }
}

// MARK: - Presentation Style Option

private enum PresentationStyleOption: String, CaseIterable, Identifiable {
    case bottomSheet
    case trailingPanel

    var id: String {
        rawValue
    }

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
}

// MARK: - Menu Theme Option

private enum MenuThemeOption: String, CaseIterable, Identifiable {
    case arcBrand
    case fitness
    case premium
    case dark

    var id: String {
        rawValue
    }

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
