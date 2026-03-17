//
//  ARCSkeletonDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCSkeletonView component.
///
/// Shows skeleton loading configurations for common scenarios with
/// interactive shimmer toggle and real-world layout examples.
@available(iOS 17.0, *)
struct ARCSkeletonDemoScreen: View {
    // MARK: Properties

    @State private var isAnimating = true
    @State private var isLoading = true
    @State private var selectedDemo: SkeletonDemo = .listRow

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                controlsSection
                demoSelector
                selectedDemoView
                primitivesSection
                textSection
                cardsSection
            }
            .padding()
        }
        .navigationTitle("ARCSkeletonView")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCSkeletonDemoScreen {
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Controls")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            Toggle("Shimmer Animation", isOn: $isAnimating)
                .tint(Color.arcBrandBurgundy)

            Toggle("Simulated Loading", isOn: $isLoading)
                .tint(Color.arcBrandBurgundy)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.arcBrandBlack.opacity(0.05))
        )
    }

    private var demoSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Layout Demos")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            Picker("Demo", selection: $selectedDemo) {
                ForEach(SkeletonDemo.allCases) { demo in
                    Text(demo.name).tag(demo)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    @ViewBuilder private var selectedDemoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            switch selectedDemo {
            case .listRow:
                listRowDemo
            case .grid:
                gridDemo
            case .profile:
                profileDemo
            case .article:
                articleDemo
            }
        }
    }

    // MARK: - Demo Views

    private var listRowDemo: some View {
        VStack(spacing: 16) {
            ForEach(0 ..< 3, id: \.self) { index in
                if isLoading {
                    HStack(spacing: 12) {
                        ARCSkeletonView(configuration: skeletonConfig(.avatar, delay: Double(index) * 0.1))

                        VStack(alignment: .leading, spacing: 4) {
                            ARCSkeletonView(configuration: skeletonConfig(.text, delay: Double(index) * 0.1 + 0.05))
                                .frame(width: 150)
                            ARCSkeletonView(configuration: skeletonConfig(.textSmall, delay: Double(index) * 0.1 + 0.1))
                                .frame(width: 100)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.arcBrandBlack.opacity(0.05))
                    )
                } else {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.arcBrandBurgundy)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("User Name \(index + 1)")
                                .font(.headline)
                            Text("user\(index + 1)@email.com")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.arcBrandBlack.opacity(0.05))
                    )
                }
            }
        }
    }

    private var gridDemo: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(0 ..< 4, id: \.self) { _ in
                if isLoading {
                    ARCSkeletonCard(
                        imageHeight: 100,
                        subtitleLines: 1,
                        showFooter: true
                    )
                } else {
                    ARCCard(
                        title: "Item Title",
                        subtitle: "Description",
                        subtitleIcon: "tag.fill"
                    ) {
                        Color.arcBrandGold.opacity(0.2)
                            .frame(height: 100)
                            .overlay {
                                Image(systemName: "star.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.arcBrandGold)
                            }
                    } footer: {
                        ARCRatingView(rating: 4.5)
                    }
                }
            }
        }
    }

    private var profileDemo: some View {
        VStack(spacing: 20) {
            if isLoading {
                // Profile header
                HStack(spacing: 16) {
                    ARCSkeletonView(configuration: skeletonConfig(.avatarLarge))

                    VStack(alignment: .leading, spacing: 8) {
                        ARCSkeletonView(configuration: skeletonConfig(.textLarge))
                            .frame(width: 150)
                        ARCSkeletonView(configuration: skeletonConfig(.textSmall, delay: 0.05))
                            .frame(width: 120)
                    }

                    Spacer()
                }

                // Stats row
                HStack(spacing: 32) {
                    ForEach(0 ..< 3, id: \.self) { index in
                        VStack(spacing: 4) {
                            ARCSkeletonView(configuration: skeletonConfig(.textLarge, delay: Double(index) * 0.05))
                                .frame(width: 40)
                            ARCSkeletonView(configuration: skeletonConfig(
                                .textSmall,
                                delay: Double(index) * 0.05 + 0.05
                            ))
                            .frame(width: 60)
                        }
                    }
                }

                // Bio
                ARCSkeletonText(
                    lineCount: 3,
                    lastLineWidth: 0.7,
                    configuration: skeletonConfig(.text, delay: 0.2)
                )
            } else {
                // Loaded profile
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.arcBrandBurgundy)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("John Doe")
                            .font(.title2.bold())
                        Text("@johndoe")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                HStack(spacing: 32) {
                    statView(value: "128", label: "Posts")
                    statView(value: "2.4K", label: "Followers")
                    statView(value: "512", label: "Following")
                }

                Text("iOS Developer passionate about Swift and SwiftUI. Building beautiful apps with ARC Labs.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.arcBrandBlack.opacity(0.05))
        )
    }

    private var articleDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                // Hero image
                ARCSkeletonView(configuration: skeletonConfig(.image))

                // Title
                ARCSkeletonView(configuration: skeletonConfig(.textLarge, delay: 0.1))
                ARCSkeletonView(configuration: skeletonConfig(.textLarge, delay: 0.15))
                    .frame(width: 200)

                // Meta info
                HStack(spacing: 12) {
                    ARCSkeletonView(configuration: skeletonConfig(.avatarSmall, delay: 0.2))
                    ARCSkeletonView(configuration: skeletonConfig(.textSmall, delay: 0.25))
                        .frame(width: 100)
                    Spacer()
                    ARCSkeletonView(configuration: skeletonConfig(.textSmall, delay: 0.3))
                        .frame(width: 80)
                }

                Divider()

                // Article body
                ARCSkeletonText(
                    lineCount: 5,
                    lastLineWidth: 0.5,
                    configuration: skeletonConfig(.text, delay: 0.35)
                )
            } else {
                // Loaded article
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.arcBrandBurgundy.opacity(0.3), Color.arcBrandGold.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .overlay {
                        Image(systemName: "newspaper.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.arcBrandBurgundy)
                    }

                Text("Building Beautiful Skeleton Loading States in SwiftUI")
                    .font(.title2.bold())

                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.arcBrandBurgundy)

                    Text("ARC Labs")
                        .font(.subheadline)

                    Spacer()

                    Text("5 min read")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Divider()

                Text(
                    """
                    Skeleton loading views provide visual feedback during content loading, \
                    improving perceived performance and user experience. In this article, \
                    we'll explore how to create beautiful skeleton animations...
                    """
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.arcBrandBlack.opacity(0.05))
        )
    }

    // MARK: - Sections

    private var primitivesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Primitive Shapes")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    ARCSkeletonView(configuration: skeletonConfig(.avatarSmall))
                    Text("Circle").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCSkeletonView(configuration: skeletonConfig(.avatar))
                    Text("Avatar").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCSkeletonView(configuration: skeletonConfig(.button))
                    Text("Capsule").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCSkeletonView(configuration: skeletonConfig(.icon))
                    Text("Icon").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Text Skeletons")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            VStack(alignment: .leading, spacing: 12) {
                Text("Single Line").font(.caption).foregroundStyle(.secondary)
                ARCSkeletonView(configuration: skeletonConfig(.text))

                Text("Multiple Lines").font(.caption).foregroundStyle(.secondary)
                ARCSkeletonText(
                    lineCount: 3,
                    lastLineWidth: 0.6,
                    configuration: skeletonConfig(.text)
                )
            }
        }
    }

    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Card Skeletons")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            HStack(spacing: 16) {
                ARCSkeletonCard.standard
                    .frame(width: 160)

                ARCSkeletonCard.compact
                    .frame(width: 140)
            }
        }
    }

    // MARK: - Helpers

    private func skeletonConfig(_ base: ARCSkeletonConfiguration, delay: Double = 0) -> ARCSkeletonConfiguration {
        ARCSkeletonConfiguration(
            shape: base.shape,
            size: base.size,
            baseColor: base.baseColor,
            highlightColor: base.highlightColor,
            animationDuration: base.animationDuration,
            animationDelay: delay,
            shimmerEnabled: isAnimating
        )
    }

    private func statView(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Supporting Types

@available(iOS 17.0, *)
private enum SkeletonDemo: String, CaseIterable, Identifiable {
    case listRow
    case grid
    case profile
    case article

    var id: String { rawValue }

    var name: String {
        switch self {
        case .listRow: "List Row"
        case .grid: "Grid"
        case .profile: "Profile"
        case .article: "Article"
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCSkeletonDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCSkeletonDemoScreen()
    }
    .preferredColorScheme(.dark)
}
