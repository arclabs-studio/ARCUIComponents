//
//  ARCStatHighlightCardDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCStatHighlightCard component.
///
/// Shows highlight cards for best/worst items with various accent colors and configurations.
struct ARCStatHighlightCardDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                restaurantSection
                bookSection
                textSubtitleSection
                compactSection
            }
            .padding()
        }
        .background(.background)
        .navigationTitle("ARCStatHighlightCard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCStatHighlightCardDemoScreen {
    private var restaurantSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("With Rating")

            Text("Uses ARCRatingView minimal to display the score.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ARCStatHighlightCard(title: "Best rated",
                                     headline: "Sushi Nakazawa",
                                     rating: 9.5,
                                     icon: "arrow.up.circle.fill",
                                     accentColor: .green)

                ARCStatHighlightCard(title: "Lowest rated",
                                     headline: "Quick Burger",
                                     rating: 5.2,
                                     icon: "arrow.down.circle.fill",
                                     accentColor: .orange)
            }
        }
    }

    private var bookSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Book Highlights")

            HStack(spacing: 12) {
                ARCStatHighlightCard(title: "Highest rated",
                                     headline: "Dune",
                                     rating: 4.9,
                                     icon: "crown.fill",
                                     accentColor: .yellow)

                ARCStatHighlightCard(title: "Most read author",
                                     headline: "Brandon Sanderson",
                                     subtitle: "12 books",
                                     subtitleIcon: "book.fill",
                                     icon: "star.circle.fill",
                                     accentColor: .purple)
            }
        }
    }

    private var textSubtitleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Text Subtitle")

            Text("For non-rating data, use subtitle + subtitleIcon instead.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ARCStatHighlightCard(title: "Most visited",
                                     headline: "Cafe Central",
                                     subtitle: "12 visits",
                                     subtitleIcon: "arrow.counterclockwise",
                                     icon: "flame.fill",
                                     accentColor: .orange)

                ARCStatHighlightCard(title: "Most expensive",
                                     headline: "Le Petit Chef",
                                     subtitle: "$85 avg",
                                     subtitleIcon: "dollarsign.circle.fill",
                                     icon: "creditcard.fill",
                                     accentColor: .green)
            }
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Compact Style")

            Text("Smaller fonts for use in tight spaces.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ARCStatHighlightCard(title: "Top city",
                                     headline: "Madrid",
                                     subtitle: "8 restaurants",
                                     subtitleIcon: "building.2.fill",
                                     icon: "mappin.circle.fill",
                                     accentColor: .blue,
                                     configuration: .compact)

                ARCStatHighlightCard(title: "Longest streak",
                                     headline: "14 days",
                                     subtitle: "Reading",
                                     subtitleIcon: "clock.fill",
                                     icon: "flame.fill",
                                     accentColor: .red,
                                     configuration: .compact)
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(Color.arcBrandBurgundy)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCStatHighlightCardDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCStatHighlightCardDemoScreen()
    }
    .preferredColorScheme(.dark)
}
