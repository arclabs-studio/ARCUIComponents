//
//  ARCCardShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// Showcase view demonstrating ARCCard capabilities
///
/// This view provides comprehensive examples of ARCCard usage patterns,
/// configurations, and customization options for documentation and testing.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCardShowcase: View {

    // MARK: - State

    @State private var favorites: Set<String> = []

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                basicCardsSection
                badgesSection
                gridLayoutSection
                interactiveCardsSection
                configurationsSection
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .navigationTitle("ARCCard")
    }

    // MARK: - Sections

    @ViewBuilder
    private var basicCardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Basic Cards")

            HStack(alignment: .top, spacing: .arcSpacingLarge) {
                ARCCard(
                    title: "Restaurant",
                    subtitle: "Italian Cuisine",
                    subtitleIcon: "fork.knife"
                ) {
                    cardImage(icon: "fork.knife", color: .orange)
                } footer: {
                    ARCRatingView(rating: 4.5)
                }

                ARCCard(
                    title: "Book Title",
                    subtitle: "Author Name",
                    secondarySubtitle: "Fiction",
                    subtitleIcon: "person.fill",
                    secondarySubtitleIcon: "books.vertical.fill"
                ) {
                    cardImage(icon: "book.fill", color: .blue)
                } footer: {
                    ARCRatingView(rating: 4.8, configuration: .heart)
                }
            }
        }
    }

    @ViewBuilder
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Badges")

            HStack(alignment: .top, spacing: .arcSpacingLarge) {
                ARCCard(
                    title: "With Badges",
                    subtitle: "Material style",
                    badges: [
                        .init(text: "$12.99", position: .topTrailing, style: .material),
                        .init(text: "NEW", position: .topLeading, style: .material)
                    ]
                ) {
                    cardImage(icon: "star.fill", color: .yellow)
                }

                ARCCard(
                    title: "Solid Badges",
                    subtitle: "Colored style",
                    badges: [
                        .init(text: "SALE", position: .topLeading, style: .solid(.red)),
                        .init(text: "-20%", position: .bottomTrailing, style: .solid(.green))
                    ]
                ) {
                    cardImage(icon: "tag.fill", color: .green)
                }
            }
        }
    }

    @ViewBuilder
    private var gridLayoutSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Grid Layout")

            LazyVGrid(columns: gridColumns, spacing: .arcSpacingLarge) {
                gridCard(title: "Pizza Place", subtitle: "Italian", icon: "flame.fill", color: .orange)
                gridCard(title: "Sushi Bar", subtitle: "Japanese", icon: "fish.fill", color: .pink)
                gridCard(title: "Burger Joint", subtitle: "American", icon: "leaf.fill", color: .red)
                gridCard(title: "Taco Shop", subtitle: "Mexican", icon: "sun.max.fill", color: .green)
            }
        }
    }

    private var gridColumns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }

    @ViewBuilder
    private func gridCard(title: String, subtitle: String, icon: String, color: Color) -> some View {
        ARCCard(
            title: title,
            subtitle: subtitle,
            subtitleIcon: icon
        ) {
            color.opacity(0.2)
                .frame(height: 100)
                .overlay {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundStyle(color)
                }
        } footer: {
            ARCRatingView(rating: 4.5)
        }
    }

    @ViewBuilder
    private var interactiveCardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Interactive Cards")

            HStack(alignment: .top, spacing: .arcSpacingLarge) {
                Button {
                    print("Card tapped")
                } label: {
                    ARCCard(
                        title: "Tap Me",
                        subtitle: "Press effect"
                    ) {
                        cardImage(icon: "hand.tap.fill", color: .blue)
                    }
                }
                .buttonStyle(ARCCardPressStyle.default)

                Button {
                    print("Prominent tap")
                } label: {
                    ARCCard(
                        title: "Prominent",
                        subtitle: "Strong effect"
                    ) {
                        cardImage(icon: "sparkles", color: .purple)
                    }
                }
                .buttonStyle(ARCCardPressStyle.prominent)
            }
        }
    }

    @ViewBuilder
    private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Configurations")

            VStack(spacing: .arcSpacingLarge) {
                configCard("Default", config: .default, color: .blue)
                configCard("Compact", config: .compact, color: .green)
                configCard("Prominent", config: .prominent, color: .purple)
            }
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func cardImage(icon: String, color: Color) -> some View {
        color.opacity(0.2)
            .frame(height: 100)
            .overlay {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(color)
            }
    }

    @ViewBuilder
    private func configCard(
        _ name: String,
        config: ARCCardConfiguration,
        color: Color
    ) -> some View {
        HStack {
            Text(name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            ARCCard(
                title: "\(name) Config",
                subtitle: "Configuration preset",
                configuration: config
            ) {
                color.opacity(0.2)
                    .frame(height: 60)
                    .overlay {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(color)
                    }
            }
        }
    }
}

// MARK: - Preview

#Preview("ARCCard Showcase") {
    NavigationStack {
        ARCCardShowcase()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCCardShowcase()
    }
    .preferredColorScheme(.dark)
}
