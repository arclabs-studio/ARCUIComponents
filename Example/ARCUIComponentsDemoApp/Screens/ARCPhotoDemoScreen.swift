//
//  ARCPhotoDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for photo components: ARCPhotoThumbnail, ARCPhotoCarousel, ARCPhotoPicker.
///
/// Demonstrates all three photo components in realistic use-case scenarios.
struct ARCPhotoDemoScreen: View {
    // MARK: Private Properties

    /// Items with synthetic coloured-block thumbnails for demonstration.
    @State private var carouselItems: [ARCPhotoItem] = ARCPhotoDemoScreen.makeSampleItems(count: 4)
    @State private var selectedCount = 0

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                thumbnailSection
                carouselSection
                #if os(iOS)
                pickerSection
                #endif
                showcaseLinksSection
            }
            .padding(.vertical)
        }
        .navigationTitle("Photo Components")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Sections

extension ARCPhotoDemoScreen {
    private var thumbnailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("ARCPhotoThumbnail",
                          subtitle: "Displays a compressed thumbnail with placeholder fallback")

            HStack(alignment: .bottom, spacing: 16) {
                VStack(spacing: 6) {
                    ARCPhotoThumbnail(data: carouselItems.first?.thumbnailData)
                    Text("default").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 6) {
                    ARCPhotoThumbnail(data: carouselItems.first?.thumbnailData,
                                      configuration: .compact)
                    Text("compact").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 6) {
                    ARCPhotoThumbnail(data: carouselItems.first?.thumbnailData,
                                      configuration: .featured)
                    Text("featured").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 6) {
                    ARCPhotoThumbnail(data: nil)
                    Text("placeholder").font(.caption2).foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
        }
    }

    private var carouselSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("ARCPhotoCarousel",
                          subtitle: "Horizontal scroll carousel for visit photo attachments")

            ARCPhotoCarousel(items: carouselItems,
                             onDelete: { item in
                                 carouselItems.removeAll { $0.id == item.id }
                             })

            Text("\(carouselItems.count) photo(s) — swipe left on item to delete")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            HStack(spacing: 12) {
                Button("Add Sample Photo") {
                    let newItem = ARCPhotoDemoScreen.makeSampleItem(index: carouselItems.count)
                    carouselItems.append(newItem)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)

                if carouselItems.isEmpty {
                    Button("Reset") {
                        carouselItems = ARCPhotoDemoScreen.makeSampleItems(count: 4)
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    .padding(.horizontal)
                }
            }
        }
    }

    #if os(iOS)
    private var pickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("ARCPhotoPicker",
                          subtitle: "Photo picker button with ARCPhotoCarousel integration")

            VStack(alignment: .leading, spacing: 8) {
                Text("Standalone pickers").font(.subheadline).foregroundStyle(.secondary)
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    ARCPhotoPicker { data in selectedCount += data.count }
                    ARCPhotoPicker(configuration: .singlePhoto) { data in selectedCount += data.count }
                    ARCPhotoPicker(configuration: .iconOnly) { data in selectedCount += data.count }
                }
                .padding(.horizontal)

                if selectedCount > 0 {
                    Text("\(selectedCount) photo(s) selected this session")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Carousel with picker add-button").font(.subheadline).foregroundStyle(.secondary)
                    .padding(.horizontal)

                ARCPhotoCarousel(items: carouselItems,
                                 onDelete: { item in
                                     carouselItems.removeAll { $0.id == item.id }
                                 },
                                 addButton: {
                                     ARCPhotoPicker(configuration: .iconOnly) { data in
                                         if let raw = data.first {
                                             let item = ARCPhotoItem(thumbnailData: raw,
                                                                     imageData: raw)
                                             carouselItems.append(item)
                                         }
                                     }
                                 })
            }
        }
    }
    #endif

    private var showcaseLinksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Full Showcases",
                          subtitle: "Deep-dive into every variant")

            VStack(spacing: 0) {
                NavigationLink {
                    ARCPhotoThumbnailShowcase()
                } label: {
                    Label("ARCPhotoThumbnail Showcase", systemImage: "photo")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }

                Divider().padding(.leading)

                NavigationLink {
                    ARCPhotoCarouselShowcase()
                } label: {
                    Label("ARCPhotoCarousel Showcase", systemImage: "photo.on.rectangle.angled")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }

                #if os(iOS)
                Divider().padding(.leading)

                NavigationLink {
                    ARCPhotoPickerShowcase()
                } label: {
                    Label("ARCPhotoPicker Showcase", systemImage: "photo.badge.plus")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }
                #endif
            }
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
}

// MARK: - Sample Data

extension ARCPhotoDemoScreen {
    private static let paletteColors: [Color] = [.blue, .purple, .orange, .green, .red, .teal, .pink, .indigo]

    /// Creates a JPEG Data block for a solid-colour thumbnail (for demo purposes).
    static func makeSampleItem(index: Int) -> ARCPhotoItem {
        ARCPhotoItem(id: UUID(),
                     thumbnailData: solidColorJPEG(paletteColors[index % paletteColors.count]),
                     caption: "Photo \(index + 1)")
    }

    static func makeSampleItems(count: Int) -> [ARCPhotoItem] {
        (0 ..< count).map { makeSampleItem(index: $0) }
    }

    /// Renders a 100×100 solid-colour JPEG using UIGraphicsImageRenderer.
    private static func solidColorJPEG(_ color: Color) -> Data {
        #if canImport(UIKit)
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            UIColor(color).setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
        return image.jpegData(compressionQuality: 0.7) ?? Data()
        #else
        return Data()
        #endif
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCPhotoDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCPhotoDemoScreen()
    }
    .preferredColorScheme(.dark)
}
