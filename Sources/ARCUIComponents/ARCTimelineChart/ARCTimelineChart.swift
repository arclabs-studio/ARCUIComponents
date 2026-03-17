//
//  ARCTimelineChart.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import Charts
import SwiftUI

/// A timeline chart with line and optional area fill
///
/// Renders temporal data as a smooth line with Catmull-Rom interpolation
/// and an optional gradient fill below the line.
///
/// ## Overview
///
/// ARCTimelineChart uses KeyPath-based API for flexibility.
/// Pass any `Identifiable` array with key paths to date and value fields.
///
/// ## Usage
///
/// ```swift
/// struct MonthlyVisits: Identifiable {
///     let id = UUID()
///     let date: Date
///     let count: Int
/// }
///
/// ARCTimelineChart(
///     data: monthlyVisits,
///     date: \.date,
///     value: \.count
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCTimelineChart<Item: Identifiable>: View {
    // MARK: - Properties

    private let data: [Item]
    private let date: KeyPath<Item, Date>
    private let value: KeyPath<Item, Int>
    private let configuration: ARCTimelineChartConfiguration

    // MARK: - Initialization

    /// Creates a timeline chart
    ///
    /// - Parameters:
    ///   - data: Array of identifiable data items
    ///   - date: KeyPath to the Date value for x-axis
    ///   - value: KeyPath to the numeric value for y-axis
    ///   - configuration: Visual configuration (default: .default)
    public init(data: [Item],
                date: KeyPath<Item, Date>,
                value: KeyPath<Item, Int>,
                configuration: ARCTimelineChartConfiguration = .default) {
        self.data = data
        self.date = date
        self.value = value
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        Chart(data) { item in
            if configuration.fillGradient {
                AreaMark(x: .value("Date", item[keyPath: date]),
                         y: .value("Value", item[keyPath: value]))
                    .foregroundStyle(.linearGradient(colors: [configuration.lineColor.opacity(0.3),
                                                              configuration.lineColor.opacity(0.05)],
                                                     startPoint: .top,
                                                     endPoint: .bottom))
                    .interpolationMethod(.catmullRom)
            }

            LineMark(x: .value("Date", item[keyPath: date]),
                     y: .value("Value", item[keyPath: value]))
                .foregroundStyle(configuration.lineColor)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: configuration.lineWidth))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: configuration.xAxisStride, count: configuration.xAxisStrideCount)) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: configuration.height)
        .padding(.horizontal, configuration.horizontalPadding)
    }
}

// MARK: - Preview

private struct PreviewTimelineItem: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

#Preview("ARCTimelineChart") {
    let items = (0 ..< 12).map { offset in
        PreviewTimelineItem(date: Calendar.current.date(byAdding: .month, value: -11 + offset, to: Date()) ?? Date(),
                            count: [2, 3, 1, 4, 2, 5, 3, 6, 4, 3, 5, 4][offset])
    }
    return ARCTimelineChart(data: items, date: \.date, value: \.count)
        .padding()
}
