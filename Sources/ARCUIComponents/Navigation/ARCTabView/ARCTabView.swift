//
//  ARCTabView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import SwiftUI

/// Type-safe tab view wrapper using the `ARCTabItem` protocol.
///
/// ## Why ARCTabView exists (vs native TabView)
///
/// SwiftUI's `TabView` (iOS 18+) requires repeating `Tab()` for each tab.
/// ARCTabView standardizes tab definition via the ``ARCTabItem`` protocol:
///
/// | Aspect | Native TabView | ARCTabView |
/// |--------|---------------|------------|
/// | Tab definition | Repeat `Tab()` per tab | Enum + protocol |
/// | Type-safety | Manual | Automatic via `CaseIterable` |
/// | Consistency | Each app decides | Same pattern across ARC apps |
///
/// ## Usage
///
/// ```swift
/// // 1. Define tabs with ARCTabItem protocol
/// enum AppTab: String, ARCTabItem {
///     case home, favorites, settings
///
///     var title: String { rawValue.capitalized }
///     var icon: String {
///         switch self {
///         case .home: "house.fill"
///         case .favorites: "heart.fill"
///         case .settings: "gearshape.fill"
///         }
///     }
///     var badge: Int? { self == .favorites ? 3 : nil }
/// }
///
/// // 2. Use ARCTabView
/// struct ContentView: View {
///     @State private var selectedTab: AppTab = .home
///
///     var body: some View {
///         ARCTabView(selection: $selectedTab) { tab in
///             switch tab {
///             case .home: HomeView()
///             case .favorites: FavoritesView()
///             case .settings: SettingsView()
///             }
///         }
///     }
/// }
/// ```
///
/// ## With Search Tab
///
/// ```swift
/// ARCTabView(selection: $selectedTab) { tab in
///     TabContent(for: tab)
/// } search: {
///     SearchView()
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
public struct ARCTabView<TabItem: ARCTabItem, Content: View, SearchContent: View>: View {
    // MARK: - Properties

    @Binding private var selection: TabItem
    private let sidebarAdaptable: Bool
    private let content: (TabItem) -> Content
    private let searchContent: SearchContent?

    // MARK: - Initialization

    /// Creates a tab view with the specified tabs.
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - sidebarAdaptable: Use sidebar style on iPad (default: `false`)
    ///   - content: View builder for each tab's content
    public init(
        selection: Binding<TabItem>,
        sidebarAdaptable: Bool = false,
        @ViewBuilder content: @escaping (TabItem) -> Content
    ) where SearchContent == Never {
        _selection = selection
        self.sidebarAdaptable = sidebarAdaptable
        self.content = content
        searchContent = nil
    }

    /// Creates a tab view with a search tab.
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - sidebarAdaptable: Use sidebar style on iPad (default: `false`)
    ///   - content: View builder for each tab's content
    ///   - search: View builder for search tab content
    public init(
        selection: Binding<TabItem>,
        sidebarAdaptable: Bool = false,
        @ViewBuilder content: @escaping (TabItem) -> Content,
        @ViewBuilder search: () -> SearchContent
    ) {
        _selection = selection
        self.sidebarAdaptable = sidebarAdaptable
        self.content = content
        searchContent = search()
    }

    // MARK: - Body

    public var body: some View {
        TabView(selection: $selection) {
            ForEach(Array(TabItem.allCases), id: \.self) { tab in
                tabContent(for: tab)
            }

            if let searchContent {
                Tab(value: selection, role: .search) {
                    searchContent
                }
            }
        }
        .modifier(TabViewStyleModifier(sidebarAdaptable: sidebarAdaptable))
    }

    @TabContentBuilder<TabItem>
    private func tabContent(for tab: TabItem) -> some TabContent<TabItem> {
        if let badge = tab.badge {
            Tab(tab.title, systemImage: tab.icon, value: tab) {
                content(tab)
            }
            .badge(badge)
        } else {
            Tab(tab.title, systemImage: tab.icon, value: tab) {
                content(tab)
            }
        }
    }
}

// MARK: - Style Modifier

@available(iOS 18.0, macOS 15.0, *)
private struct TabViewStyleModifier: ViewModifier {
    let sidebarAdaptable: Bool

    func body(content: Content) -> some View {
        if sidebarAdaptable {
            content.tabViewStyle(.sidebarAdaptable)
        } else {
            content
        }
    }
}

// MARK: - Preview

@available(iOS 18.0, macOS 15.0, *)
private enum PreviewTab: String, ARCTabItem, CaseIterable {
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

    var badge: Int? { self == .favorites ? 5 : nil }
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("Basic") {
    @Previewable @State var tab: PreviewTab = .home
    ARCTabView(selection: $tab) { tab in
        NavigationStack {
            Text(tab.title)
                .navigationTitle(tab.title)
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("With Search") {
    @Previewable @State var tab: PreviewTab = .home
    ARCTabView(selection: $tab) { tab in
        NavigationStack {
            Text(tab.title)
                .navigationTitle(tab.title)
        }
    } search: {
        NavigationStack {
            Text("Search")
                .navigationTitle("Search")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("Sidebar Adaptable") {
    @Previewable @State var tab: PreviewTab = .home
    ARCTabView(selection: $tab, sidebarAdaptable: true) { tab in
        NavigationStack {
            Text(tab.title)
                .navigationTitle(tab.title)
        }
    }
}
