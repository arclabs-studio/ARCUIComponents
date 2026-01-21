//
//  ARCRatingViewShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// Showcase view demonstrating ARCRatingView capabilities
///
/// This view provides comprehensive examples of ARCRatingView usage patterns,
/// configurations, and customization options for documentation and testing.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingViewShowcase: View {
    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                basicRatingsSection
                configurationsSection
                customIconsSection
                inContextSection
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .navigationTitle("ARCRatingView")
    }

    // MARK: - Sections

    @ViewBuilder
    private var basicRatingsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Basic Ratings")

            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                ratingRow("5.0", rating: 5.0)
                ratingRow("4.5", rating: 4.5)
                ratingRow("3.8", rating: 3.8)
                ratingRow("2.5", rating: 2.5)
                ratingRow("1.0", rating: 1.0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                    .fill(.ultraThinMaterial)
            )
        }
    }

    @ViewBuilder
    private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Configurations")

            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                configRow("Default", config: .default)
                configRow("Compact", config: .compact)
                configRow("Large", config: .large)
                configRow("Heart", config: .heart)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                    .fill(.ultraThinMaterial)
            )
        }
    }

    @ViewBuilder
    private var customIconsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Custom Icons")

            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                customIconRow("Star", icon: "star.fill", color: .yellow)
                customIconRow("Heart", icon: "heart.fill", color: .pink)
                customIconRow("Flame", icon: "flame.fill", color: .orange)
                customIconRow("Thumbs Up", icon: "hand.thumbsup.fill", color: .blue)
                customIconRow("Crown", icon: "crown.fill", color: .purple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                    .fill(.ultraThinMaterial)
            )
        }
    }

    @ViewBuilder
    private var inContextSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("In Context")

            VStack(spacing: .arcSpacingMedium) {
                contextCard(
                    title: "Italian Restaurant",
                    subtitle: "Fine Dining",
                    rating: 4.8,
                    icon: "fork.knife",
                    color: .orange
                )

                contextCard(
                    title: "Mystery Novel",
                    subtitle: "John Author",
                    rating: 4.5,
                    icon: "book.fill",
                    color: .blue,
                    ratingConfig: .heart
                )

                contextCard(
                    title: "Podcast Episode",
                    subtitle: "Tech Weekly",
                    rating: 4.2,
                    icon: "mic.fill",
                    color: .purple
                )
            }
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func ratingRow(_ label: String, rating: Double) -> some View {
        HStack {
            Text(label)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)

            Spacer()

            ARCRatingView(rating: rating)
        }
    }

    @ViewBuilder
    private func configRow(_ name: String, config: ARCRatingViewConfiguration) -> some View {
        HStack {
            Text(name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            Spacer()

            ARCRatingView(rating: 4.5, configuration: config)
        }
    }

    @ViewBuilder
    private func customIconRow(_ name: String, icon: String, color: Color) -> some View {
        HStack {
            Text(name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .leading)

            Spacer()

            ARCRatingView(
                rating: 4.5,
                icon: icon,
                iconColor: color
            )
        }
    }

    @ViewBuilder
    private func contextCard(
        title: String,
        subtitle: String,
        rating: Double,
        icon: String,
        color: Color,
        ratingConfig: ARCRatingViewConfiguration = .default
    ) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color.gradient)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))

            // Content
            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Rating
            ARCRatingView(rating: rating, configuration: ratingConfig)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Preview

#Preview("Showcase - Light") {
    NavigationStack {
        ARCRatingViewShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCRatingViewShowcase()
    }
    .preferredColorScheme(.dark)
}
