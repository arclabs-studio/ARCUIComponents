//
//  ARCRatingInputShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/2/26.
//

import ARCDesignSystem
import SwiftUI

/// Showcase demonstrating ARCRatingInputView interaction styles
///
/// This view provides an interactive gallery of all rating input styles,
/// demonstrating slider and circular drag interactions.
@available(iOS 17.0, macOS 14.0, *) public struct ARCRatingInputShowcase: View {
    // MARK: - State

    @State private var sliderRating: Double = 5.0
    @State private var circularRating: Double = 7.5
    @State private var compactRating: Double = 8.0
    @State private var formRatings: [Double] = [6.0, 7.5, 8.0]

    // MARK: - Initialization

    public init() {}

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXXLarge) {
                overviewSection
                sliderStyleSection
                circularDragStyleSection
                comparisonSection
                formExampleSection
                stepsVisualizationSection
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(nsColor: .controlBackgroundColor))
        #endif
        .navigationTitle("ARCRatingInputView")
    }

    // MARK: - Overview Section

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Overview",
                          subtitle: "Interactive rating selection from 1 to 10 with 0.5 steps")

            VStack(spacing: .arcSpacingMedium) {
                featureRow(icon: "slider.horizontal.3",
                           title: "Two Interaction Styles",
                           description: "Slider or circular drag")
                featureRow(icon: "number",
                           title: "1-10 Scale",
                           description: "With 0.5 increments (19 values)")
                featureRow(icon: "paintpalette",
                           title: "Semantic Colors",
                           description: "Colors change based on rating")
                featureRow(icon: "accessibility",
                           title: "Accessible",
                           description: "Full VoiceOver support")
            }
            .padding()
            .background(cardBackground)
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    // MARK: - Slider Style Section

    private var sliderStyleSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Slider Style",
                          subtitle: "Horizontal slider below the gauge")

            VStack(spacing: .arcSpacingLarge) {
                ARCRatingInputView(rating: $sliderRating, style: .slider)

                HStack {
                    Text("Selected:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f", sliderRating))
                        .font(.headline.monospacedDigit())
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Circular Drag Style Section

    private var circularDragStyleSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Circular Drag Style",
                          subtitle: "Drag around the gauge to select")

            VStack(spacing: .arcSpacingLarge) {
                ARCRatingInputView(rating: $circularRating, style: .circularDrag)

                HStack {
                    Text("Selected:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f", circularRating))
                        .font(.headline.monospacedDigit())
                }

                Text("Tip: Drag clockwise to increase, counter-clockwise to decrease")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Comparison Section

    private var comparisonSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Style Comparison",
                          subtitle: "Choose the best style for your use case")

            HStack(spacing: .arcSpacingXLarge) {
                VStack(spacing: .arcSpacingMedium) {
                    ARCRatingInputView(rating: $sliderRating, style: .slider)

                    VStack(spacing: 4) {
                        Text("Slider")
                            .font(.subheadline.weight(.medium))
                        Text("Forms, settings")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(spacing: .arcSpacingMedium) {
                    ARCRatingInputView(rating: $compactRating, style: .circularDrag)

                    VStack(spacing: 4) {
                        Text("Circular")
                            .font(.subheadline.weight(.medium))
                        Text("Compact, visual")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Form Example Section

    private var formExampleSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Form Example",
                          subtitle: "Rating multiple items")

            VStack(spacing: 0) {
                formRow(title: "Food Quality", rating: $formRatings[0])
                Divider().padding(.leading, 16)
                formRow(title: "Service", rating: $formRatings[1])
                Divider().padding(.leading, 16)
                formRow(title: "Ambiance", rating: $formRatings[2])
            }
            .background(cardBackground)

            // Average display
            HStack {
                Text("Average Rating:")
                    .font(.subheadline)
                Spacer()
                let average = formRatings.reduce(0, +) / Double(formRatings.count)
                Text(String(format: "%.1f", average))
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(colorForRating(average))
            }
            .padding()
            .background(cardBackground)
        }
    }

    private func formRow(title: String, rating: Binding<Double>) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)

            Spacer()

            ARCRatingInputView(rating: rating,
                               configuration: .compact)
                .scaleEffect(0.7)

            Text(String(format: "%.1f", rating.wrappedValue))
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 32, alignment: .trailing)
        }
        .padding(.horizontal, .arcSpacingMedium)
        .padding(.vertical, .arcSpacingSmall)
    }

    // MARK: - Steps Visualization Section

    private var stepsVisualizationSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Available Values",
                          subtitle: "19 possible ratings from 1 to 10")

            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())], spacing: .arcSpacingSmall) {
                ForEach(availableRatings, id: \.self) { rating in
                    Text(formatRating(rating))
                        .font(.system(.caption, design: .monospaced))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(RoundedRectangle(cornerRadius: 6)
                            .fill(colorForRating(rating).opacity(0.2)))
                        .foregroundStyle(colorForRating(rating))
                }
            }
            .padding()
            .background(cardBackground)
        }
    }

    // MARK: - Helpers

    private var availableRatings: [Double] {
        stride(from: 1.0, through: 10.0, by: 0.5).map(\.self)
    }

    private func formatRating(_ rating: Double) -> String {
        ARCRatingColorMapper.formatted(rating)
    }

    private func colorForRating(_ rating: Double) -> Color {
        ARCRatingColorMapper.color(for: rating)
    }

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
}

// MARK: - Preview

#Preview("Showcase - Light") {
    NavigationStack {
        ARCRatingInputShowcase()
    }
    .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    NavigationStack {
        ARCRatingInputShowcase()
    }
    .preferredColorScheme(.dark)
}
