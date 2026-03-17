//
//  ARCTagShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCTagShowcase

/// A comprehensive showcase of all ARCTag configurations
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTagShowcase: View {
    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    stylesSection
                    sizesSection
                    iconsSection
                    colorsSection
                    brandColorsSection
                    realWorldSection
                }
                .padding()
            }
            .navigationTitle("ARCTag")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

// MARK: - Sections

@available(iOS 17.0, macOS 14.0, *)
extension ARCTagShowcase {
    @ViewBuilder private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Styles")

            VStack(spacing: 12) {
                row("Default") {
                    ARCTag("Category")
                }

                row("Filled") {
                    ARCTag("Status", configuration: .init(style: .filled, color: .green))
                }

                row("Outlined") {
                    ARCTag("Outlined", configuration: .outlined)
                }

                row("Subtle") {
                    ARCTag("Subtle", configuration: .init(style: .subtle, color: .purple))
                }

                row("Glass") {
                    ARCTag("Glass", configuration: .glass)
                }
            }
        }
    }

    @ViewBuilder private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Sizes")

            row("Comparison") {
                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        ARCTag("Small", configuration: .init(size: .small))
                        Text("Small").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCTag("Medium", configuration: .init(size: .medium))
                        Text("Medium").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCTag("Large", configuration: .init(size: .large))
                        Text("Large").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder private var iconsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("With Icons")

            VStack(spacing: 12) {
                row("Leading") {
                    HStack(spacing: 8) {
                        ARCTag("Italian", icon: "fork.knife")
                        ARCTag("Vegan", icon: "leaf.fill", configuration: .init(color: .green))
                    }
                }

                row("Trailing") {
                    HStack(spacing: 8) {
                        ARCTag(
                            "Verified",
                            icon: "checkmark.seal.fill",
                            configuration: .init(color: .blue, iconPosition: .trailing)
                        )
                    }
                }
            }
        }
    }

    @ViewBuilder private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Colors")

            VStack(spacing: 12) {
                row("Filled") {
                    HStack(spacing: 8) {
                        ARCTag("Red", configuration: .init(style: .filled, color: .red))
                        ARCTag("Orange", configuration: .init(style: .filled, color: .orange))
                        ARCTag("Green", configuration: .init(style: .filled, color: .green))
                        ARCTag("Blue", configuration: .init(style: .filled, color: .blue))
                    }
                }

                row("Subtle") {
                    HStack(spacing: 8) {
                        ARCTag("Red", configuration: .init(style: .subtle, color: .red))
                        ARCTag("Orange", configuration: .init(style: .subtle, color: .orange))
                        ARCTag("Green", configuration: .init(style: .subtle, color: .green))
                        ARCTag("Blue", configuration: .init(style: .subtle, color: .blue))
                    }
                }
            }
        }
    }

    @ViewBuilder private var brandColorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("ARC Brand Colors")

            VStack(spacing: 12) {
                row("Filled") {
                    HStack(spacing: 8) {
                        VStack(spacing: 4) {
                            ARCTag("Burgundy", configuration: .init(style: .filled, color: .arcBrandBurgundy))
                            Text("Primary").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCTag("Gold", configuration: .init(style: .filled, color: .arcBrandGold))
                            Text("Secondary").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }

                row("Subtle") {
                    HStack(spacing: 8) {
                        ARCTag("Burgundy", configuration: .init(style: .subtle, color: .arcBrandBurgundy))
                        ARCTag("Gold", configuration: .init(style: .subtle, color: .arcBrandGold))
                    }
                }

                row("Outlined") {
                    HStack(spacing: 8) {
                        ARCTag("Burgundy", configuration: .init(style: .outlined, color: .arcBrandBurgundy))
                        ARCTag("Gold", configuration: .init(style: .outlined, color: .arcBrandGold))
                    }
                }

                row("With Icons") {
                    HStack(spacing: 8) {
                        ARCTag(
                            "ARC Labs",
                            icon: "star.fill",
                            configuration: .init(style: .filled, color: .arcBrandBurgundy)
                        )
                        ARCTag(
                            "Premium",
                            icon: "crown.fill",
                            configuration: .init(style: .filled, color: .arcBrandGold)
                        )
                    }
                }
            }
        }
    }

    @ViewBuilder private var realWorldSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Real World Examples")

            VStack(alignment: .leading, spacing: 16) {
                // Genres
                VStack(alignment: .leading, spacing: 8) {
                    Text("Movie Genres")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    FlowLayoutShowcase(spacing: 8) {
                        ForEach(["Action", "Comedy", "Drama", "Sci-Fi", "Horror"], id: \.self) { genre in
                            ARCTag(genre, configuration: .category)
                        }
                    }
                }

                // Food attributes
                VStack(alignment: .leading, spacing: 8) {
                    Text("Food Attributes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    FlowLayoutShowcase(spacing: 8) {
                        ARCTag("Vegan", icon: "leaf.fill", configuration: .init(style: .filled, color: .green))
                        ARCTag("Gluten-Free", configuration: .init(style: .subtle, color: .orange))
                        ARCTag("Spicy", icon: "flame.fill", configuration: .init(style: .subtle, color: .red))
                        ARCTag("Organic", configuration: .init(style: .outlined, color: .green))
                    }
                }

                // Status
                VStack(alignment: .leading, spacing: 8) {
                    Text("Status Labels")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 8) {
                        ARCTag("Open", configuration: .init(style: .filled, color: .green))
                        ARCTag("Closed", configuration: .init(style: .filled, color: .red))
                        ARCTag("Coming Soon", configuration: .init(style: .subtle, color: .blue))
                    }
                }

                // Skills
                VStack(alignment: .leading, spacing: 8) {
                    Text("Skills")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    FlowLayoutShowcase(spacing: 8) {
                        ARCTag("Swift", icon: "swift", configuration: .init(color: .orange))
                        ARCTag("SwiftUI", configuration: .init(color: .blue))
                        ARCTag("iOS", icon: "iphone", configuration: .init(color: .gray))
                        ARCTag("macOS", icon: "desktopcomputer", configuration: .init(color: .gray))
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    private func row(_ label: String, @ViewBuilder content: () -> some View) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            content()

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - FlowLayout for Showcase

@available(iOS 17.0, macOS 14.0, *)
private struct FlowLayoutShowcase: Layout {
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

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase") {
    ARCTagShowcase()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase - Dark") {
    ARCTagShowcase()
        .preferredColorScheme(.dark)
}
