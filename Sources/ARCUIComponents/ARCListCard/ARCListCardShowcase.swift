//
//  ARCListCardShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

/// Showcase demonstrating ARCListCard in various configurations
///
/// This view provides a visual gallery of list card variations,
/// demonstrating different configurations, content types, and use cases.
///
/// Use this showcase to:
/// - Preview card configurations and styles
/// - Test interaction and animation behavior
/// - See cards with different content combinations
/// - Verify accessibility and Dynamic Type support
/// - View realistic usage scenarios
@available(iOS 17.0, *)
public struct ARCListCardShowcase: View {
    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .styles
    @State private var favorites: Set<String> = []
    @State private var selectedItem: String?

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
                        case .content:
                            contentContent
                        case .apps:
                            appsContent
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("List Cards")
            .background(showcaseBackground)
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
                .sheet(isPresented: Binding(
                    get: { selectedItem != nil },
                    set: { if !$0 { selectedItem = nil } }
                )) {
                    if let item = selectedItem {
                        DetailSheet(item: item)
                    }
                }
        }
    }

    // MARK: - Background

    @ViewBuilder
    private var showcaseBackground: some View {
        LinearGradient(
            colors: [.blue.opacity(0.15), .purple.opacity(0.1), .pink.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    // MARK: - Styles Content

    private var stylesContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "Configurations",
                subtitle: "Different visual treatments"
            )
            .padding(.horizontal)

            // Default
            StyleSection(
                title: "Default",
                description: "Translucent background with subtle shadow"
            ) {
                ARCListCard(
                    configuration: .default,
                    image: .system("star.fill", color: .yellow),
                    title: "Default Configuration",
                    subtitle: "Standard translucent style"
                )
            }

            // Prominent
            StyleSection(
                title: "Prominent",
                description: "Liquid glass effect with enhanced depth"
            ) {
                ARCListCard(
                    configuration: .prominent,
                    image: .system("sparkles", color: .blue),
                    title: "Prominent Configuration",
                    subtitle: "Premium liquid glass effect"
                )
            }

            // Glassmorphic
            StyleSection(
                title: "Glassmorphic",
                description: "Apple Music-inspired styling"
            ) {
                ARCListCard(
                    configuration: .glassmorphic,
                    image: .system("music.note", color: .pink),
                    title: "Glassmorphic Configuration",
                    subtitle: "Music app aesthetic"
                )
            }

            // Subtle
            StyleSection(
                title: "Subtle",
                description: "Minimal styling with separator"
            ) {
                ARCListCard(
                    configuration: .subtle,
                    image: .system("doc.fill", color: .gray),
                    title: "Subtle Configuration",
                    subtitle: "Minimal visual treatment"
                )
            }
        }
    }

    // MARK: - Content Content

    private var contentContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "Content Variations",
                subtitle: "Different content combinations"
            )
            .padding(.horizontal)

            // Title only
            ContentSection(
                title: "Title Only",
                description: "Minimal card with just a title"
            ) {
                ARCListCard(
                    title: "Simple Title"
                )
            }

            // Title and subtitle
            ContentSection(
                title: "Title & Subtitle",
                description: "Card with supporting text"
            ) {
                ARCListCard(
                    title: "Main Title",
                    subtitle: "Supporting subtitle text"
                )
            }

            // With image
            ContentSection(
                title: "With Image",
                description: "Card with leading image"
            ) {
                ARCListCard(
                    image: .system("photo.fill", color: .blue),
                    title: "Title with Image",
                    subtitle: "And a subtitle"
                )
            }

            // With accessories
            ContentSection(
                title: "With Accessories",
                description: "Card with trailing elements"
            ) {
                ARCListCard(
                    image: .system("music.note", color: .pink),
                    title: "Song Title",
                    subtitle: "Artist Name",
                    accessories: {
                        HStack(spacing: 8) {
                            ARCFavoriteButton(
                                isFavorite: binding(for: "accessory-demo"),
                                size: .medium
                            )

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                )
            }
        }
    }

    // MARK: - Apps Content

    private var appsContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "App Examples",
                subtitle: "Realistic app scenarios"
            )
            .padding(.horizontal)

            // Music App
            AppSection(title: "Music App", description: "Song list with favorites") {
                VStack(spacing: 12) {
                    ForEach(musicItems, id: \.id) { item in
                        ARCListCard(
                            configuration: .glassmorphic,
                            image: .system("music.note", color: .pink),
                            title: item.title,
                            subtitle: item.subtitle,
                            accessories: {
                                ARCFavoriteButton(
                                    isFavorite: binding(for: item.id),
                                    size: .medium
                                )
                            },
                            action: {
                                selectedItem = item.id
                            }
                        )
                    }
                }
            }

            // Books App
            AppSection(title: "Books App", description: "Reading list") {
                VStack(spacing: 12) {
                    ForEach(bookItems, id: \.id) { item in
                        ARCListCard(
                            configuration: .prominent,
                            image: .system("book.fill", color: .orange),
                            title: item.title,
                            subtitle: item.subtitle,
                            accessories: {
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.tertiary)
                            },
                            action: {
                                selectedItem = item.id
                            }
                        )
                    }
                }
            }

            // Podcasts App
            AppSection(title: "Podcasts App", description: "Episode list") {
                VStack(spacing: 12) {
                    ForEach(podcastItems, id: \.id) { item in
                        ARCListCard(
                            configuration: .default,
                            image: .system("mic.fill", color: .purple),
                            title: item.title,
                            subtitle: item.subtitle
                        ) {
                            selectedItem = item.id
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { favorites.contains(key) },
            set: { isFav in
                if isFav {
                    favorites.insert(key)
                } else {
                    favorites.remove(key)
                }
            }
        )
    }
}

// MARK: - Supporting Views

@available(iOS 17.0, *)
private struct StyleSection<Content: View>: View {
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
private struct ContentSection<Content: View>: View {
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
private struct AppSection<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
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

@available(iOS 17.0, *)
private struct DetailSheet: View {
    let item: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green.gradient)

                Text("Selected")
                    .font(.title2.bold())

                Text(item)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Details")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                    #else
                    ToolbarItem(placement: .automatic) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                    #endif
                }
        }
    }
}

// MARK: - Sample Data

@available(iOS 17.0, *)
private struct SampleItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
}

@available(iOS 17.0, *)
private let musicItems = [
    SampleItem(id: "song1", title: "Summer Nights", subtitle: "The Vibes • 2024"),
    SampleItem(id: "song2", title: "City Lights", subtitle: "Urban Sound • 2024"),
    SampleItem(id: "song3", title: "Ocean Waves", subtitle: "Nature Sounds • 2023")
]

@available(iOS 17.0, *)
private let bookItems = [
    SampleItem(id: "book1", title: "Swift Programming", subtitle: "By Apple • Programming"),
    SampleItem(id: "book2", title: "Design Patterns", subtitle: "By Gang of Four • Software"),
    SampleItem(id: "book3", title: "Clean Code", subtitle: "By Robert Martin • Development")
]

@available(iOS 17.0, *)
private let podcastItems = [
    SampleItem(id: "pod1", title: "Tech Talk Daily", subtitle: "Episode 142 • 45 min"),
    SampleItem(id: "pod2", title: "Design Matters", subtitle: "Episode 89 • 32 min"),
    SampleItem(id: "pod3", title: "Code Review", subtitle: "Episode 201 • 1 hr 5 min")
]

// MARK: - Showcase Tab

@available(iOS 17.0, *)
private enum ShowcaseTab: String, CaseIterable {
    case styles = "Styles"
    case content = "Content"
    case apps = "Apps"
}

// MARK: - Preview

#Preview("Showcase - Light") {
    ARCListCardShowcase()
        .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    ARCListCardShowcase()
        .preferredColorScheme(.dark)
}
