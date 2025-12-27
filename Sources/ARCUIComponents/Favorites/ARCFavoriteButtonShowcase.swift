//
//  ARCFavoriteButtonShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

/// Showcase demonstrating ARCFavoriteButton in various configurations
///
/// This view provides a visual gallery of favorite button variations,
/// demonstrating different sizes, colors, and usage contexts.
///
/// Use this showcase to:
/// - Preview button sizes and colors
/// - Test interaction and animation behavior
/// - Compare configurations side by side
/// - Verify accessibility and Dynamic Type support
/// - See buttons in realistic contexts (cards, lists, toolbars)
@available(iOS 17.0, *)
public struct ARCFavoriteButtonShowcase: View {
    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .sizes
    @State private var favoriteStates: [String: Bool] = [:]

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
                        case .sizes:
                            sizesContent
                        case .colors:
                            colorsContent
                        case .contexts:
                            contextsContent
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Favorite Button")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    // MARK: - Sizes Content

    private var sizesContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "Sizes",
                subtitle: "Different button sizes with proper touch targets"
            )
            .padding(.horizontal)

            // Small
            SizeExample(size: .small, title: "Small", description: "20pt icon, 44pt touch target")

            Divider()
                .padding(.horizontal)

            // Medium
            SizeExample(size: .medium, title: "Medium", description: "24pt icon, 44pt touch target")

            Divider()
                .padding(.horizontal)

            // Large
            SizeExample(size: .large, title: "Large", description: "28pt icon, 48pt touch target")

            Divider()
                .padding(.horizontal)

            // Custom
            SizeExample(size: .custom(32), title: "Custom", description: "32pt icon, 52pt touch target")
        }
    }

    // MARK: - Colors Content

    private var colorsContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "Colors",
                subtitle: "Different accent colors for various contexts"
            )
            .padding(.horizontal)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 32) {
                ForEach(ColorVariation.allCases, id: \.self) { variation in
                    ColorExample(
                        variation: variation,
                        isFavorite: binding(for: variation.id)
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Contexts Content

    private var contextsContent: some View {
        VStack(spacing: 40) {
            SectionHeader(
                title: "In Context",
                subtitle: "Favorite buttons in realistic usage scenarios"
            )
            .padding(.horizontal)

            // Card Context
            ContextExample(
                title: "In Card",
                description: "Favorite button on a content card"
            ) {
                ContentCard(isFavorite: binding(for: "card"))
            }

            // List Context
            ContextExample(
                title: "In List",
                description: "Favorite button in list row"
            ) {
                VStack(spacing: 0) {
                    ForEach(1 ... 3, id: \.self) { index in
                        ListRow(
                            title: "Item \(index)",
                            subtitle: "List item with favorite button",
                            isFavorite: binding(for: "list-\(index)")
                        )
                        if index < 3 {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
                #if os(iOS)
                .background(Color(.systemBackground))
                #else
                .background(Color(nsColor: .windowBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Toolbar Context
            ContextExample(
                title: "In Toolbar",
                description: "Favorite button in navigation toolbar"
            ) {
                VStack(spacing: 0) {
                    // Toolbar
                    HStack {
                        Button {} label: {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.semibold))
                        }

                        Spacer()

                        Text("Details")
                            .font(.headline)

                        Spacer()

                        ARCFavoriteButton(
                            isFavorite: binding(for: "toolbar"),
                            size: .medium
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial)

                    // Content
                    VStack(spacing: 16) {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 100, height: 100)

                        Text("Content Title")
                            .font(.title2.bold())

                        Text("Add to favorites using the button above")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                }
                #if os(iOS)
                .background(Color(.systemGroupedBackground))
                #else
                .background(Color(nsColor: .controlBackgroundColor))
                #endif
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Helper Methods

    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { favoriteStates[key] ?? false },
            set: { favoriteStates[key] = $0 }
        )
    }
}

// MARK: - Size Example

@available(iOS 17.0, *)
private struct SizeExample: View {
    @State private var isFavorite = false
    let size: ARCFavoriteButtonConfiguration.ButtonSize
    let title: String
    let description: String

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
                VStack(spacing: 12) {
                    ARCFavoriteButton(
                        isFavorite: $isFavorite,
                        size: size
                    )

                    Text("Not Favorited")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    ARCFavoriteButton(
                        isFavorite: .constant(true),
                        size: size
                    )

                    Text("Favorited")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Color Example

@available(iOS 17.0, *)
private struct ColorExample: View {
    let variation: ColorVariation
    @Binding var isFavorite: Bool

    var body: some View {
        VStack(spacing: 16) {
            ARCFavoriteButton(
                isFavorite: $isFavorite,
                favoriteColor: variation.color,
                size: .large
            )

            Text(variation.name)
                .font(.caption.bold())

            Text(isFavorite ? "Favorited" : "Not Favorited")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        #if os(iOS)
            .background(Color(.secondarySystemGroupedBackground))
        #else
            .background(Color(nsColor: .underPageBackgroundColor))
        #endif
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Content Card

@available(iOS 17.0, *)
private struct ContentCard: View {
    @Binding var isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image with favorite button
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)

                ARCFavoriteButton(
                    isFavorite: $isFavorite,
                    size: .medium
                )
                .padding(12)
            }

            // Card content
            VStack(alignment: .leading, spacing: 8) {
                Text("Content Title")
                    .font(.headline)

                Text("Tap the heart icon to add this to your favorites")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
    }
}

// MARK: - List Row

@available(iOS 17.0, *)
private struct ListRow: View {
    let title: String
    let subtitle: String
    @Binding var isFavorite: Bool

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.blue.gradient)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ARCFavoriteButton(
                isFavorite: $isFavorite,
                size: .medium
            )
        }
        .padding()
    }
}

// MARK: - Context Example

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

// MARK: - Section Header

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

// MARK: - Color Variation

@available(iOS 17.0, *)
private enum ColorVariation: CaseIterable {
    case pink, red, orange, yellow, green, blue

    var id: String {
        name.lowercased()
    }

    var name: String {
        switch self {
        case .pink: "Pink"
        case .red: "Red"
        case .orange: "Orange"
        case .yellow: "Yellow"
        case .green: "Green"
        case .blue: "Blue"
        }
    }

    var color: Color {
        switch self {
        case .pink: .pink
        case .red: .red
        case .orange: .orange
        case .yellow: .yellow
        case .green: .green
        case .blue: .blue
        }
    }
}

// MARK: - Showcase Tab

@available(iOS 17.0, *)
private enum ShowcaseTab: String, CaseIterable {
    case sizes = "Sizes"
    case colors = "Colors"
    case contexts = "Contexts"
}

// MARK: - Preview

#Preview("Showcase - Light") {
    ARCFavoriteButtonShowcase()
        .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    ARCFavoriteButtonShowcase()
        .preferredColorScheme(.dark)
}
