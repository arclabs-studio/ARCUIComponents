//
//  ARCLinearProgress.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCLinearProgress

/// A horizontal progress bar showing determinate or indeterminate progress
///
/// `ARCLinearProgress` displays task completion with a filling track,
/// following Apple's Human Interface Guidelines for progress indicators.
///
/// ## Overview
///
/// Per Apple HIG: "Progress bars include a track that fills from the leading
/// side to the trailing side. When possible, use a determinate progress indicator.
/// An indeterminate progress indicator shows that a process is occurring, but
/// it doesn't help people estimate how long a task will take."
///
/// ARCLinearProgress provides:
/// - Determinate mode (known progress 0.0-1.0)
/// - Indeterminate mode (animated shimmer)
/// - Three height variants (thin, default, thick)
/// - Optional percentage label
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
/// // Indeterminate (loading)
/// ARCLinearProgress()
///
/// // Determinate with progress
/// ARCLinearProgress(progress: 0.65)
///
/// // With percentage label
/// ARCLinearProgress(
///     progress: downloadProgress,
///     configuration: .withPercentage
/// )
///
/// // Thick variant
/// ARCLinearProgress(
///     progress: 0.75,
///     configuration: .thick
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCLinearProgress: View {
    // MARK: - Properties

    private let progress: Double?
    private let configuration: ARCLinearProgressConfiguration

    // MARK: - State

    @State private var indeterminateOffset: CGFloat = -1.0
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

    /// Creates an indeterminate linear progress indicator
    ///
    /// Shows an animated shimmer effect indicating ongoing activity
    /// without a known completion percentage.
    ///
    /// - Parameter configuration: Visual configuration (default: .default)
    public init(
        configuration: ARCLinearProgressConfiguration = .default
    ) {
        progress = nil
        self.configuration = configuration
    }

    /// Creates a determinate linear progress indicator
    ///
    /// Shows a filled track representing completion percentage.
    ///
    /// - Parameters:
    ///   - progress: Progress value from 0.0 (empty) to 1.0 (complete)
    ///   - configuration: Visual configuration (default: .default)
    public init(
        progress: Double,
        configuration: ARCLinearProgressConfiguration = .default
    ) {
        self.progress = progress
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            progressBar

            if configuration.showPercentage, !isIndeterminate {
                percentageLabel
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(accessibilityValue)
    }

    // MARK: - Progress Bar

    @ViewBuilder private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track (background)
                trackView

                // Progress (foreground)
                if isIndeterminate {
                    indeterminateProgressView(width: geometry.size.width)
                } else {
                    determinateProgressView(width: geometry.size.width)
                }
            }
        }
        .frame(height: configuration.height)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
    }

    @ViewBuilder private var trackView: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(configuration.trackColor)
    }

    @ViewBuilder
    private func determinateProgressView(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(configuration.progressColor)
            .frame(width: width * animatedProgress)
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

    @ViewBuilder
    private func indeterminateProgressView(width: CGFloat) -> some View {
        let shimmerWidth = width * 0.3

        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        configuration.progressColor.opacity(0),
                        configuration.progressColor,
                        configuration.progressColor.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: shimmerWidth)
            .offset(x: indeterminateOffset * (width + shimmerWidth))
            .onAppear {
                guard !reduceMotion else {
                    indeterminateOffset = 0
                    return
                }
                withAnimation(
                    .linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    indeterminateOffset = 1.0
                }
            }
    }

    // MARK: - Percentage Label

    @ViewBuilder private var percentageLabel: some View {
        Text("\(Int(clampedProgress * 100))%")
            .font(configuration.percentageFont)
            .foregroundStyle(.secondary)
            .monospacedDigit()
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
    VStack(spacing: 24) {
        ARCLinearProgress(progress: 0.25)
        ARCLinearProgress(progress: 0.50)
        ARCLinearProgress(progress: 0.75)
        ARCLinearProgress(progress: 1.0)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Indeterminate Progress") {
    VStack(spacing: 24) {
        ARCLinearProgress()
        ARCLinearProgress(configuration: .thick)
        ARCLinearProgress(configuration: .thin)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Height Variants") {
    VStack(spacing: 24) {
        VStack(alignment: .leading, spacing: 4) {
            Text("Thin (2pt)")
                .font(.caption)
            ARCLinearProgress(progress: 0.6, configuration: .thin)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Default (4pt)")
                .font(.caption)
            ARCLinearProgress(progress: 0.6)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Thick (8pt)")
                .font(.caption)
            ARCLinearProgress(progress: 0.6, configuration: .thick)
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Percentage") {
    VStack(spacing: 24) {
        ARCLinearProgress(progress: 0.25, configuration: .withPercentage)
        ARCLinearProgress(progress: 0.50, configuration: .withPercentage)
        ARCLinearProgress(progress: 0.75, configuration: .withPercentage)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Custom Colors") {
    VStack(spacing: 24) {
        ARCLinearProgress(
            progress: 0.6,
            configuration: ARCLinearProgressConfiguration(
                progressColor: .green
            )
        )

        ARCLinearProgress(
            progress: 0.6,
            configuration: ARCLinearProgressConfiguration(
                progressColor: .orange
            )
        )

        ARCLinearProgress(
            progress: 0.6,
            configuration: ARCLinearProgressConfiguration(
                progressColor: .red
            )
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Glass Style") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 24) {
            ARCLinearProgress(configuration: .glass)
            ARCLinearProgress(progress: 0.65, configuration: .glass)
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    VStack(spacing: 24) {
        ARCLinearProgress(progress: 0.65)
        ARCLinearProgress()
    }
    .padding()
    .preferredColorScheme(.dark)
}
