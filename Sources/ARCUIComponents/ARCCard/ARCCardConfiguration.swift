//
//  ARCCardConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 21/1/26.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCCard appearance and behavior
///
/// Provides customization options for card appearance while maintaining
/// Apple's Human Interface Guidelines for content cards.
///
/// ## Overview
///
/// ARCCardConfiguration conforms to ``LiquidGlassConfigurable``, enabling
/// the unified liquid glass effect system used across all ARC components.
///
/// ## Topics
///
/// ### Properties
///
/// - ``accentColor``
/// - ``backgroundStyle``
/// - ``cornerRadius``
/// - ``shadow``
/// - ``contentSpacing``
/// - ``contentPadding``
/// - ``showImage``
///
/// ### Presets
///
/// - ``default``
/// - ``compact``
/// - ``prominent``
/// - ``glassmorphic``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// ARCCard(title: "Title", configuration: .default) { ... }
///
/// // Create custom configuration
/// let config = ARCCardConfiguration(
///     accentColor: .blue,
///     backgroundStyle: .liquidGlass
/// )
/// ARCCard(title: "Title", configuration: config) { ... }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCardConfiguration: Sendable, LiquidGlassConfigurable {

    // MARK: - LiquidGlassConfigurable Properties

    /// Primary accent color for the component
    public let accentColor: Color

    /// Background style for the card
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the card
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Card-specific Properties

    /// Spacing between content elements
    public let contentSpacing: CGFloat

    /// Padding around content section
    public let contentPadding: CGFloat

    /// Whether to show the image section
    public let showImage: Bool

    // MARK: - Initialization

    /// Creates a card configuration
    ///
    /// - Parameters:
    ///   - accentColor: Primary accent color (default: .blue)
    ///   - backgroundStyle: Background style (default: material)
    ///   - cornerRadius: Corner radius (default: medium)
    ///   - shadow: Shadow configuration (default: card shadow)
    ///   - contentSpacing: Spacing between elements (default: small)
    ///   - contentPadding: Padding around content (default: medium)
    ///   - showImage: Whether to show image section (default: true)
    public init(
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .material(.ultraThinMaterial),
        cornerRadius: CGFloat = .arcCornerRadiusMedium,
        shadow: ARCShadow = .card,
        contentSpacing: CGFloat = .arcSpacingSmall,
        contentPadding: CGFloat = .arcSpacingMedium,
        showImage: Bool = true
    ) {
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.contentSpacing = contentSpacing
        self.contentPadding = contentPadding
        self.showImage = showImage
    }

    // MARK: - Presets

    /// Default card configuration with material background
    public static let `default` = ARCCardConfiguration()

    /// Compact configuration with smaller spacing
    public static let compact = ARCCardConfiguration(
        contentSpacing: .arcSpacingXSmall,
        contentPadding: .arcSpacingSmall
    )

    /// Prominent configuration with liquid glass effect
    public static let prominent = ARCCardConfiguration(
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .prominent
    )

    /// Glassmorphic configuration matching Apple Music style
    public static let glassmorphic = ARCCardConfiguration(
        accentColor: .pink,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusMedium,
        shadow: .default
    )

    /// Text-only configuration without image
    public static let textOnly = ARCCardConfiguration(
        showImage: false
    )
}

// MARK: - Shadow Extension

@available(iOS 17.0, macOS 14.0, *)
extension ARCShadow {

    /// Standard card shadow with dual layers
    ///
    /// Combines a medium and light shadow for depth, matching Apple's card patterns.
    public static let card = ARCShadow(
        color: .arcShadowMedium,
        radius: 8,
        x: 0,
        y: 2
    )
}
