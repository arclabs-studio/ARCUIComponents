//
//  ARCStatDashboardShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCStatDashboard as a complete dashboard layout
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatDashboardShowcase: View {
    public init() {}

    public var body: some View {
        ARCStatDashboard {
            // Section 1: Summary Grid
            ARCStatGrid {
                ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
                ARCStatCard(icon: "magnifyingglass", value: "5", label: "To discover")
                ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
                ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
            }

            // Section 2: Highlights
            ARCStatDashboardSection {
                ARCStatSectionHeader(title: "Highlights", icon: "star.fill")

                HStack(spacing: .arcSpacingMedium) {
                    ARCStatHighlightCard(
                        title: "Best rated",
                        headline: "Sushi Zen",
                        rating: 9.5,
                        icon: "arrow.up.circle.fill",
                        accentColor: .green
                    )
                    ARCStatHighlightCard(
                        title: "Lowest rated",
                        headline: "Quick Burger",
                        rating: 5.2,
                        icon: "arrow.down.circle.fill",
                        accentColor: .orange
                    )
                }
                .padding(.horizontal, .arcSpacingLarge)

                ARCStatGrid {
                    ARCStatCard(rating: 7.8, label: "Average")
                    ARCStatCard(icon: "star.circle.fill", value: "4", label: "Excellent")
                }
            }

            // Section 3: Distribution
            ARCStatDashboardSection {
                ARCStatSectionHeader(title: "Distribution", icon: "chart.pie.fill")

                ARCDonutChart(
                    data: ShowcaseDashboardData.cuisines,
                    value: \.count,
                    label: \.name,
                    icon: \.icon
                )
            }

            // Section 4: Timeline
            ARCStatDashboardSection {
                ARCStatSectionHeader(title: "Timeline", icon: "calendar")

                ARCTimelineChart(
                    data: ShowcaseDashboardData.monthlyVisits,
                    date: \.date,
                    value: \.count
                )
            }

            // Section 5: Bar Chart
            ARCStatDashboardSection {
                ARCStatSectionHeader(title: "Geography", icon: "map.fill")

                ARCBarChart(
                    data: ShowcaseDashboardData.cities,
                    label: \.name,
                    value: \.count,
                    configuration: .horizontal
                )
            }

            Spacer(minLength: .arcSpacingXLarge)
        }
        .navigationTitle("Dashboard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Showcase Data

@available(iOS 17.0, macOS 14.0, *)
private enum ShowcaseDashboardData {
    struct ChartItem: Identifiable {
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

    struct TimelineItem: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }

    static let cuisines: [ChartItem] = [
        ChartItem("Japanese", 5, "fork.knife"),
        ChartItem("Italian", 4, "fork.knife"),
        ChartItem("Mexican", 3, "fork.knife"),
        ChartItem("Spanish", 2, "fork.knife"),
        ChartItem("Chinese", 1, "fork.knife")
    ]

    static let cities: [ChartItem] = [
        ChartItem("Madrid", 8),
        ChartItem("Barcelona", 4),
        ChartItem("Valencia", 2),
        ChartItem("Sevilla", 1)
    ]

    static let monthlyVisits: [TimelineItem] = (0 ..< 12).map { offset in
        TimelineItem(
            date: Calendar.current.date(byAdding: .month, value: -11 + offset, to: Date()) ?? Date(),
            count: [2, 3, 1, 4, 2, 5, 3, 6, 4, 3, 5, 4][offset]
        )
    }
}

// MARK: - Preview

#Preview("Dashboard - Light") {
    NavigationStack {
        ARCStatDashboardShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dashboard - Dark") {
    NavigationStack {
        ARCStatDashboardShowcase()
    }
    .preferredColorScheme(.dark)
}
