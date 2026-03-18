//
//  ARCPhotoPickerShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

#if os(iOS)

import ARCDesignSystem
import SwiftUI

// MARK: - ARCPhotoPickerShowcase

/// Showcase for `ARCPhotoPicker` demonstrating all configuration presets.
@available(iOS 17.0, *) public struct ARCPhotoPickerShowcase: View {
    @State private var selectedCount = 0

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .arcSpacingXLarge) {
                presetsSection
                inCarouselSection
            }
            .padding(.arcSpacingLarge)
        }
        .navigationTitle("ARCPhotoPicker")
    }

    // MARK: - Sections

    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            Text("Presets").font(.headline)

            VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                ARCPhotoPicker { data in selectedCount += data.count }
                ARCPhotoPicker(configuration: .singlePhoto) { data in selectedCount += data.count }
                ARCPhotoPicker(configuration: .iconOnly) { data in selectedCount += data.count }
            }

            if selectedCount > 0 {
                Text("\(selectedCount) photo(s) selected in this session")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var inCarouselSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Inside ARCPhotoCarousel").font(.headline)

            let items = (0 ..< 3).map {
                ARCPhotoItem(thumbnailData: Data(), caption: "Photo \($0 + 1)")
            }

            ARCPhotoCarousel(items: items,
                             onDelete: { _ in },
                             addButton: { ARCPhotoPicker(configuration: .iconOnly) { _ in } })
        }
    }
}

@available(iOS 17.0, *)
#Preview("ARCPhotoPickerShowcase") {
    NavigationStack {
        ARCPhotoPickerShowcase()
    }
}

#endif // os(iOS)
