//
//  ARCCarouselShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCCarouselShowcase

/// A comprehensive showcase view demonstrating all ARCCarousel configurations
///
/// This view displays various carousel presets and configurations for testing
/// and demonstration purposes.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCarouselShowcase: View {
    // MARK: - State

    @State private var defaultIndex = 0
    @State private var featuredIndex = 0
    @State private var galleryIndex = 0
    @State private var cardsIndex = 0
    @State private var storiesIndex = 0
    @State private var pagingIndex = 0

    // MARK: - Sample Data

    private let colorItems: [CarouselSampleItem] = [
        CarouselSampleItem(color: .blue, title: "Ocean", subtitle: "Calm waves"),
        CarouselSampleItem(color: .green, title: "Forest", subtitle: "Nature calls"),
        CarouselSampleItem(color: .orange, title: "Sunset", subtitle: "Golden hour"),
        CarouselSampleItem(color: .purple, title: "Galaxy", subtitle: "Explore space"),
        CarouselSampleItem(color: .red, title: "Passion", subtitle: "Feel alive"),
    ]

    private let manyItems: [CarouselSampleItem] = (1...12).map { index in
        CarouselSampleItem(
            color: Color(hue: Double(index) / 12.0, saturation: 0.7, brightness: 0.8),
            title: "Item \(index)",
            subtitle: "Description"
        )
    }

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                headerSection

                defaultSection

                featuredSection

                gallerySection

                cardsSection

                storiesSection

                pagingSection

                customSection

                indicatorStylesSection
            }
            .padding(.vertical, 24)
        }
        .background(.background.secondary)
    }

    // MARK: - Header Section

    @ViewBuilder private var headerSection: some View {
        VStack(spacing: 8) {
            Text("ARCCarousel")
                .font(.largeTitle.bold())

            Text("Horizontal carousel component with multiple presets")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }

    // MARK: - Default Section

    @ViewBuilder private var defaultSection: some View {
        showcaseSection(title: "Default", subtitle: "Standard carousel with peek effect") {
            ARCCarousel(colorItems, currentIndex: $defaultIndex) { item in
                SampleCardView(item: item)
                    .frame(height: 180)
            }
            .frame(height: 220)
        }
    }

    // MARK: - Featured Section

    @ViewBuilder private var featuredSection: some View {
        showcaseSection(title: "Featured", subtitle: "Auto-scroll with scale effect and indicators") {
            ARCFeaturedCarousel(colorItems, currentIndex: $featuredIndex) { item in
                SampleBannerView(item: item)
                    .frame(height: 200)
            }
            .frame(height: 260)
        }
    }

    // MARK: - Gallery Section

    @ViewBuilder private var gallerySection: some View {
        showcaseSection(title: "Gallery", subtitle: "Prominent scale effect, wider peek") {
            ARCCarousel(colorItems, currentIndex: $galleryIndex, configuration: .gallery) { item in
                SampleCardView(item: item)
                    .frame(height: 220)
            }
            .frame(height: 260)
        }
    }

    // MARK: - Cards Section

    @ViewBuilder private var cardsSection: some View {
        showcaseSection(title: "Cards", subtitle: "Fixed-width cards, multiple visible") {
            ARCCarousel(manyItems, currentIndex: $cardsIndex, configuration: .cards) { item in
                SampleCardView(item: item)
                    .frame(height: 160)
            }
            .frame(height: 180)
        }
    }

    // MARK: - Stories Section

    @ViewBuilder private var storiesSection: some View {
        showcaseSection(title: "Stories", subtitle: "Small circular items, free scroll") {
            ARCCarousel(manyItems, currentIndex: $storiesIndex, configuration: .stories) { item in
                Circle()
                    .fill(item.color.gradient)
                    .overlay {
                        Text(String(item.title.prefix(1)))
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                    }
                    .frame(width: 70, height: 70)
            }
            .frame(height: 90)
        }
    }

    // MARK: - Paging Section

    @ViewBuilder private var pagingSection: some View {
        showcaseSection(title: "Paging", subtitle: "Full-width pages with line indicators") {
            ARCCarousel(colorItems, currentIndex: $pagingIndex, configuration: .paging) { item in
                SampleBannerView(item: item)
                    .frame(height: 180)
            }
            .frame(height: 220)
        }
    }

    // MARK: - Custom Section

    @ViewBuilder private var customSection: some View {
        showcaseSection(title: "Custom Configuration", subtitle: "Numbers indicator, no snap") {
            let customConfig = ARCCarouselConfiguration(
                itemSize: .fractional(0.7),
                itemSpacing: 24,
                snapBehavior: .none,
                indicatorStyle: .numbers,
                indicatorPosition: .bottom(offset: 12)
            )

            ARCCarousel(colorItems, configuration: customConfig) { item in
                SampleCardView(item: item)
                    .frame(height: 160)
            }
            .frame(height: 220)
        }
    }

    // MARK: - Indicator Styles Section

    @ViewBuilder private var indicatorStylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Indicator Styles", subtitle: "Available indicator options")

            VStack(spacing: 24) {
                indicatorDemo(style: .dots, label: "Dots")
                indicatorDemo(style: .lines, label: "Lines")
                indicatorDemo(style: .numbers, label: "Numbers")
            }
            .padding()
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
        }
    }

    // MARK: - Helper Views

    @ViewBuilder
    private func showcaseSection<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: title, subtitle: subtitle)
            content()
        }
    }

    @ViewBuilder
    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func indicatorDemo(style: ARCCarouselConfiguration.IndicatorStyle, label: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            Spacer()

            ARCCarouselIndicator(
                totalItems: 5,
                currentIndex: 2,
                style: style,
                accentColor: .primary
            )

            Spacer()
        }
    }
}

// MARK: - Sample Data Models

@available(iOS 17.0, macOS 14.0, *)
struct CarouselSampleItem: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    let subtitle: String
}

// MARK: - Sample Views

@available(iOS 17.0, macOS 14.0, *)
private struct SampleCardView: View {
    let item: CarouselSampleItem

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(item.color.gradient)
            .overlay {
                VStack(spacing: 8) {
                    Text(item.title)
                        .font(.title3.bold())
                    Text(item.subtitle)
                        .font(.caption)
                        .opacity(0.8)
                }
                .foregroundStyle(.white)
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
private struct SampleBannerView: View {
    let item: CarouselSampleItem

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

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Light Mode") {
    ARCCarouselShowcase()
        .preferredColorScheme(.light)
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    ARCCarouselShowcase()
        .preferredColorScheme(.dark)
}
