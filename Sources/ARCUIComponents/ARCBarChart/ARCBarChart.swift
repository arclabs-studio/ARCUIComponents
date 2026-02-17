//
//  ARCBarChart.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import Charts
import SwiftUI

/// A bar chart supporting both vertical and horizontal orientations
///
/// Renders data items as bar marks with configurable colors, annotations,
/// and gradient fills. Supports per-item coloring via a closure.
///
/// ## Overview
///
/// ARCBarChart uses KeyPath-based API for label and value, plus an optional
/// closure for per-item colors. Use `.default` for vertical charts and
/// `.horizontal` for horizontal charts with trailing annotations.
///
/// ## Usage
///
/// ```swift
/// // Vertical bar chart
/// ARCBarChart(
///     data: priceRanges,
///     label: \.name,
///     value: \.count
/// )
///
/// // Horizontal with custom colors
/// ARCBarChart(
///     data: cities,
///     label: \.city,
///     value: \.count,
///     configuration: .horizontal
/// )
///
/// // Per-item coloring
/// ARCBarChart(
///     data: priceRanges,
///     label: \.name,
///     value: \.count,
///     color: { item in item.color }
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBarChart<Item: Identifiable>: View {
    // MARK: - Properties

    private let data: [Item]
    private let label: KeyPath<Item, String>
    private let value: KeyPath<Item, Int>
    private let color: ((Item) -> Color)?
    private let configuration: ARCBarChartConfiguration

    // MARK: - Initialization

    /// Creates a bar chart
    ///
    /// - Parameters:
    ///   - data: Array of identifiable data items
    ///   - label: KeyPath to the label string for each bar
    ///   - value: KeyPath to the numeric value for each bar
    ///   - color: Optional closure returning a color per item (nil uses default color)
    ///   - configuration: Visual configuration (default: .default)
    public init(
        data: [Item],
        label: KeyPath<Item, String>,
        value: KeyPath<Item, Int>,
        color: ((Item) -> Color)? = nil,
        configuration: ARCBarChartConfiguration = .default
    ) {
        self.data = data
        self.label = label
        self.value = value
        self.color = color
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        chart
            .frame(height: chartHeight)
            .padding(.horizontal, configuration.horizontalPadding)
    }

    // MARK: - Private Views

    @ViewBuilder private var chart: some View {
        switch configuration.orientation {
        case .vertical:
            verticalChart
        case .horizontal:
            horizontalChart
        }
    }

    private var verticalChart: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Label", item[keyPath: label]),
                y: .value("Value", item[keyPath: value])
            )
            .foregroundStyle(barColor(for: item))
            .cornerRadius(configuration.cornerRadius)
            .accessibilityLabel("\(item[keyPath: label]): \(item[keyPath: value])")
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }

    private var horizontalChart: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Value", item[keyPath: value]),
                y: .value("Label", item[keyPath: label])
            )
            .foregroundStyle(barColor(for: item))
            .cornerRadius(configuration.cornerRadius)
            .annotation(position: .trailing) {
                if configuration.showAnnotations {
                    Text("\(item[keyPath: value])")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityLabel("\(item[keyPath: label]): \(item[keyPath: value])")
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
            }
        }
    }

    // MARK: - Private Helpers

    private var chartHeight: CGFloat {
        if let height = configuration.height {
            return height
        }
        return CGFloat(data.count) * configuration.heightPerBar
    }

    private func barColor(for item: Item) -> some ShapeStyle {
        let itemColor = color?(item) ?? configuration.defaultColor
        return configuration.useGradient ? AnyShapeStyle(itemColor.gradient) : AnyShapeStyle(itemColor)
    }
}

// MARK: - Preview

private struct PreviewBarItem: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
}

#Preview("ARCBarChart - Vertical") {
    ARCBarChart(
        data: [
            PreviewBarItem(name: "Budget", count: 3),
            PreviewBarItem(name: "Moderate", count: 7),
            PreviewBarItem(name: "Expensive", count: 4),
            PreviewBarItem(name: "Luxury", count: 1)
        ],
        label: \.name,
        value: \.count
    )
    .padding()
}

#Preview("ARCBarChart - Horizontal") {
    ARCBarChart(
        data: [
            PreviewBarItem(name: "Madrid", count: 8),
            PreviewBarItem(name: "Barcelona", count: 4),
            PreviewBarItem(name: "Valencia", count: 2),
            PreviewBarItem(name: "Sevilla", count: 1)
        ],
        label: \.name,
        value: \.count,
        configuration: .horizontal
    )
    .padding()
}
