//
//  ARCRatingViewDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCRatingView component.
///
/// Shows rating displays with various styles, configurations, and scales.
struct ARCRatingViewDemoScreen: View {
    // MARK: - State

    @State private var interactiveRating: Double = 7.0

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                stylesSection
                colorScaleSection
                interactiveSection
                presetsSection
                usageExamplesSection
                overlaySection
            }
            .padding()
        }
        .navigationTitle("ARCRatingView")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Sections

private extension ARCRatingViewDemoScreen {
    // MARK: - Styles Section

    var stylesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Styles", description: "3 visual styles for different contexts")

            VStack(spacing: 20) {
                styleRow(
                    title: "Circular Gauge",
                    description: "Default - Cards, featured content",
                    style: .circularGauge
                )

                styleRow(
                    title: "Compact Inline",
                    description: "Lists, table rows",
                    style: .compactInline
                )

                styleRow(
                    title: "Minimal",
                    description: "Badges, inline text",
                    style: .minimal
                )
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    func styleRow(title: String, description: String, style: ARCRatingStyle) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ARCRatingView(rating: 8.5, style: style)
        }
    }

    // MARK: - Color Scale Section

    var colorScaleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Color Scale", description: "Semantic colors from 1 to 10")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(1...10, id: \.self) { rating in
                    VStack(spacing: 4) {
                        ARCRatingView(
                            rating: Double(rating),
                            style: .circularGauge,
                            animated: false
                        )
                        .scaleEffect(0.7)

                        Text("\(rating)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Interactive Section

    var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Interactive", description: "Drag to see animated transitions")

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    ARCRatingView(rating: interactiveRating, style: .circularGauge)
                    Spacer()
                    ARCRatingView(rating: interactiveRating, style: .compactInline)
                    Spacer()
                    ARCRatingView(rating: interactiveRating, style: .minimal)
                    Spacer()
                }

                Slider(value: $interactiveRating, in: 1...10, step: 0.5)
                    .tint(.green)

                Text("Rating: \(String(format: "%.1f", interactiveRating))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Presets Section

    var presetsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Configuration Presets", description: "Ready-to-use configurations")

            VStack(spacing: 16) {
                presetRow(title: ".circularGauge", config: .circularGauge)
                presetRow(title: ".compactInline", config: .compactInline)
                presetRow(title: ".minimal", config: .minimal)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    func presetRow(title: String, config: ARCRatingViewConfiguration) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.monospaced())
                .foregroundStyle(.secondary)
            Spacer()
            ARCRatingView(rating: 8.5, configuration: config)
        }
    }

    // MARK: - Usage Examples Section

    var usageExamplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Usage Examples", description: "Real-world integration patterns")

            VStack(spacing: 16) {
                // Restaurant card
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "fork.knife")
                                .foregroundStyle(.orange)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("La Bella Italia")
                            .font(.headline)
                        Text("Italian Cuisine • $$$$")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    ARCRatingView(rating: 9.2)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                // Product list
                VStack(spacing: 0) {
                    listRow(name: "iPhone 16 Pro", rating: 9.4)
                    Divider().padding(.leading, 16)
                    listRow(name: "AirPods Pro", rating: 8.8)
                    Divider().padding(.leading, 16)
                    listRow(name: "MacBook Air", rating: 9.1)
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                // Inline text
                HStack(spacing: 4) {
                    Text("Rating:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ARCRatingView(rating: 8.7, style: .minimal)
                    Text("(234 reviews)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    func listRow(name: String, rating: Double) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
            Spacer()
            ARCRatingView(rating: rating, style: .compactInline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Overlay Section

    var overlaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Rating Overlay", description: "View modifier for easy integration")

            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 80)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.blue.opacity(0.5))
                    }
                    .ratingOverlay(9.2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(".ratingOverlay(9.2)")
                        .font(.caption.monospaced())
                    Text("Adds a minimal rating badge to any view")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Helpers

    func sectionHeader(_ title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCRatingViewDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCRatingViewDemoScreen()
    }
    .preferredColorScheme(.dark)
}
