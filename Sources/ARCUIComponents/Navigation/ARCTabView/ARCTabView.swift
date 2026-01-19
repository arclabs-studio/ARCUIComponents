//
//  ARCTabView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 19/01/2026.
//

import SwiftUI

/// A reusable tab view component with Liquid Glass design for iOS 26+
///
/// ARCTabView provides a type-safe, customizable tab bar navigation that follows
/// Apple's Human Interface Guidelines. It automatically adopts Liquid Glass
/// styling on iOS 26 and supports search tabs and bottom accessories.
///
/// ## Overview
///
/// ARCTabView wraps SwiftUI's `TabView` with a simplified API that works with
/// any type conforming to ``ARCTabItem``. It provides:
///
/// - Type-safe tab navigation with enums
/// - Optional search tab with `TabRole.search`
/// - Bottom accessory support (like Music's MiniPlayer)
/// - Automatic Liquid Glass styling on iOS 26
/// - Platform-adaptive presentation
///
/// ## Topics
///
/// ### Creating Tab Views
///
/// - ``init(selection:configuration:content:)``
/// - ``init(selection:configuration:content:searchContent:)``
/// - ``init(selection:configuration:content:bottomAccessory:)``
/// - ``init(selection:configuration:content:searchContent:bottomAccessory:)``
///
/// ## Usage
///
/// ### Basic Usage
///
/// ```swift
/// enum AppTab: String, ARCTabItem {
///     case home, favorites, settings
///
///     var id: String { rawValue }
///     var title: String { rawValue.capitalized }
///     var icon: String {
///         switch self {
///         case .home: "house.fill"
///         case .favorites: "heart.fill"
///         case .settings: "gearshape.fill"
///         }
///     }
/// }
///
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
/// ### With Search Tab
///
/// ```swift
/// ARCTabView(selection: $selectedTab) { tab in
///     TabContent(for: tab)
/// } searchContent: {
///     SearchView()
/// }
/// ```
///
/// ### With Bottom Accessory (iOS 26+)
///
/// ```swift
/// ARCTabView(selection: $selectedTab) { tab in
///     TabContent(for: tab)
/// } bottomAccessory: {
///     MiniPlayerView()
/// }
/// ```
///
/// - Note: The component requires iOS 18+ for the new `Tab` API.
///   Bottom accessory support requires iOS 26+.
@available(iOS 18.0, macOS 15.0, *)
public struct ARCTabView<
    TabItem: ARCTabItem,
    Content: View,
    SearchContent: View,
    AccessoryContent: View
>: View {
    // MARK: - Properties

    /// Current tab selection
    @Binding private var selection: TabItem

    /// Configuration for appearance and behavior
    private let configuration: ARCTabViewConfiguration

    /// Content builder for each tab
    private let content: (TabItem) -> Content

    /// Optional search content
    private let searchContent: SearchContent

    /// Optional bottom accessory content
    private let accessoryContent: AccessoryContent

    /// Tracks if search content is provided
    private let hasSearchContent: Bool

    /// Tracks if accessory content is provided
    private let hasAccessoryContent: Bool

    // MARK: - Initialization

    /// Creates a tab view with all options
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - configuration: Configuration for appearance and behavior
    ///   - content: View builder that creates content for each tab
    ///   - searchContent: View builder for search tab content
    ///   - bottomAccessory: View builder for bottom accessory (iOS 26+)
    public init(
        selection: Binding<TabItem>,
        configuration: ARCTabViewConfiguration = .default,
        @ViewBuilder content: @escaping (TabItem) -> Content,
        @ViewBuilder searchContent: () -> SearchContent,
        @ViewBuilder bottomAccessory: () -> AccessoryContent
    ) {
        _selection = selection
        self.configuration = configuration
        self.content = content
        self.searchContent = searchContent()
        self.accessoryContent = bottomAccessory()
        self.hasSearchContent = true
        self.hasAccessoryContent = true
    }

    // MARK: - Body

    public var body: some View {
        tabViewContent
    }

    // MARK: - Private Views

    @ViewBuilder
    private var tabViewContent: some View {
        #if os(iOS)
        if hasAccessoryContent, AccessoryContent.self != EmptyView.self {
            tabViewWithAccessory
        } else {
            basicTabView
        }
        #else
        basicTabView
        #endif
    }

    @ViewBuilder
    private var basicTabView: some View {
        TabView(selection: $selection) {
            // Regular tabs from ARCTabItem
            ForEach(Array(TabItem.allCases), id: \.self) { tab in
                tabItem(for: tab)
            }

            // Search tab (if content provided)
            if hasSearchContent, SearchContent.self != EmptyView.self {
                Tab(value: selection, role: .search) {
                    searchContent
                }
            }
        }
        .modifier(TabViewStyleModifier(style: configuration.style))
    }

    #if os(iOS)
    @available(iOS 18.0, *)
    @ViewBuilder
    private var tabViewWithAccessory: some View {
        if #available(iOS 26.0, *) {
            TabView(selection: $selection) {
                // Regular tabs from ARCTabItem
                ForEach(Array(TabItem.allCases), id: \.self) { tab in
                    tabItem(for: tab)
                }

                // Search tab (if content provided)
                if hasSearchContent, SearchContent.self != EmptyView.self {
                    Tab(value: selection, role: .search) {
                        searchContent
                    }
                }
            }
            .tabViewBottomAccessory {
                accessoryContent
            }
            .modifier(TabViewStyleModifier(style: configuration.style))
        } else {
            basicTabView
        }
    }
    #endif

    @TabContentBuilder<TabItem>
    private func tabItem(for tab: TabItem) -> some TabContent<TabItem> {
        if let badgeCount = tab.badge {
            Tab(tab.title, systemImage: tab.icon, value: tab) {
                content(tab)
            }
            .badge(badgeCount)
        } else {
            Tab(tab.title, systemImage: tab.icon, value: tab) {
                content(tab)
            }
        }
    }
}

// MARK: - Convenience Initializers

@available(iOS 18.0, macOS 15.0, *)
public extension ARCTabView where SearchContent == EmptyView, AccessoryContent == EmptyView {
    /// Creates a basic tab view without search or accessory
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - configuration: Configuration for appearance and behavior
    ///   - content: View builder that creates content for each tab
    init(
        selection: Binding<TabItem>,
        configuration: ARCTabViewConfiguration = .default,
        @ViewBuilder content: @escaping (TabItem) -> Content
    ) {
        _selection = selection
        self.configuration = configuration
        self.content = content
        self.searchContent = EmptyView()
        self.accessoryContent = EmptyView()
        self.hasSearchContent = false
        self.hasAccessoryContent = false
    }
}

@available(iOS 18.0, macOS 15.0, *)
public extension ARCTabView where AccessoryContent == EmptyView {
    /// Creates a tab view with search but no accessory
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - configuration: Configuration for appearance and behavior
    ///   - content: View builder that creates content for each tab
    ///   - searchContent: View builder for search tab content
    init(
        selection: Binding<TabItem>,
        configuration: ARCTabViewConfiguration = .default,
        @ViewBuilder content: @escaping (TabItem) -> Content,
        @ViewBuilder searchContent: () -> SearchContent
    ) {
        _selection = selection
        self.configuration = configuration
        self.content = content
        self.searchContent = searchContent()
        self.accessoryContent = EmptyView()
        self.hasSearchContent = true
        self.hasAccessoryContent = false
    }
}

@available(iOS 18.0, macOS 15.0, *)
public extension ARCTabView where SearchContent == EmptyView {
    /// Creates a tab view with accessory but no search
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - configuration: Configuration for appearance and behavior
    ///   - content: View builder that creates content for each tab
    ///   - bottomAccessory: View builder for bottom accessory (iOS 26+)
    init(
        selection: Binding<TabItem>,
        configuration: ARCTabViewConfiguration = .default,
        @ViewBuilder content: @escaping (TabItem) -> Content,
        @ViewBuilder bottomAccessory: () -> AccessoryContent
    ) {
        _selection = selection
        self.configuration = configuration
        self.content = content
        self.searchContent = EmptyView()
        self.accessoryContent = bottomAccessory()
        self.hasSearchContent = false
        self.hasAccessoryContent = true
    }
}

// MARK: - Style Modifier

@available(iOS 18.0, macOS 15.0, *)
private struct TabViewStyleModifier: ViewModifier {
    let style: ARCTabViewStyle

    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content
        case .tabBarOnly:
            content.tabViewStyle(.tabBarOnly)
        case .sidebarAdaptable:
            content.tabViewStyle(.sidebarAdaptable)
        }
    }
}


// MARK: - Preview Support

@available(iOS 18.0, macOS 15.0, *)
private enum PreviewTab: String, ARCTabItem, CaseIterable {
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
        case .favorites: 5
        default: nil
        }
    }
}

// MARK: - Preview Wrapper

@available(iOS 18.0, macOS 15.0, *)
private struct ARCTabViewPreview: View {
    @State private var selectedTab: PreviewTab = .home
    let showSearch: Bool
    let style: ARCTabViewConfiguration

    init(showSearch: Bool = false, style: ARCTabViewConfiguration = .default) {
        self.showSearch = showSearch
        self.style = style
    }

    var body: some View {
        if showSearch {
            ARCTabView(
                selection: $selectedTab,
                configuration: style
            ) { tab in
                tabContent(for: tab)
            } searchContent: {
                NavigationStack {
                    Text("Search Content")
                        .navigationTitle("Search")
                }
            }
        } else {
            ARCTabView(
                selection: $selectedTab,
                configuration: style
            ) { tab in
                tabContent(for: tab)
            }
        }
    }

    private func tabContent(for tab: PreviewTab) -> some View {
        NavigationStack {
            VStack {
                Text("Content for \(tab.title)")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(tab.title)
        }
    }
}

// MARK: - Previews

@available(iOS 18.0, macOS 15.0, *)
#Preview("Basic") {
    ARCTabViewPreview()
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("With Search") {
    ARCTabViewPreview(showSearch: true)
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("Sidebar Adaptable") {
    ARCTabViewPreview(style: .sidebarAdaptable)
}

@available(iOS 18.0, macOS 15.0, *)
#Preview("Dark Mode") {
    ARCTabViewPreview()
        .preferredColorScheme(.dark)
}
