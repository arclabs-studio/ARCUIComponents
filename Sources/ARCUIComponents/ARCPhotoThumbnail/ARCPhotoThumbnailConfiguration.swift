//
//  ARCPhotoThumbnailConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCPhotoThumbnailConfiguration

/// Configuration for `ARCPhotoThumbnail` appearance.
@available(iOS 17.0, macOS 14.0, *) public struct ARCPhotoThumbnailConfiguration: Sendable {
    // MARK: - Size

    /// Predefined size variants.
    public enum Size: Sendable {
        /// 64×64pt — for compact list rows.
        case small
        /// 100×100pt — for grids and carousels.
        case medium
        /// 160×160pt — for featured slots.
        case large
        /// Custom width × height.
        case custom(width: CGFloat, height: CGFloat)

        public var width: CGFloat {
            switch self {
            case .small: 64
            case .medium: 100
            case .large: 160
            case let .custom(customWidth, _): customWidth
            }
        }

        public var height: CGFloat {
            switch self {
            case .small: 64
            case .medium: 100
            case .large: 160
            case let .custom(_, customHeight): customHeight
            }
        }
    }

    // MARK: - Properties

    public let size: Size
    public let cornerRadius: CGFloat
    public let placeholderIcon: String
    public let placeholderBackground: Color

    // MARK: - Initialization

    public init(size: Size = .medium,
                cornerRadius: CGFloat = .arcSpacingSmall,
                placeholderIcon: String = "photo",
                placeholderBackground: Color = Color.secondary.opacity(0.15)) {
        self.size = size
        self.cornerRadius = cornerRadius
        self.placeholderIcon = placeholderIcon
        self.placeholderBackground = placeholderBackground
    }

    // MARK: - Presets

    /// Default 100×100pt thumbnail with rounded corners.
    public static let `default` = ARCPhotoThumbnailConfiguration()

    /// Compact 64×64pt for list rows.
    public static let compact = ARCPhotoThumbnailConfiguration(size: .small, cornerRadius: 6)

    /// Large 160×160pt for featured display.
    public static let featured = ARCPhotoThumbnailConfiguration(size: .large, cornerRadius: .arcSpacingMedium)
}
