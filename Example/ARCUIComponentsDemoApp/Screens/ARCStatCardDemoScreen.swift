//
//  ARCStatCardDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCStatCard component.
///
/// Shows stat cards in various configurations: default, compact, prominent, and custom colors
/// with interactive icon customization.
struct ARCStatCardDemoScreen: View {
    // MARK: - Properties

    @State private var useStar = true

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                defaultSection
                iconCustomizationSection
                compactSection
                prominentSection
                customColorsSection
            }
            .padding()
        }
        .background(.background)
        .navigationTitle("ARCStatCard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCStatCardDemoScreen {
    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Default Style")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ARCStatCard(icon: "fork.knife", value: "15", label: "Restaurants")
                ARCStatCard(icon: useStar ? "star.fill" : "heart.fill",
                            value: "6",
                            label: "Favorites",
                            iconColor: useStar ? .yellow : .red)
                ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
                ARCStatCard(rating: 7.8, label: "Avg rating")
            }
        }
    }

    private var iconCustomizationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Icon Customization")

            Text("Toggle between star and heart for the Favorites card above.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Favorites Icon", selection: $useStar) {
                Label("Star", systemImage: "star.fill").tag(true)
                Label("Heart", systemImage: "heart.fill").tag(false)
            }
            .pickerStyle(.segmented)
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Compact Style")

            Text("Smaller fonts and less padding for dense layouts.")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                      spacing: 12) {
                ARCStatCard(icon: "star.fill", value: "23", label: "Reviews", configuration: .compact)
                ARCStatCard(icon: "flame.fill", value: "5", label: "Streak", configuration: .compact)
                ARCStatCard(icon: "trophy.fill", value: "3", label: "Awards", configuration: .compact)
            }
        }
    }

    private var prominentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Prominent Style")

            Text("Larger icon and value for hero metrics.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ARCStatCard(icon: "book.fill",
                            value: "128",
                            label: "Books read",
                            configuration: .prominent)
                ARCStatCard(icon: "clock.fill",
                            value: "340h",
                            label: "Reading time",
                            configuration: .prominent)
            }
        }
    }

    private var customColorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Custom Icon Colors")

            Text("Override the default icon color per card.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ARCStatCard(icon: "dollarsign.circle.fill",
                            value: "$2.4k",
                            label: "Spent this month",
                            iconColor: .green)
                ARCStatCard(icon: "chart.line.uptrend.xyaxis",
                            value: "+12%",
                            label: "Growth",
                            iconColor: .blue)
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
        ARCStatCardDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCStatCardDemoScreen()
    }
    .preferredColorScheme(.dark)
}
