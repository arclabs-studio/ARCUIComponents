//
//  ARCBarChartShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCBarChart in various configurations
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBarChartShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                verticalSection
                verticalWithColorsSection
                horizontalSection
            }
            .padding()
        }
        .background(.background)
        .navigationTitle("ARCBarChart")
    }

    // MARK: - Sections

    private var verticalSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Vertical (default)")

            ARCBarChart(
                data: ShowcaseBarData.priceRanges,
                label: \.name,
                value: \.count
            )
        }
    }

    private var verticalWithColorsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Vertical (per-item colors)")

            ARCBarChart(
                data: ShowcaseBarData.coloredRanges,
                label: \.name,
                value: \.count,
                color: { $0.color }
            )
        }
    }

    private var horizontalSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Horizontal (with annotations)")

            ARCBarChart(
                data: ShowcaseBarData.cities,
                label: \.name,
                value: \.count,
                configuration: .horizontal
            )
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Showcase Data

@available(iOS 17.0, macOS 14.0, *)
private enum ShowcaseBarData {
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

// MARK: - Preview

#Preview("Light") {
    NavigationStack {
        ARCBarChartShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ARCBarChartShowcase()
    }
    .preferredColorScheme(.dark)
}
