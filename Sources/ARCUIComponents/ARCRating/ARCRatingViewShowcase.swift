//
//  ARCRatingViewShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCRatingView in various styles and configurations
///
/// This view provides a visual gallery of all rating display styles,
/// demonstrating different configurations, colors, and use cases.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCRatingViewShowcase: View {
    // MARK: - State

    @State private var animatedRating: Double = 5.0

    // MARK: - Initialization

    public init() {}

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                allStylesSection
                circularGaugeSection
                compactInlineSection
                minimalSection
                colorScaleSection
                interactiveSection
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

    // MARK: - All Styles Section

    @ViewBuilder
    private var allStylesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("All Styles", subtitle: "3 visual styles for different contexts")

            VStack(spacing: .arcSpacingMedium) {
                styleRow("Circular Gauge", style: .circularGauge, description: "Default, cards")
                styleRow("Compact Inline", style: .compactInline, description: "Lists, rows")
                styleRow("Minimal", style: .minimal, description: "Inline text")
            }
            .padding()
            .background(cardBackground)
        }
    }

    @ViewBuilder
    private func styleRow(_ name: String, style: ARCRatingStyle, description: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 120, alignment: .leading)

            Spacer()

            ARCRatingView(rating: 8.5, style: style)
        }
    }

    // MARK: - Circular Gauge Section

    @ViewBuilder
    private var circularGaugeSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Circular Gauge", subtitle: "Default style with progress ring")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: .arcSpacingLarge) {
                ForEach([2.0, 4.5, 6.0, 7.5, 8.5, 10.0], id: \.self) { rating in
                    VStack(spacing: .arcSpacingSmall) {
                        ARCRatingView(rating: rating, style: .circularGauge)

                        Text(ratingLabel(for: rating))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Compact Inline Section

    @ViewBuilder
    private var compactInlineSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Compact Inline", subtitle: "Number with mini progress bar")

            VStack(spacing: 0) {
                ForEach(Array(sampleItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Image(systemName: item.icon)
                            .font(.title3)
                            .foregroundStyle(item.color)
                            .frame(width: 32)

                        Text(item.name)
                            .font(.subheadline)

                        Spacer()

                        ARCRatingView(rating: item.rating, style: .compactInline)
                    }
                    .padding(.vertical, .arcSpacingSmall)
                    .padding(.horizontal, .arcSpacingMedium)

                    if index < sampleItems.count - 1 {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .background(cardBackground)
        }
    }

    // MARK: - Minimal Section

    @ViewBuilder
    private var minimalSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Minimal", subtitle: "Just the colored number")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: .arcSpacingMedium) {
                ForEach([2.0, 5.0, 7.0, 9.5], id: \.self) { rating in
                    VStack(spacing: .arcSpacingXSmall) {
                        ARCRatingView(rating: rating, style: .minimal)
                        Text(ratingLabel(for: rating))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Color Scale Section

    @ViewBuilder
    private var colorScaleSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Color Scale", subtitle: "Semantic colors from 1 to 10")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: .arcSpacingMedium) {
                ForEach(1...10, id: \.self) { rating in
                    VStack(spacing: .arcSpacingXSmall) {
                        ARCRatingView(
                            rating: Double(rating),
                            style: .circularGauge,
                            animated: false
                        )
                        .scaleEffect(0.55)

                        Text("\(rating)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Interactive Section

    @ViewBuilder
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Interactive", subtitle: "Drag slider to see transitions")

            VStack(spacing: .arcSpacingLarge) {
                HStack {
                    ARCRatingView(rating: animatedRating, style: .circularGauge)
                    Spacer()
                    ARCRatingView(rating: animatedRating, style: .compactInline)
                    Spacer()
                    ARCRatingView(rating: animatedRating, style: .minimal)
                }

                Slider(value: $animatedRating, in: 1...10, step: 0.5)
                    .tint(.green)

                Text("Rating: \(String(format: "%.1f", animatedRating))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - In Context Section

    @ViewBuilder
    private var inContextSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("In Context", subtitle: "Real-world usage examples")

            // Restaurant card
            restaurantCard

            // Product list
            productList

            // Inline text example
            inlineTextExample
        }
    }

    @ViewBuilder
    private var restaurantCard: some View {
        HStack(spacing: .arcSpacingMedium) {
            RoundedRectangle(cornerRadius: .arcCornerRadiusSmall)
                .fill(
                    LinearGradient(
                        colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 70, height: 70)
                .overlay {
                    Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundStyle(.orange)
                }

            VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                Text("La Bella Italia")
                    .font(.headline)

                HStack(spacing: .arcSpacingXSmall) {
                    Image(systemName: "mappin")
                        .font(.caption2)
                    Text("2.3 km")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)

                HStack(spacing: .arcSpacingXSmall) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("Open until 11 PM")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }

            Spacer()

            ARCRatingView(rating: 9.2, style: .circularGauge)
        }
        .padding()
        .background(cardBackground)
    }

    @ViewBuilder
    private var productList: some View {
        VStack(spacing: 0) {
            ForEach(Array(productItems.enumerated()), id: \.offset) { index, item in
                HStack {
                    Circle()
                        .fill(item.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: item.icon)
                                .font(.body)
                                .foregroundStyle(item.color)
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(.subheadline.weight(.medium))
                        Text(item.category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    ARCRatingView(rating: item.rating, style: .compactInline)
                }
                .padding(.vertical, .arcSpacingSmall)
                .padding(.horizontal, .arcSpacingMedium)

                if index < productItems.count - 1 {
                    Divider()
                        .padding(.leading, 64)
                }
            }
        }
        .background(cardBackground)
    }

    @ViewBuilder
    private var inlineTextExample: some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Inline Text Usage")
                .font(.subheadline.weight(.medium))

            HStack(spacing: .arcSpacingXSmall) {
                Text("Rating:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ARCRatingView(rating: 8.7, style: .minimal)
                Text("(234 reviews)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(cardBackground)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
            Text(title)
                .font(.title2.bold())

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: .arcCornerRadiusMedium)
            .fill(.ultraThinMaterial)
    }

    private func ratingLabel(for rating: Double) -> String {
        switch rating {
        case 0..<3: return "Poor"
        case 3..<5: return "Fair"
        case 5..<7: return "Good"
        case 7..<8.5: return "Great"
        default: return "Excellent"
        }
    }

    // MARK: - Sample Data

    private var sampleItems: [(name: String, icon: String, color: Color, rating: Double)] {
        [
            ("Pasta Carbonara", "fork.knife", .orange, 9.2),
            ("Caesar Salad", "leaf.fill", .green, 7.8),
            ("Tiramisu", "birthday.cake", .brown, 8.5),
            ("Espresso", "cup.and.saucer.fill", .brown, 6.5)
        ]
    }

    private var productItems: [(name: String, category: String, icon: String, color: Color, rating: Double)] {
        [
            ("iPhone 16 Pro", "Electronics", "iphone", .blue, 9.4),
            ("AirPods Pro", "Audio", "airpodspro", .gray, 8.8),
            ("MacBook Air", "Computers", "laptopcomputer", .gray, 9.1),
            ("Apple Watch", "Wearables", "applewatch", .pink, 8.2)
        ]
    }
}

// MARK: - Preview

#Preview("Showcase - Light") {
    NavigationStack {
        ARCRatingViewShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    NavigationStack {
        ARCRatingViewShowcase()
    }
    .preferredColorScheme(.dark)
}
