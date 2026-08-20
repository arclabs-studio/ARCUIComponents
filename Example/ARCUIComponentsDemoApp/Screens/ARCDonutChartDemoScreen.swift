//
//  ARCDonutChartDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCDonutChart component.
///
/// Shows donut charts with legend, without legend, and with different data sets.
struct ARCDonutChartDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                defaultSection
                compactSection
            }
            .padding(.vertical)
        }
        .background(.background)
        .navigationTitle("ARCDonutChart")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCDonutChartDemoScreen {
    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("With Legend & Icons")

            Text("Shows category distribution with an icon legend below.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCDonutChart(data: DemoDonutData.cuisines,
                          value: \.count,
                          label: \.name,
                          icon: \.icon)
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Compact (No Legend)")

            Text("Minimal donut chart without the legend below.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCDonutChart(data: DemoDonutData.genres,
                          value: \.count,
                          label: \.name,
                          icon: \.icon,
                          configuration: .compact)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(Color.arcBrandBurgundy)
            .padding(.horizontal)
    }
}

// MARK: - Demo Data

private enum DemoDonutData {
    struct DonutItem: Identifiable {
        let id = UUID()
        let name: String
        let count: Int
        let icon: String
    }

    static let cuisines: [DonutItem] = [DonutItem(name: "Japanese", count: 5, icon: "fork.knife"),
                                        DonutItem(name: "Italian", count: 4, icon: "fork.knife"),
                                        DonutItem(name: "Mexican", count: 3, icon: "fork.knife"),
                                        DonutItem(name: "Spanish", count: 2, icon: "fork.knife"),
                                        DonutItem(name: "Chinese", count: 1, icon: "fork.knife")]

    static let genres: [DonutItem] = [DonutItem(name: "Sci-Fi", count: 8, icon: "sparkles"),
                                      DonutItem(name: "Fantasy", count: 6, icon: "wand.and.stars"),
                                      DonutItem(name: "Mystery", count: 4, icon: "magnifyingglass"),
                                      DonutItem(name: "Non-Fiction", count: 3, icon: "book.fill")]
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCDonutChartDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCDonutChartDemoScreen()
    }
    .preferredColorScheme(.dark)
}
