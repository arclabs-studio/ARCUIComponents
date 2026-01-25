//
//  ARCCarousel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCCarousel

/// A customizable horizontal carousel component for showcasing content
///
/// `ARCCarousel` provides a smooth, native-feeling carousel experience with
/// support for snapping, page indicators, auto-scroll, and visual effects
/// like scale transitions.
///
/// ## Overview
///
/// ARCCarousel supports:
/// - Multiple item sizing modes (full width, fractional, fixed)
/// - Configurable snap behavior
/// - Various indicator styles (dots, lines, numbers)
/// - Auto-scroll with pause on interaction
/// - Scale effects for non-centered items
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating a Carousel
///
/// - ``init(_:currentIndex:configuration:content:)``
///
/// ### Types
///
/// - ``ARCCarouselConfiguration``
///
/// ## Usage
///
/// ```swift
/// // Basic carousel
/// ARCCarousel(items) { item in
///     CardView(item: item)
/// }
///
/// // With binding and configuration
/// @State private var currentPage = 0
///
/// ARCCarousel(
///     banners,
///     currentIndex: $currentPage,
///     configuration: .featured
/// ) { banner in
///     BannerView(banner: banner)
/// }
///
/// // Card gallery
/// ARCCarousel(
///     restaurants,
///     configuration: .cards
/// ) { restaurant in
///     RestaurantCard(restaurant: restaurant)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCarousel<Data: RandomAccessCollection, Content: View>: View
where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let configuration: ARCCarouselConfiguration
    private let content: (Data.Element) -> Content

    // MARK: - Bindings

    @Binding private var currentIndex: Int

    // MARK: - State

    @State private var containerWidth: CGFloat = 0
    @State private var autoScrollTimer: Timer?
    @State private var isDragging = false
    @State private var scrollPosition: Int?

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a carousel with the specified data and content builder
    ///
    /// - Parameters:
    ///   - data: The collection of identifiable items to display
    ///   - currentIndex: Binding to the currently displayed item index
    ///   - configuration: Configuration options for appearance and behavior
    ///   - content: A view builder that creates the view for each item
    public init(
        _ data: Data,
        currentIndex: Binding<Int> = .constant(0),
        configuration: ARCCarouselConfiguration = .default,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        _currentIndex = currentIndex
        self.configuration = configuration
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            if case let .top(offset) = configuration.indicatorPosition {
                indicatorView
                    .padding(.bottom, offset)
            }

            carouselContent
                .overlay(alignment: overlayAlignment) {
                    if case .overlay = configuration.indicatorPosition {
                        indicatorView
                            .padding(8)
                    }
                }

            if case let .bottom(offset) = configuration.indicatorPosition {
                indicatorView
                    .padding(.top, offset)
            }
        }
        .onAppear {
            scrollPosition = currentIndex
            startAutoScrollIfNeeded()
        }
        .onDisappear {
            stopAutoScroll()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Carousel")
        .accessibilityValue("Item \(currentIndex + 1) of \(data.count)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                navigateToNext()
            case .decrement:
                navigateToPrevious()
            @unknown default:
                break
            }
        }
    }

    // MARK: - Carousel Content

    @ViewBuilder private var carouselContent: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: configuration.itemSpacing) {
                        ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                            itemView(for: item, at: index, containerWidth: width)
                                .id(index)
                        }
                    }
                    .padding(configuration.contentInsets)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(scrollBehavior)
                .scrollPosition(id: $scrollPosition)
                .onChange(of: scrollPosition) { _, newPosition in
                    if let newPosition, newPosition != currentIndex {
                        currentIndex = newPosition
                    }
                }
                .onChange(of: currentIndex) { _, newIndex in
                    if scrollPosition != newIndex {
                        withAnimation(reduceMotion ? .none : .arcGentle) {
                            scrollPosition = newIndex
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
                .simultaneousGesture(dragGesture)
            }
            .onAppear {
                containerWidth = width
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                containerWidth = newWidth
            }
        }
        .frame(height: carouselHeight)
    }

    // MARK: - Drag Gesture (for auto-scroll pause)

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !isDragging {
                    isDragging = true
                    if configuration.pauseOnInteraction {
                        stopAutoScroll()
                    }
                }
            }
            .onEnded { _ in
                isDragging = false
                if configuration.pauseOnInteraction {
                    startAutoScrollIfNeeded()
                }
            }
    }

    // MARK: - Scroll Behavior

    private var scrollBehavior: ViewAlignedScrollTargetBehavior {
        switch configuration.snapBehavior {
        case .none:
            ViewAlignedScrollTargetBehavior(limitBehavior: .never)
        case .item, .page:
            ViewAlignedScrollTargetBehavior(limitBehavior: .always)
        }
    }

    // MARK: - Item View

    @ViewBuilder
    private func itemView(for item: Data.Element, at index: Int, containerWidth: CGFloat) -> some View {
        let itemWidth = calculateItemWidth(containerWidth: containerWidth)

        content(item)
            .frame(width: itemWidth)
            .clipShape(RoundedRectangle(cornerRadius: configuration.itemCornerRadius, style: .continuous))
            .shadow(
                color: configuration.showShadows ? .black.opacity(0.15) : .clear,
                radius: configuration.showShadows ? 10 : 0,
                x: 0,
                y: configuration.showShadows ? 4 : 0
            )
            .scaleEffect(scaleFor(index: index))
            .animation(
                reduceMotion ? .none : (configuration.scaleEffect?.animation ?? .spring(response: 0.3)),
                value: currentIndex
            )
            .accessibilityLabel("Item \(index + 1)")
            .accessibilityHint("Swipe left or right to see more items")
    }

    // MARK: - Indicator View

    @ViewBuilder private var indicatorView: some View {
        if configuration.indicatorStyle != .none, data.count > 1 {
            ARCCarouselIndicator(
                totalItems: data.count,
                currentIndex: currentIndex,
                style: configuration.indicatorStyle,
                maxVisibleDots: configuration.maxVisibleDots,
                accentColor: .primary
            )
        }
    }

    // MARK: - Computed Properties

    private var overlayAlignment: Alignment {
        if case let .overlay(alignment) = configuration.indicatorPosition {
            return alignment
        }
        return .bottom
    }

    private var carouselHeight: CGFloat? {
        if case let .aspectRatio(_, height) = configuration.itemSize {
            return height
        }
        return nil
    }

    // MARK: - Helper Functions

    private func calculateItemWidth(containerWidth: CGFloat) -> CGFloat {
        let availableWidth = containerWidth
            - configuration.contentInsets.leading
            - configuration.contentInsets.trailing

        switch configuration.itemSize {
        case .fullWidth:
            return availableWidth

        case let .fractional(fraction):
            return availableWidth * min(1, max(0.1, fraction))

        case let .fixed(width):
            return min(width, availableWidth)

        case let .aspectRatio(ratio, height):
            return height * ratio
        }
    }

    private func scaleFor(index: Int) -> CGFloat {
        guard let scaleEffect = configuration.scaleEffect else {
            return 1.0
        }

        if index == currentIndex {
            return scaleEffect.centered
        }

        return scaleEffect.adjacent
    }

    // MARK: - Auto-Scroll

    private func startAutoScrollIfNeeded() {
        guard configuration.autoScrollEnabled, data.count > 1 else { return }

        stopAutoScroll()

        autoScrollTimer = Timer.scheduledTimer(
            withTimeInterval: configuration.autoScrollInterval,
            repeats: true
        ) { [self] _ in
            Task { @MainActor in
                guard !isDragging else { return }

                withAnimation(reduceMotion ? .none : .arcGentle) {
                    if currentIndex < data.count - 1 {
                        currentIndex += 1
                    } else if configuration.loopEnabled {
                        currentIndex = 0
                    }
                }
            }
        }
    }

    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    // MARK: - Navigation

    private func navigateToNext() {
        guard currentIndex < data.count - 1 else {
            if configuration.loopEnabled {
                currentIndex = 0
            }
            return
        }
        currentIndex += 1
    }

    private func navigateToPrevious() {
        guard currentIndex > 0 else {
            if configuration.loopEnabled {
                currentIndex = data.count - 1
            }
            return
        }
        currentIndex -= 1
    }
}

// MARK: - Preview Data

@available(iOS 17.0, macOS 14.0, *)
private struct PreviewItem: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Default") {
    let items = [
        PreviewItem(color: .blue, title: "First"),
        PreviewItem(color: .green, title: "Second"),
        PreviewItem(color: .orange, title: "Third"),
        PreviewItem(color: .purple, title: "Fourth")
    ]

    ARCCarousel(items) { item in
        RoundedRectangle(cornerRadius: 16)
            .fill(item.color.gradient)
            .overlay {
                Text(item.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
            .frame(height: 200)
    }
    .frame(height: 250)
    .padding(.vertical)
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Featured") {
    let items = [
        PreviewItem(color: .red, title: "Featured 1"),
        PreviewItem(color: .blue, title: "Featured 2"),
        PreviewItem(color: .green, title: "Featured 3")
    ]

    ARCCarousel(items, configuration: .featured) { item in
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color.gradient)
            .overlay {
                VStack {
                    Text(item.title)
                        .font(.title.bold())
                    Text("Subtitle text here")
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
            }
            .frame(height: 220)
    }
    .frame(height: 280)
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Cards") {
    let items = (1 ... 8).map { PreviewItem(color: .blue.opacity(Double($0) / 10 + 0.2), title: "Card \($0)") }

    ARCCarousel(items, configuration: .cards) { item in
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color)
            .overlay {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(height: 180)
    }
    .frame(height: 200)
}
