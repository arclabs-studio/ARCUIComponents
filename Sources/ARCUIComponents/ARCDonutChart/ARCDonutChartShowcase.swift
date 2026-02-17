//
//  ARCDonutChartShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCDonutChart in various configurations
@available(iOS 17.0, macOS 14.0, *)
public struct ARCDonutChartShowcase: View {
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
        .navigationTitle("ARCDonutChart")
    }

    // MARK: - Sections

    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Default (with legend)")

            ARCDonutChart(
                data: ShowcaseData.cuisines,
                value: \.count,
                label: \.name,
                icon: \.icon
            )
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Compact (no legend)")

            ARCDonutChart(
                data: ShowcaseData.genres,
                value: \.count,
                label: \.name,
                configuration: .compact
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
private enum ShowcaseData {
    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let count: Int
        let icon: String

        init(_ name: String, _ count: Int, _ icon: String = "circle.fill") {
            self.name = name
            self.count = count
            self.icon = icon
        }
    }

    static let cuisines: [Item] = [
        Item("Japanese", 5, "fork.knife"),
        Item("Italian", 4, "fork.knife"),
        Item("Mexican", 3, "fork.knife"),
        Item("Spanish", 2, "fork.knife"),
        Item("Chinese", 1, "fork.knife")
    ]

    static let genres: [Item] = [
        Item("Fiction", 12),
        Item("Non-Fiction", 8),
        Item("Science", 5),
        Item("History", 3)
    ]
}

// MARK: - Preview

#Preview("Light") {
    NavigationStack {
        ARCDonutChartShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ARCDonutChartShowcase()
    }
    .preferredColorScheme(.dark)
}
