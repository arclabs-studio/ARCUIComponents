//
//  AIGlowIntensity.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/19/26.
//

import SwiftUI

/// Intensity levels for the AI glow border effect
///
/// Controls the visual prominence of the animated glow around
/// AI recommendation cards. Each level defines halo, blur, and
/// stroke parameters for a cohesive appearance.
///
/// The glow uses two layers:
/// - **Ambient halo**: A filled gradient shape blurred outward to create
///   a wide, visible light spread (like Apple Music album art halos)
/// - **Crisp stroke**: A thin rotating gradient border for edge definition
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
@available(iOS 17.0, macOS 14.0, *)
public enum AIGlowIntensity: Sendable, Hashable {
    /// Subtle glow — noticeable ambient light, premium feel
    case subtle

    /// Standard glow — clearly visible halo filling lateral space
    case standard

    /// Prominent glow — strong visual emphasis, wide spread
    case prominent

    // MARK: - Halo Parameters (Ambient Glow)

    /// How far the filled halo shape expands beyond card bounds (pt)
    var haloExpand: CGFloat {
        switch self {
        case .subtle: 16
        case .standard: 24
        case .prominent: 32
        }
    }

    /// Blur radius for the ambient halo
    var haloBlurRadius: CGFloat {
        switch self {
        case .subtle: 16
        case .standard: 22
        case .prominent: 30
        }
    }

    /// Opacity for the ambient halo layer
    var haloOpacity: Double {
        switch self {
        case .subtle: 0.55
        case .standard: 0.7
        case .prominent: 0.85
        }
    }

    // MARK: - Stroke Parameters (Edge Definition)

    /// Opacity for the crisp inner stroke
    var strokeOpacity: Double {
        switch self {
        case .subtle: 0.5
        case .standard: 0.7
        case .prominent: 0.9
        }
    }

    /// Line width for the crisp inner stroke
    var innerStrokeWidth: CGFloat {
        switch self {
        case .subtle: 1.0
        case .standard: 1.5
        case .prominent: 2.0
        }
    }
}
