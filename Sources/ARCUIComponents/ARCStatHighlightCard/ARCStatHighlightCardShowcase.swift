//
//  ARCStatHighlightCardShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCStatHighlightCard in various configurations
@available(iOS 17.0, macOS 14.0, *) public struct ARCStatHighlightCardShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                restaurantSection
                bookSection
                compactSection
            }
            .padding()
        }
        .background(.background)
        .navigationTitle("ARCStatHighlightCard")
    }

    // MARK: - Sections

    private var restaurantSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Restaurant Examples")

            HStack(spacing: .arcSpacingMedium) {
                ARCStatHighlightCard(title: "Best rated",
                                     headline: "Sushi Zen",
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
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Book Examples")

            HStack(spacing: .arcSpacingMedium) {
                ARCStatHighlightCard(title: "Highest rated",
                                     headline: "Don Quixote",
                                     subtitle: "1200 pages",
                                     subtitleIcon: "book.fill",
                                     icon: "crown.fill",
                                     accentColor: .purple)
                ARCStatHighlightCard(title: "Most read author",
                                     headline: "Gabriel Garcia Marquez",
                                     subtitle: "8 books",
                                     subtitleIcon: "person.fill",
                                     icon: "star.circle.fill",
                                     accentColor: .blue)
            }
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Compact")

            HStack(spacing: .arcSpacingSmall) {
                ARCStatHighlightCard(title: "Top",
                                     headline: "Madrid",
                                     icon: "building.2.fill",
                                     accentColor: .accentColor,
                                     configuration: .compact)
                ARCStatHighlightCard(title: "Recent",
                                     headline: "Barcelona",
                                     icon: "clock.fill",
                                     accentColor: .secondary,
                                     configuration: .compact)
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview("Light") {
    NavigationStack {
        ARCStatHighlightCardShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ARCStatHighlightCardShowcase()
    }
    .preferredColorScheme(.dark)
}
