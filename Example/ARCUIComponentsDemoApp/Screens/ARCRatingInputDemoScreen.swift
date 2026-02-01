//
//  ARCRatingInputDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 1/2/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCRatingInputView component.
///
/// Shows interactive rating selection with slider and circular drag styles.
struct ARCRatingInputDemoScreen: View {
    // MARK: - State

    @State private var sliderRating: Double = 5.0
    @State private var circularRating: Double = 7.5

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                sliderSection
                circularDragSection
                configurationPresetsSection
                useCaseSection
            }
            .padding()
        }
        .navigationTitle("ARCRatingInputView")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Sections

extension ARCRatingInputDemoScreen {
    // MARK: - Slider Section

    private var sliderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Slider Style", description: "Drag the slider to select a rating")

            VStack(spacing: 20) {
                ARCRatingInputView(rating: $sliderRating, style: .slider)

                HStack {
                    Text("Selected Rating:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", sliderRating))
                        .font(.title3.bold().monospacedDigit())
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Circular Drag Section

    private var circularDragSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Circular Drag Style", description: "Drag around the circle to select")

            VStack(spacing: 20) {
                ARCRatingInputView(rating: $circularRating, style: .circularDrag)

                HStack {
                    Text("Selected Rating:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.1f", circularRating))
                        .font(.title3.bold().monospacedDigit())
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Configuration Presets Section

    private var configurationPresetsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Configuration Presets", description: "Ready-to-use configurations")

            VStack(spacing: 16) {
                presetRow(title: ".slider", description: "Default with slider") {
                    ARCRatingInputView(rating: .constant(6.5), configuration: .slider)
                        .scaleEffect(0.8)
                }

                presetRow(title: ".circularDrag", description: "Interactive gauge") {
                    ARCRatingInputView(rating: .constant(8.0), configuration: .circularDrag)
                        .scaleEffect(0.8)
                }

                presetRow(title: ".compact", description: "No label, drag only") {
                    ARCRatingInputView(rating: .constant(9.0), configuration: .compact)
                        .scaleEffect(0.8)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private func presetRow(
        title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.monospaced())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            content()
        }
    }

    // MARK: - Use Case Section

    private var useCaseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Use Case: Review Form", description: "Rate your experience")

            VStack(spacing: 0) {
                reviewFormRow(title: "Food Quality", systemImage: "fork.knife")
                Divider().padding(.leading, 48)
                reviewFormRow(title: "Service", systemImage: "person.fill")
                Divider().padding(.leading, 48)
                reviewFormRow(title: "Ambiance", systemImage: "sparkles")
                Divider().padding(.leading, 48)
                reviewFormRow(title: "Value", systemImage: "dollarsign.circle")
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private func reviewFormRow(title: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.body)
                .foregroundStyle(.blue)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)

            Spacer()

            RatingCell()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, description: String) -> some View {
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

// MARK: - Rating Cell

private struct RatingCell: View {
    @State private var rating: Double = 7.0

    var body: some View {
        HStack(spacing: 8) {
            ARCRatingInputView(rating: $rating, configuration: .compact)
                .scaleEffect(0.6)
                .frame(width: 50, height: 50)

            Text(String(format: "%.1f", rating))
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .trailing)
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCRatingInputDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCRatingInputDemoScreen()
    }
    .preferredColorScheme(.dark)
}
