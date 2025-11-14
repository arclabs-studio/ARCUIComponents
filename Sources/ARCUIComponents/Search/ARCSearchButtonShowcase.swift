//
//  ARCSearchButtonShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

/// Showcase demonstrating ARCSearchButton in various configurations
///
/// This view provides a visual gallery of search button variations,
/// demonstrating different styles, sizes, and usage contexts.
///
/// Use this showcase to:
/// - Preview button styles and sizes
/// - Test interaction and animation behavior
/// - Compare configurations side by side
/// - Verify accessibility and Dynamic Type support
/// - See buttons in realistic contexts (toolbars, navigation bars, content)
@available(iOS 17.0, *)
public struct ARCSearchButtonShowcase: View {
    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .styles
    @State private var showSearchSheet = false
    @State private var searchQuery = ""

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // Tabs
                    Picker("Showcase Tab", selection: $selectedTab) {
                        ForEach(ShowcaseTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top)

                    // Content
                    Group {
                        switch selectedTab {
                        case .styles:
                            stylesContent
                        case .sizes:
                            sizesContent
                        case .contexts:
                            contextsContent
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Search Button")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showSearchSheet) {
                SearchSheetView(searchQuery: $searchQuery)
            }
        }
    }

    // MARK: - Styles Content

    private var stylesContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "Styles",
                subtitle: "Different visual treatments"
            )
            .padding(.horizontal)

            // Plain
            StyleExample(
                title: "Plain",
                description: "Icon only, no background",
                style: .plain
            )

            Divider()
                .padding(.horizontal)

            // Bordered
            StyleExample(
                title: "Bordered",
                description: "Icon with border outline",
                style: .bordered
            )

            Divider()
                .padding(.horizontal)

            // Filled
            StyleExample(
                title: "Filled",
                description: "Icon with filled background",
                style: .filled
            )
        }
    }

    // MARK: - Sizes Content

    private var sizesContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "Sizes",
                subtitle: "Different button sizes"
            )
            .padding(.horizontal)

            VStack(spacing: 32) {
                SizeExample(size: .small, title: "Small", description: "18pt icon, 36pt frame")
                SizeExample(size: .medium, title: "Medium", description: "20pt icon, 44pt frame")
                SizeExample(size: .large, title: "Large", description: "24pt icon, 52pt frame")
            }
        }
    }

    // MARK: - Contexts Content

    private var contextsContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "In Context",
                subtitle: "Search buttons in realistic usage scenarios"
            )
            .padding(.horizontal)

            // Navigation Bar
            ContextExample(
                title: "Navigation Bar",
                description: "Search button in top bar trailing position"
            ) {
                NavigationBarExample()
            }

            // Toolbar
            ContextExample(
                title: "Toolbar",
                description: "Search button in bottom toolbar"
            ) {
                ToolbarExample()
            }

            // Content Area
            ContextExample(
                title: "Content Area",
                description: "Prominent search button in content"
            ) {
                ContentAreaExample(showSearchSheet: $showSearchSheet)
            }

            // Search Bar Alternative
            ContextExample(
                title: "Search Bar Alternative",
                description: "Button triggering full search interface"
            ) {
                SearchBarAlternativeExample(showSearchSheet: $showSearchSheet)
            }
        }
    }
}

// MARK: - Style Example

@available(iOS 17.0, *)
private struct StyleExample: View {
    let title: String
    let description: String
    let style: ARCSearchButtonConfiguration.ButtonStyle

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            HStack(spacing: 40) {
                ForEach([Color.blue, .green, .orange], id: \.self) { color in
                    ARCSearchButton(
                        style: style,
                        accentColor: style == .filled ? .white : color
                    ) {
                        print("\(title) search tapped")
                    }
                }
            }
        }
    }
}

// MARK: - Size Example

@available(iOS 17.0, *)
private struct SizeExample: View {
    let size: ARCSearchButtonConfiguration.ButtonSize
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            HStack(spacing: 40) {
                ARCSearchButton(
                    style: .plain,
                    size: size,
                    accentColor: .secondary
                ) {
                    print("Plain search")
                }

                ARCSearchButton(
                    style: .bordered,
                    size: size,
                    accentColor: .blue
                ) {
                    print("Bordered search")
                }

                ARCSearchButton(
                    style: .filled,
                    size: size,
                    accentColor: .white
                ) {
                    print("Filled search")
                }
            }
        }
    }
}

// MARK: - Context Examples

@available(iOS 17.0, *)
private struct NavigationBarExample: View {
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Text("Content")
                    .font(.largeTitle.bold())

                Spacer()

                ARCSearchButton {
                    print("Search from nav bar")
                }
            }
            .padding()
            .background(.ultraThinMaterial)

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(1...5, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(.blue.gradient)
                                .frame(width: 44, height: 44)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Item \(index)")
                                    .font(.headline)

                                Text("Tap search to find items")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .frame(height: 300)
        }
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 17.0, *)
private struct ToolbarExample: View {
    var body: some View {
        VStack(spacing: 0) {
            // Content
            VStack(spacing: 20) {
                Text("Toolbar Example")
                    .font(.title2.bold())

                Text("Search button appears in the bottom toolbar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(Color(.systemBackground))

            // Toolbar
            HStack {
                Button {} label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                }

                Spacer()

                ARCSearchButton(style: .bordered, accentColor: .blue) {
                    print("Search from toolbar")
                }

                Spacer()

                Button {} label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 17.0, *)
private struct ContentAreaExample: View {
    @Binding var showSearchSheet: Bool

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.blue.gradient)

            VStack(spacing: 8) {
                Text("Search Content")
                    .font(.title2.bold())

                Text("Find exactly what you're looking for")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ARCSearchButton(configuration: .prominent) {
                showSearchSheet = true
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 17.0, *)
private struct SearchBarAlternativeExample: View {
    @Binding var showSearchSheet: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Fake search bar that triggers sheet
            Button {
                showSearchSheet = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    Text("Search")
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding()
                .background(Color(.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()

            // Content
            Text("Tap the search field above to open full search")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Search Sheet

@available(iOS 17.0, *)
private struct SearchSheetView: View {
    @Binding var searchQuery: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search", text: $searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                if searchQuery.isEmpty {
                    Spacer()
                    Text("Enter a search query")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List(1...10, id: \.self) { item in
                        Text("Result \(item) for \"\(searchQuery)\"")
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

@available(iOS 17.0, *)
private struct ContextExample<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            content()
                .padding(.horizontal)
        }
    }
}

@available(iOS 17.0, *)
private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title.bold())

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

@available(iOS 17.0, *)
private enum ShowcaseTab: String, CaseIterable {
    case styles = "Styles"
    case sizes = "Sizes"
    case contexts = "Contexts"
}

// MARK: - Preview

#Preview("Showcase - Light") {
    ARCSearchButtonShowcase()
        .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    ARCSearchButtonShowcase()
        .preferredColorScheme(.dark)
}
