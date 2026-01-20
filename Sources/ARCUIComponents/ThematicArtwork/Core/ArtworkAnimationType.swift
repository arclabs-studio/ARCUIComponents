//
//  ArtworkAnimationType.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ArtworkAnimationType

/// The type of animation to apply to a thematic artwork.
///
/// Use these animation types with `ARCThemedArtworkView` or `ARCThemedLoaderView`
/// to create engaging loading states or visual effects.
///
/// ## Animation Types
/// - `.spin` - Continuous 360° rotation
/// - `.pulse` - Subtle scale pulsing effect
/// - `.shimmer` - Horizontal light sweep effect
/// - `.breathe` - Opacity fading effect
public enum ArtworkAnimationType: Sendable, CaseIterable {
    /// Continuous rotation animation, ideal for loading states.
    case spin

    /// Subtle scale pulsing effect.
    case pulse

    /// Horizontal shimmer/shine effect.
    case shimmer

    /// Gentle opacity breathing effect.
    case breathe
}

// MARK: - Animation Descriptions

extension ArtworkAnimationType {
    /// A human-readable name for the animation type.
    public var displayName: String {
        switch self {
        case .spin:
            "Spin"
        case .pulse:
            "Pulse"
        case .shimmer:
            "Shimmer"
        case .breathe:
            "Breathe"
        }
    }

    /// A description of the animation effect.
    public var description: String {
        switch self {
        case .spin:
            "Continuous 360° rotation"
        case .pulse:
            "Subtle scale pulsing"
        case .shimmer:
            "Horizontal light sweep"
        case .breathe:
            "Gentle opacity fading"
        }
    }
}
