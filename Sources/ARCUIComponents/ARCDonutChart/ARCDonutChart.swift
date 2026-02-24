//
//  ARCDonutChart.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import Charts
import SwiftUI

/// A generic donut chart using Swift Charts SectorMark
///
/// Renders data items as a donut chart with configurable colors, legend,
/// and sector limits following Apple HIG (max 7 sectors recommended).
///
/// ## Overview
///
/// ARCDonutChart uses KeyPath-based API for maximum flexibility.
/// Pass any `Identifiable` data array with key paths to the value and label fields.
///
/// ## Usage
///
/// ```swift
/// struct CuisineCount: Identifiable {
///     let id = UUID()
///     let name: String
///     let count: Int
///     let icon: String
/// }
///
/// ARCDonutChart(
///     data: cuisineCounts,
///     value: \.count,
///     label: \.name,
///     icon: \.icon
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCDonutChart<Item: Identifiable>: View {
    // MARK: - Properties

    private let data: [Item]
    private let value: KeyPath<Item, Int>
    private let label: KeyPath<Item, String>
    private let icon: KeyPath<Item, String>?
    private let configuration: ARCDonutChartConfiguration

    // MARK: - Initialization

    /// Creates a donut chart
    ///
    /// - Parameters:
    ///   - data: Array of identifiable data items
    ///   - value: KeyPath to the numeric value for each sector
    ///   - label: KeyPath to the display label for each sector
    ///   - icon: Optional KeyPath to an SF Symbol name per item
    ///   - configuration: Visual configuration (default: .default)
    public init(data: [Item],
                value: KeyPath<Item, Int>,
                label: KeyPath<Item, String>,
                icon: KeyPath<Item, String>? = nil,
                configuration: ARCDonutChartConfiguration = .default)
    {
        self.data = data
        self.value = value
        self.label = label
        self.icon = icon
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: .arcSpacingMedium) {
            Chart(data) { item in
                SectorMark(angle: .value("Value", item[keyPath: value]),
                           innerRadius: .ratio(configuration.innerRadiusRatio),
                           angularInset: configuration.angularInset)
                    .cornerRadius(configuration.cornerRadius)
                    .foregroundStyle(colorForItem(item))
                    .accessibilityLabel("\(item[keyPath: label]): \(item[keyPath: value])")
            }
            .frame(height: configuration.height)
            .padding(.horizontal, configuration.horizontalPadding)

            if configuration.showLegend {
                legendView
            }
        }
    }

    // MARK: - Private Views

    private var legendView: some View {
        VStack(spacing: .arcSpacingSmall) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                HStack(spacing: .arcSpacingSmall) {
                    Circle()
                        .fill(colorForIndex(index))
                        .frame(width: 10, height: 10)

                    if let icon {
                        Image(systemName: item[keyPath: icon])
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                    }

                    Text(item[keyPath: label])
                        .font(.subheadline)

                    Spacer()

                    Text("\(item[keyPath: value])")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(item[keyPath: label]): \(item[keyPath: value])")
            }
        }
        .padding(.horizontal, configuration.horizontalPadding)
    }

    // MARK: - Private Helpers

    private func colorForItem(_ item: Item) -> Color {
        guard let index = data.firstIndex(where: { $0.id == item.id }) else {
            return configuration.colors[0]
        }
        return colorForIndex(index)
    }

    private func colorForIndex(_ index: Int) -> Color {
        configuration.colors[index % configuration.colors.count]
    }
}

// MARK: - Preview

private struct PreviewItem: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let icon: String
}

#Preview("ARCDonutChart") {
    ARCDonutChart(data: [PreviewItem(name: "Japanese", count: 5, icon: "fork.knife"),
                         PreviewItem(name: "Italian", count: 4, icon: "fork.knife"),
                         PreviewItem(name: "Mexican", count: 3, icon: "fork.knife"),
                         PreviewItem(name: "Spanish", count: 2, icon: "fork.knife"),
                         PreviewItem(name: "Chinese", count: 1, icon: "fork.knife")],
                  value: \.count,
                  label: \.name,
                  icon: \.icon)
        .padding()
}
