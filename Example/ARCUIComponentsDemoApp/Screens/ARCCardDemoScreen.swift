//
//  ARCCardDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCCard component.
///
/// Shows cards with various configurations, badges, and interactive examples.
struct ARCCardDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                basicCardsSection
                badgesSection
                footerSection
                interactiveSection
                configurationsSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .navigationTitle("ARCCard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

private extension ARCCardDemoScreen {
    var backgroundGradient: some View {
        LinearGradient(
            colors: [.blue.opacity(0.1), .purple.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var basicCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Cards")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            HStack(spacing: 16) {
                ARCCard(
                    title: "Simple Card",
                    subtitle: "With subtitle"
                ) {
                    Color.arcBrandBurgundy.opacity(0.2)
                        .frame(height: 100)
                        .overlay {
                            Image(systemName: "square.stack")
                                .font(.title)
                                .foregroundStyle(Color.arcBrandBurgundy)
                        }
                }

                ARCCard(
                    title: "With Icons",
                    subtitle: "Category",
                    secondarySubtitle: "Location",
                    subtitleIcon: "tag.fill",
                    secondarySubtitleIcon: "location.fill"
                ) {
                    Color.arcBrandGold.opacity(0.2)
                        .frame(height: 100)
                        .overlay {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color.arcBrandGold)
                        }
                }
            }
        }
    }

    var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("With Badges")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            HStack(spacing: 16) {
                ARCCard(
                    title: "Material Badge",
                    subtitle: "Blur effect",
                    badges: [
                        .init(text: "$9.99", position: .topTrailing, style: .material)
                    ]
                ) {
                    Color.blue.opacity(0.2)
                        .frame(height: 100)
                        .overlay {
                            Image(systemName: "tag.fill")
                                .font(.title)
                                .foregroundStyle(.blue)
                        }
                }

                ARCCard(
                    title: "Solid Badge",
                    subtitle: "Color background",
                    badges: [
                        .init(text: "NEW", position: .topLeading, style: .solid(.arcBrandBurgundy))
                    ]
                ) {
                    Color.green.opacity(0.2)
                        .frame(height: 100)
                        .overlay {
                            Image(systemName: "sparkles")
                                .font(.title)
                                .foregroundStyle(.green)
                        }
                }
            }

            ARCCard(
                title: "Multiple Badges",
                subtitle: "Different positions",
                badges: [
                    .init(text: "SALE", position: .topLeading, style: .solid(.red)),
                    .init(text: "$19.99", position: .topTrailing, style: .material),
                    .init(text: "Limited", position: .bottomTrailing, style: .solid(.arcBrandGold))
                ]
            ) {
                Color.purple.opacity(0.2)
                    .frame(height: 120)
                    .overlay {
                        Image(systemName: "gift.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.purple)
                    }
            }
        }
    }

    var footerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("With Footer")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            HStack(spacing: 16) {
                ARCCard(
                    title: "Restaurant",
                    subtitle: "Italian Cuisine",
                    subtitleIcon: "fork.knife"
                ) {
                    Color.orange.opacity(0.2)
                        .frame(height: 100)
                        .overlay {
                            Image(systemName: "fork.knife")
                                .font(.title)
                                .foregroundStyle(.orange)
                        }
                } footer: {
                    ARCRatingView(rating: 4.5)
                }

                ARCCard(
                    title: "Book Title",
                    subtitle: "Author Name",
                    subtitleIcon: "person.fill"
                ) {
                    Color.pink.opacity(0.2)
                        .frame(height: 100)
                        .overlay {
                            Image(systemName: "book.fill")
                                .font(.title)
                                .foregroundStyle(.pink)
                        }
                } footer: {
                    ARCRatingView(rating: 4.8, configuration: .compact)
                }
            }
        }
    }

    var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interactive Cards")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            Text("Press and hold to see the effect")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Button {
                    // Action
                } label: {
                    ARCCard(
                        title: "Subtle Press",
                        subtitle: "Light feedback"
                    ) {
                        Color.cyan.opacity(0.2)
                            .frame(height: 80)
                            .overlay {
                                Image(systemName: "hand.tap.fill")
                                    .font(.title2)
                                    .foregroundStyle(.cyan)
                            }
                    }
                }
                .buttonStyle(ARCCardPressStyle.subtle)

                Button {
                    // Action
                } label: {
                    ARCCard(
                        title: "Prominent Press",
                        subtitle: "Strong feedback"
                    ) {
                        Color.indigo.opacity(0.2)
                            .frame(height: 80)
                            .overlay {
                                Image(systemName: "hand.tap.fill")
                                    .font(.title2)
                                    .foregroundStyle(.indigo)
                            }
                    }
                }
                .buttonStyle(ARCCardPressStyle.prominent)
            }
        }
    }

    var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configurations")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        ARCCard(
                            title: "Default",
                            configuration: .default
                        ) {
                            Color.gray.opacity(0.2).frame(height: 60)
                        }
                        Text("Default")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCCard(
                            title: "Compact",
                            configuration: .compact
                        ) {
                            Color.gray.opacity(0.2).frame(height: 60)
                        }
                        Text("Compact")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        ARCCard(
                            title: "Prominent",
                            configuration: .prominent
                        ) {
                            Color.gray.opacity(0.2).frame(height: 60)
                        }
                        Text("Prominent")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCCard(
                            title: "Glassmorphic",
                            configuration: .glassmorphic
                        ) {
                            Color.gray.opacity(0.2).frame(height: 60)
                        }
                        Text("Glassmorphic")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCCardDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCCardDemoScreen()
    }
    .preferredColorScheme(.dark)
}
