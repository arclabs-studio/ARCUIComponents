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
///
/// // Rating style with ARCRatingView
/// ARCStatCard(rating: 7.8, label: "Average rating")
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCStatCard: View {
    // MARK: - Properties

    private let icon: String?
    private let value: String?
    private let rating: Double?
    private let label: String
    private let iconColor: Color?
    private let configuration: ARCStatCardConfiguration

    // MARK: - Initialization

    /// Creates a stat card with icon and value
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name for the icon
    ///   - value: The metric value to display prominently
    ///   - label: Descriptive label for the metric
    ///   - iconColor: Override color for the icon (nil uses configuration's iconColor)
    ///   - configuration: Visual configuration (default: .default)
    public init(icon: String,
                value: String,
                label: String,
                iconColor: Color? = nil,
                configuration: ARCStatCardConfiguration = .default)
    {
        self.icon = icon
        self.value = value
        rating = nil
        self.label = label
        self.iconColor = iconColor
        self.configuration = configuration
    }

    /// Creates a stat card displaying a rating via ARCRatingView
    ///
    /// Uses `ARCRatingView` to render the rating value. The rating style is determined
    /// by the configuration: `.default`/`.prominent` use `.circularGauge`,
    /// `.compact` uses `.compactInline`.
    ///
    /// - Parameters:
    ///   - rating: The rating value to display (1-10 scale)
    ///   - label: Descriptive label for the rating
    ///   - configuration: Visual configuration (default: .default)
    public init(rating: Double,
                label: String,
                configuration: ARCStatCardConfiguration = .default)
    {
        icon = nil
        value = nil
        self.rating = rating
        self.label = label
        iconColor = nil
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: configuration.spacing) {
            if let rating {
                ARCRatingView(rating: rating, style: configuration.ratingStyle)

                Text(label)
                    .font(configuration.labelFont)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            } else if let icon, let value {
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
        }
        .frame(maxWidth: .infinity)
        .padding(configuration.padding)
        .background(.fill.tertiary, in: .rect(cornerRadius: configuration.cornerRadius))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Private

    private var accessibilityLabel: String {
        if let rating {
            return "\(label): \(String(format: "%.1f", rating))"
        }
        return "\(label): \(value ?? "")"
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

#Preview("ARCStatCard - Rating") {
    HStack {
        ARCStatCard(rating: 7.8, label: "Average rating")
        ARCStatCard(rating: 9.5, label: "Best rating")
    }
    .padding()
}

#Preview("ARCStatCard - Rating Compact") {
    HStack {
        ARCStatCard(rating: 7.8, label: "Avg", configuration: .compact)
        ARCStatCard(rating: 9.5, label: "Best", configuration: .compact)
    }
    .padding()
}
