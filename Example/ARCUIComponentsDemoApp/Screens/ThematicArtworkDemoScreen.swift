//
//  ThematicArtworkDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/1/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for Thematic Artwork components.
///
/// Shows themed visual placeholders and loaders with interactive configuration options.
struct ThematicArtworkDemoScreen: View {

    // MARK: Properties

    @State private var selectedCategory: CategoryOption = .food
    @State private var selectedFoodStyle: ArtworkType.FoodStyle = .pizza
    @State private var selectedBookStyle: ArtworkType.BookStyle = .romance
    @State private var isAnimating: Bool = false
    @State private var selectedAnimation: ArtworkAnimationType = .spin

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                configurationSection
                previewSection
                useCasesSection
                loaderSizesSection
            }
            .padding()
        }
        .navigationTitle("Thematic Artwork")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Private Views

private extension ThematicArtworkDemoScreen {

    // MARK: Configuration Section

    var configurationSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Configuration")

            VStack(spacing: 12) {
                categoryPicker
                stylePicker
                animationToggle

                if isAnimating {
                    animationPicker
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Category", selection: $selectedCategory) {
                ForEach(CategoryOption.allCases) { category in
                    Text(category.name).tag(category)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var stylePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Style")
                .font(.caption)
                .foregroundStyle(.secondary)

            switch selectedCategory {
            case .food:
                Picker("Food Style", selection: $selectedFoodStyle) {
                    ForEach(ArtworkType.FoodStyle.allCases, id: \.self) { style in
                        Text(style.rawValue.capitalized).tag(style)
                    }
                }
                .pickerStyle(.segmented)

            case .book:
                Picker("Book Style", selection: $selectedBookStyle) {
                    ForEach(ArtworkType.BookStyle.allCases, id: \.self) { style in
                        Text(style.rawValue.capitalized).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    var animationToggle: some View {
        Toggle("Animate", isOn: $isAnimating.animation(.easeInOut))
    }

    var animationPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Animation Type")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Animation", selection: $selectedAnimation) {
                ForEach(ArtworkAnimationType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: Preview Section

    var previewSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Preview")

            VStack(spacing: 12) {
                ThemedArtworkView(
                    type: currentArtworkType,
                    isAnimating: isAnimating,
                    animationType: selectedAnimation
                )
                .frame(
                    width: selectedCategory == .food ? 150 : 120,
                    height: selectedCategory == .food ? 150 : 180
                )

                Text(currentArtworkType.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(currentArtworkType.categoryName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: Use Cases Section

    var useCasesSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Use Cases")

            VStack(spacing: 16) {
                useCaseCard(
                    title: "Loading State",
                    description: "Use as a themed loading indicator",
                    icon: "hourglass"
                ) {
                    HStack(spacing: 16) {
                        ThemedLoaderView(type: .food(.pizza), size: 40)
                        ThemedLoaderView(type: .food(.sushi), size: 40)
                        ThemedLoaderView(type: .food(.taco), size: 40)
                    }
                }

                useCaseCard(
                    title: "Placeholder",
                    description: "Use as image placeholder while content loads",
                    icon: "photo"
                ) {
                    HStack(spacing: 12) {
                        ThemedArtworkView(type: .book(.noir))
                            .frame(width: 60, height: 90)
                        ThemedArtworkView(type: .book(.romance))
                            .frame(width: 60, height: 90)
                        ThemedArtworkView(type: .book(.horror))
                            .frame(width: 60, height: 90)
                    }
                }

                useCaseCard(
                    title: "Empty State",
                    description: "Use to illustrate empty categories",
                    icon: "tray"
                ) {
                    VStack(spacing: 8) {
                        ThemedArtworkView(type: .food(.sushi))
                            .frame(width: 80, height: 80)
                        Text("No items yet")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: Loader Sizes Section

    var loaderSizesSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Loader Sizes")

            HStack(spacing: 24) {
                loaderSize(32, label: "Small")
                loaderSize(48, label: "Medium")
                loaderSize(64, label: "Large")
                loaderSize(80, label: "XLarge")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Helper Views

    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
        }
    }

    func useCaseCard<Content: View>(
        title: String,
        description: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.arcBrandBurgundy)
                Text(title)
                    .font(.subheadline.bold())
            }

            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)

            content()
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    func loaderSize(_ size: CGFloat, label: String) -> some View {
        VStack(spacing: 8) {
            ThemedLoaderView(type: .food(.pizza), size: size)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: Computed Properties

    var currentArtworkType: ArtworkType {
        switch selectedCategory {
        case .food:
            return .food(selectedFoodStyle)
        case .book:
            return .book(selectedBookStyle)
        }
    }
}

// MARK: - Supporting Types

private enum CategoryOption: String, CaseIterable, Identifiable {
    case food
    case book

    var id: String { rawValue }

    var name: String {
        switch self {
        case .food: "Food"
        case .book: "Book"
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ThematicArtworkDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ThematicArtworkDemoScreen()
    }
    .preferredColorScheme(.dark)
}
