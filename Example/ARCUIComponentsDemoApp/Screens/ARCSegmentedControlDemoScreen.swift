//
//  ARCSegmentedControlDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCSegmentedControl component.
///
/// Shows interactive examples of segmented controls with different styles,
/// content types, and practical use cases.
@available(iOS 17.0, *)
struct ARCSegmentedControlDemoScreen: View {
    // MARK: - State

    @State private var selectedFilter: ContentFilter = .all
    @State private var selectedViewMode: ViewMode = .grid
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedTab: SocialTab = .posts
    @State private var selectedStyle: StyleOption = .modern

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                basicUsageSection
                viewModeSwitcherSection
                filterBarSection
                tabStyleSection
                realWorldSection
            }
            .padding()
        }
        .navigationTitle("ARCSegmentedControl")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Filter Enum

@available(iOS 17.0, *)
private enum ContentFilter: String, CaseIterable, Sendable {
    case all = "All"
    case favorites = "Favorites"
    case recent = "Recent"
}

// MARK: - ViewMode Enum

@available(iOS 17.0, *)
private enum ViewMode: Int, CaseIterable, Sendable {
    case list
    case grid
    case gallery
}

// MARK: - TimeRange Enum

@available(iOS 17.0, *)
private enum TimeRange: String, CaseIterable, Sendable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

// MARK: - SocialTab Enum

@available(iOS 17.0, *)
private enum SocialTab: String, CaseIterable, Sendable {
    case posts = "Posts"
    case replies = "Replies"
    case media = "Media"
    case likes = "Likes"
}

// MARK: - StyleOption Enum

@available(iOS 17.0, *)
private enum StyleOption: String, CaseIterable, Sendable {
    case classic = "Classic"
    case modern = "Modern"
    case minimal = "Minimal"
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCSegmentedControlDemoScreen {
    // MARK: - Basic Usage Section

    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Basic Usage", subtitle: "Simple segmented control with CaseIterable enum")

            VStack(spacing: 16) {
                usageRow("With Enum", description: "Automatic segments from CaseIterable") {
                    ARCSegmentedControl(selection: $selectedFilter)
                }

                usageRow("Current Selection", description: "Value binding in action") {
                    VStack(spacing: 8) {
                        ARCSegmentedControl(selection: $selectedFilter)

                        Text("Selected: \(selectedFilter.rawValue)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }

    private func usageRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - View Mode Switcher Section

    private var viewModeSwitcherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("View Mode Switcher", subtitle: "Icon-only segments for compact controls")

            VStack(alignment: .leading, spacing: 12) {
                Text("Switch view layout:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    ARCSegmentedControl(
                        selection: $selectedViewMode,
                        segments: [
                            .icon("list.bullet", value: .list, accessibilityLabel: "List view"),
                            .icon("square.grid.2x2", value: .grid, accessibilityLabel: "Grid view"),
                            .icon("rectangle.grid.1x2", value: .gallery, accessibilityLabel: "Gallery view")
                        ],
                        configuration: .pill
                    )

                    Spacer()

                    Text(viewModeLabel)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                viewModePreview
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private var viewModeLabel: String {
        switch selectedViewMode {
        case .list: "List View"
        case .grid: "Grid View"
        case .gallery: "Gallery View"
        }
    }

    @ViewBuilder private var viewModePreview: some View {
        Group {
            switch selectedViewMode {
            case .list:
                VStack(spacing: 8) {
                    ForEach(0 ..< 3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 44)
                    }
                }
            case .grid:
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(0 ..< 4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 80)
                    }
                }
            case .gallery:
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                    HStack(spacing: 8) {
                        ForEach(0 ..< 2, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 60)
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selectedViewMode)
    }

    // MARK: - Filter Bar Section

    private var filterBarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Filter Bar", subtitle: "Date range selection with outlined style")

            VStack(alignment: .leading, spacing: 12) {
                Text("Select time range:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ARCSegmentedControl(
                    selection: $selectedTimeRange,
                    segments: [
                        .text("Day", value: .day),
                        .text("Week", value: .week),
                        .text("Month", value: .month),
                        .text("Year", value: .year)
                    ],
                    configuration: .outlined
                )

                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    Text("Showing data for: \(selectedTimeRange.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Tab Style Section

    private var tabStyleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Tab Style", subtitle: "Underlined style for profile-like navigation")

            VStack(spacing: 0) {
                ARCSegmentedControl(
                    selection: $selectedTab,
                    segments: [
                        .text("Posts", value: .posts),
                        .text("Replies", value: .replies),
                        .text("Media", value: .media),
                        .text("Likes", value: .likes)
                    ],
                    configuration: .underlined
                )

                Divider()

                tabContentPreview
                    .frame(height: 150)
            }
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder private var tabContentPreview: some View {
        VStack {
            Spacer()
            Text("\(selectedTab.rawValue) content")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Content would appear here")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.15), value: selectedTab)
    }

    // MARK: - Real World Section

    private var realWorldSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Real World Example", subtitle: "Glass style with gradient background")

            ZStack {
                LinearGradient(
                    colors: [.purple, .blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 20) {
                    Text("Choose Your Style")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    ARCSegmentedControl(
                        selection: $selectedStyle,
                        segments: [
                            .textAndIcon("Classic", icon: "crown", value: .classic),
                            .textAndIcon("Modern", icon: "sparkles", value: .modern),
                            .textAndIcon("Minimal", icon: "leaf", value: .minimal)
                        ],
                        configuration: .glass
                    )

                    Text("Selected: \(selectedStyle.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(24)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCSegmentedControlDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCSegmentedControlDemoScreen()
    }
    .preferredColorScheme(.dark)
}
