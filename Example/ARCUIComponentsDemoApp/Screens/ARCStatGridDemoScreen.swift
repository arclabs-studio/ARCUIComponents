//
//  ARCStatGridDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCStatGrid component.
///
/// Shows grid layouts with 2-column and 3-column configurations.
struct ARCStatGridDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                twoColumnSection
                threeColumnSection
            }
            .padding(.vertical)
        }
        .background(.background)
        .navigationTitle("ARCStatGrid")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCStatGridDemoScreen {
    private var twoColumnSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("2 Columns (Default)")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
                .padding(.horizontal)

            ARCStatGrid {
                ARCStatCard(icon: "fork.knife", value: "15", label: "Restaurants")
                ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
                ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
                ARCStatCard(rating: 7.8, label: "Average rating")
            }
        }
    }

    private var threeColumnSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("3 Columns")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
                .padding(.horizontal)

            Text("Use compact stat cards for denser layouts.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCStatGrid(columns: 3) {
                ARCStatCard(icon: "star.fill", value: "23", label: "Reviews", configuration: .compact)
                ARCStatCard(icon: "flame.fill", value: "5", label: "Streak", configuration: .compact)
                ARCStatCard(icon: "trophy.fill", value: "3", label: "Awards", configuration: .compact)
            }
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCStatGridDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCStatGridDemoScreen()
    }
    .preferredColorScheme(.dark)
}
