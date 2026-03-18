//
//  ARCPhotoThumbnail.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - ARCPhotoThumbnail

/// A fixed-size image view rendered from raw `Data`.
///
/// `ARCPhotoThumbnail` decodes JPEG/PNG bytes and renders them as a
/// fill-cropped image. When the data is `nil` or cannot be decoded it
/// falls back to a configurable placeholder icon.
///
/// Consumer apps supply `ARCPhotoItem.thumbnailData` (stored inline in SQLite)
/// so list scrolling never triggers external file I/O.
///
/// ## Usage
///
/// ```swift
/// // From ARCPhotoItem
/// ARCPhotoThumbnail(data: item.thumbnailData)
///
/// // Compact preset for a list row
/// ARCPhotoThumbnail(data: item.thumbnailData, configuration: .compact)
///
/// // Custom size
/// ARCPhotoThumbnail(
///     data: photo.thumbnailData,
///     configuration: ARCPhotoThumbnailConfiguration(
///         size: .custom(width: 80, height: 60)
///     )
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCPhotoThumbnail: View {
    // MARK: - Properties

    private let data: Data?
    private let configuration: ARCPhotoThumbnailConfiguration

    // MARK: - Initialization

    /// Creates a thumbnail from raw image data.
    ///
    /// - Parameters:
    ///   - data: JPEG or PNG bytes. Pass `nil` to show the placeholder.
    ///   - configuration: Appearance configuration (default: `.default`).
    public init(data: Data?, configuration: ARCPhotoThumbnailConfiguration = .default) {
        self.data = data
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if let image = resolvedImage {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholderView
            }
        }
        .frame(width: configuration.size.width, height: configuration.size.height)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .accessibilityLabel(Text("Photo thumbnail"))
        .accessibilityAddTraits(.isImage)
    }

    // MARK: - Private

    private var resolvedImage: Image? {
        guard let data else { return nil }
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
        #else
        return nil
        #endif
    }

    private var placeholderView: some View {
        configuration.placeholderBackground
            .overlay {
                Image(systemName: configuration.placeholderIcon)
                    .font(.system(size: configuration.size.width * 0.25))
                    .foregroundStyle(.secondary)
            }
    }
}

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCPhotoThumbnail — placeholder") {
    HStack(spacing: .arcSpacingMedium) {
        ARCPhotoThumbnail(data: nil, configuration: .compact)
        ARCPhotoThumbnail(data: nil)
        ARCPhotoThumbnail(data: nil, configuration: .featured)
    }
    .padding()
}
