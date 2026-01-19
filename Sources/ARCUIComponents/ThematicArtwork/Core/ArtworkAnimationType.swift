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
/// Use these animation types with `ThemedArtworkView` or `ThemedLoaderView`
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

public extension ArtworkAnimationType {

    /// A human-readable name for the animation type.
    var displayName: String {
        switch self {
        case .spin:
            return "Spin"
        case .pulse:
            return "Pulse"
        case .shimmer:
            return "Shimmer"
        case .breathe:
            return "Breathe"
        }
    }

    /// A description of the animation effect.
    var description: String {
        switch self {
        case .spin:
            return "Continuous 360° rotation"
        case .pulse:
            return "Subtle scale pulsing"
        case .shimmer:
            return "Horizontal light sweep"
        case .breathe:
            return "Gentle opacity fading"
        }
    }
}
