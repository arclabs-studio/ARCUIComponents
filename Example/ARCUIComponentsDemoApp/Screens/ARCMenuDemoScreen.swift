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
/// Demonstrates the **recommended pattern** for ARCMenu integration:
///
/// ## Key Concepts
///
/// 1. **External Binding Pattern** (`@State var showMenu`)
///    - Presentation state lives in the View layer (SwiftUI standard)
///    - ViewModel holds data only (user, items, configuration)
///
/// 2. **ARCMenuButton with Binding**
///    - Use `ARCMenuButton(isPresented: $showMenu, viewModel:)`
///    - Or use `.arcMenuToolbarButton(isPresented:viewModel:)` modifier
///
/// 3. **Architecture Agnostic**
///    - Works with plain SwiftUI, Coordinators, TCA, or any pattern
///    - Only requirement: a `Binding<Bool>` for presentation
///
/// ## Usage Example
///
/// ```swift
/// struct MyView: View {
///     @State private var showMenu = false
///     @State private var menuViewModel = ARCMenuViewModel(...)
///
///     var body: some View {
///         NavigationStack {
///             ContentView()
///                 .arcMenuToolbarButton(
///                     isPresented: $showMenu,
///                     viewModel: menuViewModel
///                 )
///         }
///         .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
///     }
/// }
/// ```
struct ARCMenuDemoScreen: View {
    // MARK: - Properties

    /// Controls menu presentation via native SwiftUI sheet
    ///
    /// This is the **key** to the new pattern - an external `@State`
    /// that both the button and the menu modifier share.
    @State private var showMenu = false

    /// Menu view model with user data, items, and configuration
    ///
    /// The ViewModel now only holds data, not presentation state.
    @State private var menuViewModel = ARCMenuViewModel.withDefaultItems(
        user: ARCMenuUser(
            name: "ARC Labs",
            email: "hello@arclabs.studio",
            subtitle: "Premium Member",
            avatarImage: .imageName("ARC_Icon")
        ),
        configuration: ARCMenuConfiguration(sheetTitle: "Cuenta"),
        actions: ARCMenuActions(
            onProfile: { print("Profile tapped") },
            onSettings: { print("Settings tapped") },
            onFeedback: { print("Feedback tapped") },
            onSubscriptions: { print("Subscriptions tapped") },
            onAbout: { print("About tapped") },
            onLogout: { print("Logout tapped") }
        )
    )

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
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    // NEW: Using ARCMenuButton with isPresented binding
                    ARCMenuButton(
                        isPresented: $showMenu,
                        viewModel: menuViewModel,
                        showsBadge: showBadge,
                        badgeCount: badgeCount
                    )
                }
                #else
                ToolbarItem(placement: .automatic) {
                    ARCMenuButton(
                        isPresented: $showMenu,
                        viewModel: menuViewModel,
                        showsBadge: showBadge,
                        badgeCount: badgeCount
                    )
                }
                #endif
            }
            // NEW: Using arcMenu with isPresented binding
            .arcMenu(isPresented: $showMenu, viewModel: menuViewModel)
            .onChange(of: selectedPresentationStyle) { _, _ in
                updateConfiguration()
            }
            .onChange(of: selectedTheme) { _, _ in
                updateConfiguration()
            }
    }

    // MARK: - Private Methods

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
                apiPatternCard
                presentationStylePicker
                themePicker
                badgeOptions
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

    private var apiPatternCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                Text("v1.9.1 Pattern")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                CodeSnippetRow(
                    label: "State",
                    code: "@State var showMenu = false"
                )
                CodeSnippetRow(
                    label: "Button",
                    code: "ARCMenuButton(isPresented: $showMenu, ...)"
                )
                CodeSnippetRow(
                    label: "Modifier",
                    code: ".arcMenu(isPresented: $showMenu, ...)"
                )
            }

            Text("External binding = SwiftUI native sheet presentation")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
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
                ("arrow.up.doc", "Native SwiftUI .sheet() presentation"),
                ("hand.draw", "Swipe down to dismiss"),
                ("minus.rectangle", "Grabber handle"),
                ("xmark.circle", "Close button"),
                ("sparkles", "iOS 26+ Liquid Glass ready")
            ]
        case .trailingPanel:
            [
                ("arrow.right.doc", "Slides in from right"),
                ("hand.draw", "Swipe right to dismiss"),
                ("person.crop.circle", "User profile header"),
                ("paintbrush", "Material background")
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
