//
//  ARCPhotoCarousel.swift
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

// MARK: - ARCPhotoCarousel

/// A horizontally scrolling carousel of photo thumbnails backed by raw `Data`.
///
/// `ARCPhotoCarousel` is persistence-agnostic — it works with `[ARCPhotoItem]`,
/// a simple `Sendable` struct that consumer apps populate from any data source
/// (SwiftData, Core Data, in-memory, etc.).
///
/// ## Overview
///
/// - Thumbnails are rendered from `ARCPhotoItem.thumbnailData` (fast, no I/O).
/// - Tapping a cell opens a full-screen sheet using `imageData` if available,
///   otherwise falling back to `thumbnailData`.
/// - Pass `onDelete` to enable a delete badge on each cell.
/// - Pass `addButton` to append a custom "add photo" button at the trailing end.
///
/// ## Usage
///
/// ```swift
/// // Read-only
/// ARCPhotoCarousel(items: photoItems)
///
/// // With delete
/// ARCPhotoCarousel(items: photoItems) { item in
///     viewModel.deletePhoto(item)
/// }
///
/// // With add button (iOS: connect to ARCPhotoPicker)
/// ARCPhotoCarousel(items: photoItems, onDelete: { viewModel.delete($0) }) {
///     ARCPhotoPicker(maxSelectionCount: 5) { dataArray in
///         viewModel.addPhotos(dataArray)
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCPhotoCarousel<AddButton: View>: View {
    // MARK: - Properties

    private let items: [ARCPhotoItem]
    private let configuration: ARCPhotoCarouselConfiguration
    private let onDelete: ((ARCPhotoItem) -> Void)?
    private let addButton: AddButton?

    @State private var selectedItem: ARCPhotoItem?

    // MARK: - Initialization

    /// Creates a carousel without an add button.
    ///
    /// - Parameters:
    ///   - items: Photos to display.
    ///   - configuration: Appearance configuration (default: `.default`).
    ///   - onDelete: Called when the user taps the delete badge. `nil` hides the badge.
    public init(items: [ARCPhotoItem],
                configuration: ARCPhotoCarouselConfiguration = .default,
                onDelete: ((ARCPhotoItem) -> Void)? = nil) where AddButton == EmptyView {
        self.items = items
        self.configuration = configuration
        self.onDelete = onDelete
        addButton = nil
    }

    /// Creates a carousel with a trailing add button.
    ///
    /// - Parameters:
    ///   - items: Photos to display.
    ///   - configuration: Appearance configuration (default: `.default`).
    ///   - onDelete: Called when the user taps the delete badge. `nil` hides the badge.
    ///   - addButton: View rendered at the trailing end (e.g. `ARCPhotoPicker`).
    public init(items: [ARCPhotoItem],
                configuration: ARCPhotoCarouselConfiguration = .default,
                onDelete: ((ARCPhotoItem) -> Void)? = nil,
                @ViewBuilder addButton: () -> AddButton) {
        self.items = items
        self.configuration = configuration
        self.onDelete = onDelete
        self.addButton = addButton()
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: configuration.itemSpacing) {
                ForEach(items) { item in
                    photoCell(for: item)
                }
                if let addButton {
                    addButton
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.vertical, .arcSpacingXSmall)
        }
        .sheet(item: $selectedItem) { item in
            ARCPhotoFullScreenView(item: item)
        }
    }

    // MARK: - Photo Cell

    private func photoCell(for item: ARCPhotoItem) -> some View {
        let thumbnailConfig = ARCPhotoThumbnailConfiguration(size: configuration.thumbnailSize,
                                                             cornerRadius: configuration.cornerRadius)

        return ARCPhotoThumbnail(data: item.thumbnailData, configuration: thumbnailConfig)
            .overlay(alignment: .topTrailing) {
                if configuration.showDeleteBadge, onDelete != nil {
                    deleteBadge(for: item)
                }
            }
            .onTapGesture {
                arcWithAnimation { selectedItem = item }
            }
            .accessibilityLabel(item.caption.map { Text($0) } ?? Text("Photo"))
            .accessibilityHint(Text("Double tap to view full screen"))
            .accessibilityAddTraits(.isButton)
    }

    private func deleteBadge(for item: ARCPhotoItem) -> some View {
        Button {
            arcWithAnimation { onDelete?(item) }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color(.systemGray))
                .font(.system(size: 18))
        }
        .offset(x: 6, y: -6)
        .accessibilityLabel(Text("Delete photo"))
    }
}

// MARK: - Full-Screen Viewer

/// Internal full-screen photo viewer presented as a sheet from `ARCPhotoCarousel`.
@available(iOS 17.0, macOS 14.0, *) struct ARCPhotoFullScreenView: View {
    let item: ARCPhotoItem

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical]) {
                    if let image = resolvedFullImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: geometry.size.width,
                                   minHeight: geometry.size.height)
                    } else {
                        placeholderView(in: geometry)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "Close")) { dismiss() }
                    }
                }
                .toolbar {
                    if let caption = item.caption {
                        ToolbarItem(placement: .principal) {
                            Text(caption)
                                .font(.headline)
                        }
                    }
                }
        }
    }

    private var resolvedFullImage: Image? {
        let data = item.imageData ?? item.thumbnailData
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

    private func placeholderView(in geometry: GeometryProxy) -> some View {
        Color.secondary.opacity(0.1)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .overlay {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
    }
}

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCPhotoCarousel — empty") {
    ARCPhotoCarousel(items: [])
        .padding(.vertical)
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCPhotoCarousel — placeholders") {
    let items = (0 ..< 5).map {
        ARCPhotoItem(thumbnailData: Data(), caption: "Photo \($0 + 1)")
    }
    ARCPhotoCarousel(items: items, onDelete: { _ in })
        .padding(.vertical)
}
