//
//  ARCSkeletonShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSkeletonShowcase

/// A comprehensive showcase of all ARCSkeleton components
///
/// Use this view to preview all skeleton variants and configurations
/// in both light and dark modes.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSkeletonShowcase: View {
    // MARK: - State

    @State private var selectedSection: ShowcaseSection = .primitives
    @State private var isAnimating = true

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .arcSpacingXLarge) {
                    // Animation toggle
                    animationToggle

                    // Section picker
                    sectionPicker

                    // Content based on selection
                    switch selectedSection {
                    case .primitives:
                        primitivesSection
                    case .text:
                        textSection
                    case .cards:
                        cardsSection
                    case .layouts:
                        layoutsSection
                    }
                }
                .padding()
            }
            .navigationTitle("ARCSkeleton")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    // MARK: - Animation Toggle

    @ViewBuilder private var animationToggle: some View {
        Toggle("Shimmer Animation", isOn: $isAnimating)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Section Picker

    @ViewBuilder private var sectionPicker: some View {
        Picker("Section", selection: $selectedSection) {
            ForEach(ShowcaseSection.allCases, id: \.self) { section in
                Text(section.rawValue).tag(section)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Primitives Section

    @ViewBuilder private var primitivesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Shapes")

            showcaseRow("Rectangle") {
                ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                    shape: .rectangle,
                    size: .fixed(width: 80, height: 40),
                    shimmerEnabled: isAnimating
                ))
            }

            showcaseRow("Rounded Rectangle") {
                ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                    shape: .roundedRectangle(cornerRadius: 12),
                    size: .fixed(width: 80, height: 40),
                    shimmerEnabled: isAnimating
                ))
            }

            showcaseRow("Circle") {
                ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                    shape: .circle,
                    size: .fixed(width: 50, height: 50),
                    shimmerEnabled: isAnimating
                ))
            }

            showcaseRow("Capsule") {
                ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                    shape: .capsule,
                    size: .fixed(width: 100, height: 36),
                    shimmerEnabled: isAnimating
                ))
            }

            Divider()

            sectionHeader("Presets")

            HStack(spacing: .arcSpacingLarge) {
                VStack(spacing: .arcSpacingSmall) {
                    ARCSkeletonView(configuration: shimmerConfig(.avatarSmall))
                    Text("Small").font(.caption2).foregroundStyle(.secondary)
                }
                VStack(spacing: .arcSpacingSmall) {
                    ARCSkeletonView(configuration: shimmerConfig(.avatar))
                    Text("Medium").font(.caption2).foregroundStyle(.secondary)
                }
                VStack(spacing: .arcSpacingSmall) {
                    ARCSkeletonView(configuration: shimmerConfig(.avatarLarge))
                    Text("Large").font(.caption2).foregroundStyle(.secondary)
                }
            }

            showcaseRow("Icon") {
                ARCSkeletonView(configuration: shimmerConfig(.icon))
            }

            showcaseRow("Button") {
                ARCSkeletonView(configuration: shimmerConfig(.button))
            }

            showcaseRow("Image") {
                ARCSkeletonView(configuration: shimmerConfig(.image))
            }
        }
    }

    // MARK: - Text Section

    @ViewBuilder private var textSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Single Lines")

            showcaseRow("Text Small") {
                textSkeletonView(.textSmall, width: 200)
            }

            showcaseRow("Text") {
                textSkeletonView(.text, width: 250)
            }

            showcaseRow("Text Large") {
                textSkeletonView(.textLarge, width: 180)
            }

            Divider()

            sectionHeader("Multiple Lines")

            showcaseRow("2 Lines") {
                ARCSkeletonText(
                    lineCount: 2,
                    staggerDelay: isAnimating ? 0.05 : 0,
                    configuration: shimmerConfig(.text)
                )
            }

            showcaseRow("3 Lines (Default)") {
                ARCSkeletonText(
                    lineCount: 3,
                    staggerDelay: isAnimating ? 0.05 : 0,
                    configuration: shimmerConfig(.text)
                )
            }

            showcaseRow("Paragraph (4 lines)") {
                ARCSkeletonText(
                    lineCount: 4,
                    lastLineWidth: 0.6,
                    staggerDelay: isAnimating ? 0.05 : 0,
                    configuration: shimmerConfig(.text)
                )
            }

            Divider()

            sectionHeader("Presets")

            showcaseRow("Title") {
                ARCSkeletonText.title
            }

            showcaseRow("Subtitle") {
                ARCSkeletonText.subtitle
            }

            showcaseRow("Description") {
                ARCSkeletonText.description
            }
        }
    }

    // MARK: - Cards Section

    @ViewBuilder private var cardsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Card Presets")

            showcaseRow("Standard") {
                ARCSkeletonCard()
                    .frame(width: 200)
            }

            showcaseRow("Compact") {
                ARCSkeletonCard.compact
                    .frame(width: 180)
            }

            showcaseRow("Text Only") {
                ARCSkeletonCard.textOnly
                    .frame(width: 200)
            }

            showcaseRow("List Row") {
                ARCSkeletonCard.listRow
            }

            Divider()

            sectionHeader("Custom Options")

            showcaseRow("No Footer") {
                ARCSkeletonCard(
                    showImage: true,
                    showFooter: false
                )
                .frame(width: 200)
            }

            showcaseRow("Multiple Subtitles") {
                ARCSkeletonCard(
                    showImage: true,
                    subtitleLines: 2
                )
                .frame(width: 200)
            }
        }
    }

    // MARK: - Layouts Section

    @ViewBuilder private var layoutsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("List Row Pattern")

            listRowPattern

            Divider()

            sectionHeader("Grid Pattern")

            gridPattern

            Divider()

            sectionHeader("Profile Pattern")

            profilePattern

            Divider()

            sectionHeader("Article Pattern")

            articlePattern
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    private func showcaseRow(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            content()
        }
    }

    @ViewBuilder
    private func textSkeletonView(_ config: ARCSkeletonConfiguration, width: CGFloat) -> some View {
        ARCSkeletonView(configuration: shimmerConfig(config))
            .frame(width: width)
    }

    func shimmerConfig(_ base: ARCSkeletonConfiguration, delay: Double = 0) -> ARCSkeletonConfiguration {
        ARCSkeletonConfiguration(
            shape: base.shape,
            size: base.size,
            baseColor: base.baseColor,
            highlightColor: base.highlightColor,
            animationDuration: base.animationDuration,
            animationDelay: delay,
            shimmerEnabled: isAnimating
        )
    }
}

// MARK: - Showcase Section

@available(iOS 17.0, macOS 14.0, *)
extension ARCSkeletonShowcase {
    enum ShowcaseSection: String, CaseIterable {
        case primitives = "Primitives"
        case text = "Text"
        case cards = "Cards"
        case layouts = "Layouts"
    }
}

// MARK: - Layout Patterns

@available(iOS 17.0, macOS 14.0, *)
extension ARCSkeletonShowcase {
    @ViewBuilder var listRowPattern: some View {
        VStack(spacing: .arcSpacingMedium) {
            ForEach(0 ..< 3, id: \.self) { index in
                HStack(spacing: .arcSpacingMedium) {
                    ARCSkeletonView(configuration: shimmerConfig(.avatar, delay: Double(index) * 0.1))

                    VStack(alignment: .leading, spacing: .arcSpacingXSmall) {
                        ARCSkeletonView(configuration: shimmerConfig(.text, delay: Double(index) * 0.1 + 0.05))
                            .frame(width: 150)
                        ARCSkeletonView(configuration: shimmerConfig(.textSmall, delay: Double(index) * 0.1 + 0.1))
                            .frame(width: 100)
                    }

                    Spacer()

                    ARCSkeletonView(configuration: shimmerConfig(.icon, delay: Double(index) * 0.1 + 0.15))
                }
                .padding()
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    @ViewBuilder var gridPattern: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: .arcSpacingMedium) {
            ForEach(0 ..< 4, id: \.self) { _ in
                ARCSkeletonCard(
                    imageHeight: 100,
                    subtitleLines: 1,
                    showFooter: true
                )
            }
        }
    }

    @ViewBuilder var profilePattern: some View {
        VStack(spacing: .arcSpacingLarge) {
            // Profile header
            HStack(spacing: .arcSpacingMedium) {
                ARCSkeletonView(configuration: shimmerConfig(.avatarLarge))

                VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                    ARCSkeletonView(configuration: shimmerConfig(.textLarge))
                        .frame(width: 150)
                    ARCSkeletonView(configuration: shimmerConfig(.textSmall, delay: 0.05))
                        .frame(width: 120)
                }

                Spacer()
            }

            // Stats row
            HStack(spacing: .arcSpacingXLarge) {
                ForEach(0 ..< 3, id: \.self) { index in
                    VStack(spacing: .arcSpacingXSmall) {
                        ARCSkeletonView(configuration: shimmerConfig(.textLarge, delay: Double(index) * 0.05))
                            .frame(width: 40)
                        ARCSkeletonView(configuration: shimmerConfig(.textSmall, delay: Double(index) * 0.05 + 0.05))
                            .frame(width: 60)
                    }
                }
            }

            // Bio
            ARCSkeletonText(
                lineCount: 3,
                lastLineWidth: 0.7,
                configuration: shimmerConfig(.text, delay: 0.2)
            )
        }
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder var articlePattern: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            // Hero image
            ARCSkeletonView(configuration: shimmerConfig(.image))

            // Title
            ARCSkeletonView(configuration: shimmerConfig(.textLarge, delay: 0.1))
            ARCSkeletonView(configuration: shimmerConfig(.textLarge, delay: 0.15))
                .frame(width: 200)

            // Meta info
            HStack(spacing: .arcSpacingMedium) {
                ARCSkeletonView(configuration: shimmerConfig(.avatarSmall, delay: 0.2))
                ARCSkeletonView(configuration: shimmerConfig(.textSmall, delay: 0.25))
                    .frame(width: 100)
                Spacer()
                ARCSkeletonView(configuration: shimmerConfig(.textSmall, delay: 0.3))
                    .frame(width: 80)
            }

            Divider()

            // Article body
            ARCSkeletonText(
                lineCount: 5,
                lastLineWidth: 0.5,
                configuration: shimmerConfig(.text, delay: 0.35)
            )
        }
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Preview

#Preview("Showcase") {
    ARCSkeletonShowcase()
}

#Preview("Showcase - Dark") {
    ARCSkeletonShowcase()
        .preferredColorScheme(.dark)
}
