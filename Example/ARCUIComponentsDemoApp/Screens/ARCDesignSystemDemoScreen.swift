//
//  ARCDesignSystemDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 24/1/2026.
//

import ARCDesignSystem
import ARCUIComponents
import SwiftUI

/// Demo screen showcasing ARC Labs Studio brand assets and typography.
///
/// This screen demonstrates the usage of ARCDesignSystem components
/// including brand assets, typography, animation tokens, and color tokens.
struct ARCDesignSystemDemoScreen: View {
    // MARK: - State

    @State private var animationDemoValue = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: .arcSpacingXLarge) {
                animationTokensSection
                typographySection
                brandColorsSection
                iconsSection
                logosSection
                wordmarksSection
            }
            .padding(.arcPaddingSection)
        }
        .background(Color.arcBackgroundPrimary)
        .navigationTitle("ARCDesignSystem")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Private Views

extension ARCDesignSystemDemoScreen {
    // MARK: - Animation Tokens Section

    private var animationTokensSection: some View {
        sectionContainer(title: "Animation Tokens", icon: "wand.and.stars") {
            VStack(alignment: .leading, spacing: .arcSpacingLarge) {
                Text("Tap the circles to see each animation style")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: .arcSpacingMedium
                ) {
                    animationDemoItem(name: "Standard", animation: .arcStandard)
                    animationDemoItem(name: "Quick", animation: .arcQuick)
                    animationDemoItem(name: "Smooth", animation: .arcSmooth)
                    animationDemoItem(name: "Slow", animation: .arcSlow)
                    animationDemoItem(name: "Spring", animation: .arcSpring)
                    animationDemoItem(name: "Bouncy", animation: .arcBouncy)
                    animationDemoItem(name: "Gentle", animation: .arcGentle)
                    animationDemoItem(name: "Snappy", animation: .arcSnappy)
                }

                Divider()

                VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                    Text("Usage")
                        .font(.subheadline.bold())

                    Text("""
                    // View modifier
                    .arcAnimation(.arcSpring, value: isExpanded)

                    // WithAnimation helper
                    arcWithAnimation(.arcBouncy) {
                        showMenu.toggle()
                    }
                    """)
                    .font(.caption.monospaced())
                    .padding(.arcSpacingSmall)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.arcBackgroundTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
                }
            }
        }
    }

    private func animationDemoItem(name: String, animation: Animation) -> some View {
        AnimationDemoCard(name: name, animation: animation)
    }

    // MARK: - Typography Section

    private var typographySection: some View {
        sectionContainer(title: "Typography", icon: "textformat") {
            VStack(alignment: .leading, spacing: .arcSpacingMedium) {
                Text("Radley Sans — Brand Font")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                    typographyRow(.largeTitle, name: "Large Title")
                    typographyRow(.title, name: "Title")
                    typographyRow(.title2, name: "Title 2")
                    typographyRow(.title3, name: "Title 3")
                    typographyRow(.headline, name: "Headline")
                    typographyRow(.body, name: "Body")
                    typographyRow(.callout, name: "Callout")
                    typographyRow(.subheadline, name: "Subheadline")
                    typographyRow(.footnote, name: "Footnote")
                    typographyRow(.caption, name: "Caption")
                }
            }
        }
    }

    private func typographyRow(_ style: Font.TextStyle, name: String) -> some View {
        HStack {
            Text("ARC Labs Studio")
                .font(.arcBrandFont(style))
                .lineLimit(1)

            Spacer()

            Text(name)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }

    private var brandColorsSection: some View {
        sectionContainer(title: "Brand Colors", icon: "paintpalette") {
            VStack(spacing: .arcSpacingMedium) {
                colorRow(color: .arcBrandBurgundy, name: "Burgundy", hex: "#722F37")
                colorRow(color: .arcBrandGold, name: "Gold", hex: "#D4AF37")
                colorRow(color: .arcBrandBlack, name: "Black", hex: "#1C1C1E")
            }
        }
    }

    private func colorRow(color: Color, name: String, hex: String) -> some View {
        HStack(spacing: .arcSpacingMedium) {
            RoundedRectangle(cornerRadius: .arcCornerRadiusSmall)
                .fill(color)
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: .arcCornerRadiusSmall)
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)

                Text(hex)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(".arcBrand\(name)")
                .font(.caption2.monospaced())
                .foregroundStyle(.tertiary)
        }
        .padding(.arcSpacingSmall)
        .background(Color.arcBackgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
    }

    private var iconsSection: some View {
        sectionContainer(title: "Icons & Symbols", icon: "app") {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 100, maximum: 150), spacing: .arcSpacingMedium)
                ],
                spacing: .arcSpacingMedium
            ) {
                ForEach(ARCBrandAsset.icons + ARCBrandAsset.symbols, id: \.rawValue) { asset in
                    assetGridItem(asset: asset, variant: .burgundy)
                }
            }
        }
    }

    private var logosSection: some View {
        sectionContainer(title: "Logos", icon: "rectangle.stack") {
            VStack(spacing: .arcSpacingMedium) {
                ForEach(ARCBrandAsset.logos.prefix(4), id: \.rawValue) { asset in
                    logoRow(asset: asset)
                }
            }
        }
    }

    private func logoRow(asset: ARCBrandAsset) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text(asset.description)
                .font(.subheadline)
                .fontWeight(.medium)

            asset.image(variant: .burgundy)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 50)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.arcSpacingMedium)
        .background(Color.arcBackgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
    }

    private var wordmarksSection: some View {
        sectionContainer(title: "Wordmarks & Badges", icon: "character") {
            VStack(spacing: .arcSpacingMedium) {
                ForEach(ARCBrandAsset.wordmarks + ARCBrandAsset.badges, id: \.rawValue) { asset in
                    wordmarkRow(asset: asset)
                }
            }
        }
    }

    private func wordmarkRow(asset: ARCBrandAsset) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            HStack {
                Text(asset.description)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                Text("Burgundy")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            asset.image(variant: .burgundy)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 60)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.arcSpacingMedium)
        .background(Color.arcBackgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
    }

    private func assetGridItem(asset: ARCBrandAsset, variant: ARCBrandColorVariant) -> some View {
        VStack(spacing: .arcSpacingSmall) {
            asset.image(variant: variant)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)

            Text(asset.description)
                .font(.caption2)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.arcSpacingSmall)
        .background(Color.arcBackgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
    }

    @ViewBuilder
    private func sectionContainer(
        title: String,
        icon: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            Label(title, systemImage: icon)
                .font(.title2.bold())
                .foregroundStyle(.primary)

            content()
        }
        .padding(.arcPaddingCard)
        .background(Color.arcBackgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusLarge))
    }
}

// MARK: - Animation Demo Card

private struct AnimationDemoCard: View {
    let name: String
    let animation: Animation

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: .arcSpacingSmall) {
            Circle()
                .fill(Color.arcBrandBurgundy.gradient)
                .frame(width: 40, height: 40)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .animation(animation, value: isAnimating)

            Text(name)
                .font(.caption)
                .fontWeight(.medium)

            Text(".arc\(name)")
                .font(.caption2.monospaced())
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.arcSpacingMedium)
        .background(Color.arcBackgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: .arcCornerRadiusSmall))
        .onTapGesture {
            isAnimating.toggle()
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCDesignSystemDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCDesignSystemDemoScreen()
    }
    .preferredColorScheme(.dark)
}
