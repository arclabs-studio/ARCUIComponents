//
//  AIRecommenderSwipeCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/17/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - AIRecommenderSwipeCard

/// Rich card view for displaying a recommendation item in the card stack
///
/// Shows a hero image, title with rating, subtitle tags, highlight detail,
/// AI reason quote block, location, and a prominent bookmark button.
@available(iOS 17.0, macOS 14.0, *) struct AIRecommenderSwipeCard<Item: AIRecommenderItem>: View {
    // MARK: - Properties

    let item: Item
    let isBookmarked: Bool
    let configuration: ARCAIRecommenderConfiguration
    let onTap: () -> Void
    let onBookmarkToggle: () -> Void

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .title2) private var titleSize: CGFloat = 22
    @ScaledMetric(relativeTo: .body) private var bookmarkHeight: CGFloat = 48
    @ScaledMetric(relativeTo: .body) private var quoteBarWidth: CGFloat = 3
    @ScaledMetric(relativeTo: .body) private var heroHeight: CGFloat = 180

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                heroImageSection

                VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                    titleRow

                    if configuration.showTags {
                        tagsRow
                    }

                    if configuration.showLocation {
                        locationRow
                    }

                    if configuration.showHighlightDetail {
                        highlightRow
                    }

                    aiReasonSection

                    Spacer(minLength: .arcSpacingSmall)

                    bookmarkButton
                }
                .padding(.horizontal, .arcSpacingMedium)
                .padding(.top, .arcSpacingMedium)
                .padding(.bottom, .arcSpacingMedium)
            }
            .background(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial))
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .stroke(Color.secondary.opacity(0.15), lineWidth: 0.5))
        }
        .buttonStyle(ARCCardPressStyle.subtle)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAction(named: isBookmarked ? "Quitar guardado" : "Guardar") {
            onBookmarkToggle()
        }
    }

    // MARK: - Hero Image

    @ViewBuilder private var heroImageSection: some View {
        if let imageSource = item.imageSource {
            imageSource.heroImageView(height: heroHeight)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: configuration.cornerRadius,
                                                  bottomLeadingRadius: 0,
                                                  bottomTrailingRadius: 0,
                                                  topTrailingRadius: configuration.cornerRadius,
                                                  style: .continuous))
        } else {
            AIRecommenderImageSource
                .placeholder(colors: [configuration.accentColor.opacity(0.3),
                                      configuration.accentColor.opacity(0.1)])
                .heroImageView(height: heroHeight)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: configuration.cornerRadius,
                                                  bottomLeadingRadius: 0,
                                                  bottomTrailingRadius: 0,
                                                  topTrailingRadius: configuration.cornerRadius,
                                                  style: .continuous))
        }
    }

    // MARK: - Title

    private var titleRow: some View {
        Text(item.title)
            .font(.system(size: titleSize, weight: .bold))
            .lineLimit(2)
    }

    // MARK: - Tags

    @ViewBuilder private var tagsRow: some View {
        if let subtitle = item.subtitle {
            let tags = subtitle.components(separatedBy: " · ")
            if !tags.isEmpty {
                HStack(spacing: .arcSpacingXSmall) {
                    ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                        ARCChip(tag,
                                isSelected: .constant(index == 0),
                                configuration: ARCChipConfiguration(size: .small,
                                                                    selectedColor: configuration.accentColor,
                                                                    unselectedColor: .secondary,
                                                                    showCheckmark: false,
                                                                    hapticFeedback: false))
                            .allowsHitTesting(false)
                    }
                }
            }
        }
    }

    // MARK: - Highlight Detail

    @ViewBuilder private var highlightRow: some View {
        if let highlight = item.highlightDetail {
            HStack(spacing: .arcSpacingXSmall) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(configuration.accentColor)
                Text(highlight)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
        }
    }

    // MARK: - AI Reason

    @ViewBuilder private var aiReasonSection: some View {
        if configuration.showAIReason, let reason = item.aiReason {
            HStack(spacing: .arcSpacingSmall) {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(configuration.accentColor)
                    .frame(width: quoteBarWidth)

                Text("\"\(reason)\"")
                    .font(.callout)
                    .italic()
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, .arcSpacingXSmall)
        }
    }

    // MARK: - Location

    @ViewBuilder private var locationRow: some View {
        if let location = item.location {
            HStack(spacing: .arcSpacingXSmall) {
                Image(systemName: "location.fill")
                    .font(.caption2)
                Text(location)
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Bookmark Button

    private var bookmarkButton: some View {
        Button {
            onBookmarkToggle()
        } label: {
            HStack(spacing: .arcSpacingSmall) {
                Image(systemName: isBookmarked ? configuration.bookmarkActiveIcon : configuration.bookmarkIcon)
                    .contentTransition(.symbolEffect(.replace))
                Text(isBookmarked ? "Guardado" : "Guardar restaurante")
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .frame(minHeight: bookmarkHeight)
            .foregroundStyle(isBookmarked ? .white : configuration.accentColor)
            .background(Capsule()
                .fill(isBookmarked ? configuration.accentColor : configuration.accentColor.opacity(0.15)))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isBookmarked ? "Quitar de guardados" : "Guardar restaurante")
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var components: [String] = [item.title]

        if configuration.showTags, let subtitle = item.subtitle {
            components.append(subtitle)
        }

        if configuration.showLocation, let location = item.location {
            components.append(location)
        }

        if configuration.showHighlightDetail, let highlight = item.highlightDetail {
            components.append(highlight)
        }

        if configuration.showAIReason, let reason = item.aiReason {
            components.append(reason)
        }

        components.append(isBookmarked ? "Guardado" : "No guardado")

        return components.joined(separator: ", ")
    }
}

// MARK: - Previews

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *) private struct PreviewItem: AIRecommenderItem {
    let id: UUID
    let title: String
    var subtitle: String?
    var rating: Double?
    var imageSource: AIRecommenderImageSource?
    var aiReason: String?
    var location: String?
    var highlightDetail: String?
}

@available(iOS 17.0, *)
#Preview("Swipe Card - Full") {
    AIRecommenderSwipeCard(item: PreviewItem(id: UUID(),
                                             title: "La Tagliatella",
                                             subtitle: "Italiano · €€",
                                             rating: 8.5,
                                             imageSource: .system("fork.knife", color: .orange),
                                             aiReason: "Te encanta la cocina italiana y este lugar"
                                                 + " tiene los mejores platos caseros",
                                             location: "Centro, Madrid · 0.5 km",
                                             highlightDetail: "Pasta Carbonara"),
                           isBookmarked: false,
                           configuration: .default,
                           onTap: {},
                           onBookmarkToggle: {})
        .padding()
        .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, *)
#Preview("Swipe Card - Bookmarked") {
    AIRecommenderSwipeCard(item: PreviewItem(id: UUID(),
                                             title: "Sushi Master",
                                             subtitle: "Japonés · €€€",
                                             rating: 9.2,
                                             imageSource: .system("fish.fill", color: .cyan),
                                             aiReason: "Similar a tus restaurantes favoritos",
                                             location: "Salamanca, Madrid · 1.2 km",
                                             highlightDetail: "Omakase Menú"),
                           isBookmarked: true,
                           configuration: .default,
                           onTap: {},
                           onBookmarkToggle: {})
        .padding()
        .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, *)
#Preview("Swipe Card - Minimal") {
    AIRecommenderSwipeCard(item: PreviewItem(id: UUID(),
                                             title: "El Rincón",
                                             subtitle: "Español · €",
                                             rating: 7.8,
                                             imageSource: .system("flame.fill", color: .red),
                                             aiReason: nil,
                                             location: nil,
                                             highlightDetail: nil),
                           isBookmarked: false,
                           configuration: .default,
                           onTap: {},
                           onBookmarkToggle: {})
        .padding()
        .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, *)
#Preview("Swipe Card - Dark") {
    AIRecommenderSwipeCard(item: PreviewItem(id: UUID(),
                                             title: "La Tagliatella",
                                             subtitle: "Italiano · €€",
                                             rating: 8.5,
                                             imageSource: .system("fork.knife", color: .orange),
                                             aiReason: "Te encanta la cocina italiana",
                                             location: "Centro, Madrid · 0.5 km",
                                             highlightDetail: "Pasta Carbonara"),
                           isBookmarked: false,
                           configuration: .default,
                           onTap: {},
                           onBookmarkToggle: {})
        .padding()
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
}
#endif
