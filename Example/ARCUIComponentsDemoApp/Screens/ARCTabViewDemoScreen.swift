//
//  ARCTabViewDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen showcasing ARCTabView functionality
///
/// Provides an interactive demonstration of the ARCTabView component
/// with configurable options for style, search, and accessories.
@available(iOS 18.0, *)
struct ARCTabViewDemoScreen: View {

    // MARK: - State

    @State private var selectedTab: DemoAppTab = .home
    @State private var showSearchTab = true
    @State private var showAccessory = false
    @State private var selectedStyle: ARCTabViewStyle = .automatic
    @State private var isFullScreenDemo = false

    // MARK: - Body

    var body: some View {
        List {
            configurationSection
            previewSection
            fullScreenDemoSection
        }
        .navigationTitle("ARCTabView")
        .listStyle(.insetGrouped)
        .fullScreenCover(isPresented: $isFullScreenDemo) {
            fullScreenDemoView
        }
    }

    // MARK: - Configuration Section

    private var configurationSection: some View {
        Section {
            // Style Picker
            Picker("Style", selection: $selectedStyle) {
                Text("Automatic").tag(ARCTabViewStyle.automatic)
                Text("Tab Bar Only").tag(ARCTabViewStyle.tabBarOnly)
                Text("Sidebar Adaptable").tag(ARCTabViewStyle.sidebarAdaptable)
            }

            // Search Tab Toggle
            Toggle("Show Search Tab", isOn: $showSearchTab)

            // Accessory Toggle
            Toggle("Show Bottom Accessory", isOn: $showAccessory)
        } header: {
            Text("Configuration")
        } footer: {
            Text("Bottom accessory requires iOS 26+. Search tab uses TabRole.search for integrated search experience.")
        }
    }

    // MARK: - Preview Section

    private var previewSection: some View {
        Section {
            VStack(spacing: 0) {
                embeddedDemoView
            }
            .frame(height: 350)
            .listRowInsets(EdgeInsets())
        } header: {
            Text("Preview")
        } footer: {
            Text("Tap a tab to see it in action. The badge on Favorites shows notification count.")
        }
    }

    // MARK: - Full Screen Demo Section

    private var fullScreenDemoSection: some View {
        Section {
            Button {
                isFullScreenDemo = true
            } label: {
                HStack {
                    Label("Open Full Screen Demo", systemImage: "arrow.up.left.and.arrow.down.right")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        } header: {
            Text("Full Screen")
        } footer: {
            Text("Experience ARCTabView in a full screen environment to better understand the navigation flow.")
        }
    }

    // MARK: - Demo Views

    @ViewBuilder
    private var embeddedDemoView: some View {
        if showSearchTab && showAccessory {
            ARCTabView(
                selection: $selectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                TabContentView(tab: tab)
            } searchContent: {
                SearchContentView()
            } bottomAccessory: {
                MiniPlayerView()
            }
        } else if showSearchTab {
            ARCTabView(
                selection: $selectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                TabContentView(tab: tab)
            } searchContent: {
                SearchContentView()
            }
        } else if showAccessory {
            ARCTabView(
                selection: $selectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                TabContentView(tab: tab)
            } bottomAccessory: {
                MiniPlayerView()
            }
        } else {
            ARCTabView(
                selection: $selectedTab,
                configuration: ARCTabViewConfiguration(style: selectedStyle)
            ) { tab in
                TabContentView(tab: tab)
            }
        }
    }

    @ViewBuilder
    private var fullScreenDemoView: some View {
        NavigationStack {
            if showSearchTab && showAccessory {
                ARCTabView(
                    selection: $selectedTab,
                    configuration: ARCTabViewConfiguration(style: selectedStyle)
                ) { tab in
                    FullScreenTabContent(tab: tab)
                } searchContent: {
                    FullScreenSearchContent()
                } bottomAccessory: {
                    MiniPlayerView()
                }
            } else if showSearchTab {
                ARCTabView(
                    selection: $selectedTab,
                    configuration: ARCTabViewConfiguration(style: selectedStyle)
                ) { tab in
                    FullScreenTabContent(tab: tab)
                } searchContent: {
                    FullScreenSearchContent()
                }
            } else if showAccessory {
                ARCTabView(
                    selection: $selectedTab,
                    configuration: ARCTabViewConfiguration(style: selectedStyle)
                ) { tab in
                    FullScreenTabContent(tab: tab)
                } bottomAccessory: {
                    MiniPlayerView()
                }
            } else {
                ARCTabView(
                    selection: $selectedTab,
                    configuration: ARCTabViewConfiguration(style: selectedStyle)
                ) { tab in
                    FullScreenTabContent(tab: tab)
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                isFullScreenDemo = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

// MARK: - Demo Tab Enum

@available(iOS 18.0, *)
private enum DemoAppTab: String, ARCTabItem, CaseIterable {
    case home
    case favorites
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .favorites: "Favorites"
        case .profile: "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .favorites: "heart.fill"
        case .profile: "person.fill"
        }
    }

    var badge: Int? {
        switch self {
        case .favorites: 5
        default: nil
        }
    }
}

// MARK: - Content Views

@available(iOS 18.0, *)
private struct TabContentView: View {
    let tab: DemoAppTab

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: tab.icon)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(tab.title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

@available(iOS 18.0, *)
private struct SearchContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("Search")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

@available(iOS 18.0, *)
private struct FullScreenTabContent: View {
    let tab: DemoAppTab

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(.blue.gradient)

                    Text(tab.title)
                        .font(.largeTitle.bold())
                }
                .padding(.top, 40)

                // Sample content
                ForEach(1..<6) { index in
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.opacity(0.1))
                            .frame(width: 60, height: 60)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Item \(index)")
                                .font(.headline)

                            Text("Sample content for \(tab.title.lowercased())")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(tab.title)
    }
}

@available(iOS 18.0, *)
private struct FullScreenSearchContent: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Search")
                .font(.largeTitle.bold())

            Text("Type to search...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Search")
        .searchable(text: $searchText)
    }
}

@available(iOS 18.0, *)
private struct MiniPlayerView: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("Now Playing")
                    .font(.caption.bold())

                Text("Sample Track - Artist")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 16) {
                Button {} label: {
                    Image(systemName: "backward.fill")
                }

                Button {} label: {
                    Image(systemName: "play.fill")
                }

                Button {} label: {
                    Image(systemName: "forward.fill")
                }
            }
            .font(.body)
            .foregroundStyle(.primary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Previews

#Preview("Demo Screen") {
    if #available(iOS 18.0, *) {
        NavigationStack {
            ARCTabViewDemoScreen()
        }
    }
}
