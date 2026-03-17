//
//  ARCTagDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCTag component.
///
/// Shows static label tags with various styles, colors, and configurations.
@available(iOS 17.0, *)
struct ARCTagDemoScreen: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                stylesSection
                iconsSection
                colorsSection
                realWorldExamplesSection
            }
            .padding()
        }
        .navigationTitle("ARCTag")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCTagDemoScreen {
    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Tag Styles", subtitle: "Different visual treatments")

            VStack(spacing: 16) {
                styleRow("Default", description: "Subtle tinted background") {
                    HStack(spacing: 8) {
                        ARCTag("Category")
                        ARCTag("Topic")
                        ARCTag("Label")
                    }
                }

                styleRow("Filled", description: "Solid background") {
                    HStack(spacing: 8) {
                        ARCTag("Active", configuration: .init(style: .filled, color: .green))
                        ARCTag("New", configuration: .init(style: .filled, color: .blue))
                        ARCTag("Hot", configuration: .init(style: .filled, color: .red))
                    }
                }

                styleRow("Outlined", description: "Border only") {
                    HStack(spacing: 8) {
                        ARCTag("Outlined", configuration: .outlined)
                        ARCTag("Bordered", configuration: .init(style: .outlined, color: .purple))
                    }
                }

                styleRow("Glass", description: "Liquid glass effect") {
                    HStack(spacing: 8) {
                        ARCTag("Glass", configuration: .glass)
                        ARCTag("Premium", configuration: .glass)
                    }
                }
            }
        }
    }

    private func styleRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Icons Section

    private var iconsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Tags with Icons", subtitle: "Leading and trailing icon positions")

            VStack(spacing: 16) {
                iconRow("Leading Icons", description: "Icon before text") {
                    HStack(spacing: 8) {
                        ARCTag("Italian", icon: "fork.knife")
                        ARCTag("Vegan", icon: "leaf.fill", configuration: .init(color: .green))
                        ARCTag("Spicy", icon: "flame.fill", configuration: .init(color: .orange))
                    }
                }

                iconRow("Trailing Icons", description: "Icon after text") {
                    HStack(spacing: 8) {
                        ARCTag(
                            "Verified",
                            icon: "checkmark.seal.fill",
                            configuration: .init(color: .blue, iconPosition: .trailing)
                        )
                        ARCTag(
                            "Premium",
                            icon: "star.fill",
                            configuration: .init(color: .yellow, iconPosition: .trailing)
                        )
                    }
                }
            }
        }
    }

    private func iconRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Colors Section

    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Color Variations", subtitle: "Filled and subtle styles")

            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    ARCTag("Red", configuration: .init(style: .filled, color: .red))
                    ARCTag("Orange", configuration: .init(style: .filled, color: .orange))
                    ARCTag("Green", configuration: .init(style: .filled, color: .green))
                    ARCTag("Blue", configuration: .init(style: .filled, color: .blue))
                }

                HStack(spacing: 8) {
                    ARCTag("Red", configuration: .init(style: .subtle, color: .red))
                    ARCTag("Orange", configuration: .init(style: .subtle, color: .orange))
                    ARCTag("Green", configuration: .init(style: .subtle, color: .green))
                    ARCTag("Blue", configuration: .init(style: .subtle, color: .blue))
                }

                HStack(spacing: 8) {
                    ARCTag("Purple", configuration: .init(style: .subtle, color: .purple))
                    ARCTag("Pink", configuration: .init(style: .subtle, color: .pink))
                    ARCTag("Teal", configuration: .init(style: .subtle, color: .teal))
                    ARCTag("Mint", configuration: .init(style: .subtle, color: .mint))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Real World Examples Section

    private var realWorldExamplesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Real World Examples", subtitle: "Common use cases")

            VStack(spacing: 20) {
                // Movie genres
                exampleSection("Movie Genres") {
                    FlowLayoutDemo(spacing: 8) {
                        ForEach(["Action", "Comedy", "Drama", "Sci-Fi", "Horror", "Romance"], id: \.self) { genre in
                            ARCTag(genre, configuration: .category)
                        }
                    }
                }

                // Food attributes
                exampleSection("Food Attributes") {
                    FlowLayoutDemo(spacing: 8) {
                        ARCTag("Vegan", icon: "leaf.fill", configuration: .init(style: .filled, color: .green))
                        ARCTag("Gluten-Free", configuration: .init(style: .subtle, color: .orange))
                        ARCTag("Spicy", icon: "flame.fill", configuration: .init(style: .subtle, color: .red))
                        ARCTag("Organic", configuration: .init(style: .outlined, color: .green))
                    }
                }

                // Status labels
                exampleSection("Status Labels") {
                    HStack(spacing: 8) {
                        ARCTag("Open", configuration: .init(style: .filled, color: .green))
                        ARCTag("Closed", configuration: .init(style: .filled, color: .red))
                        ARCTag("Coming Soon", configuration: .init(style: .subtle, color: .blue))
                    }
                }

                // Tech skills
                exampleSection("Skills") {
                    FlowLayoutDemo(spacing: 8) {
                        ARCTag("Swift", icon: "swift", configuration: .init(color: .orange))
                        ARCTag("SwiftUI", configuration: .init(color: .blue))
                        ARCTag("iOS", icon: "iphone", configuration: .init(color: .gray))
                        ARCTag("macOS", icon: "desktopcomputer", configuration: .init(color: .gray))
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private func exampleSection(
        _ title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            content()
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
    }
}

// MARK: - FlowLayout for Demo

@available(iOS 17.0, *)
private struct FlowLayoutDemo: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)

        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: ProposedViewSize(subviews[index].sizeThatFits(.unspecified))
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            totalWidth = max(totalWidth, currentX - spacing)
        }

        return (positions, CGSize(width: totalWidth, height: currentY + lineHeight))
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCTagDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCTagDemoScreen()
    }
    .preferredColorScheme(.dark)
}
