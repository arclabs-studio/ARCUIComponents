//
//  ARCStatHighlightCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/02/2026.
//

import ARCDesignSystem
import SwiftUI

/// A highlight card for displaying best/worst/notable items in a statistics dashboard
///
/// Shows a colored title label, a headline (e.g. restaurant or book name),
/// and an optional subtitle with icon or an ``ARCRatingView`` in minimal style.
///
/// ## Overview
///
/// Use ARCStatHighlightCard to call attention to notable data points like
/// "Best rated", "Most read", or "Most expensive". The accent color and icon
/// visually distinguish the card's purpose.
///
/// ## Usage
///
/// ```swift
/// // With rating (renders ARCRatingView minimal)
/// ARCStatHighlightCard(
///     title: "Best rated",
///     headline: "Sushi Nakazawa",
///     rating: 9.5,
///     icon: "arrow.up.circle.fill",
///     accentColor: .green
/// )
///
/// // With text subtitle
/// ARCStatHighlightCard(
///     title: "Most read",
///     headline: "Brandon Sanderson",
///     subtitle: "12 books",
///     subtitleIcon: "book.fill",
///     icon: "star.circle.fill",
///     accentColor: .purple
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCStatHighlightCard: View {
    // MARK: - Properties

    private let title: String
    private let headline: String
    private let rating: Double?
    private let subtitle: String?
    private let subtitleIcon: String?
    private let icon: String
    private let accentColor: Color
    private let configuration: ARCStatHighlightCardConfiguration

    // MARK: - Initialization

    /// Creates a highlight card with a rating displayed as ``ARCRatingView`` minimal
    ///
    /// - Parameters:
    ///   - title: Category title (e.g. "Best rated", "Most read")
    ///   - headline: The highlighted item name
    ///   - rating: Rating value displayed as ``ARCRatingView`` in minimal style
    ///   - icon: SF Symbol for the title label (e.g. "arrow.up.circle.fill")
    ///   - accentColor: Color for the title and icon
    ///   - configuration: Visual configuration (default: .default)
    public init(
        title: String,
        headline: String,
        rating: Double,
        icon: String,
        accentColor: Color,
        configuration: ARCStatHighlightCardConfiguration = .default
    ) {
        self.title = title
        self.headline = headline
        self.rating = rating
        subtitle = nil
        subtitleIcon = nil
        self.icon = icon
        self.accentColor = accentColor
        self.configuration = configuration
    }

    /// Creates a highlight card with a text subtitle
    ///
    /// - Parameters:
    ///   - title: Category title (e.g. "Best rated", "Most read")
    ///   - headline: The highlighted item name
    ///   - subtitle: Optional value or description (e.g. "1200 pages", "12 books")
    ///   - subtitleIcon: Optional SF Symbol for the subtitle (e.g. "book.fill")
    ///   - icon: SF Symbol for the title label (e.g. "arrow.up.circle.fill")
    ///   - accentColor: Color for the title and icon
    ///   - configuration: Visual configuration (default: .default)
    public init(
        title: String,
        headline: String,
        subtitle: String? = nil,
        subtitleIcon: String? = nil,
        icon: String,
        accentColor: Color,
        configuration: ARCStatHighlightCardConfiguration = .default
    ) {
        self.title = title
        self.headline = headline
        rating = nil
        self.subtitle = subtitle
        self.subtitleIcon = subtitleIcon
        self.icon = icon
        self.accentColor = accentColor
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            Label(title, systemImage: icon)
                .font(configuration.titleFont)
                .foregroundStyle(accentColor)

            Text(headline)
                .font(configuration.headlineFont)
                .lineLimit(1)

            if let rating {
                ARCRatingView(rating: rating, configuration: .minimal)
            } else if let subtitle {
                HStack(spacing: .arcSpacingXSmall) {
                    if let subtitleIcon {
                        Image(systemName: subtitleIcon)
                            .font(configuration.subtitleIconFont)
                            .foregroundStyle(Color.accentColor)
                    }
                    Text(subtitle)
                        .font(configuration.subtitleFont)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(configuration.padding)
        .background(.fill.tertiary, in: .rect(cornerRadius: configuration.cornerRadius))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    // MARK: - Private Helpers

    private var accessibilityText: String {
        if let rating {
            return "\(title): \(headline), \(String(format: "%.1f", rating))"
        }
        return "\(title): \(headline)\(subtitle.map { ", \($0)" } ?? "")"
    }
}

// MARK: - Preview

#Preview("ARCStatHighlightCard - Rating") {
    HStack {
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
    .padding()
}

#Preview("ARCStatHighlightCard - Text Subtitle") {
    HStack {
        ARCStatHighlightCard(
            title: "Most read",
            headline: "Brandon Sanderson",
            subtitle: "12 books",
            subtitleIcon: "book.fill",
            icon: "star.circle.fill",
            accentColor: .purple
        )
        ARCStatHighlightCard(
            title: "Top city",
            headline: "Madrid",
            subtitle: "8 restaurants",
            subtitleIcon: "building.2.fill",
            icon: "mappin.circle.fill",
            accentColor: .blue
        )
    }
    .padding()
}
