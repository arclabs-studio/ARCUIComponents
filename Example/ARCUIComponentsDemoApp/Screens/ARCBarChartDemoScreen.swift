//
//  ARCBarChartDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCBarChart component.
///
/// Shows bar charts in vertical, horizontal, and custom color configurations.
struct ARCBarChartDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                verticalSection
                customColorsSection
                horizontalSection
            }
            .padding(.vertical)
        }
        .background(.background)
        .navigationTitle("ARCBarChart")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCBarChartDemoScreen {
    private var verticalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Vertical (Default)")

            Text("Standard vertical bar chart with gradient fill.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCBarChart(
                data: DemoBarData.priceRanges,
                label: \.name,
                value: \.count
            )
        }
    }

    private var customColorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Per-Item Colors")

            Text("Each bar can have its own color via a closure.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCBarChart(
                data: DemoBarData.coloredRanges,
                label: \.name,
                value: \.count,
                color: { $0.color }
            )
        }
    }

    private var horizontalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Horizontal with Annotations")

            Text("Horizontal orientation with trailing value labels.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCBarChart(
                data: DemoBarData.cities,
                label: \.name,
                value: \.count,
                configuration: .horizontal
            )
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

private enum DemoBarData {
    struct BarItem: Identifiable {
        let id = UUID()
        let name: String
        let count: Int
    }

    struct ColoredBarItem: Identifiable {
        let id = UUID()
        let name: String
        let count: Int
        let color: Color
    }

    static let priceRanges: [BarItem] = [
        BarItem(name: "Budget", count: 3),
        BarItem(name: "Moderate", count: 7),
        BarItem(name: "Expensive", count: 4),
        BarItem(name: "Luxury", count: 1)
    ]

    static let coloredRanges: [ColoredBarItem] = [
        ColoredBarItem(name: "Budget", count: 3, color: .green),
        ColoredBarItem(name: "Moderate", count: 7, color: .blue),
        ColoredBarItem(name: "Expensive", count: 4, color: .orange),
        ColoredBarItem(name: "Luxury", count: 1, color: .red)
    ]

    static let cities: [BarItem] = [
        BarItem(name: "Madrid", count: 8),
        BarItem(name: "Barcelona", count: 4),
        BarItem(name: "Valencia", count: 2),
        BarItem(name: "Sevilla", count: 1)
    ]
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCBarChartDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCBarChartDemoScreen()
    }
    .preferredColorScheme(.dark)
}
