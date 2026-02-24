//
//  ARCTimelineChartShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCTimelineChart in various configurations
@available(iOS 17.0, macOS 14.0, *) public struct ARCTimelineChartShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                defaultSection
                compactSection
            }
            .padding()
        }
        .background(.background)
        .navigationTitle("ARCTimelineChart")
    }

    // MARK: - Sections

    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Default (with gradient)")

            ARCTimelineChart(data: ShowcaseTimelineData.monthlyVisits,
                             date: \.date,
                             value: \.count)
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Compact (no gradient)")

            ARCTimelineChart(data: ShowcaseTimelineData.monthlyVisits,
                             date: \.date,
                             value: \.count,
                             configuration: .compact)
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

@available(iOS 17.0, macOS 14.0, *) private enum ShowcaseTimelineData {
    struct TimelineItem: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }

    static let monthlyVisits: [TimelineItem] = (0 ..< 12).map { offset in
        TimelineItem(date: Calendar.current.date(byAdding: .month, value: -11 + offset, to: Date()) ?? Date(),
                     count: [2, 3, 1, 4, 2, 5, 3, 6, 4, 3, 5, 4][offset])
    }
}

// MARK: - Preview

#Preview("Light") {
    NavigationStack {
        ARCTimelineChartShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ARCTimelineChartShowcase()
    }
    .preferredColorScheme(.dark)
}
