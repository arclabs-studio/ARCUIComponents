//
//  ARCFavoriteButtonDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCFavoriteButton component.
///
/// Shows the favorite button in various sizes and configurations.
struct ARCFavoriteButtonDemoScreen: View {
    // MARK: Properties

    @State private var favorites: [String: Bool] = [
        "small": false,
        "medium": true,
        "large": false,
        "custom": true
    ]

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Size Comparison
                sizeComparisonSection

                // Interactive Demo
                interactiveDemoSection

                // In Context
                contextSection
            }
            .padding()
        }
        .navigationTitle("ARCFavoriteButton")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: Sections

    private var sizeComparisonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sizes")
                .font(.headline)

            HStack(spacing: 32) {
                VStack {
                    ARCFavoriteButton(
                        isFavorite: binding(for: "small"),
                        size: .small
                    )
                    Text("Small")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    ARCFavoriteButton(
                        isFavorite: binding(for: "medium"),
                        size: .medium
                    )
                    Text("Medium")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    ARCFavoriteButton(
                        isFavorite: binding(for: "large"),
                        size: .large
                    )
                    Text("Large")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var interactiveDemoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive")
                .font(.headline)

            VStack(spacing: 16) {
                ARCFavoriteButton(
                    isFavorite: binding(for: "custom"),
                    configuration: ARCFavoriteButtonConfiguration(
                        favoriteColor: .pink,
                        unfavoriteColor: .gray,
                        size: .large,
                        animationDuration: 0.3,
                        hapticFeedback: true
                    )
                ) { isFavorite in
                    print("Favorite changed: \(isFavorite)")
                }

                Text(favorites["custom"] == true ? "Favorited!" : "Tap to favorite")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut, value: favorites["custom"])
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Context")
                .font(.headline)

            // Sample Card
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.blue)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Sample Item")
                        .font(.headline)

                    Text("Description text here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                ARCFavoriteButton(
                    isFavorite: .constant(true),
                    size: .medium
                )
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Helpers

    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { favorites[key] ?? false },
            set: { favorites[key] = $0 }
        )
    }
}

#Preview {
    NavigationStack {
        ARCFavoriteButtonDemoScreen()
    }
}
