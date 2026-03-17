//
//  SkeletonShimmerModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - SkeletonShimmerModifier

/// A view modifier optimized for skeleton loading animations
///
/// This modifier creates a shimmer effect specifically designed for skeleton views,
/// with support for accessibility preferences and customizable colors.
///
/// ## Overview
///
/// SkeletonShimmerModifier provides a horizontal shimmer animation that sweeps
/// across the content, creating a loading effect. It automatically respects
/// the user's reduced motion accessibility setting.
///
/// ## Features
///
/// - Customizable base and highlight colors
/// - Respects `accessibilityReduceMotion` setting
/// - Configurable animation duration and delay
/// - Optimized for performance with shared animation timing
///
/// ## Usage
///
/// ```swift
/// Rectangle()
///     .fill(Color.gray.opacity(0.3))
///     .skeletonShimmer()
///
/// // With custom colors
/// RoundedRectangle(cornerRadius: 8)
///     .skeletonShimmer(
///         baseColor: .gray.opacity(0.2),
///         highlightColor: .gray.opacity(0.1)
///     )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct SkeletonShimmerModifier: ViewModifier {
    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - State

    @State private var phase: CGFloat = 0

    // MARK: - Properties

    private let isActive: Bool
    private let baseColor: Color
    private let highlightColor: Color
    private let duration: Double
    private let delay: Double

    // MARK: - Initialization

    /// Creates a skeleton shimmer modifier
    ///
    /// - Parameters:
    ///   - isActive: Whether the shimmer animation is active (default: true)
    ///   - baseColor: Base color of the shimmer gradient edges
    ///   - highlightColor: Highlight color at the center of the shimmer
    ///   - duration: Duration of one shimmer cycle in seconds (default: 1.5)
    ///   - delay: Delay before starting animation (default: 0)
    public init(
        isActive: Bool = true,
        baseColor: Color = .clear,
        highlightColor: Color = .white.opacity(0.4),
        duration: Double = 1.5,
        delay: Double = 0
    ) {
        self.isActive = isActive
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.duration = duration
        self.delay = delay
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .overlay {
                if isActive, !reduceMotion {
                    shimmerOverlay
                }
            }
            .clipped()
            .onAppear {
                startAnimationIfNeeded()
            }
            .onChange(of: isActive) { _, newValue in
                handleActiveChange(newValue)
            }
            .accessibilityLabel(isActive ? "Loading" : "")
    }

    // MARK: - Shimmer Overlay

    @ViewBuilder private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    baseColor,
                    highlightColor,
                    baseColor
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width * 0.6)
            .offset(x: shimmerOffset(for: geometry.size.width))
            .blendMode(.sourceAtop)
        }
    }

    // MARK: - Animation Helpers

    private func shimmerOffset(for width: CGFloat) -> CGFloat {
        -width + (width * 2.6 * phase)
    }

    private func startAnimationIfNeeded() {
        guard isActive, !reduceMotion else { return }

        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animateShimmer()
            }
        } else {
            animateShimmer()
        }
    }

    private func animateShimmer() {
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            phase = 1
        }
    }

    private func handleActiveChange(_ newValue: Bool) {
        if newValue, !reduceMotion {
            phase = 0
            animateShimmer()
        } else {
            phase = 0
        }
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *)
extension View {
    /// Adds a skeleton shimmer effect to the view
    ///
    /// The shimmer creates a loading effect that sweeps across the content.
    /// Automatically disabled when the user has reduced motion enabled.
    ///
    /// - Parameters:
    ///   - isActive: Whether the shimmer is active (default: true)
    ///   - baseColor: Color at gradient edges (default: clear)
    ///   - highlightColor: Color at gradient center (default: white at 40% opacity)
    ///   - duration: Duration of one cycle in seconds (default: 1.5)
    ///   - delay: Delay before starting (default: 0)
    /// - Returns: A view with the shimmer effect applied
    public func skeletonShimmer(
        isActive: Bool = true,
        baseColor: Color = .clear,
        highlightColor: Color = .white.opacity(0.4),
        duration: Double = 1.5,
        delay: Double = 0
    ) -> some View {
        modifier(
            SkeletonShimmerModifier(
                isActive: isActive,
                baseColor: baseColor,
                highlightColor: highlightColor,
                duration: duration,
                delay: delay
            )
        )
    }

    /// Adds a skeleton shimmer effect using configuration
    ///
    /// - Parameter configuration: The skeleton configuration to use for animation settings
    /// - Returns: A view with the shimmer effect applied
    public func skeletonShimmer(configuration: ARCSkeletonConfiguration) -> some View {
        modifier(
            SkeletonShimmerModifier(
                isActive: configuration.shimmerEnabled,
                baseColor: .clear,
                highlightColor: configuration.highlightColor,
                duration: configuration.animationDuration,
                delay: configuration.animationDelay
            )
        )
    }
}

// MARK: - Preview

#Preview("Skeleton Shimmer Active") {
    VStack(spacing: 16) {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 16)
            .skeletonShimmer()

        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 200, height: 16)
            .skeletonShimmer(delay: 0.1)

        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 150, height: 16)
            .skeletonShimmer(delay: 0.2)
    }
    .padding()
}

#Preview("Skeleton Shimmer Inactive") {
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.gray.opacity(0.2))
        .frame(height: 16)
        .skeletonShimmer(isActive: false)
        .padding()
}
