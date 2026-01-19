//
//  ThematicArtworkShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ThematicArtworkShowcase

/// A comprehensive showcase view demonstrating all thematic artworks.
///
/// Use `ThematicArtworkShowcase` to explore the available artwork types,
/// animation styles, and configurations in an interactive gallery.
public struct ThematicArtworkShowcase: View {

    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .food
    @State private var isAnimating: Bool = false
    @State private var selectedAnimation: ArtworkAnimationType = .spin

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    tabPicker
                    animationControls

                    switch selectedTab {
                    case .food:
                        foodSection
                    case .books:
                        booksSection
                    case .loaders:
                        loadersSection
                    }
                }
                .padding()
            }
            .navigationTitle("Thematic Artwork")
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        Picker("Category", selection: $selectedTab) {
            ForEach(ShowcaseTab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Animation Controls

    private var animationControls: some View {
        VStack(spacing: 12) {
            Toggle("Animate", isOn: $isAnimating)

            if isAnimating {
                Picker("Animation", selection: $selectedAnimation) {
                    ForEach(ArtworkAnimationType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Food Section

    private var foodSection: some View {
        VStack(spacing: 24) {
            sectionHeader("Food Artworks")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 20) {
                ForEach(ArtworkType.allFoodCases, id: \.displayName) { type in
                    artworkCard(type.displayName) {
                        ThemedArtworkView(
                            type: type,
                            isAnimating: isAnimating,
                            animationType: selectedAnimation
                        )
                    }
                }
            }
        }
    }

    // MARK: - Books Section

    private var booksSection: some View {
        VStack(spacing: 24) {
            sectionHeader("Book Artworks")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                ForEach(ArtworkType.allBookCases, id: \.displayName) { type in
                    bookCard(type.displayName) {
                        ThemedArtworkView(
                            type: type,
                            isAnimating: isAnimating,
                            animationType: selectedAnimation
                        )
                    }
                }
            }
        }
    }

    // MARK: - Loaders Section

    private var loadersSection: some View {
        VStack(spacing: 24) {
            sectionHeader("Loader Examples")

            HStack(spacing: 24) {
                ForEach(ArtworkType.allFoodCases, id: \.displayName) { type in
                    loaderExample(type.displayName, type: type, size: 60)
                }
            }

            Divider()

            sectionHeader("Animation Types")

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                ForEach(ArtworkAnimationType.allCases, id: \.self) { animationType in
                    VStack(spacing: 8) {
                        ThemedLoaderView(
                            type: .food(.pizza),
                            size: 60,
                            animationType: animationType
                        )

                        Text(animationType.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()

            sectionHeader("Book Loaders")

            HStack(spacing: 24) {
                ForEach(ArtworkType.allBookCases, id: \.displayName) { type in
                    loaderExample(type.displayName, type: type, size: 60)
                }
            }
        }
    }

    // MARK: - Helper Views

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }

    private func artworkCard<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 8) {
            content()
                .frame(width: 100, height: 100)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func bookCard<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 8) {
            content()
                .frame(width: 80, height: 120)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func loaderExample(
        _ title: String,
        type: ArtworkType,
        size: CGFloat
    ) -> some View {
        VStack(spacing: 8) {
            ThemedLoaderView(type: type, size: size)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - ShowcaseTab

private enum ShowcaseTab: String, CaseIterable {
    case food = "Food"
    case books = "Books"
    case loaders = "Loaders"
}

// MARK: - Preview

#Preview("Showcase") {
    ThematicArtworkShowcase()
}

#Preview("Showcase - Dark") {
    ThematicArtworkShowcase()
        .preferredColorScheme(.dark)
}
