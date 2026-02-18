//
//  ARCStatSectionHeaderDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCStatSectionHeader component.
///
/// Shows section headers with various icons used to organize dashboard sections.
struct ARCStatSectionHeaderDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                usageSection
                examplesSection
                inContextSection
            }
            .padding(.vertical)
        }
        .background(.background)
        .navigationTitle("ARCStatSectionHeader")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCStatSectionHeaderDemoScreen {
    private var usageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Section Headers")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
                .padding(.horizontal)

            Text("Used to label sections in a statistics dashboard.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    private var examplesSection: some View {
        VStack(spacing: 16) {
            ARCStatSectionHeader(title: "Ratings", icon: "star.fill")
            ARCStatSectionHeader(title: "Cuisines", icon: "fork.knife")
            ARCStatSectionHeader(title: "Timeline", icon: "calendar")
            ARCStatSectionHeader(title: "Spending", icon: "creditcard.fill")
            ARCStatSectionHeader(title: "Geography", icon: "map.fill")
            ARCStatSectionHeader(title: "Genres", icon: "books.vertical.fill")
            ARCStatSectionHeader(title: "Authors", icon: "person.2.fill")
        }
    }

    private var inContextSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
                .padding(.horizontal)

            Text("In Context")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
                .padding(.horizontal)

            Text("Headers paired with content below them.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            VStack(spacing: 16) {
                ARCStatSectionHeader(title: "Summary", icon: "chart.bar.fill")
                ARCStatGrid {
                    ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
                    ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
                }

                Divider()
                    .padding(.horizontal)

                ARCStatSectionHeader(title: "Highlights", icon: "star.fill")
                HStack(spacing: 12) {
                    ARCStatHighlightCard(
                        title: "Best rated",
                        headline: "Sushi Zen",
                        rating: 9.5,
                        icon: "arrow.up.circle.fill",
                        accentColor: .green
                    )
                    ARCStatHighlightCard(
                        title: "Lowest rated",
                        headline: "Quick Burger",
                        rating: 5.2,
                        icon: "arrow.down.circle.fill",
                        accentColor: .orange
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCStatSectionHeaderDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCStatSectionHeaderDemoScreen()
    }
    .preferredColorScheme(.dark)
}
