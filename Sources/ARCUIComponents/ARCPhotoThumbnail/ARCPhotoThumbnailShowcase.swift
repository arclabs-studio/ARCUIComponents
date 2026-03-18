//
//  ARCPhotoThumbnailShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCPhotoThumbnailShowcase

/// Showcase for `ARCPhotoThumbnail` demonstrating all size and state variants.
@available(iOS 17.0, macOS 14.0, *) public struct ARCPhotoThumbnailShowcase: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .arcSpacingXLarge) {
                placeholderSection
                sizeSection
            }
            .padding(.arcSpacingLarge)
        }
        .navigationTitle("ARCPhotoThumbnail")
    }

    // MARK: - Sections

    private var placeholderSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            Text("Placeholder States").font(.headline)
            HStack(spacing: .arcSpacingMedium) {
                VStack(spacing: .arcSpacingSmall) {
                    ARCPhotoThumbnail(data: nil, configuration: .compact)
                    Text("compact").font(.caption2).foregroundStyle(.secondary)
                }
                VStack(spacing: .arcSpacingSmall) {
                    ARCPhotoThumbnail(data: nil)
                    Text("default").font(.caption2).foregroundStyle(.secondary)
                }
                VStack(spacing: .arcSpacingSmall) {
                    ARCPhotoThumbnail(data: nil, configuration: .featured)
                    Text("featured").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }

    private var sizeSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingMedium) {
            Text("Size Variants").font(.headline)
            HStack(alignment: .bottom, spacing: .arcSpacingMedium) {
                ARCPhotoThumbnail(data: nil, configuration: .init(size: .small))
                ARCPhotoThumbnail(data: nil, configuration: .init(size: .medium))
                ARCPhotoThumbnail(data: nil, configuration: .init(size: .large))
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCPhotoThumbnailShowcase") {
    NavigationStack {
        ARCPhotoThumbnailShowcase()
    }
}
