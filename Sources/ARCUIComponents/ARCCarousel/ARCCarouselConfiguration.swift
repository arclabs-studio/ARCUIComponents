//
//  ARCCarouselConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCCarouselConfiguration

/// Configuration options for customizing the appearance and behavior of ARCCarousel
///
/// `ARCCarouselConfiguration` provides comprehensive customization options for the
/// carousel component, including item sizing, snap behavior, indicators, and auto-scroll.
///
/// ## Overview
///
/// The configuration controls:
/// - Item size and spacing
/// - Snap behavior (none, item, page)
/// - Page indicators (dots, lines, numbers)
/// - Auto-scroll settings
/// - Visual effects (scale, shadows)
///
/// ## Topics
///
/// ### Configuration Properties
///
/// - ``itemSize``
/// - ``itemSpacing``
/// - ``snapBehavior``
/// - ``indicatorStyle``
///
/// ### Presets
///
/// - ``default``
/// - ``featured``
/// - ``gallery``
/// - ``cards``
/// - ``stories``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// ARCCarousel(items, configuration: .default) { item in
///     CardView(item: item)
/// }
///
/// // Use a preset
/// ARCCarousel(items, configuration: .featured) { item in
///     FeaturedBanner(item: item)
/// }
///
/// // Custom configuration
/// let config = ARCCarouselConfiguration(
///     itemSize: .fractional(0.85),
///     itemSpacing: 16,
///     snapBehavior: .item,
///     indicatorStyle: .dots
/// )
/// ARCCarousel(items, configuration: config) { item in
///     ContentCard(item: item)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCCarouselConfiguration: Sendable {
    // MARK: - Size & Layout Properties

    /// The size configuration for carousel items
    public let itemSize: ItemSize

    /// The spacing between carousel items in points
    public let itemSpacing: CGFloat

    /// The content insets for the carousel
    public let contentInsets: EdgeInsets

    // MARK: - Behavior Properties

    /// The snap behavior when scrolling ends
    public let snapBehavior: SnapBehavior

    /// The scroll direction of the carousel
    public let scrollDirection: Axis.Set

    /// Whether the carousel loops infinitely
    public let loopEnabled: Bool

    // MARK: - Auto-Scroll Properties

    /// Whether auto-scroll is enabled
    public let autoScrollEnabled: Bool

    /// The interval between auto-scroll advances in seconds
    public let autoScrollInterval: TimeInterval

    /// Whether to pause auto-scroll when user interacts
    public let pauseOnInteraction: Bool

    // MARK: - Indicator Properties

    /// The style of page indicators
    public let indicatorStyle: IndicatorStyle

    /// The position of page indicators
    public let indicatorPosition: IndicatorPosition

    /// The maximum number of visible dots (for many items)
    public let maxVisibleDots: Int

    // MARK: - Visual Properties

    /// Whether to show shadows on items
    public let showShadows: Bool

    /// The scale effect configuration for non-centered items
    public let scaleEffect: ScaleEffect?

    /// The corner radius for item clipping (if applicable)
    public let itemCornerRadius: CGFloat

    // MARK: - Initialization

    /// Creates a carousel configuration with the specified options
    ///
    /// - Parameters:
    ///   - itemSize: Size configuration for items (default: .fractional(0.85))
    ///   - itemSpacing: Spacing between items in points (default: 16)
    ///   - contentInsets: Content insets (default: horizontal 16pt)
    ///   - snapBehavior: Snap behavior when scrolling ends (default: .item)
    ///   - scrollDirection: Scroll direction (default: .horizontal)
    ///   - loopEnabled: Whether to enable infinite loop (default: false)
    ///   - autoScrollEnabled: Whether to enable auto-scroll (default: false)
    ///   - autoScrollInterval: Auto-scroll interval in seconds (default: 4)
    ///   - pauseOnInteraction: Pause auto-scroll on interaction (default: true)
    ///   - indicatorStyle: Page indicator style (default: .dots)
    ///   - indicatorPosition: Indicator position (default: .bottom(offset: 16))
    ///   - maxVisibleDots: Maximum visible indicator dots (default: 7)
    ///   - showShadows: Whether to show item shadows (default: false)
    ///   - scaleEffect: Scale effect for non-centered items (default: nil)
    ///   - itemCornerRadius: Corner radius for items (default: 16)
    public init(
        itemSize: ItemSize = .fractional(0.85),
        itemSpacing: CGFloat = 16,
        contentInsets: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16),
        snapBehavior: SnapBehavior = .item,
        scrollDirection: Axis.Set = .horizontal,
        loopEnabled: Bool = false,
        autoScrollEnabled: Bool = false,
        autoScrollInterval: TimeInterval = 4,
        pauseOnInteraction: Bool = true,
        indicatorStyle: IndicatorStyle = .dots,
        indicatorPosition: IndicatorPosition = .bottom(offset: 16),
        maxVisibleDots: Int = 7,
        showShadows: Bool = false,
        scaleEffect: ScaleEffect? = nil,
        itemCornerRadius: CGFloat = 16
    ) {
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
        self.contentInsets = contentInsets
        self.snapBehavior = snapBehavior
        self.scrollDirection = scrollDirection
        self.loopEnabled = loopEnabled
        self.autoScrollEnabled = autoScrollEnabled
        self.autoScrollInterval = max(1, autoScrollInterval)
        self.pauseOnInteraction = pauseOnInteraction
        self.indicatorStyle = indicatorStyle
        self.indicatorPosition = indicatorPosition
        self.maxVisibleDots = max(3, maxVisibleDots)
        self.showShadows = showShadows
        self.scaleEffect = scaleEffect
        self.itemCornerRadius = itemCornerRadius
    }
}

// MARK: - ItemSize

@available(iOS 17.0, macOS 14.0, *)
extension ARCCarouselConfiguration {
    /// Defines how carousel items are sized
    public enum ItemSize: Sendable, Equatable {
        /// One item fills the entire width
        case fullWidth

        /// Item width is a fraction of the container (e.g., 0.85 for peek effect)
        case fractional(CGFloat)

        /// Item has a fixed width in points
        case fixed(CGFloat)

        /// Item width is calculated from aspect ratio and height
        case aspectRatio(CGFloat, height: CGFloat)
    }
}

// MARK: - SnapBehavior

@available(iOS 17.0, macOS 14.0, *)
extension ARCCarouselConfiguration {
    /// Defines how the carousel snaps when scrolling ends
    public enum SnapBehavior: Sendable, Equatable {
        /// Free scroll without snapping
        case none

        /// Snap to each individual item
        case item

        /// Snap to pages containing multiple items
        case page(itemsPerPage: Int)
    }
}

// MARK: - IndicatorStyle

@available(iOS 17.0, macOS 14.0, *)
extension ARCCarouselConfiguration {
    /// The visual style for page indicators
    public enum IndicatorStyle: Sendable, Equatable {
        /// No indicators shown
        case none

        /// Traditional dot indicators
        case dots

        /// Line/bar indicators
        case lines

        /// Numeric indicators (e.g., "3 / 10")
        case numbers
    }
}

// MARK: - IndicatorPosition

@available(iOS 17.0, macOS 14.0, *)
extension ARCCarouselConfiguration {
    /// The position of page indicators
    public enum IndicatorPosition: Sendable, Equatable {
        /// Below the carousel with specified offset
        case bottom(offset: CGFloat)

        /// Above the carousel with specified offset
        case top(offset: CGFloat)

        /// Overlaid on the carousel with specified alignment
        case overlay(alignment: Alignment)

        public static func == (lhs: IndicatorPosition, rhs: IndicatorPosition) -> Bool {
            switch (lhs, rhs) {
            case let (.bottom(l), .bottom(r)): l == r
            case let (.top(l), .top(r)): l == r
            case let (.overlay(l), .overlay(r)):
                l.horizontal == r.horizontal && l.vertical == r.vertical
            default: false
            }
        }
    }
}

// MARK: - ScaleEffect

@available(iOS 17.0, macOS 14.0, *)
extension ARCCarouselConfiguration {
    /// Configuration for scale effect on carousel items
    public struct ScaleEffect: Sendable, Equatable {
        /// Scale factor for the centered/focused item (typically 1.0)
        public let centered: CGFloat

        /// Scale factor for adjacent items (e.g., 0.9)
        public let adjacent: CGFloat

        /// Animation for scale transitions
        public let animation: Animation

        /// Creates a scale effect configuration
        ///
        /// - Parameters:
        ///   - centered: Scale for centered item (default: 1.0)
        ///   - adjacent: Scale for adjacent items (default: 0.9)
        ///   - animation: Animation for scale changes (default: spring)
        public init(
            centered: CGFloat = 1.0,
            adjacent: CGFloat = 0.9,
            animation: Animation = .spring(response: 0.3, dampingFraction: 0.8)
        ) {
            self.centered = centered
            self.adjacent = adjacent
            self.animation = animation
        }

        /// Default scale effect with subtle scaling
        public static let `default` = ScaleEffect()

        /// Prominent scale effect with more visible difference
        public static let prominent = ScaleEffect(centered: 1.0, adjacent: 0.85)

        public static func == (lhs: ScaleEffect, rhs: ScaleEffect) -> Bool {
            lhs.centered == rhs.centered && lhs.adjacent == rhs.adjacent
        }
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCCarouselConfiguration {
    /// Default carousel configuration
    ///
    /// Features:
    /// - 85% width items with peek effect
    /// - Item snapping
    /// - Dot indicators at bottom
    public static let `default` = ARCCarouselConfiguration()

    /// Featured content carousel (like App Store)
    ///
    /// Features:
    /// - 90% width items
    /// - Auto-scroll enabled
    /// - Dot indicators
    /// - Subtle scale effect
    public static let featured = ARCCarouselConfiguration(
        itemSize: .fractional(0.9),
        itemSpacing: 12,
        autoScrollEnabled: true,
        autoScrollInterval: 5,
        indicatorStyle: .dots,
        indicatorPosition: .overlay(alignment: .bottom),
        showShadows: true,
        scaleEffect: .default
    )

    /// Gallery-style carousel with scale effect
    ///
    /// Features:
    /// - 75% width items for more visible peek
    /// - Prominent scale effect
    /// - No indicators
    public static let gallery = ARCCarouselConfiguration(
        itemSize: .fractional(0.75),
        itemSpacing: 20,
        indicatorStyle: .none,
        scaleEffect: .prominent
    )

    /// Card carousel with fixed-width items
    ///
    /// Features:
    /// - Fixed 280pt width cards
    /// - Multiple visible items
    /// - No indicators
    /// - Shadows enabled
    public static let cards = ARCCarouselConfiguration(
        itemSize: .fixed(280),
        itemSpacing: 16,
        indicatorStyle: .none,
        showShadows: true,
        itemCornerRadius: 20
    )

    /// Stories-style carousel (like Instagram)
    ///
    /// Features:
    /// - Small fixed-width items
    /// - No snapping
    /// - No indicators
    public static let stories = ARCCarouselConfiguration(
        itemSize: .fixed(80),
        itemSpacing: 12,
        contentInsets: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16),
        snapBehavior: .none,
        indicatorStyle: .none,
        itemCornerRadius: 40
    )

    /// Full-width paging carousel
    ///
    /// Features:
    /// - Full width items
    /// - Page snapping
    /// - Line indicators at top
    public static let paging = ARCCarouselConfiguration(
        itemSize: .fullWidth,
        itemSpacing: 0,
        contentInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 0),
        indicatorStyle: .lines,
        indicatorPosition: .top(offset: 8)
    )
}
