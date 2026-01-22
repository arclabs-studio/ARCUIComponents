//
//  ARCCarouselIndicator.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCCarouselIndicator

/// Internal view that displays page indicators for the carousel
///
/// Supports multiple indicator styles including dots, lines, and numbers.
/// Handles large item counts by showing a subset of indicators with scaling.
@available(iOS 17.0, macOS 14.0, *)
struct ARCCarouselIndicator: View {
    // MARK: - Properties

    let totalItems: Int
    let currentIndex: Int
    let style: ARCCarouselConfiguration.IndicatorStyle
    let maxVisibleDots: Int
    let accentColor: Color

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .caption)
    private var dotSize: CGFloat = 8

    @ScaledMetric(relativeTo: .caption)
    private var lineWidth: CGFloat = 24

    @ScaledMetric(relativeTo: .caption)
    private var lineHeight: CGFloat = 4

    @ScaledMetric(relativeTo: .caption)
    private var spacing: CGFloat = 6

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    init(
        totalItems: Int,
        currentIndex: Int,
        style: ARCCarouselConfiguration.IndicatorStyle,
        maxVisibleDots: Int = 7,
        accentColor: Color = .primary
    ) {
        self.totalItems = totalItems
        self.currentIndex = currentIndex
        self.style = style
        self.maxVisibleDots = maxVisibleDots
        self.accentColor = accentColor
    }

    // MARK: - Body

    var body: some View {
        switch style {
        case .none:
            EmptyView()

        case .dots:
            dotsIndicator

        case .lines:
            linesIndicator

        case .numbers:
            numbersIndicator
        }
    }

    // MARK: - Dots Indicator

    @ViewBuilder private var dotsIndicator: some View {
        HStack(spacing: spacing) {
            ForEach(visibleDotIndices, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? accentColor : accentColor.opacity(0.3))
                    .frame(width: dotSizeFor(index: index), height: dotSizeFor(index: index))
                    .animation(reduceMotion ? .none : .spring(response: 0.3), value: currentIndex)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(currentIndex + 1) of \(totalItems)")
    }

    // MARK: - Lines Indicator

    @ViewBuilder private var linesIndicator: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalItems, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? accentColor : accentColor.opacity(0.3))
                    .frame(width: lineWidth, height: lineHeight)
                    .animation(reduceMotion ? .none : .spring(response: 0.3), value: currentIndex)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(currentIndex + 1) of \(totalItems)")
    }

    // MARK: - Numbers Indicator

    @ViewBuilder private var numbersIndicator: some View {
        Text("\(currentIndex + 1) / \(totalItems)")
            .font(.caption.monospacedDigit())
            .foregroundStyle(.secondary)
            .accessibilityLabel("Page \(currentIndex + 1) of \(totalItems)")
    }

    // MARK: - Computed Properties

    /// Returns the indices of dots to display (for large item counts)
    private var visibleDotIndices: [Int] {
        guard totalItems > maxVisibleDots else {
            return Array(0..<totalItems)
        }

        // Calculate visible range centered on current index
        let halfVisible = maxVisibleDots / 2

        var start = currentIndex - halfVisible
        var end = currentIndex + halfVisible

        // Adjust if we're at the edges
        if start < 0 {
            start = 0
            end = maxVisibleDots - 1
        } else if end >= totalItems {
            end = totalItems - 1
            start = totalItems - maxVisibleDots
        }

        return Array(start...end)
    }

    /// Returns the size for a dot at the given index (smaller for edge dots)
    private func dotSizeFor(index: Int) -> CGFloat {
        guard totalItems > maxVisibleDots else {
            return dotSize
        }

        let visibleIndices = visibleDotIndices
        guard let position = visibleIndices.firstIndex(of: index) else {
            return dotSize * 0.5
        }

        // Scale down dots at the edges
        let distanceFromCenter = abs(position - maxVisibleDots / 2)
        let maxDistance = maxVisibleDots / 2

        if distanceFromCenter >= maxDistance {
            return dotSize * 0.6
        } else if distanceFromCenter == maxDistance - 1 {
            return dotSize * 0.8
        }

        return dotSize
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dots - Few Items") {
    VStack(spacing: 32) {
        ARCCarouselIndicator(
            totalItems: 5,
            currentIndex: 2,
            style: .dots
        )

        ARCCarouselIndicator(
            totalItems: 5,
            currentIndex: 0,
            style: .dots,
            accentColor: .blue
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dots - Many Items") {
    VStack(spacing: 32) {
        ARCCarouselIndicator(
            totalItems: 15,
            currentIndex: 7,
            style: .dots
        )

        ARCCarouselIndicator(
            totalItems: 15,
            currentIndex: 0,
            style: .dots
        )

        ARCCarouselIndicator(
            totalItems: 15,
            currentIndex: 14,
            style: .dots
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Lines") {
    ARCCarouselIndicator(
        totalItems: 4,
        currentIndex: 1,
        style: .lines,
        accentColor: .orange
    )
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Numbers") {
    ARCCarouselIndicator(
        totalItems: 10,
        currentIndex: 3,
        style: .numbers
    )
    .padding()
}
