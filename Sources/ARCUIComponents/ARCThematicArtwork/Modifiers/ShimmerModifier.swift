//
//  ShimmerModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ShimmerModifier

/// A view modifier that adds a horizontal shimmer/shine effect.
///
/// Use the `.shimmer()` modifier to add a loading or highlight effect
/// to any view. The shimmer creates a diagonal light sweep animation
/// that repeats continuously.
///
/// ## Example Usage
/// ```swift
/// PizzaArtwork()
///     .shimmer(isActive: isLoading)
///
/// // With custom duration
/// SushiArtwork()
///     .shimmer(isActive: true, duration: 2.0)
/// ```
public struct ShimmerModifier: ViewModifier {
    // MARK: - Properties

    @State private var phase: CGFloat = 0

    let isActive: Bool
    let duration: Double

    // MARK: - Initialization

    /// Creates a shimmer modifier.
    ///
    /// - Parameters:
    ///   - isActive: Whether the shimmer animation is active. Defaults to `true`.
    ///   - duration: The duration of one shimmer cycle in seconds. Defaults to `1.5`.
    public init(isActive: Bool = true, duration: Double = 1.5) {
        self.isActive = isActive
        self.duration = duration
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    if isActive {
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.4),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                        .blendMode(.screen)
                    }
                }
            }
            .clipped()
            .onAppear {
                guard isActive else { return }
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    phase = 0
                    withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                } else {
                    phase = 0
                }
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds a shimmer effect to the view.
    ///
    /// - Parameters:
    ///   - isActive: Whether the shimmer is active. Defaults to `true`.
    ///   - duration: The duration of one shimmer cycle. Defaults to `1.5` seconds.
    /// - Returns: A view with the shimmer effect applied.
    func shimmer(isActive: Bool = true, duration: Double = 1.5) -> some View {
        modifier(ShimmerModifier(isActive: isActive, duration: duration))
    }
}

// MARK: - Preview

#Preview("Shimmer Active") {
    RoundedRectangle(cornerRadius: 16)
        .fill(Color.gray.opacity(0.3))
        .frame(width: 200, height: 100)
        .shimmer()
        .padding()
}

#Preview("Shimmer Inactive") {
    RoundedRectangle(cornerRadius: 16)
        .fill(Color.gray.opacity(0.3))
        .frame(width: 200, height: 100)
        .shimmer(isActive: false)
        .padding()
}
