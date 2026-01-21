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
/// Shows rating displays with various configurations, icons, and styles.
struct ARCRatingViewDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                basicRatingsSection
                configurationsSection
                customIconsSection
                usageExamplesSection
            }
            .padding()
        }
        .navigationTitle("ARCRatingView")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

private extension ARCRatingViewDemoScreen {
    var basicRatingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Ratings")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            VStack(alignment: .leading, spacing: 16) {
                ratingRow(label: "Excellent", rating: 5.0)
                ratingRow(label: "Very Good", rating: 4.5)
                ratingRow(label: "Good", rating: 4.0)
                ratingRow(label: "Average", rating: 3.5)
                ratingRow(label: "Below Average", rating: 2.5)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    func ratingRow(label: String, rating: Double) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            ARCRatingView(rating: rating)
        }
    }

    var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configurations")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            VStack(alignment: .leading, spacing: 20) {
                configRow(
                    title: "Default",
                    description: "Star icon with numeric value",
                    content: { ARCRatingView(rating: 4.5, configuration: .default) }
                )

                configRow(
                    title: "Compact",
                    description: "Icon only, no numeric value",
                    content: { ARCRatingView(rating: 4.5, configuration: .compact) }
                )

                configRow(
                    title: "Large",
                    description: "Headline font size",
                    content: { ARCRatingView(rating: 4.5, configuration: .large) }
                )

                configRow(
                    title: "Heart",
                    description: "Pink heart icon",
                    content: { ARCRatingView(rating: 4.5, configuration: .heart) }
                )
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    func configRow<Content: View>(
        title: String,
        description: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            content()
        }
    }

    var customIconsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Icons")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                iconExample(icon: "star.fill", color: .yellow, label: "Star")
                iconExample(icon: "heart.fill", color: .pink, label: "Heart")
                iconExample(icon: "flame.fill", color: .orange, label: "Flame")
                iconExample(icon: "hand.thumbsup.fill", color: .blue, label: "Thumbs")
                iconExample(icon: "bolt.fill", color: .purple, label: "Bolt")
                iconExample(icon: "leaf.fill", color: .green, label: "Leaf")
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    func iconExample(icon: String, color: Color, label: String) -> some View {
        VStack(spacing: 8) {
            ARCRatingView(
                rating: 4.2,
                icon: icon,
                iconColor: color
            )
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    var usageExamplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usage Examples")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            VStack(spacing: 16) {
                // Restaurant card example
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "fork.knife")
                                .foregroundStyle(.orange)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Restaurant Name")
                            .font(.headline)
                        Text("Italian Cuisine • $$")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ARCRatingView(rating: 4.7)
                    }

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                // Book card example
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.pink.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "book.fill")
                                .foregroundStyle(.pink)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Book Title")
                            .font(.headline)
                        Text("Author Name")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ARCRatingView(rating: 4.9, configuration: .heart)
                    }

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                // App review example
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "app.fill")
                                .foregroundStyle(.blue)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("App Name")
                            .font(.headline)
                        Text("125K Reviews")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ARCRatingView(rating: 4.8, configuration: .large)
                    }

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
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
