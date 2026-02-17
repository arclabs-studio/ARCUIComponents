//
//  ARCStatCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// A card displaying a single metric with icon, value, and label
///
/// Consolidates the common stat card pattern used across ARC apps:
/// icon at the top, a prominent value in the center, and a descriptive label below.
///
/// ## Overview
///
/// ARCStatCard is the building block for statistics dashboards. It replaces
/// multiple ad-hoc implementations (StatSummaryCard, metricTile, spendingTile)
/// with a single, configurable component.
///
/// ## Usage
///
/// ```swift
/// // Default style
/// ARCStatCard(icon: "fork.knife", value: "15", label: "Restaurants visited")
///
/// // Custom icon color
/// ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
///
/// // Compact style
/// ARCStatCard(icon: "star.fill", value: "9.5", label: "Rating", configuration: .compact)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatCard: View {
    // MARK: - Properties

    private let icon: String
    private let value: String
    private let label: String
    private let iconColor: Color?
    private let configuration: ARCStatCardConfiguration

    // MARK: - Initialization

    /// Creates a stat card
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name for the icon
    ///   - value: The metric value to display prominently
    ///   - label: Descriptive label for the metric
    ///   - iconColor: Override color for the icon (nil uses configuration's iconColor)
    ///   - configuration: Visual configuration (default: .default)
    public init(
        icon: String,
        value: String,
        label: String,
        iconColor: Color? = nil,
        configuration: ARCStatCardConfiguration = .default
    ) {
        self.icon = icon
        self.value = value
        self.label = label
        self.iconColor = iconColor
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: configuration.spacing) {
            Image(systemName: icon)
                .font(configuration.iconFont)
                .foregroundStyle(iconColor ?? configuration.iconColor)

            Text(value)
                .font(configuration.valueFont)
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(label)
                .font(configuration.labelFont)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(configuration.padding)
        .background(.fill.tertiary, in: .rect(cornerRadius: configuration.cornerRadius))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

// MARK: - Preview

#Preview("ARCStatCard") {
    HStack {
        ARCStatCard(icon: "fork.knife", value: "15", label: "Visited")
        ARCStatCard(icon: "heart.fill", value: "6", label: "Favorites", iconColor: .red)
    }
    .padding()
}
