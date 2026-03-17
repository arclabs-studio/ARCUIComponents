//
//  ARCCarouselDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCCarousel component.
///
/// Shows carousels with various configurations, presets, and use cases.
@available(iOS 17.0, *)
struct ARCCarouselDemoScreen: View {
    // MARK: - State

    @State private var defaultIndex = 0
    @State private var featuredIndex = 0
    @State private var galleryIndex = 0
    @State private var cardsIndex = 0

    // MARK: - Sample Data

    private let featuredItems: [CarouselDemoItem] = [
        CarouselDemoItem(color: .blue, title: "Summer Collection", subtitle: "New arrivals are here"),
        CarouselDemoItem(color: .orange, title: "Flash Sale", subtitle: "Up to 50% off selected items"),
        CarouselDemoItem(color: .purple, title: "Premium Members", subtitle: "Exclusive access to deals"),
        CarouselDemoItem(color: .green, title: "Free Shipping", subtitle: "On orders over $50"),
    ]

    private let cardItems: [CarouselDemoItem] = (1...8).map { index in
        CarouselDemoItem(
            color: Color(hue: Double(index) / 10.0 + 0.1, saturation: 0.6, brightness: 0.8),
            title: "Card \(index)",
            subtitle: "Item description"
        )
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                defaultSection
                featuredSection
                gallerySection
                cardsSection
                storiesSection
                customSection
            }
            .padding(.vertical)
        }
        .navigationTitle("ARCCarousel")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCCarouselDemoScreen {
    // MARK: - Default Section

    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                "Default Carousel",
                subtitle: "Standard configuration with peek effect and dot indicators"
            )

            ARCCarousel(featuredItems, currentIndex: $defaultIndex) { item in
                DemoCarouselCard(item: item)
                    .frame(height: 180)
            }
            .frame(height: 220)

            currentIndexLabel(defaultIndex, total: featuredItems.count)
        }
    }

    // MARK: - Featured Section

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                "Featured Carousel",
                subtitle: "Auto-scrolling with scale effect, perfect for hero banners"
            )

            ARCFeaturedCarousel(featuredItems, currentIndex: $featuredIndex) { item in
                DemoFeaturedBanner(item: item)
                    .frame(height: 200)
            }
            .frame(height: 260)

            currentIndexLabel(featuredIndex, total: featuredItems.count)
        }
    }

    // MARK: - Gallery Section

    private var gallerySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                "Gallery Style",
                subtitle: "Prominent scale effect with wider peek"
            )

            ARCCarousel(featuredItems, currentIndex: $galleryIndex, configuration: .gallery) { item in
                DemoCarouselCard(item: item)
                    .frame(height: 200)
            }
            .frame(height: 240)

            currentIndexLabel(galleryIndex, total: featuredItems.count)
        }
    }

    // MARK: - Cards Section

    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                "Card Carousel",
                subtitle: "Fixed-width cards, multiple visible at once"
            )

            ARCCarousel(cardItems, currentIndex: $cardsIndex, configuration: .cards) { item in
                DemoCompactCard(item: item)
                    .frame(height: 140)
            }
            .frame(height: 160)
        }
    }

    // MARK: - Stories Section

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                "Stories Style",
                subtitle: "Small circular items like Instagram stories"
            )

            ARCCarousel(cardItems, configuration: .stories) { item in
                Circle()
                    .fill(item.color.gradient)
                    .overlay {
                        Text(String(item.title.prefix(1)))
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                    }
                    .overlay {
                        Circle()
                            .stroke(item.color, lineWidth: 2)
                            .padding(-4)
                    }
                    .frame(width: 70, height: 70)
            }
            .frame(height: 90)
        }
    }

    // MARK: - Custom Section

    private var customSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(
                "Custom Configuration",
                subtitle: "Numbers indicator with 70% width items"
            )

            let customConfig = ARCCarouselConfiguration(
                itemSize: .fractional(0.7),
                itemSpacing: 20,
                snapBehavior: .item,
                indicatorStyle: .numbers,
                indicatorPosition: .bottom(offset: 12),
                showShadows: true,
                itemCornerRadius: 24
            )

            ARCCarousel(featuredItems, configuration: customConfig) { item in
                DemoCarouselCard(item: item)
                    .frame(height: 160)
            }
            .frame(height: 220)
        }
    }

    // MARK: - Helper Views

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }

    private func currentIndexLabel(_ index: Int, total: Int) -> some View {
        Text("Current: \(index + 1) of \(total)")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
    }
}

// MARK: - Demo Data Model

private struct CarouselDemoItem: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    let subtitle: String
}

// MARK: - Demo Card Views

@available(iOS 17.0, *)
private struct DemoCarouselCard: View {
    let item: CarouselDemoItem

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(item.color.gradient)
            .overlay {
                VStack(spacing: 8) {
                    Text(item.title)
                        .font(.title3.bold())
                    Text(item.subtitle)
                        .font(.caption)
                        .opacity(0.9)
                }
                .foregroundStyle(.white)
            }
    }
}

@available(iOS 17.0, *)
private struct DemoFeaturedBanner: View {
    let item: CarouselDemoItem

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color.gradient)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.title2.bold())
                    Text(item.subtitle)
                        .font(.subheadline)
                        .opacity(0.9)
                }
                .foregroundStyle(.white)
                .padding(20)
            }
    }
}

@available(iOS 17.0, *)
private struct DemoCompactCard: View {
    let item: CarouselDemoItem

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(item.color.gradient)
            .overlay {
                VStack(spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.subtitle)
                        .font(.caption2)
                        .opacity(0.8)
                }
                .foregroundStyle(.white)
            }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCCarouselDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCCarouselDemoScreen()
    }
    .preferredColorScheme(.dark)
}
