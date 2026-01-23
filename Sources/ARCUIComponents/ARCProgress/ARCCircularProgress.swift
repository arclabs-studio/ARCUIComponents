//
//  ARCCircularProgress.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCCircularProgress

/// A circular progress indicator showing determinate or indeterminate progress
///
/// `ARCCircularProgress` displays task completion with a circular ring,
/// following Apple's Human Interface Guidelines for progress indicators.
///
/// ## Overview
///
/// Per Apple HIG: "Circular progress indicators have a track that fills in a
/// clockwise direction. An indeterminate progress indicator (spinner) uses
/// an animated image to indicate progress."
///
/// ARCCircularProgress provides:
/// - Determinate mode (arc fills based on progress 0.0-1.0)
/// - Indeterminate mode (spinning animation)
/// - Three size variants (small, medium, large)
/// - Optional centered percentage label
/// - Smooth animated transitions
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating Progress Views
///
/// - ``init(configuration:)``
/// - ``init(progress:configuration:)``
///
/// ## Usage
///
/// ```swift
/// // Indeterminate (spinner)
/// ARCCircularProgress()
///
/// // Determinate with progress
/// ARCCircularProgress(progress: 0.75)
///
/// // With centered percentage
/// ARCCircularProgress(
///     progress: 0.75,
///     configuration: .labeledProgress
/// )
///
/// // Small spinner
/// ARCCircularProgress(configuration: .small)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCircularProgress: View {
    // MARK: - Properties

    private let progress: Double?
    private let configuration: ARCCircularProgressConfiguration

    // MARK: - State

    @State private var rotation: Angle = .zero
    @State private var animatedProgress: Double = 0

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Computed Properties

    private var isIndeterminate: Bool {
        progress == nil
    }

    private var clampedProgress: Double {
        guard let progress else { return 0 }
        return min(max(progress, 0), 1)
    }

    // MARK: - Initialization

    /// Creates an indeterminate circular progress indicator (spinner)
    ///
    /// Shows a spinning animation indicating ongoing activity
    /// without a known completion percentage.
    ///
    /// - Parameter configuration: Visual configuration (default: .default)
    public init(
        configuration: ARCCircularProgressConfiguration = .default
    ) {
        progress = nil
        self.configuration = configuration
    }

    /// Creates a determinate circular progress indicator
    ///
    /// Shows a filling arc representing completion percentage.
    ///
    /// - Parameters:
    ///   - progress: Progress value from 0.0 (empty) to 1.0 (complete)
    ///   - configuration: Visual configuration (default: .default)
    public init(
        progress: Double,
        configuration: ARCCircularProgressConfiguration = .default
    ) {
        self.progress = progress
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Track (background circle)
            trackView

            // Progress arc
            if isIndeterminate {
                indeterminateView
            } else {
                determinateView
            }

            // Percentage label
            if configuration.showPercentage, !isIndeterminate {
                percentageLabel
            }
        }
        .frame(width: configuration.diameter, height: configuration.diameter)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(accessibilityValue)
    }

    // MARK: - Track View

    @ViewBuilder private var trackView: some View {
        Circle()
            .stroke(
                configuration.trackColor,
                style: StrokeStyle(
                    lineWidth: configuration.lineWidth,
                    lineCap: configuration.lineCap
                )
            )
    }

    // MARK: - Determinate View

    @ViewBuilder private var determinateView: some View {
        Circle()
            .trim(from: 0, to: animatedProgress)
            .stroke(
                configuration.progressColor,
                style: StrokeStyle(
                    lineWidth: configuration.lineWidth,
                    lineCap: configuration.lineCap
                )
            )
            .rotationEffect(configuration.startAngle)
            .animation(
                configuration.animated && !reduceMotion
                    ? .easeInOut(duration: configuration.animationDuration)
                    : .none,
                value: animatedProgress
            )
            .onAppear {
                animatedProgress = clampedProgress
            }
            .onChange(of: progress) { _, newValue in
                animatedProgress = min(max(newValue ?? 0, 0), 1)
            }
    }

    // MARK: - Indeterminate View

    @ViewBuilder private var indeterminateView: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                configuration.progressColor,
                style: StrokeStyle(
                    lineWidth: configuration.lineWidth,
                    lineCap: configuration.lineCap
                )
            )
            .rotationEffect(rotation)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    .linear(duration: configuration.rotationDuration)
                        .repeatForever(autoreverses: false)
                ) {
                    rotation = .degrees(360)
                }
            }
    }

    // MARK: - Percentage Label

    @ViewBuilder private var percentageLabel: some View {
        Text("\(Int(clampedProgress * 100))%")
            .font(configuration.percentageFont)
            .foregroundStyle(.primary)
            .contentTransition(.numericText())
            .animation(
                configuration.animated ? .easeInOut(duration: configuration.animationDuration) : .none,
                value: clampedProgress
            )
    }

    // MARK: - Accessibility

    private var accessibilityValue: String {
        if isIndeterminate {
            return "Loading"
        }
        return "\(Int(clampedProgress * 100)) percent"
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Determinate Progress") {
    HStack(spacing: 24) {
        ARCCircularProgress(progress: 0.25)
        ARCCircularProgress(progress: 0.50)
        ARCCircularProgress(progress: 0.75)
        ARCCircularProgress(progress: 1.0)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Indeterminate (Spinner)") {
    HStack(spacing: 24) {
        ARCCircularProgress(configuration: .small)
        ARCCircularProgress()
        ARCCircularProgress(configuration: .large)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Size Variants") {
    HStack(spacing: 24) {
        VStack(spacing: 8) {
            ARCCircularProgress(progress: 0.6, configuration: .small)
            Text("Small")
                .font(.caption)
        }

        VStack(spacing: 8) {
            ARCCircularProgress(progress: 0.6)
            Text("Medium")
                .font(.caption)
        }

        VStack(spacing: 8) {
            ARCCircularProgress(progress: 0.6, configuration: .large)
            Text("Large")
                .font(.caption)
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Percentage Label") {
    HStack(spacing: 24) {
        ARCCircularProgress(
            progress: 0.25,
            configuration: .labeledProgress
        )

        ARCCircularProgress(
            progress: 0.65,
            configuration: .labeledProgress
        )

        ARCCircularProgress(
            progress: 0.95,
            configuration: .labeledProgress
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Custom Colors") {
    HStack(spacing: 24) {
        ARCCircularProgress(
            progress: 0.6,
            configuration: ARCCircularProgressConfiguration(
                progressColor: .green
            )
        )

        ARCCircularProgress(
            progress: 0.6,
            configuration: ARCCircularProgressConfiguration(
                progressColor: .orange
            )
        )

        ARCCircularProgress(
            progress: 0.6,
            configuration: ARCCircularProgressConfiguration(
                progressColor: .red
            )
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Line Cap Styles") {
    HStack(spacing: 24) {
        VStack(spacing: 8) {
            ARCCircularProgress(
                progress: 0.6,
                configuration: ARCCircularProgressConfiguration(
                    size: .large,
                    lineCap: .round
                )
            )
            Text("Round")
                .font(.caption)
        }

        VStack(spacing: 8) {
            ARCCircularProgress(
                progress: 0.6,
                configuration: ARCCircularProgressConfiguration(
                    size: .large,
                    lineCap: .butt
                )
            )
            Text("Butt")
                .font(.caption)
        }

        VStack(spacing: 8) {
            ARCCircularProgress(
                progress: 0.6,
                configuration: ARCCircularProgressConfiguration(
                    size: .large,
                    lineCap: .square
                )
            )
            Text("Square")
                .font(.caption)
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    HStack(spacing: 24) {
        ARCCircularProgress(progress: 0.65)
        ARCCircularProgress()
        ARCCircularProgress(progress: 0.65, configuration: .labeledProgress)
    }
    .padding()
    .preferredColorScheme(.dark)
}
