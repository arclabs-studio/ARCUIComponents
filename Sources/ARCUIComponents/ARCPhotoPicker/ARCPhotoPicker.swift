//
//  ARCPhotoPicker.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

#if os(iOS)

import ARCDesignSystem
import PhotosUI
import SwiftUI

// MARK: - ARCPhotoPicker

/// An iOS-only button that presents the system `PhotosPicker` and emits selected photos as `[Data]`.
///
/// `ARCPhotoPicker` handles the full selection → data loading pipeline.
/// No photo library permission prompt is required — the system picker manages access.
///
/// The component emits raw `[Data]` so callers remain agnostic of any storage layer.
/// Pass the result straight to your repository (e.g. `SwiftDataPhotoRepository.add(imageData:)`).
///
/// ## Usage
///
/// ```swift
/// // Standalone button
/// ARCPhotoPicker { dataArray in
///     for data in dataArray {
///         try? photoRepository.add(imageData: data, caption: nil, sortOrder: 0)
///     }
/// }
///
/// // Inside ARCPhotoCarousel as the add button
/// ARCPhotoCarousel(items: items, onDelete: { viewModel.delete($0) }) {
///     ARCPhotoPicker(configuration: .iconOnly) { dataArray in
///         viewModel.addPhotos(dataArray)
///     }
/// }
/// ```
///
/// - Note: Available on iOS only. Use `#if os(iOS)` when embedding in cross-platform views.
@available(iOS 17.0, *) public struct ARCPhotoPicker: View {
    // MARK: - Properties

    private let configuration: ARCPhotoPickerConfiguration
    private let onSelect: ([Data]) -> Void

    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var isLoading = false

    // MARK: - Initialization

    /// Creates a photo picker button.
    ///
    /// - Parameters:
    ///   - configuration: Button appearance and picker behaviour (default: `.default`).
    ///   - onSelect: Called on the `@MainActor` with the loaded `Data` array.
    ///     Items that fail to load are silently skipped.
    public init(configuration: ARCPhotoPickerConfiguration = .default,
                onSelect: @escaping ([Data]) -> Void) {
        self.configuration = configuration
        self.onSelect = onSelect
    }

    // MARK: - Body

    public var body: some View {
        PhotosPicker(selection: $pickerItems,
                     maxSelectionCount: configuration.maxSelectionCount,
                     matching: .images) {
            Label(configuration.buttonLabel, systemImage: configuration.buttonIcon)
                .opacity(isLoading ? 0 : 1)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
        }
        .disabled(isLoading)
        .onChange(of: pickerItems) { _, newItems in
            guard !newItems.isEmpty else { return }
            loadImages(from: newItems)
        }
        .accessibilityLabel(Text(configuration.buttonLabel))
        .accessibilityHint(Text("Opens photo library"))
    }

    // MARK: - Private

    @MainActor private func loadImages(from items: [PhotosPickerItem]) {
        isLoading = true
        Task {
            var results: [Data] = []
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    results.append(data)
                }
            }
            pickerItems = []
            isLoading = false
            if !results.isEmpty {
                onSelect(results)
            }
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("ARCPhotoPicker — default") {
    VStack(spacing: .arcSpacingLarge) {
        ARCPhotoPicker { _ in }
        ARCPhotoPicker(configuration: .singlePhoto) { _ in }
        ARCPhotoPicker(configuration: .iconOnly) { _ in }
    }
    .padding()
}

#endif // os(iOS)
