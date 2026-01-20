//
//  ThematicArtworkDemoScreen.swift
//  ARCUIComponentsDemoApp
//
//  Created by ARC Labs Studio on 19/1/2026.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for Thematic Artwork components.
///
/// Shows themed visual placeholders and loaders with interactive configuration options.
/// Demonstrates how to use the generic artwork system with custom artwork types.
struct ThematicArtworkDemoScreen: View {

    // MARK: Properties

    @State private var selectedArtwork: ExampleArtwork = .circles
    @State private var isAnimating: Bool = false
    @State private var selectedAnimation: ArtworkAnimationType = .spin

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                configurationSection
                previewSection
                allArtworksSection
                useCasesSection
                loaderSizesSection
            }
            .padding()
        }
        .navigationTitle("Thematic Artwork")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Private Views

private extension ThematicArtworkDemoScreen {

    // MARK: Configuration Section

    var configurationSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Configuration")

            VStack(spacing: 12) {
                artworkPicker
                animationToggle

                if isAnimating {
                    animationPicker
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var artworkPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Artwork Style")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Style", selection: $selectedArtwork) {
                ForEach(ExampleArtwork.allCases, id: \.self) { artwork in
                    Text(artwork.displayName).tag(artwork)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var animationToggle: some View {
        Toggle("Animate", isOn: $isAnimating.animation(.easeInOut))
    }

    var animationPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Animation Type")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Animation", selection: $selectedAnimation) {
                ForEach(ArtworkAnimationType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: Preview Section

    var previewSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Preview")

            VStack(spacing: 12) {
                GenericThemedArtworkView(
                    type: selectedArtwork,
                    isAnimating: isAnimating,
                    animationType: selectedAnimation
                )
                .frame(width: 150, height: 150)

                Text(selectedArtwork.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Example Artwork")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: All Artworks Section

    var allArtworksSection: some View {
        VStack(spacing: 16) {
            sectionHeader("All Artwork Styles")

            HStack(spacing: 24) {
                ForEach(ExampleArtwork.allCases, id: \.self) { artwork in
                    VStack(spacing: 8) {
                        GenericThemedArtworkView(
                            type: artwork,
                            isAnimating: isAnimating,
                            animationType: selectedAnimation
                        )
                        .frame(width: 80, height: 80)

                        Text(artwork.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Use Cases Section

    var useCasesSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Use Cases")

            VStack(spacing: 16) {
                useCaseCard(
                    title: "Loading State",
                    description: "Use as a themed loading indicator",
                    icon: "hourglass"
                ) {
                    HStack(spacing: 16) {
                        ForEach(ExampleArtwork.allCases, id: \.self) { artwork in
                            GenericThemedLoaderView(type: artwork, size: 40)
                        }
                    }
                }

                useCaseCard(
                    title: "Placeholder",
                    description: "Use as image placeholder while content loads",
                    icon: "photo"
                ) {
                    HStack(spacing: 12) {
                        ForEach(ExampleArtwork.allCases, id: \.self) { artwork in
                            GenericThemedArtworkView(type: artwork)
                                .frame(width: 60, height: 60)
                        }
                    }
                }

                useCaseCard(
                    title: "Empty State",
                    description: "Use to illustrate empty categories",
                    icon: "tray"
                ) {
                    VStack(spacing: 8) {
                        GenericThemedArtworkView(type: ExampleArtwork.circles)
                            .frame(width: 80, height: 80)
                        Text("No items yet")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: Loader Sizes Section

    var loaderSizesSection: some View {
        VStack(spacing: 16) {
            sectionHeader("Loader Sizes")

            HStack(spacing: 24) {
                loaderSize(32, label: "Small")
                loaderSize(48, label: "Medium")
                loaderSize(64, label: "Large")
                loaderSize(80, label: "XLarge")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Helper Views

    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
        }
    }

    func useCaseCard<Content: View>(
        title: String,
        description: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(Color.arcBrandBurgundy)
                Text(title)
                    .font(.subheadline.bold())
            }

            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)

            content()
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    func loaderSize(_ size: CGFloat, label: String) -> some View {
        VStack(spacing: 8) {
            GenericThemedLoaderView(type: ExampleArtwork.circles, size: size)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ThematicArtworkDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ThematicArtworkDemoScreen()
    }
    .preferredColorScheme(.dark)
}
