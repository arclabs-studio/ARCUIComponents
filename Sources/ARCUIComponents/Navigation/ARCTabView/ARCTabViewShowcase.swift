//
//  ARCTabViewShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import SwiftUI

/// Showcase demonstrating ARCTabView in various configurations
///
/// This view provides an interactive gallery of tab view variations,
/// demonstrating different styles, search functionality, and accessories.
///
/// Use this showcase to:
/// - Preview tab view styles
/// - Test search tab functionality
/// - Explore bottom accessory behavior
/// - Compare configurations side by side
/// - Verify light/dark mode appearance
@available(iOS 18.0, macOS 15.0, *)
public struct ARCTabViewShowcase: View {
    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .basic
    @State private var demoSelectedTab: DemoTab = .home
    @State private var showSearchTab = true
    @State private var showAccessory = true
    @State private var selectedStyle: ARCTabViewStyle = .automatic

    // MARK: - Initialization

    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // Configuration Controls
                    configurationSection

                    // Live Demo
                    liveDemoSection

                    // Style Examples
                    styleExamplesSection

                    // Code Example
                    codeExampleSection
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("ARCTabView")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    // MARK: - Configuration Section

    private var configurationSection: some View {
        VStack(spacing: 20) {
            SectionHeader(
                title: "Configuration",
                subtitle: "Customize the tab view behavior"
            )
            .padding(.horizontal)

            VStack(spacing: 16) {
                // Style Picker
                HStack {
                    Text("Style")
                        .font(.subheadline)

                    Spacer()

                    Picker("Style", selection: $selectedStyle) {
                        Text("Automatic").tag(ARCTabViewStyle.automatic)
                        Text("Tab Bar Only").tag(ARCTabViewStyle.tabBarOnly)
                        Text("Sidebar Adaptable").tag(ARCTabViewStyle.sidebarAdaptable)
                    }
                    .pickerStyle(.menu)
                }

                Divider()

                // Search Tab Toggle
                Toggle("Show Search Tab", isOn: $showSearchTab)
                    .font(.subheadline)

                Divider()

                // Accessory Toggle
                Toggle("Show Bottom Accessory", isOn: $showAccessory)
                    .font(.subheadline)

                if showAccessory {
                    Text("Bottom accessory requires iOS 26+")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            #if os(iOS)
            .background(Color(.secondarySystemGroupedBackground))
            #else
            .background(Color(nsColor: .controlBackgroundColor))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }

    // MARK: - Live Demo Section

    private var liveDemoSection: some View {
        VStack(spacing: 20) {
            SectionHeader(
                title: "Live Demo",
                subtitle: "Interactive preview of ARCTabView"
            )
            .padding(.horizontal)

            // Demo container
            VStack(spacing: 0) {
                demoTabView
            }
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var demoTabView: some View {
        if showSearchTab && showAccessory {
            ARCTabView(
                selection: $demoSelectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                DemoTabContent(tab: tab)
            } searchContent: {
                DemoSearchContent()
            } bottomAccessory: {
                DemoAccessoryContent()
            }
        } else if showSearchTab {
            ARCTabView(
                selection: $demoSelectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                DemoTabContent(tab: tab)
            } searchContent: {
                DemoSearchContent()
            }
        } else if showAccessory {
            ARCTabView(
                selection: $demoSelectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                DemoTabContent(tab: tab)
            } bottomAccessory: {
                DemoAccessoryContent()
            }
        } else {
            ARCTabView(
                selection: $demoSelectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                DemoTabContent(tab: tab)
            }
        }
    }

    // MARK: - Style Examples Section

    private var styleExamplesSection: some View {
        VStack(spacing: 20) {
            SectionHeader(
                title: "Style Options",
                subtitle: "Available tab view presentation styles"
            )
            .padding(.horizontal)

            VStack(spacing: 16) {
                StyleCard(
                    style: .automatic,
                    title: "Automatic",
                    description: "System chooses the best style for the current platform and device.",
                    icon: "wand.and.stars"
                )

                StyleCard(
                    style: .tabBarOnly,
                    title: "Tab Bar Only",
                    description: "Traditional tab bar that doesn't convert to sidebar.",
                    icon: "rectangle.split.3x1"
                )

                StyleCard(
                    style: .sidebarAdaptable,
                    title: "Sidebar Adaptable",
                    description: "Tab bar that can expand to sidebar on iPadOS.",
                    icon: "sidebar.leading"
                )
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Code Example Section

    private var codeExampleSection: some View {
        VStack(spacing: 20) {
            SectionHeader(
                title: "Usage Example",
                subtitle: "How to use ARCTabView in your app"
            )
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                Text(codeExample)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
            }
            #if os(iOS)
            .background(Color(.secondarySystemGroupedBackground))
            #else
            .background(Color(nsColor: .controlBackgroundColor))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }

    private var codeExample: String {
        """
        enum AppTab: String, ARCTabItem {
            case home, favorites, settings

            var id: String { rawValue }
            var title: String { rawValue.capitalized }
            var icon: String {
                switch self {
                case .home: "house.fill"
                case .favorites: "heart.fill"
                case .settings: "gearshape.fill"
                }
            }
        }

        struct ContentView: View {
            @State private var selectedTab: AppTab = .home

            var body: some View {
                ARCTabView(selection: $selectedTab) { tab in
                    switch tab {
                    case .home: HomeView()
                    case .favorites: FavoritesView()
                    case .settings: SettingsView()
                    }
                } searchContent: {
                    SearchView()
                }
            }
        }
        """
    }
}

// MARK: - Demo Tab Enum

@available(iOS 18.0, macOS 15.0, *)
private enum DemoTab: String, ARCTabItem, CaseIterable {
    case home
    case favorites
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .favorites: "Favorites"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .favorites: "heart.fill"
        case .settings: "gearshape.fill"
        }
    }

    var badge: Int? {
        switch self {
        case .favorites: 3
        default: nil
        }
    }
}

// MARK: - Demo Content Views

@available(iOS 18.0, macOS 15.0, *)
private struct DemoTabContent: View {
    let tab: DemoTab

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: tab.icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text(tab.title)
                .font(.title2.bold())

            Text("This is the \(tab.title.lowercased()) tab content")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
    }
}

@available(iOS 18.0, macOS 15.0, *)
private struct DemoSearchContent: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Search")
                .font(.title2.bold())

            Text("Search content appears here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
    }
}

@available(iOS 18.0, macOS 15.0, *)
private struct DemoAccessoryContent: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.blue.gradient)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text("Now Playing")
                    .font(.caption.bold())

                Text("Sample Track")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {} label: {
                Image(systemName: "play.fill")
                    .font(.title3)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Style Card

@available(iOS 18.0, macOS 15.0, *)
private struct StyleCard: View {
    let style: ARCTabViewStyle
    let title: String
    let description: String
    let icon: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                #if os(iOS)
                .background(Color(.tertiarySystemGroupedBackground))
                #else
                .background(Color(nsColor: .controlBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        #if os(iOS)
        .background(Color(.secondarySystemGroupedBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Section Header

@available(iOS 18.0, macOS 15.0, *)
private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Showcase Tab

@available(iOS 18.0, macOS 15.0, *)
private enum ShowcaseTab: String, CaseIterable {
    case basic = "Basic"
    case withSearch = "Search"
    case withAccessory = "Accessory"
}

// MARK: - Previews

@available(iOS 18.0, macOS 15.0, *)
#Preview("Showcase - Light") {
    ARCTabViewShowcase()
        .preferredColorScheme(.light)
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("Showcase - Dark") {
    ARCTabViewShowcase()
        .preferredColorScheme(.dark)
}
