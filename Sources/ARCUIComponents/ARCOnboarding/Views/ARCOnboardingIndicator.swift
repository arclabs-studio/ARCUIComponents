//
//  ARCOnboardingIndicator.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCOnboardingIndicator

/// Internal view for rendering page indicators
///
/// This view displays progress indicators for the onboarding flow,
/// supporting multiple visual styles (dots, lines, numbers, progress).
@available(iOS 17.0, macOS 14.0, *)
struct ARCOnboardingIndicator: View {
    // MARK: - Properties

    let totalPages: Int
    let currentPage: Int
    let style: ARCOnboardingConfiguration.IndicatorStyle
    let accentColor: Color

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .caption)
    private var dotSize: CGFloat = 8

    @ScaledMetric(relativeTo: .caption)
    private var lineWidth: CGFloat = 24

    @ScaledMetric(relativeTo: .caption)
    private var lineHeight: CGFloat = 4

    @ScaledMetric(relativeTo: .caption)
    private var spacing: CGFloat = 8

    // MARK: - Body

    var body: some View {
        Group {
            switch style {
            case .dots:
                dotsIndicator
            case .lines:
                linesIndicator
            case .numbers:
                numbersIndicator
            case .progress:
                progressIndicator
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
    }

    // MARK: - Dots Indicator

    @ViewBuilder private var dotsIndicator: some View {
        HStack(spacing: spacing) {
            ForEach(0 ..< totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? accentColor : accentColor.opacity(0.3))
                    .frame(
                        width: index == currentPage ? dotSize * 1.25 : dotSize,
                        height: index == currentPage ? dotSize * 1.25 : dotSize
                    )
                    .animation(
                        reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7),
                        value: currentPage
                    )
            }
        }
    }

    // MARK: - Lines Indicator

    @ViewBuilder private var linesIndicator: some View {
        HStack(spacing: spacing / 2) {
            ForEach(0 ..< totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? accentColor : accentColor.opacity(0.3))
                    .frame(
                        width: index == currentPage ? lineWidth * 1.5 : lineWidth,
                        height: lineHeight
                    )
                    .animation(
                        reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7),
                        value: currentPage
                    )
            }
        }
    }

    // MARK: - Numbers Indicator

    @ViewBuilder private var numbersIndicator: some View {
        Text("\(currentPage + 1) / \(totalPages)")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.secondary)
            .monospacedDigit()
    }

    // MARK: - Progress Indicator

    @ViewBuilder private var progressIndicator: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(accentColor.opacity(0.2))
                    .frame(height: lineHeight)

                Capsule()
                    .fill(accentColor)
                    .frame(
                        width: progressWidth(totalWidth: geometry.size.width),
                        height: lineHeight
                    )
                    .animation(
                        reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.8),
                        value: currentPage
                    )
            }
        }
        .frame(maxWidth: 200)
        .frame(height: lineHeight)
    }

    // MARK: - Helper Functions

    private func progressWidth(totalWidth: CGFloat) -> CGFloat {
        let progress = CGFloat(currentPage + 1) / CGFloat(totalPages)
        return totalWidth * progress
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        "Page indicator"
    }

    private var accessibilityValue: String {
        "Page \(currentPage + 1) of \(totalPages)"
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Indicator Styles") {
    VStack(spacing: 40) {
        Group {
            VStack(spacing: 8) {
                Text("Dots")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCOnboardingIndicator(
                    totalPages: 5,
                    currentPage: 2,
                    style: .dots,
                    accentColor: .blue
                )
            }

            VStack(spacing: 8) {
                Text("Lines")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCOnboardingIndicator(
                    totalPages: 5,
                    currentPage: 2,
                    style: .lines,
                    accentColor: .blue
                )
            }

            VStack(spacing: 8) {
                Text("Numbers")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCOnboardingIndicator(
                    totalPages: 5,
                    currentPage: 2,
                    style: .numbers,
                    accentColor: .blue
                )
            }

            VStack(spacing: 8) {
                Text("Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ARCOnboardingIndicator(
                    totalPages: 5,
                    currentPage: 2,
                    style: .progress,
                    accentColor: .blue
                )
            }
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("All Pages - Dots") {
    VStack(spacing: 20) {
        ForEach(0 ..< 5) { page in
            ARCOnboardingIndicator(
                totalPages: 5,
                currentPage: page,
                style: .dots,
                accentColor: .purple
            )
        }
    }
    .padding()
}
