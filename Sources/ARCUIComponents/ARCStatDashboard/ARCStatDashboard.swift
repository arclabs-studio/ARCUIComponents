//
//  ARCStatDashboard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// A scrollable container for statistics dashboard sections
///
/// Wraps content in a ScrollView with a LazyVStack, applying consistent spacing
/// and optional dividers between sections. Use this as the top-level container
/// for any statistics dashboard.
///
/// ## Usage
///
/// ```swift
/// ARCStatDashboard {
///     ARCStatGrid {
///         ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
///         ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites")
///     }
///
///     ratingsSection
///
///     cuisineSection
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatDashboard<Content: View>: View {
    // MARK: - Properties

    private let configuration: ARCStatDashboardConfiguration
    private let content: Content

    // MARK: - Initialization

    /// Creates a statistics dashboard container
    ///
    /// - Parameters:
    ///   - configuration: Layout configuration (default: .default)
    ///   - content: Dashboard sections
    public init(
        configuration: ARCStatDashboardConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: configuration.sectionSpacing) {
                content
            }
            .padding(.top, configuration.topPadding)
        }
        .background(.background)
    }
}

/// A section wrapper that adds an optional divider before the section content
///
/// Use inside ``ARCStatDashboard`` when you need automatic dividers between sections.
///
/// ## Usage
///
/// ```swift
/// ARCStatDashboard {
///     summaryGrid // first section, no divider
///
///     ARCStatDashboardSection {
///         ratingsContent
///     }
///
///     ARCStatDashboardSection {
///         timelineContent
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatDashboardSection<Content: View>: View {
    private let dividerPadding: CGFloat
    private let content: Content

    /// Creates a dashboard section with a leading divider
    ///
    /// - Parameters:
    ///   - dividerPadding: Horizontal padding for the divider (default: arcSpacingLarge)
    ///   - content: Section content
    public init(
        dividerPadding: CGFloat = .arcSpacingLarge,
        @ViewBuilder content: () -> Content
    ) {
        self.dividerPadding = dividerPadding
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: .arcSpacingLarge) {
            Divider()
                .padding(.horizontal, dividerPadding)

            content
        }
    }
}

// MARK: - Preview

#Preview("ARCStatDashboard") {
    ARCStatDashboard {
        ARCStatGrid {
            ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
            ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
        }

        ARCStatDashboardSection {
            ARCStatSectionHeader(title: "Highlights", icon: "star.fill")
            HStack(spacing: .arcSpacingMedium) {
                ARCStatHighlightCard(
                    title: "Best",
                    headline: "Sushi Zen",
                    subtitle: "9.5",
                    subtitleIcon: "star.fill",
                    icon: "arrow.up.circle.fill",
                    accentColor: .green
                )
                ARCStatHighlightCard(
                    title: "Lowest",
                    headline: "Quick Burger",
                    subtitle: "5.2",
                    subtitleIcon: "star.fill",
                    icon: "arrow.down.circle.fill",
                    accentColor: .orange
                )
            }
            .padding(.horizontal, .arcSpacingLarge)
        }
    }
}
