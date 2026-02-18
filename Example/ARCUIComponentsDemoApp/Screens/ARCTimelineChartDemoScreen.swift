//
//  ARCTimelineChartDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCTimelineChart component.
///
/// Shows timeline charts with gradient fill and without gradient fill.
struct ARCTimelineChartDemoScreen: View {
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
        .navigationTitle("ARCTimelineChart")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCTimelineChartDemoScreen {
    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Default (With Gradient)")

            Text("Smooth Catmull-Rom interpolated line with gradient area fill.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCTimelineChart(
                data: DemoTimelineData.monthlyVisits,
                date: \.date,
                value: \.count
            )
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Compact (No Gradient)")

            Text("Line-only version without the area fill below the curve.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            ARCTimelineChart(
                data: DemoTimelineData.monthlyVisits,
                date: \.date,
                value: \.count,
                configuration: .compact
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

private enum DemoTimelineData {
    struct TimelineItem: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }

    static let monthlyVisits: [TimelineItem] = (0 ..< 12).map { offset in
        TimelineItem(
            date: Calendar.current.date(byAdding: .month, value: -11 + offset, to: Date()) ?? Date(),
            count: [2, 3, 1, 4, 2, 5, 3, 6, 4, 3, 5, 4][offset]
        )
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCTimelineChartDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCTimelineChartDemoScreen()
    }
    .preferredColorScheme(.dark)
}
