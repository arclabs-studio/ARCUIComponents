//
//  ARCStatCardShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCStatCard in various configurations
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatCardShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                defaultSection
                compactSection
                prominentSection
                customColorsSection
            }
            .padding()
        }
        .background(.background)
        .navigationTitle("ARCStatCard")
    }

    // MARK: - Sections

    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Default")

            ARCStatGrid {
                ARCStatCard(icon: "fork.knife", value: "15", label: "Restaurants visited")
                ARCStatCard(icon: "magnifyingglass", value: "5", label: "To discover")
                ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
                ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
            }
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Compact")

            ARCStatGrid(columns: 3) {
                ARCStatCard(icon: "star.fill", value: "7.8", label: "Avg", configuration: .compact)
                ARCStatCard(
                    icon: "flame.fill",
                    value: "4",
                    label: "Streak",
                    iconColor: .orange,
                    configuration: .compact
                )
                ARCStatCard(icon: "trophy.fill", value: "9.5", label: "Best", configuration: .compact)
            }
        }
    }

    private var prominentSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Prominent")

            HStack(spacing: .arcSpacingMedium) {
                ARCStatCard(icon: "book.fill", value: "128", label: "Books read", configuration: .prominent)
                ARCStatCard(
                    icon: "clock.fill",
                    value: "340h",
                    label: "Reading time",
                    iconColor: .purple,
                    configuration: .prominent
                )
            }
            .padding(.horizontal, .arcSpacingLarge)
        }
    }

    private var customColorsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Custom Colors")

            ARCStatGrid {
                ARCStatCard(icon: "dollarsign.circle.fill", value: "$1,250", label: "Total spent", iconColor: .green)
                ARCStatCard(icon: "chart.line.downtrend.xyaxis", value: "$29", label: "Avg per visit", iconColor: .blue)
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
        ARCStatCardShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ARCStatCardShowcase()
    }
    .preferredColorScheme(.dark)
}
