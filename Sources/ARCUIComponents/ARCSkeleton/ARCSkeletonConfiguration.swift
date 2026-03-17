//
//  ARCSkeletonConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSkeletonConfiguration

/// Configuration for ARCSkeletonView appearance and animation
///
/// Provides customization options for skeleton loading placeholders while maintaining
/// consistency with Apple's Human Interface Guidelines for loading states.
///
/// ## Overview
///
/// ARCSkeletonConfiguration defines the shape, size, colors, and animation timing
/// for skeleton views. Use presets for common patterns or create custom configurations
/// for specific needs.
///
/// ## Topics
///
/// ### Shape Options
///
/// - ``Shape-swift.enum``
///
/// ### Size Options
///
/// - ``Size-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``text``
/// - ``textSmall``
/// - ``avatar``
/// - ``avatarSmall``
/// - ``image``
/// - ``button``
///
/// ## Usage
///
/// ```swift
/// // Use preset configurations
/// ARCSkeletonView(configuration: .avatar)
/// ARCSkeletonView(configuration: .text)
///
/// // Create custom configuration
/// let config = ARCSkeletonConfiguration(
///     shape: .roundedRectangle(cornerRadius: 12),
///     size: .fixed(width: 100, height: 50),
///     baseColor: .gray.opacity(0.3)
/// )
/// ARCSkeletonView(configuration: config)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSkeletonConfiguration: Sendable {
    // MARK: - Shape

    /// Shape options for skeleton views
    public enum Shape: Sendable {
        /// Rectangular shape with no corner radius
        case rectangle

        /// Rounded rectangle with specified corner radius
        case roundedRectangle(cornerRadius: CGFloat)

        /// Circular shape (aspect ratio 1:1)
        case circle

        /// Capsule shape (pill-shaped)
        case capsule
    }

    // MARK: - Size

    /// Size options for skeleton views
    public enum Size: Sendable {
        /// Fixed width and height
        case fixed(width: CGFloat, height: CGFloat)

        /// Flexible width with fixed height
        case flexible(minWidth: CGFloat?, maxWidth: CGFloat?, height: CGFloat)

        /// Fixed height with aspect ratio for width
        case aspectRatio(CGFloat, height: CGFloat)

        /// Fills available space
        case fill(height: CGFloat)
    }

    // MARK: - Properties

    /// Shape of the skeleton
    public let shape: Shape

    /// Size configuration
    public let size: Size

    /// Base color for the skeleton background
    public let baseColor: Color

    /// Highlight color for the shimmer effect
    public let highlightColor: Color

    /// Duration of one shimmer animation cycle in seconds
    public let animationDuration: Double

    /// Delay before animation starts (useful for staggered effects)
    public let animationDelay: Double

    /// Whether shimmer animation is enabled
    public let shimmerEnabled: Bool

    // MARK: - Initialization

    /// Creates a skeleton configuration
    ///
    /// - Parameters:
    ///   - shape: Shape of the skeleton (default: roundedRectangle)
    ///   - size: Size configuration (default: flexible height 16)
    ///   - baseColor: Base background color (default: gray at 20% opacity)
    ///   - highlightColor: Shimmer highlight color (default: gray at 10% opacity)
    ///   - animationDuration: Duration of shimmer cycle (default: 1.5 seconds)
    ///   - animationDelay: Delay before animation starts (default: 0)
    ///   - shimmerEnabled: Whether shimmer is enabled (default: true)
    public init(
        shape: Shape = .roundedRectangle(cornerRadius: .arcCornerRadiusSmall),
        size: Size = .flexible(minWidth: nil, maxWidth: nil, height: 16),
        baseColor: Color = Color.gray.opacity(0.2),
        highlightColor: Color = Color.gray.opacity(0.1),
        animationDuration: Double = 1.5,
        animationDelay: Double = 0,
        shimmerEnabled: Bool = true
    ) {
        self.shape = shape
        self.size = size
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.animationDuration = animationDuration
        self.animationDelay = animationDelay
        self.shimmerEnabled = shimmerEnabled
    }

    // MARK: - Presets

    /// Default skeleton configuration
    ///
    /// Rounded rectangle suitable for general content placeholders.
    public static let `default` = ARCSkeletonConfiguration()

    /// Text line skeleton
    ///
    /// Standard height for body text placeholders.
    public static let text = ARCSkeletonConfiguration(
        shape: .roundedRectangle(cornerRadius: 4),
        size: .flexible(minWidth: nil, maxWidth: nil, height: 16)
    )

    /// Small text line skeleton
    ///
    /// Smaller height for caption or secondary text.
    public static let textSmall = ARCSkeletonConfiguration(
        shape: .roundedRectangle(cornerRadius: 4),
        size: .flexible(minWidth: nil, maxWidth: nil, height: 12)
    )

    /// Large text line skeleton
    ///
    /// Larger height for headlines or titles.
    public static let textLarge = ARCSkeletonConfiguration(
        shape: .roundedRectangle(cornerRadius: 4),
        size: .flexible(minWidth: nil, maxWidth: nil, height: 20)
    )

    /// Avatar skeleton (medium size)
    ///
    /// Circular placeholder for user avatars.
    public static let avatar = ARCSkeletonConfiguration(
        shape: .circle,
        size: .fixed(width: 44, height: 44)
    )

    /// Small avatar skeleton
    ///
    /// Smaller circular placeholder for compact layouts.
    public static let avatarSmall = ARCSkeletonConfiguration(
        shape: .circle,
        size: .fixed(width: 32, height: 32)
    )

    /// Large avatar skeleton
    ///
    /// Larger circular placeholder for profile headers.
    public static let avatarLarge = ARCSkeletonConfiguration(
        shape: .circle,
        size: .fixed(width: 64, height: 64)
    )

    /// Image placeholder skeleton
    ///
    /// Rounded rectangle for image content areas.
    public static let image = ARCSkeletonConfiguration(
        shape: .roundedRectangle(cornerRadius: .arcCornerRadiusMedium),
        size: .aspectRatio(16 / 9, height: 180)
    )

    /// Square image placeholder
    ///
    /// Square aspect ratio for thumbnails or album art.
    public static let imageSquare = ARCSkeletonConfiguration(
        shape: .roundedRectangle(cornerRadius: .arcCornerRadiusMedium),
        size: .fixed(width: 120, height: 120)
    )

    /// Button placeholder skeleton
    ///
    /// Capsule-shaped placeholder for buttons.
    public static let button = ARCSkeletonConfiguration(
        shape: .capsule,
        size: .fixed(width: 120, height: 44)
    )

    /// Icon placeholder skeleton
    ///
    /// Small rounded square for icon placeholders.
    public static let icon = ARCSkeletonConfiguration(
        shape: .roundedRectangle(cornerRadius: .arcCornerRadiusSmall),
        size: .fixed(width: 24, height: 24)
    )
}
