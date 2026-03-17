//
//  AIRecommenderItemCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/27/26.
//

import ARCDesignSystem
import SwiftUI

/// Card view for displaying a single AI recommendation item
///
/// Shows item artwork, title, subtitle, optional AI reason, and rating.
/// Designed for use in a vertical list of recommendations.
@available(iOS 17.0, macOS 14.0, *)
struct AIRecommenderItemCard<Item: AIRecommenderItem>: View {
    // MARK: - Properties

    let item: Item
    let rank: Int?
    let configuration: ARCAIRecommenderConfiguration
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: .arcSpacingMedium) {
                // Rank badge (optional)
                if let rank, configuration.showRankBadges {
                    rankBadge(rank: rank)
                }

                // Item artwork
                artworkView

                // Text content
                textContent

                Spacer(minLength: 0)

                // Rating with chevron (optional)
                if configuration.showRating, let rating = item.rating {
                    ratingView(rating: rating)
                }
            }
            .padding(.arcSpacingMedium)
            .background(
                RoundedRectangle(cornerRadius: configuration.itemCornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(ARCCardPressStyle.subtle)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Private Views

    @ViewBuilder
    private func rankBadge(rank: Int) -> some View {
        Text("\(rank)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(width: 24, height: 24)
            .background(
                Circle()
                    .fill(configuration.accentColor.gradient)
            )
    }

    @ViewBuilder private var artworkView: some View {
        if let imageSource = item.imageSource {
            imageSource.imageView(size: 60)
        } else {
            // Default placeholder with accent color
            AIRecommenderImageSource
                .placeholder(colors: [
                    configuration.accentColor.opacity(0.2),
                    configuration.accentColor.opacity(0.1)
                ])
                .imageView(size: 60)
        }
    }

    @ViewBuilder private var textContent: some View {
        VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
            Text(item.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)

            if let subtitle = item.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if configuration.showAIReason, let reason = item.aiReason {
                Text(reason)
                    .font(.caption)
                    .foregroundStyle(configuration.accentColor)
                    .lineLimit(1)
            }
        }
    }

    @ViewBuilder
    private func ratingView(rating: Double) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .foregroundStyle(configuration.ratingColor)
                Text(String(format: "%.1f", rating))
                    .fontWeight(.semibold)
            }
            .font(.subheadline)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var components: [String] = [item.title]

        if let rank, configuration.showRankBadges {
            components.insert("Rank \(rank)", at: 0)
        }

        if let subtitle = item.subtitle {
            components.append(subtitle)
        }

        if let rating = item.rating, configuration.showRating {
            components.append("Rating \(String(format: "%.1f", rating))")
        }

        if let reason = item.aiReason, configuration.showAIReason {
            components.append(reason)
        }

        return components.joined(separator: ", ")
    }
}

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
private struct MockItem: AIRecommenderItem {
    let id: UUID
    let title: String
    let subtitle: String?
    let rating: Double?
    let imageSource: AIRecommenderImageSource?
    let aiReason: String?
}

#if os(iOS)
#Preview("Item Card - Full") {
    AIRecommenderItemCard(
        item: MockItem(
            id: UUID(),
            title: "La Tagliatella",
            subtitle: "Italiano · €€",
            rating: 8.5,
            imageSource: .system("fork.knife", color: .orange),
            aiReason: "Te encanta la cocina italiana"
        ),
        rank: 1,
        configuration: .default,
        action: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Item Card - Minimal") {
    AIRecommenderItemCard(
        item: MockItem(
            id: UUID(),
            title: "El Rincón",
            subtitle: "Español · €€€",
            rating: 9.2,
            imageSource: .system("flame.fill", color: .red),
            aiReason: nil
        ),
        rank: nil,
        configuration: .minimal,
        action: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Item Card - Dark Mode") {
    AIRecommenderItemCard(
        item: MockItem(
            id: UUID(),
            title: "La Tagliatella",
            subtitle: "Italiano · €€",
            rating: 8.5,
            imageSource: .system("fork.knife", color: .orange),
            aiReason: "Te encanta la cocina italiana"
        ),
        rank: 1,
        configuration: .default,
        action: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
#endif
