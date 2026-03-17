//
//  ARCCardShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCCard in various configurations
///
/// This view provides a visual gallery of card variations,
/// demonstrating different configurations, badges, and use cases.
///
/// Use this showcase to:
/// - Preview card configurations and styles
/// - Test badge positioning and styling
/// - See cards with different content combinations
/// - Verify accessibility and Dynamic Type support
/// - View interactive card patterns with ARCCardPressStyle
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCardShowcase: View {
    // MARK: - State

    @State private var favorites: Set<String> = []

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                configurationsSection
                basicCardsSection
                badgesSection
                interactiveCardsSection
            }
            .padding()
        }
        .background(showcaseBackground)
        .navigationTitle("ARCCard")
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

    // MARK: - Sections

    @ViewBuilder
    private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Configurations")
            Text("Unified styling with LiquidGlassConfigurable")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Feature comparison
            VStack(spacing: .arcSpacingMedium) {
                ConfigurationRow(
                    name: "Default",
                    features: ["Material blur", "Medium corners", "Card shadow"],
                    config: .default,
                    icon: "square.grid.2x2",
                    color: .blue
                )

                ConfigurationRow(
                    name: "Prominent",
                    features: ["Liquid Glass ✨", "Large corners", "Prominent shadow"],
                    config: .prominent,
                    icon: "sparkles",
                    color: .purple
                )

                ConfigurationRow(
                    name: "Glassmorphic",
                    features: ["Liquid Glass ✨", "Pink accent", "Default shadow"],
                    config: .glassmorphic,
                    icon: "waveform",
                    color: .pink
                )

                ConfigurationRow(
                    name: "Compact",
                    features: ["Material blur", "Smaller padding", "Card shadow"],
                    config: .compact,
                    icon: "square.compress.vertical",
                    color: .green
                )
            }
        }
    }

    @ViewBuilder
    private var basicCardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Basic Cards")

            HStack(alignment: .top, spacing: .arcSpacingLarge) {
                ARCCard(
                    title: "Restaurant",
                    subtitle: "Italian Cuisine",
                    secondarySubtitle: "Downtown",
                    subtitleIcon: "fork.knife",
                    secondarySubtitleIcon: "location.fill"
                ) {
                    cardImage(icon: "fork.knife", color: .orange)
                } footer: {
                    HStack {
                        Label("12", systemImage: "person.2.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        ARCRatingView(rating: 4.5)
                    }
                }

                ARCCard(
                    title: "Book Title",
                    subtitle: "Author Name",
                    secondarySubtitle: "Fiction",
                    subtitleIcon: "person.fill",
                    secondarySubtitleIcon: "books.vertical.fill",
                    configuration: .prominent
                ) {
                    cardImage(icon: "book.fill", color: .blue)
                } footer: {
                    ARCRatingView(rating: 4.8)
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
                    title: "Material Badges",
                    subtitle: "Blur effect",
                    badges: [
                        .init(text: "$12.99", position: .topTrailing, style: .material),
                        .init(text: "NEW", position: .topLeading, style: .material)
                    ],
                    configuration: .glassmorphic
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
    private var interactiveCardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Interactive (ARCCardPressStyle)")

            HStack(alignment: .top, spacing: .arcSpacingLarge) {
                Button {
                    print("Default tap")
                } label: {
                    ARCCard(
                        title: "Default Press",
                        subtitle: "Scale: 0.96"
                    ) {
                        cardImage(icon: "hand.tap.fill", color: .blue)
                    }
                }
                .buttonStyle(ARCCardPressStyle.default)

                Button {
                    print("Subtle tap")
                } label: {
                    ARCCard(
                        title: "Subtle Press",
                        subtitle: "Scale: 0.98",
                        configuration: .prominent
                    ) {
                        cardImage(icon: "hand.point.up.fill", color: .mint)
                    }
                }
                .buttonStyle(ARCCardPressStyle.subtle)

                Button {
                    print("Prominent tap")
                } label: {
                    ARCCard(
                        title: "Prominent",
                        subtitle: "Scale: 0.92",
                        configuration: .glassmorphic
                    ) {
                        cardImage(icon: "sparkles", color: .purple)
                    }
                }
                .buttonStyle(ARCCardPressStyle.prominent)
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
}

// MARK: - Configuration Row

@available(iOS 17.0, macOS 14.0, *)
private struct ConfigurationRow: View {
    let name: String
    let features: [String]
    let config: ARCCardConfiguration
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: .arcSpacingLarge) {
            // Card preview
            ARCCard(
                title: name,
                subtitle: features.first ?? "",
                subtitleIcon: icon,
                configuration: config
            ) {
                color.opacity(0.15)
                    .frame(height: 60)
                    .overlay {
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundStyle(color)
                    }
            }
            .frame(width: 160)

            // Features list
            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text(name)
                    .font(.subheadline.bold())
                    .foregroundStyle(color)

                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(color.opacity(0.7))
                        Text(feature)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.arcSpacingMedium)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: .arcCornerRadiusMedium))
    }
}

// MARK: - Preview

#Preview("Showcase - Light") {
    NavigationStack {
        ARCCardShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCCardShowcase()
    }
    .preferredColorScheme(.dark)
}
