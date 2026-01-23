//
//  ARCSkeletonText.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSkeletonText

/// A skeleton placeholder for multiple lines of text
///
/// `ARCSkeletonText` creates a realistic text placeholder with multiple lines,
/// where the last line can be shorter to mimic natural text endings.
///
/// ## Overview
///
/// This component is useful for placeholder content in list rows, articles,
/// descriptions, and other text-heavy layouts. Each line animates with a
/// staggered shimmer effect for a natural loading appearance.
///
/// ## Topics
///
/// ### Creating Text Skeletons
///
/// - ``init(lineCount:lineHeight:lineSpacing:lastLineWidth:configuration:)``
///
/// ### Presets
///
/// - ``paragraph``
/// - ``title``
/// - ``subtitle``
///
/// ## Usage
///
/// ```swift
/// // Simple 3-line text skeleton
/// ARCSkeletonText(lineCount: 3)
///
/// // Paragraph with last line at 60% width
/// ARCSkeletonText(lineCount: 4, lastLineWidth: 0.6)
///
/// // Custom configuration
/// ARCSkeletonText(
///     lineCount: 2,
///     lineHeight: 20,
///     lineSpacing: 8,
///     configuration: .textLarge
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSkeletonText: View {
    // MARK: - Properties

    private let lineCount: Int
    private let lineHeight: CGFloat
    private let lineSpacing: CGFloat
    private let lastLineWidth: CGFloat
    private let configuration: ARCSkeletonConfiguration
    private let staggerDelay: Double

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var scaledLineHeight: CGFloat = 16

    @ScaledMetric(relativeTo: .body)
    private var scaledLineSpacing: CGFloat = 8

    // MARK: - Initialization

    /// Creates a text skeleton with the specified parameters
    ///
    /// - Parameters:
    ///   - lineCount: Number of text lines to display (default: 3)
    ///   - lineHeight: Height of each line in points (default: 16)
    ///   - lineSpacing: Vertical spacing between lines (default: 8)
    ///   - lastLineWidth: Width of last line as percentage 0-1 (default: 0.7)
    ///   - staggerDelay: Delay between each line's animation (default: 0.05)
    ///   - configuration: Base configuration for the skeleton (default: .text)
    public init(
        lineCount: Int = 3,
        lineHeight: CGFloat = 16,
        lineSpacing: CGFloat = 8,
        lastLineWidth: CGFloat = 0.7,
        staggerDelay: Double = 0.05,
        configuration: ARCSkeletonConfiguration = .text
    ) {
        self.lineCount = max(1, lineCount)
        self.lineHeight = lineHeight
        self.lineSpacing = lineSpacing
        self.lastLineWidth = min(max(lastLineWidth, 0.1), 1.0)
        self.staggerDelay = staggerDelay
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: scaledLineSpacing) {
            ForEach(0 ..< lineCount, id: \.self) { index in
                lineView(at: index)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading text content")
    }

    // MARK: - Line View

    @ViewBuilder
    private func lineView(at index: Int) -> some View {
        let isLastLine = index == lineCount - 1
        let lineConfig = lineConfiguration(at: index)

        ARCSkeletonView(configuration: lineConfig)
            .frame(maxWidth: isLastLine ? .infinity : .infinity, alignment: .leading)
            .frame(maxWidth: isLastLine ? lastLineMaxWidth : .infinity)
    }

    private func lineConfiguration(at index: Int) -> ARCSkeletonConfiguration {
        ARCSkeletonConfiguration(
            shape: configuration.shape,
            size: .fill(height: scaledLineHeight),
            baseColor: configuration.baseColor,
            highlightColor: configuration.highlightColor,
            animationDuration: configuration.animationDuration,
            animationDelay: configuration.animationDelay + (Double(index) * staggerDelay),
            shimmerEnabled: configuration.shimmerEnabled
        )
    }

    private var lastLineMaxWidth: CGFloat? {
        // Return nil to use GeometryReader for percentage width
        nil
    }

    // Use GeometryReader to calculate percentage width
    @ViewBuilder
    private func lastLineView(at index: Int) -> some View {
        GeometryReader { geometry in
            ARCSkeletonView(configuration: lineConfiguration(at: index))
                .frame(width: geometry.size.width * lastLineWidth)
        }
        .frame(height: scaledLineHeight)
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCSkeletonText {
    /// Paragraph skeleton (4 lines, last line at 60%)
    ///
    /// Suitable for article or description placeholders.
    public static var paragraph: ARCSkeletonText {
        ARCSkeletonText(lineCount: 4, lastLineWidth: 0.6)
    }

    /// Title skeleton (single line, large)
    ///
    /// Suitable for headline placeholders.
    public static var title: ARCSkeletonText {
        ARCSkeletonText(
            lineCount: 1,
            lineHeight: 24,
            configuration: .textLarge
        )
    }

    /// Subtitle skeleton (single line, small)
    ///
    /// Suitable for secondary text placeholders.
    public static var subtitle: ARCSkeletonText {
        ARCSkeletonText(
            lineCount: 1,
            lineHeight: 14,
            lastLineWidth: 0.5,
            configuration: .textSmall
        )
    }

    /// Description skeleton (2 lines)
    ///
    /// Suitable for short description placeholders.
    public static var description: ARCSkeletonText {
        ARCSkeletonText(lineCount: 2, lastLineWidth: 0.8)
    }
}

// MARK: - Preview

#Preview("Default Text Skeleton") {
    ARCSkeletonText()
        .padding()
}

#Preview("Line Counts") {
    VStack(alignment: .leading, spacing: 32) {
        Group {
            Text("1 Line")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText(lineCount: 1)
        }

        Group {
            Text("2 Lines")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText(lineCount: 2)
        }

        Group {
            Text("3 Lines (Default)")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText(lineCount: 3)
        }

        Group {
            Text("5 Lines")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText(lineCount: 5, lastLineWidth: 0.5)
        }
    }
    .padding()
}

#Preview("Presets") {
    VStack(alignment: .leading, spacing: 32) {
        Group {
            Text("Title")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText.title
        }

        Group {
            Text("Subtitle")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText.subtitle
        }

        Group {
            Text("Description")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText.description
        }

        Group {
            Text("Paragraph")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonText.paragraph
        }
    }
    .padding()
}

#Preview("In List Row") {
    List {
        ForEach(0 ..< 5, id: \.self) { _ in
            HStack(spacing: 12) {
                ARCSkeletonView(configuration: .avatar)

                VStack(alignment: .leading, spacing: 4) {
                    ARCSkeletonText(lineCount: 1, lineHeight: 18)
                        .frame(width: 150)
                    ARCSkeletonText(lineCount: 1, lineHeight: 14, configuration: .textSmall)
                        .frame(width: 100)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview("Dark Mode") {
    VStack(alignment: .leading, spacing: 24) {
        ARCSkeletonText.title
        ARCSkeletonText.paragraph
    }
    .padding()
    .preferredColorScheme(.dark)
}
