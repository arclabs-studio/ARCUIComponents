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
/// ARCCardConfiguration allows you to customize spacing, corner radius,
/// background style, and shadow while preserving the familiar card pattern.
///
/// ## Topics
///
/// ### Properties
///
/// - ``contentSpacing``
/// - ``contentPadding``
/// - ``cornerRadius``
/// - ``backgroundStyle``
/// - ``shadow``
///
/// ### Presets
///
/// - ``default``
/// - ``compact``
/// - ``prominent``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// ARCCard(title: "Title", configuration: .default) { ... }
///
/// // Create custom configuration
/// let config = ARCCardConfiguration(
///     cornerRadius: 20,
///     backgroundStyle: .solidColor(.white)
/// )
/// ARCCard(title: "Title", configuration: config) { ... }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCardConfiguration: Sendable {

    // MARK: - Properties

    /// Spacing between content elements
    public let contentSpacing: CGFloat

    /// Padding around content section
    public let contentPadding: CGFloat

    /// Corner radius for the card
    public let cornerRadius: CGFloat

    /// Background style for the card
    public let backgroundStyle: ARCCardBackgroundStyle

    /// Shadow configuration
    public let shadow: ARCShadow

    /// Whether to show the image section
    public let showImage: Bool

    // MARK: - Initialization

    /// Creates a card configuration
    ///
    /// - Parameters:
    ///   - contentSpacing: Spacing between elements (default: small)
    ///   - contentPadding: Padding around content (default: medium)
    ///   - cornerRadius: Corner radius (default: medium)
    ///   - backgroundStyle: Background style (default: material)
    ///   - shadow: Shadow configuration (default: card shadow)
    ///   - showImage: Whether to show image section (default: true)
    public init(
        contentSpacing: CGFloat = .arcSpacingSmall,
        contentPadding: CGFloat = .arcSpacingMedium,
        cornerRadius: CGFloat = .arcCornerRadiusMedium,
        backgroundStyle: ARCCardBackgroundStyle = .material,
        shadow: ARCShadow = .card,
        showImage: Bool = true
    ) {
        self.contentSpacing = contentSpacing
        self.contentPadding = contentPadding
        self.cornerRadius = cornerRadius
        self.backgroundStyle = backgroundStyle
        self.shadow = shadow
        self.showImage = showImage
    }

    // MARK: - Presets

    /// Default card configuration
    public static let `default` = ARCCardConfiguration()

    /// Compact configuration with smaller spacing
    public static let compact = ARCCardConfiguration(
        contentSpacing: .arcSpacingXSmall,
        contentPadding: .arcSpacingSmall
    )

    /// Prominent configuration with larger corner radius and shadow
    public static let prominent = ARCCardConfiguration(
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .prominent
    )

    /// Text-only configuration without image
    public static let textOnly = ARCCardConfiguration(
        showImage: false
    )
}

// MARK: - Background Style

/// Background style options for ARCCard
@available(iOS 17.0, macOS 14.0, *)
public enum ARCCardBackgroundStyle: Sendable {
    /// Ultra thin material background
    case material

    /// Solid color background
    case solidColor(Color)

    /// Gradient background
    case gradient(LinearGradient)

    /// Clear background (no fill)
    case clear
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
