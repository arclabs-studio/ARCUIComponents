//
//  AnimationModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - AnimationModifier

/// A view modifier that applies artwork animations based on the specified type.
///
/// This modifier is used internally by `ThemedArtworkView` to apply
/// rotation, scale, or opacity animations to thematic artworks.
struct AnimationModifier: ViewModifier {

    // MARK: - Properties

    let type: ArtworkAnimationType
    let isActive: Bool
    let progress: Double

    // MARK: - Body

    func body(content: Content) -> some View {
        switch type {
        case .spin:
            content
                .rotationEffect(.degrees(progress * 360))

        case .pulse:
            content
                .scaleEffect(1 + (0.05 * sin(progress * .pi * 2)))

        case .shimmer:
            content

        case .breathe:
            content
                .opacity(0.7 + (0.3 * sin(progress * .pi * 2)))
        }
    }
}

// MARK: - View Extension

extension View {

    /// Applies an artwork animation to the view.
    ///
    /// - Parameters:
    ///   - type: The type of animation to apply.
    ///   - isActive: Whether the animation is currently active.
    ///   - progress: The animation progress from 0 to 1.
    /// - Returns: A view with the animation applied.
    func artworkAnimation(
        type: ArtworkAnimationType,
        isActive: Bool,
        progress: Double
    ) -> some View {
        modifier(AnimationModifier(type: type, isActive: isActive, progress: progress))
    }
}
