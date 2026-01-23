//
//  ARCFeaturedCarousel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCFeaturedCarousel

/// A pre-configured carousel optimized for featured content display
///
/// `ARCFeaturedCarousel` is a convenience wrapper around `ARCCarousel` that comes
/// pre-configured with settings ideal for showcasing featured content, similar to
/// the App Store's featured apps section or Netflix's hero banners.
///
/// ## Overview
///
/// This carousel includes:
/// - Full-width items with peek effect (90% width)
/// - Auto-scroll enabled (5 second interval)
/// - Dot indicators overlaid at the bottom
/// - Subtle scale effect on non-centered items
/// - Shadows for depth
///
/// ## Usage
///
/// ```swift
/// // Simple usage
/// ARCFeaturedCarousel(promotions) { promo in
///     PromotionBanner(promo: promo)
/// }
///
/// // With index binding
/// @State private var currentBanner = 0
///
/// ARCFeaturedCarousel(
///     banners,
///     currentIndex: $currentBanner,
///     autoScrollInterval: 6
/// ) { banner in
///     BannerView(banner: banner)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCFeaturedCarousel<Data: RandomAccessCollection, Content: View>: View
where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let content: (Data.Element) -> Content
    private let autoScrollInterval: TimeInterval
    private let showIndicators: Bool

    // MARK: - Bindings

    @Binding private var currentIndex: Int

    // MARK: - Initialization

    /// Creates a featured carousel with the specified data and content
    ///
    /// - Parameters:
    ///   - data: The collection of identifiable items to display
    ///   - currentIndex: Binding to the currently displayed item index
    ///   - autoScrollInterval: Time between auto-scroll advances (default: 5 seconds)
    ///   - showIndicators: Whether to show page indicators (default: true)
    ///   - content: A view builder that creates the view for each item
    public init(
        _ data: Data,
        currentIndex: Binding<Int> = .constant(0),
        autoScrollInterval: TimeInterval = 5,
        showIndicators: Bool = true,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        _currentIndex = currentIndex
        self.autoScrollInterval = autoScrollInterval
        self.showIndicators = showIndicators
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        ARCCarousel(
            data,
            currentIndex: $currentIndex,
            configuration: configuration
        ) { item in
            content(item)
        }
    }

    // MARK: - Configuration

    private var configuration: ARCCarouselConfiguration {
        ARCCarouselConfiguration(
            itemSize: .fractional(0.9),
            itemSpacing: 12,
            contentInsets: EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20),
            snapBehavior: .item,
            autoScrollEnabled: true,
            autoScrollInterval: autoScrollInterval,
            pauseOnInteraction: true,
            indicatorStyle: showIndicators ? .dots : .none,
            indicatorPosition: .overlay(alignment: .bottom),
            showShadows: true,
            scaleEffect: .default,
            itemCornerRadius: 20
        )
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
private struct FeaturedPreviewItem: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    let subtitle: String
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCFeaturedCarousel") {
    let items = [
        FeaturedPreviewItem(color: .blue, title: "Summer Sale", subtitle: "Up to 50% off"),
        FeaturedPreviewItem(color: .orange, title: "New Arrivals", subtitle: "Check out what's new"),
        FeaturedPreviewItem(color: .purple, title: "Featured", subtitle: "Editor's choice"),
        FeaturedPreviewItem(color: .green, title: "Trending", subtitle: "Popular this week")
    ]

    VStack {
        Text("Featured")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

        ARCFeaturedCarousel(items) { item in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(item.color.gradient)

                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    Text(item.title)
                        .font(.title.bold())
                    Text(item.subtitle)
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            .frame(height: 200)
        }
        .frame(height: 260)
    }
}
