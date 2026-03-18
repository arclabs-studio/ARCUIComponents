//
//  ARCPhotoCarouselConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCPhotoCarouselConfiguration

/// Configuration for `ARCPhotoCarousel` appearance and layout.
@available(iOS 17.0, macOS 14.0, *) public struct ARCPhotoCarouselConfiguration: Sendable {
    // MARK: - Properties

    /// Size of each thumbnail cell in the carousel.
    public let thumbnailSize: ARCPhotoThumbnailConfiguration.Size

    /// Corner radius applied to each thumbnail cell.
    public let cornerRadius: CGFloat

    /// Horizontal spacing between cells.
    public let itemSpacing: CGFloat

    /// Horizontal content inset for the scroll view.
    public let horizontalPadding: CGFloat

    /// Whether to show a delete badge on each cell when `onDelete` is provided.
    public let showDeleteBadge: Bool

    // MARK: - Initialization

    public init(thumbnailSize: ARCPhotoThumbnailConfiguration.Size = .medium,
                cornerRadius: CGFloat = .arcSpacingSmall,
                itemSpacing: CGFloat = .arcSpacingSmall,
                horizontalPadding: CGFloat = .arcSpacingLarge,
                showDeleteBadge: Bool = true) {
        self.thumbnailSize = thumbnailSize
        self.cornerRadius = cornerRadius
        self.itemSpacing = itemSpacing
        self.horizontalPadding = horizontalPadding
        self.showDeleteBadge = showDeleteBadge
    }

    // MARK: - Presets

    /// Default 100×100pt cells with delete badges enabled.
    public static let `default` = ARCPhotoCarouselConfiguration()

    /// Compact 64×64pt cells for tight layouts.
    public static let compact = ARCPhotoCarouselConfiguration(thumbnailSize: .small,
                                                              cornerRadius: 6,
                                                              itemSpacing: .arcSpacingXSmall)

    /// Large 160×160pt cells for hero-style carousels.
    public static let featured = ARCPhotoCarouselConfiguration(thumbnailSize: .large,
                                                               cornerRadius: .arcSpacingMedium,
                                                               itemSpacing: .arcSpacingMedium)
}
