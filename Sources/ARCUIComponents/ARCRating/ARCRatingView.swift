//
//  ARCRatingView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// A view that displays a numeric rating with an icon
///
/// `ARCRatingView` provides a compact way to display ratings, matching the patterns
/// found in App Store, Maps, and other Apple apps that display user ratings.
///
/// ## Overview
///
/// ARCRatingView displays:
/// - A customizable icon (default: star)
/// - Optional numeric value
/// - Configurable colors and fonts
/// - Full accessibility support with VoiceOver
///
/// ## Topics
///
/// ### Creating Rating Views
///
/// - ``init(rating:maxRating:icon:iconColor:showNumericValue:font:)``
/// - ``init(rating:configuration:)``
///
/// ## Usage
///
/// ```swift
/// // Simple rating display
/// ARCRatingView(rating: 4.5)
///
/// // Custom icon and color
/// ARCRatingView(
///     rating: 4.2,
///     icon: "heart.fill",
///     iconColor: .pink
/// )
///
/// // Icon only (no numeric value)
/// ARCRatingView(
///     rating: 5.0,
///     showNumericValue: false
/// )
/// ```
///
/// - Note: The view automatically formats ratings to one decimal place and
///   provides meaningful accessibility labels.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingView: View {
    // MARK: - Properties

    /// The rating value to display
    private let rating: Double

    /// Configuration for appearance
    private let configuration: ARCRatingViewConfiguration

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .subheadline)
    private var iconSpacing: CGFloat = .arcSpacingXSmall

    // MARK: - Initialization

    /// Creates a rating view with a configuration
    ///
    /// - Parameters:
    ///   - rating: The rating value to display
    ///   - configuration: Visual configuration
    public init(
        rating: Double,
        configuration: ARCRatingViewConfiguration = .default
    ) {
        self.rating = rating
        self.configuration = configuration
    }

    /// Creates a rating view with common parameters
    ///
    /// - Parameters:
    ///   - rating: The rating value to display
    ///   - maxRating: Maximum rating value for accessibility (default: 5.0)
    ///   - icon: SF Symbol name for the icon (default: "star.fill")
    ///   - iconColor: Color for the icon (default: .yellow)
    ///   - showNumericValue: Whether to show the numeric value (default: true)
    ///   - font: Font for the numeric value (default: .subheadline)
    public init(
        rating: Double,
        maxRating: Double = 5.0,
        icon: String = "star.fill",
        iconColor: Color = .yellow,
        showNumericValue: Bool = true,
        font: Font = .subheadline
    ) {
        self.rating = rating
        configuration = ARCRatingViewConfiguration(
            maxRating: maxRating,
            icon: icon,
            iconColor: iconColor,
            showNumericValue: showNumericValue,
            font: font
        )
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: iconSpacing) {
            Image(systemName: configuration.icon)
                .foregroundStyle(configuration.iconColor.gradient)
                .font(configuration.font)

            if configuration.showNumericValue {
                Text(formattedRating)
                    .font(configuration.font.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Computed Properties

    private var formattedRating: String {
        String(format: "%.1f", min(rating, configuration.maxRating))
    }

    private var accessibilityLabel: String {
        let clampedRating = min(rating, configuration.maxRating)
        return String(
            format: "Rating: %.1f out of %.0f",
            clampedRating,
            configuration.maxRating
        )
    }
}

// MARK: - Configuration

/// Configuration for ARCRatingView appearance
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingViewConfiguration: Sendable {
    // MARK: - Properties

    /// Maximum rating value (used for accessibility)
    public let maxRating: Double

    /// SF Symbol name for the icon
    public let icon: String

    /// Color for the icon
    public let iconColor: Color

    /// Whether to show the numeric value
    public let showNumericValue: Bool

    /// Font for the numeric value
    public let font: Font

    // MARK: - Initialization

    /// Creates a rating view configuration
    ///
    /// - Parameters:
    ///   - maxRating: Maximum rating value
    ///   - icon: SF Symbol name
    ///   - iconColor: Icon color
    ///   - showNumericValue: Whether to show numeric value
    ///   - font: Font for text
    public init(
        maxRating: Double = 5.0,
        icon: String = "star.fill",
        iconColor: Color = .yellow,
        showNumericValue: Bool = true,
        font: Font = .subheadline
    ) {
        self.maxRating = maxRating
        self.icon = icon
        self.iconColor = iconColor
        self.showNumericValue = showNumericValue
        self.font = font
    }

    // MARK: - Presets

    /// Default configuration with yellow star
    public static let `default` = ARCRatingViewConfiguration()

    /// Compact configuration without numeric value
    public static let compact = ARCRatingViewConfiguration(
        showNumericValue: false
    )

    /// Large configuration with headline font
    public static let large = ARCRatingViewConfiguration(
        font: .headline
    )

    /// Heart style for favorites/likes
    public static let heart = ARCRatingViewConfiguration(
        icon: "heart.fill",
        iconColor: .pink
    )
}

// MARK: - Preview

#Preview("Default") {
    VStack(spacing: .arcSpacingLarge) {
        ARCRatingView(rating: 4.5)
        ARCRatingView(rating: 3.8)
        ARCRatingView(rating: 5.0)
    }
    .padding()
}

#Preview("Configurations") {
    VStack(alignment: .leading, spacing: .arcSpacingXLarge) {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Default")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCRatingView(rating: 4.5, configuration: .default)
        }

        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Compact (icon only)")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCRatingView(rating: 4.5, configuration: .compact)
        }

        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Large")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCRatingView(rating: 4.5, configuration: .large)
        }

        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Heart Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCRatingView(rating: 4.5, configuration: .heart)
        }
    }
    .padding()
}

#Preview("Custom Icons") {
    VStack(spacing: .arcSpacingLarge) {
        ARCRatingView(
            rating: 4.2,
            icon: "star.fill",
            iconColor: .yellow
        )

        ARCRatingView(
            rating: 4.8,
            icon: "heart.fill",
            iconColor: .pink
        )

        ARCRatingView(
            rating: 3.5,
            icon: "flame.fill",
            iconColor: .orange
        )

        ARCRatingView(
            rating: 4.0,
            icon: "hand.thumbsup.fill",
            iconColor: .blue
        )
    }
    .padding()
}

#Preview("In Context") {
    VStack(alignment: .leading, spacing: .arcSpacingMedium) {
        HStack {
            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text("Restaurant Name")
                    .font(.headline)
                Text("Italian Cuisine")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ARCRatingView(rating: 4.7)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                .fill(.ultraThinMaterial)
        )
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: .arcSpacingLarge) {
        ARCRatingView(rating: 4.5)
        ARCRatingView(rating: 4.5, configuration: .heart)
    }
    .padding()
    .preferredColorScheme(.dark)
}
