//
//  ARCPhotoCarouselShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCPhotoCarouselShowcase

/// Showcase for `ARCPhotoCarousel` demonstrating all configuration presets.
@available(iOS 17.0, macOS 14.0, *) public struct ARCPhotoCarouselShowcase: View {
    public init() {}

    private let sampleItems = (0 ..< 6).map {
        ARCPhotoItem(thumbnailData: Data(), caption: "Photo \($0 + 1)")
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .arcSpacingXLarge) {
                defaultSection
                compactSection
                featuredSection
                readOnlySection
            }
            .padding(.vertical, .arcSpacingLarge)
        }
        .navigationTitle("ARCPhotoCarousel")
    }

    // MARK: - Sections

    private var defaultSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Default (with delete)").font(.headline).padding(.horizontal, .arcSpacingLarge)
            ARCPhotoCarousel(items: sampleItems, onDelete: { _ in })
        }
    }

    private var compactSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Compact").font(.headline).padding(.horizontal, .arcSpacingLarge)
            ARCPhotoCarousel(items: sampleItems, configuration: .compact, onDelete: { _ in })
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Featured").font(.headline).padding(.horizontal, .arcSpacingLarge)
            ARCPhotoCarousel(items: sampleItems, configuration: .featured, onDelete: { _ in })
        }
    }

    private var readOnlySection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingSmall) {
            Text("Read-only (no delete)").font(.headline).padding(.horizontal, .arcSpacingLarge)
            ARCPhotoCarousel(items: sampleItems)
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCPhotoCarouselShowcase") {
    NavigationStack {
        ARCPhotoCarouselShowcase()
    }
}
