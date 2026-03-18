//
//  ARCPhotoItem.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import Foundation

// MARK: - ARCPhotoItem

/// A display model for a photo attachment, agnostic of any persistence layer.
///
/// Consumer apps map their storage model (e.g. `ARCPhoto` from ARCStorage) to
/// `ARCPhotoItem` before passing it to `ARCPhotoCarousel` or `ARCPhotoThumbnail`.
///
/// ## Example mapping
/// ```swift
/// // FavRes: map ARCPhoto → ARCPhotoItem
/// let items = visit.photos?.map {
///     ARCPhotoItem(
///         id: $0.id,
///         thumbnailData: $0.thumbnailData ?? Data(),
///         imageData: $0.imageData,
///         caption: $0.caption
///     )
/// } ?? []
/// ```
public struct ARCPhotoItem: Identifiable, Sendable {
    // MARK: - Properties

    /// Stable identity for SwiftUI diffing.
    public let id: UUID

    /// Compressed thumbnail shown in list and carousel (≤ 200×200px).
    public let thumbnailData: Data

    /// Full-resolution image shown in the full-screen viewer. `nil` falls back to thumbnail.
    public let imageData: Data?

    /// Optional user caption displayed in the full-screen viewer.
    public let caption: String?

    // MARK: - Initialization

    public init(id: UUID = UUID(),
                thumbnailData: Data,
                imageData: Data? = nil,
                caption: String? = nil) {
        self.id = id
        self.thumbnailData = thumbnailData
        self.imageData = imageData
        self.caption = caption
    }
}
