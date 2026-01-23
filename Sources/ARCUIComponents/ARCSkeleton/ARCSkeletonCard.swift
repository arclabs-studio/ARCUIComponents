//
//  ARCSkeletonCard.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSkeletonCard

/// A skeleton placeholder matching ARCCard layout
///
/// `ARCSkeletonCard` provides a loading placeholder that mirrors the structure
/// of ``ARCCard``, ensuring smooth transitions between loading and loaded states
/// without layout shifts.
///
/// ## Overview
///
/// This component replicates ARCCard's layout with configurable sections:
/// - Image placeholder (optional)
/// - Title line
/// - Subtitle lines (configurable count)
/// - Footer placeholder (optional)
///
/// ## Topics
///
/// ### Creating Card Skeletons
///
/// - ``init(showImage:imageHeight:titleLines:subtitleLines:showFooter:configuration:)``
///
/// ### Presets
///
/// - ``standard``
/// - ``compact``
/// - ``imageOnly``
/// - ``textOnly``
///
/// ## Usage
///
/// ```swift
/// // Standard card skeleton
/// ARCSkeletonCard()
///
/// // Card without image
/// ARCSkeletonCard(showImage: false)
///
/// // Compact card skeleton
/// ARCSkeletonCard.compact
///
/// // In a grid
/// LazyVGrid(columns: columns) {
///     ForEach(0..<6, id: \.self) { _ in
///         ARCSkeletonCard()
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSkeletonCard: View {
    // MARK: - Properties

    private let showImage: Bool
    private let imageHeight: CGFloat
    private let titleLines: Int
    private let subtitleLines: Int
    private let showFooter: Bool
    private let cardConfiguration: ARCCardConfiguration

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var contentSpacing: CGFloat = .arcSpacingSmall

    @ScaledMetric(relativeTo: .body)
    private var contentPadding: CGFloat = .arcSpacingMedium

    @ScaledMetric(relativeTo: .caption)
    private var footerHeight: CGFloat = 20

    // MARK: - Initialization

    /// Creates a skeleton card with the specified options
    ///
    /// - Parameters:
    ///   - showImage: Whether to show image placeholder (default: true)
    ///   - imageHeight: Height of the image section (default: 140)
    ///   - titleLines: Number of title lines (default: 1)
    ///   - subtitleLines: Number of subtitle lines (default: 1)
    ///   - showFooter: Whether to show footer placeholder (default: true)
    ///   - configuration: Card appearance configuration (default: .default)
    public init(
        showImage: Bool = true,
        imageHeight: CGFloat = 140,
        titleLines: Int = 1,
        subtitleLines: Int = 1,
        showFooter: Bool = true,
        configuration: ARCCardConfiguration = .default
    ) {
        self.showImage = showImage
        self.imageHeight = imageHeight
        self.titleLines = max(1, titleLines)
        self.subtitleLines = max(0, subtitleLines)
        self.showFooter = showFooter
        cardConfiguration = configuration
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if showImage {
                imageSection
            }

            contentSection
        }
        .liquidGlass(configuration: cardConfiguration)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading card")
    }

    // MARK: - Image Section

    @ViewBuilder private var imageSection: some View {
        ARCSkeletonView(configuration: ARCSkeletonConfiguration(
            shape: .rectangle,
            size: .fill(height: imageHeight),
            animationDelay: 0
        ))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: cardConfiguration.cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: cardConfiguration.cornerRadius,
                style: .continuous
            )
        )
    }

    // MARK: - Content Section

    @ViewBuilder private var contentSection: some View {
        VStack(alignment: .leading, spacing: contentSpacing) {
            // Title
            titleSection

            // Subtitles
            subtitleSection

            // Footer
            if showFooter {
                Spacer(minLength: .arcSpacingXSmall)
                footerSection
            }
        }
        .padding(contentPadding)
    }

    @ViewBuilder private var titleSection: some View {
        ForEach(0 ..< titleLines, id: \.self) { index in
            ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                shape: .roundedRectangle(cornerRadius: 4),
                size: .flexible(minWidth: nil, maxWidth: nil, height: 18),
                animationDelay: 0.05 + Double(index) * 0.05
            ))
            .frame(maxWidth: index == titleLines - 1 ? 150 : .infinity)
        }
    }

    @ViewBuilder private var subtitleSection: some View {
        ForEach(0 ..< subtitleLines, id: \.self) { index in
            HStack(spacing: .arcSpacingXSmall) {
                // Icon placeholder
                ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                    shape: .roundedRectangle(cornerRadius: 2),
                    size: .fixed(width: 12, height: 12),
                    animationDelay: 0.1 + Double(index) * 0.05
                ))

                // Subtitle text
                ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                    shape: .roundedRectangle(cornerRadius: 4),
                    size: .flexible(minWidth: nil, maxWidth: nil, height: 14),
                    animationDelay: 0.1 + Double(index) * 0.05
                ))
                .frame(width: subtitleWidth(for: index))
            }
        }
    }

    @ViewBuilder private var footerSection: some View {
        HStack {
            // Left side placeholder
            ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                shape: .roundedRectangle(cornerRadius: 4),
                size: .fixed(width: 60, height: footerHeight),
                animationDelay: 0.2
            ))

            Spacer()

            // Right side placeholder (e.g., rating)
            ARCSkeletonView(configuration: ARCSkeletonConfiguration(
                shape: .roundedRectangle(cornerRadius: 4),
                size: .fixed(width: 50, height: footerHeight),
                animationDelay: 0.25
            ))
        }
    }

    // MARK: - Helpers

    private func subtitleWidth(for index: Int) -> CGFloat {
        // Vary subtitle widths for natural appearance
        let widths: [CGFloat] = [120, 100, 80, 90]
        return widths[index % widths.count]
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCSkeletonCard {
    /// Standard card skeleton with image, title, subtitle, and footer
    public static var standard: ARCSkeletonCard {
        ARCSkeletonCard()
    }

    /// Compact card skeleton with smaller image and minimal text
    public static var compact: ARCSkeletonCard {
        ARCSkeletonCard(
            imageHeight: 100,
            subtitleLines: 0,
            showFooter: false,
            configuration: .compact
        )
    }

    /// Image-only card skeleton
    public static var imageOnly: ARCSkeletonCard {
        ARCSkeletonCard(
            showImage: true,
            imageHeight: 180,
            titleLines: 0,
            subtitleLines: 0,
            showFooter: false
        )
    }

    /// Text-only card skeleton without image
    public static var textOnly: ARCSkeletonCard {
        ARCSkeletonCard(
            showImage: false,
            subtitleLines: 2,
            configuration: .textOnly
        )
    }

    /// List row card skeleton
    public static var listRow: ARCSkeletonCard {
        ARCSkeletonCard(
            showImage: false,
            titleLines: 1,
            subtitleLines: 1,
            showFooter: false
        )
    }
}

// MARK: - Preview

#Preview("Standard Card") {
    ARCSkeletonCard()
        .frame(width: 200)
        .padding()
}

#Preview("Presets") {
    ScrollView {
        VStack(spacing: 24) {
            Group {
                Text("Standard")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCSkeletonCard.standard
                    .frame(width: 200)
            }

            Group {
                Text("Compact")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCSkeletonCard.compact
                    .frame(width: 180)
            }

            Group {
                Text("Text Only")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCSkeletonCard.textOnly
                    .frame(width: 200)
            }

            Group {
                Text("List Row")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCSkeletonCard.listRow
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview("Grid Layout") {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: .arcSpacingLarge) {
        ForEach(0 ..< 4, id: \.self) { _ in
            ARCSkeletonCard(
                imageHeight: 100
            )
        }
    }
    .padding()
}

#Preview("List Layout") {
    List {
        ForEach(0 ..< 5, id: \.self) { _ in
            ARCSkeletonCard.listRow
                .listRowInsets(EdgeInsets(
                    top: 8,
                    leading: 16,
                    bottom: 8,
                    trailing: 16
                ))
        }
    }
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        ARCSkeletonCard.standard
            .frame(width: 200)

        ARCSkeletonCard.textOnly
            .frame(width: 200)
    }
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Loading to Loaded Transition") {
    struct TransitionDemo: View {
        @State private var isLoading = true

        var body: some View {
            VStack(spacing: 20) {
                if isLoading {
                    ARCSkeletonCard()
                        .frame(width: 200)
                } else {
                    ARCCard(
                        title: "Restaurant Name",
                        subtitle: "Italian Cuisine",
                        subtitleIcon: "fork.knife"
                    ) {
                        LinearGradient(
                            colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 140)
                    } footer: {
                        ARCRatingView(rating: 4.5)
                    }
                    .frame(width: 200)
                }

                Button(isLoading ? "Show Content" : "Show Skeleton") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLoading.toggle()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }

    return TransitionDemo()
}
