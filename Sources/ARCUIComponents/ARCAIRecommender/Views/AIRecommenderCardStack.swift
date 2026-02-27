//
//  AIRecommenderCardStack.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/17/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - AIRecommenderCardStack

/// Horizontal peek carousel for browsing AI recommendations
///
/// Displays items in a scrollable carousel where adjacent cards are partially
/// visible on the sides. Supports accessibility, reduce motion, and bookmarks.
///
/// ## Features
/// - Horizontal scroll with snap-to-center behavior
/// - Adjacent cards peek from the sides with scale + opacity effects
/// - Position indicator showing current card
/// - Reduce motion: disables scale/opacity transitions
@available(iOS 17.0, macOS 14.0, *) struct AIRecommenderCardStack<Item: AIRecommenderItem>: View {
    // MARK: - Properties

    let items: [Item]
    let bookmarkedItemIDs: Set<AnyHashable>
    let configuration: ARCAIRecommenderConfiguration
    let onItemSelected: ((Item) -> Void)?
    let onItemBookmarked: ((Item) -> Void)?

    // MARK: - State

    @State private var currentIndex: Int = 0
    @State private var scrollPosition: Int?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Body

    var body: some View {
        if items.isEmpty {
            emptyStateView
        } else {
            VStack(spacing: .arcSpacingLarge) {
                cardCarousel
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Recomendaciones, card \(currentIndex + 1) de \(items.count)")
                    .accessibilityAction(named: "Siguiente") { navigateForward() }
                    .accessibilityAction(named: "Anterior") { navigateBackward() }

                if configuration.showCardIndicator {
                    cardIndicator
                }
            }
        }
    }

    // MARK: - Card Indicator

    private var cardIndicator: some View {
        ARCCarouselIndicator(totalItems: items.count,
                             currentIndex: currentIndex,
                             style: .dots,
                             accentColor: configuration.accentColor)
    }

    // MARK: - Card Carousel

    private var cardCarousel: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * configuration.peekFraction

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: configuration.cardSpacing) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        cardView(for: item)
                            .aiGlowBorder(isActive: index == currentIndex && configuration.showGlowEffect,
                                          cornerRadius: configuration.cornerRadius,
                                          accentColor: configuration.accentColor,
                                          intensity: configuration.glowIntensity,
                                          showSparkles: configuration.showSparkles)
                            .frame(width: cardWidth, height: geometry.size.height)
                            .scaleEffect(scaleForIndex(index))
                            .opacity(opacityForIndex(index))
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .contentMargins(.horizontal, (geometry.size.width - cardWidth) / 2)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .onChange(of: scrollPosition) { _, newPosition in
                if let newPosition, newPosition != currentIndex {
                    currentIndex = newPosition
                }
            }
        }
        .padding(.vertical, configuration.showGlowEffect ? configuration.glowIntensity.haloExpand : 0)
    }

    // MARK: - Visual Effects

    private func scaleForIndex(_ index: Int) -> CGFloat {
        guard !reduceMotion else { return 1.0 }
        return index == currentIndex ? 1.0 : configuration.adjacentCardScale
    }

    private func opacityForIndex(_ index: Int) -> Double {
        guard !reduceMotion else { return 1.0 }
        return index == currentIndex ? 1.0 : configuration.adjacentCardOpacity
    }

    // MARK: - Card View

    private func cardView(for item: Item) -> some View {
        AIRecommenderSwipeCard(item: item,
                               isBookmarked: bookmarkedItemIDs.contains(AnyHashable(item.id)),
                               configuration: configuration,
                               onTap: { onItemSelected?(item) },
                               onBookmarkToggle: { onItemBookmarked?(item) })
    }

    // MARK: - Navigation (Accessibility)

    private func navigateForward() {
        let newIndex = min(currentIndex + 1, items.count - 1)
        let animation: Animation = reduceMotion ? .arcGentle : .arcSnappy
        arcWithAnimation(animation) {
            currentIndex = newIndex
            scrollPosition = newIndex
        }
    }

    private func navigateBackward() {
        let newIndex = max(currentIndex - 1, 0)
        let animation: Animation = reduceMotion ? .arcGentle : .arcSnappy
        arcWithAnimation(animation) {
            currentIndex = newIndex
            scrollPosition = newIndex
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: .arcSpacingMedium) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundStyle(configuration.accentColor.opacity(0.5))

            Text("Sin recomendaciones")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Explora otras categorias para descubrir nuevas sugerencias")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.arcSpacingXLarge)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Previews

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *) private struct CardStackPreviewItem: AIRecommenderItem {
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
#Preview("Peek Carousel") {
    let items: [CardStackPreviewItem] = [CardStackPreviewItem(id: UUID(),
                                                              title: "La Tagliatella",
                                                              subtitle: "Italiano \u{00B7} \u{20AC}\u{20AC}",
                                                              rating: 8.5,
                                                              imageSource: .system("fork.knife", color: .orange),
                                                              aiReason: "Te encanta la cocina italiana"
                                                                  + " y este lugar tiene"
                                                                  + " los mejores platos caseros",
                                                              location: "Centro, Madrid \u{00B7} 0.5 km",
                                                              highlightDetail: "Pasta Carbonara"),
                                         CardStackPreviewItem(id: UUID(),
                                                              title: "Sushi Master",
                                                              subtitle: "Japones \u{00B7} \u{20AC}\u{20AC}\u{20AC}",
                                                              rating: 9.2,
                                                              imageSource: .system("fish.fill", color: .cyan),
                                                              aiReason: "Similar a tus restaurantes favoritos",
                                                              location: "Salamanca, Madrid \u{00B7} 1.2 km",
                                                              highlightDetail: "Omakase Menu"),
                                         CardStackPreviewItem(id: UUID(),
                                                              title: "El Mexicano",
                                                              subtitle: "Mexicano \u{00B7} \u{20AC}",
                                                              rating: 7.8,
                                                              imageSource: .system("flame.fill", color: .red),
                                                              aiReason: "Muy bien valorado en tu zona",
                                                              location: "Malasana, Madrid \u{00B7} 0.8 km",
                                                              highlightDetail: "Tacos al Pastor"),
                                         CardStackPreviewItem(id: UUID(),
                                                              title: "Wok & Roll",
                                                              subtitle: "Asiatico \u{00B7} \u{20AC}\u{20AC}",
                                                              rating: 8.1,
                                                              imageSource: .system("leaf.fill", color: .green),
                                                              aiReason: "Nuevo descubrimiento en tu barrio",
                                                              location: "Lavapies, Madrid \u{00B7} 0.3 km",
                                                              highlightDetail: nil)]

    ScrollView {
        AIRecommenderCardStack(items: items,
                               bookmarkedItemIDs: [items[1].id],
                               configuration: .default,
                               onItemSelected: { _ in },
                               onItemBookmarked: { _ in })
    }
    .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, *)
#Preview("Peek Carousel - Dark") {
    let items: [CardStackPreviewItem] = [CardStackPreviewItem(id: UUID(),
                                                              title: "La Tagliatella",
                                                              subtitle: "Italiano \u{00B7} \u{20AC}\u{20AC}",
                                                              rating: 8.5,
                                                              imageSource: .system("fork.knife", color: .orange),
                                                              aiReason: "Te encanta la cocina italiana",
                                                              location: "Centro, Madrid \u{00B7} 0.5 km",
                                                              highlightDetail: "Pasta Carbonara"),
                                         CardStackPreviewItem(id: UUID(),
                                                              title: "Sushi Master",
                                                              subtitle: "Japones \u{00B7} \u{20AC}\u{20AC}\u{20AC}",
                                                              rating: 9.2,
                                                              imageSource: .system("fish.fill", color: .cyan),
                                                              aiReason: "Similar a tus restaurantes favoritos",
                                                              location: "Salamanca, Madrid \u{00B7} 1.2 km",
                                                              highlightDetail: "Omakase Menu")]

    ScrollView {
        AIRecommenderCardStack(items: items,
                               bookmarkedItemIDs: [],
                               configuration: .default,
                               onItemSelected: { _ in },
                               onItemBookmarked: { _ in })
    }
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
#endif
