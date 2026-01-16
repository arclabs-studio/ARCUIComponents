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
                sizeComparisonSection
                interactiveDemoSection
                contextSection
            }
            .padding()
        }
        .navigationTitle("ARCFavoriteButton")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

private extension ARCFavoriteButtonDemoScreen {

    var sizeComparisonSection: some View {
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
            .background(Color.arcBrandBurgundy.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var interactiveDemoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive")
                .font(.headline)

            VStack(spacing: 16) {
                ARCFavoriteButton(
                    isFavorite: binding(for: "custom"),
                    configuration: ARCFavoriteButtonConfiguration(
                        favoriteColor: .arcBrandBurgundy,
                        unfavoriteColor: .gray,
                        size: .large,
                        animationDuration: 0.3,
                        hapticFeedback: true
                    )
                )

                Text(favorites["custom"] == true ? "Favorited!" : "Tap to favorite")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut, value: favorites["custom"])
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color.arcBrandGold.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var contextSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Context")
                .font(.headline)

            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.arcBrandBurgundy.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(Color.arcBrandBurgundy)
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
            .background(Color.arcBrandBlack.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Private Functions

private extension ARCFavoriteButtonDemoScreen {

    func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { favorites[key] ?? false },
            set: { favorites[key] = $0 }
        )
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCFavoriteButtonDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCFavoriteButtonDemoScreen()
    }
    .preferredColorScheme(.dark)
}
