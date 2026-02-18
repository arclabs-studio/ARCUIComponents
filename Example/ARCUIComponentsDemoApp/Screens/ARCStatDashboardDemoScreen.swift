//
//  ARCStatDashboardDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/02/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCStatDashboard component.
///
/// Shows a full statistics dashboard combining all stat components: grid, highlight cards,
/// section headers, donut chart, timeline chart, and bar chart.
struct ARCStatDashboardDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ARCStatDashboard {
            summarySection
            highlightsSection
            distributionSection
            timelineSection
            geographySection
        }
        .navigationTitle("ARCStatDashboard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

extension ARCStatDashboardDemoScreen {
    private var summarySection: some View {
        ARCStatGrid {
            ARCStatCard(icon: "fork.knife", value: "15", label: "Restaurants")
            ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
            ARCStatCard(icon: "calendar", value: "42", label: "Total visits")
            ARCStatCard(rating: 7.8, label: "Avg rating")
        }
    }

    private var highlightsSection: some View {
        ARCStatDashboardSection {
            ARCStatSectionHeader(title: "Highlights", icon: "star.fill")

            HStack(spacing: 12) {
                ARCStatHighlightCard(
                    title: "Best rated",
                    headline: "Sushi Nakazawa",
                    rating: 9.5,
                    icon: "arrow.up.circle.fill",
                    accentColor: .green
                )
                ARCStatHighlightCard(
                    title: "Most visited",
                    headline: "Cafe Central",
                    subtitle: "12 visits",
                    subtitleIcon: "arrow.counterclockwise",
                    icon: "flame.fill",
                    accentColor: .orange
                )
            }
            .padding(.horizontal)
        }
    }

    private var distributionSection: some View {
        ARCStatDashboardSection {
            ARCStatSectionHeader(title: "Cuisines", icon: "fork.knife")

            ARCDonutChart(
                data: DemoDashboardData.cuisines,
                value: \.count,
                label: \.name,
                icon: \.icon
            )
        }
    }

    private var timelineSection: some View {
        ARCStatDashboardSection {
            ARCStatSectionHeader(title: "Monthly Visits", icon: "calendar")

            ARCTimelineChart(
                data: DemoDashboardData.monthlyVisits,
                date: \.date,
                value: \.count
            )
        }
    }

    private var geographySection: some View {
        ARCStatDashboardSection {
            ARCStatSectionHeader(title: "Cities", icon: "map.fill")

            ARCBarChart(
                data: DemoDashboardData.cities,
                label: \.name,
                value: \.count,
                configuration: .horizontal
            )
        }
    }
}

// MARK: - Demo Data

private enum DemoDashboardData {
    struct CuisineItem: Identifiable {
        let id = UUID()
        let name: String
        let count: Int
        let icon: String
    }

    struct TimelineItem: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }

    struct CityItem: Identifiable {
        let id = UUID()
        let name: String
        let count: Int
    }

    static let cuisines: [CuisineItem] = [
        CuisineItem(name: "Japanese", count: 5, icon: "fork.knife"),
        CuisineItem(name: "Italian", count: 4, icon: "fork.knife"),
        CuisineItem(name: "Mexican", count: 3, icon: "fork.knife"),
        CuisineItem(name: "Spanish", count: 2, icon: "fork.knife"),
        CuisineItem(name: "Chinese", count: 1, icon: "fork.knife")
    ]

    static let monthlyVisits: [TimelineItem] = (0 ..< 12).map { offset in
        TimelineItem(
            date: Calendar.current.date(byAdding: .month, value: -11 + offset, to: Date()) ?? Date(),
            count: [2, 3, 1, 4, 2, 5, 3, 6, 4, 3, 5, 4][offset]
        )
    }

    static let cities: [CityItem] = [
        CityItem(name: "Madrid", count: 8),
        CityItem(name: "Barcelona", count: 4),
        CityItem(name: "Valencia", count: 2),
        CityItem(name: "Sevilla", count: 1)
    ]
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCStatDashboardDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCStatDashboardDemoScreen()
    }
    .preferredColorScheme(.dark)
}
