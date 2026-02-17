//
//  AIRecommenderCardStack.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/17/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - AIRecommenderCardStack

/// Swipeable card stack for browsing AI recommendations
///
/// Displays items as stacked cards with bidirectional swipe navigation.
/// Supports accessibility, reduce motion, and bookmark actions.
///
/// ## Features
/// - Bidirectional swipe to navigate between cards
/// - Visual stack with depth effect (scale + offset)
/// - Position indicator showing current card
/// - Reduce motion: cross-fade instead of slide animations
@available(iOS 17.0, macOS 14.0, *)
struct AIRecommenderCardStack<Item: AIRecommenderItem>: View {
    // MARK: - Properties

    let items: [Item]
    let bookmarkedItemIDs: Set<AnyHashable>
    let configuration: ARCAIRecommenderConfiguration
    let onItemSelected: ((Item) -> Void)?
    let onItemBookmarked: ((Item) -> Void)?

    // MARK: - State

    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Body

    var body: some View {
        if items.isEmpty {
            emptyStateView
        } else {
            VStack(spacing: .arcSpacingMedium) {
                cardStack
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Recomendaciones, card \(currentIndex + 1) de \(items.count)")
                    .accessibilityAction(named: "Siguiente") { navigateForward() }
                    .accessibilityAction(named: "Anterior") { navigateBackward() }

                if configuration.showCardIndicator {
                    cardIndicator
                }
            }
            .padding(.horizontal, .arcSpacingLarge)
        }
    }

    // MARK: - Card Indicator

    private var cardIndicator: some View {
        ARCCarouselIndicator(
            totalItems: items.count,
            currentIndex: currentIndex,
            style: .dots,
            accentColor: configuration.accentColor
        )
    }

    // MARK: - Card Stack

    private var cardStack: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width

            ZStack {
                // Background cards (rendered back-to-front)
                ForEach(backgroundCardIndices, id: \.self) { index in
                    let depth = index - currentIndex
                    cardView(for: items[index])
                        .scaleEffect(scaleForDepth(depth))
                        .offset(y: offsetForDepth(depth))
                        .opacity(opacityForDepth(depth))
                        .allowsHitTesting(false)
                }

                // Top card with gesture
                if currentIndex < items.count {
                    cardView(for: items[currentIndex])
                        .offset(x: dragOffset)
                        .rotationEffect(
                            reduceMotion ? .zero : Angle(degrees: Double(dragOffset) / 25),
                            anchor: .bottom
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    handleDragEnd(
                                        translation: value.translation.width,
                                        cardWidth: cardWidth
                                    )
                                }
                        )
                        .id(currentIndex)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(0.62, contentMode: .fit)
    }

    // MARK: - Card View

    private func cardView(for item: Item) -> some View {
        AIRecommenderSwipeCard(
            item: item,
            isBookmarked: bookmarkedItemIDs.contains(AnyHashable(item.id)),
            configuration: configuration,
            onTap: { onItemSelected?(item) },
            onBookmarkToggle: { onItemBookmarked?(item) }
        )
    }

    // MARK: - Background Card Indices

    private var backgroundCardIndices: [Int] {
        let maxDepth = configuration.cardStackDepth
        let start = currentIndex + 1
        let end = min(currentIndex + maxDepth, items.count)
        guard start < end else { return [] }
        return Array((start ..< end).reversed())
    }

    // MARK: - Stack Visual Calculations

    private func scaleForDepth(_ depth: Int) -> CGFloat {
        max(1.0 - CGFloat(depth) * 0.05, 0.85)
    }

    private func offsetForDepth(_ depth: Int) -> CGFloat {
        CGFloat(depth) * 10
    }

    private func opacityForDepth(_ depth: Int) -> Double {
        max(1.0 - Double(depth) * 0.2, 0.4)
    }

    // MARK: - Drag Handling

    private func handleDragEnd(translation: CGFloat, cardWidth: CGFloat) {
        isDragging = false
        let threshold = cardWidth * configuration.swipeThreshold

        if translation < -threshold, currentIndex < items.count - 1 {
            // Swipe left → next card
            navigateForward()
        } else if translation > threshold, currentIndex > 0 {
            // Swipe right → previous card
            navigateBackward()
        } else {
            // Snap back
            let animation: Animation = reduceMotion ? .arcGentle : .arcBouncy
            arcWithAnimation(animation) {
                dragOffset = 0
            }
        }
    }

    private func navigateForward() {
        let animation: Animation = reduceMotion ? .arcGentle : .arcSnappy
        arcWithAnimation(animation) {
            dragOffset = 0
            currentIndex = min(currentIndex + 1, items.count - 1)
        }
    }

    private func navigateBackward() {
        let animation: Animation = reduceMotion ? .arcGentle : .arcSnappy
        arcWithAnimation(animation) {
            dragOffset = 0
            currentIndex = max(currentIndex - 1, 0)
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

            Text("Explora otras categorías para descubrir nuevas sugerencias")
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
@available(iOS 17.0, macOS 14.0, *)
private struct CardStackPreviewItem: AIRecommenderItem {
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
#Preview("Card Stack") {
    let items: [CardStackPreviewItem] = [
        CardStackPreviewItem(
            id: UUID(),
            title: "La Tagliatella",
            subtitle: "Italiano · €€",
            rating: 8.5,
            imageSource: .system("fork.knife", color: .orange),
            aiReason: "Te encanta la cocina italiana y este lugar tiene los mejores platos caseros",
            location: "Centro, Madrid · 0.5 km",
            highlightDetail: "Pasta Carbonara"
        ),
        CardStackPreviewItem(
            id: UUID(),
            title: "Sushi Master",
            subtitle: "Japonés · €€€",
            rating: 9.2,
            imageSource: .system("fish.fill", color: .cyan),
            aiReason: "Similar a tus restaurantes favoritos",
            location: "Salamanca, Madrid · 1.2 km",
            highlightDetail: "Omakase Menú"
        ),
        CardStackPreviewItem(
            id: UUID(),
            title: "El Mexicano",
            subtitle: "Mexicano · €",
            rating: 7.8,
            imageSource: .system("flame.fill", color: .red),
            aiReason: "Muy bien valorado en tu zona",
            location: "Malasaña, Madrid · 0.8 km",
            highlightDetail: "Tacos al Pastor"
        ),
        CardStackPreviewItem(
            id: UUID(),
            title: "Wok & Roll",
            subtitle: "Asiático · €€",
            rating: 8.1,
            imageSource: .system("leaf.fill", color: .green),
            aiReason: "Nuevo descubrimiento en tu barrio",
            location: "Lavapiés, Madrid · 0.3 km",
            highlightDetail: nil
        )
    ]

    ScrollView {
        AIRecommenderCardStack(
            items: items,
            bookmarkedItemIDs: [items[1].id],
            configuration: .default,
            onItemSelected: { _ in },
            onItemBookmarked: { _ in }
        )
    }
    .background(Color(.systemGroupedBackground))
}

@available(iOS 17.0, *)
#Preview("Card Stack - Dark") {
    let items: [CardStackPreviewItem] = [
        CardStackPreviewItem(
            id: UUID(),
            title: "La Tagliatella",
            subtitle: "Italiano · €€",
            rating: 8.5,
            imageSource: .system("fork.knife", color: .orange),
            aiReason: "Te encanta la cocina italiana",
            location: "Centro, Madrid · 0.5 km",
            highlightDetail: "Pasta Carbonara"
        )
    ]

    ScrollView {
        AIRecommenderCardStack(
            items: items,
            bookmarkedItemIDs: [],
            configuration: .default,
            onItemSelected: { _ in },
            onItemBookmarked: { _ in }
        )
    }
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
#endif
