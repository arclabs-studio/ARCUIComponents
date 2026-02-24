//
//  ARCStatGridShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCStatGrid layout variations
@available(iOS 17.0, macOS 14.0, *) public struct ARCStatGridShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                twoColumnSection
                threeColumnSection
            }
            .padding(.vertical)
        }
        .background(.background)
        .navigationTitle("ARCStatGrid")
    }

    // MARK: - Sections

    private var twoColumnSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            Text("2 Columns (default)")
                .font(.title2.bold())
                .padding(.horizontal, .arcSpacingLarge)

            ARCStatGrid {
                ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
                ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
                ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
                ARCStatCard(rating: 7.8, label: "Average rating")
            }
        }
    }

    private var threeColumnSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            Text("3 Columns")
                .font(.title2.bold())
                .padding(.horizontal, .arcSpacingLarge)

            ARCStatGrid(columns: 3) {
                ARCStatCard(rating: 7.8, label: "Avg", configuration: .compact)
                ARCStatCard(icon: "flame.fill",
                            value: "4",
                            label: "Streak",
                            iconColor: .orange,
                            configuration: .compact)
                ARCStatCard(rating: 9.5, label: "Best", configuration: .compact)
            }
        }
    }
}

// MARK: - Preview

#Preview("ARCStatGrid") {
    NavigationStack {
        ARCStatGridShowcase()
    }
}
