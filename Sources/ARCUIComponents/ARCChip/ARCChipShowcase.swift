//
//  ARCChipShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCChipShowcase

/// A comprehensive showcase of all ARCChip configurations
@available(iOS 17.0, macOS 14.0, *)
public struct ARCChipShowcase: View {
    // MARK: - State

    @State private var selectedChip = false
    @State private var selectedCuisines: Set<String> = ["Italian"]
    @State private var selectedPrice: Set<String> = ["$$"]
    @State private var inputTags: Set<String> = ["Swift", "iOS", "SwiftUI"]

    private let cuisines = ["Italian", "Japanese", "Mexican", "Chinese", "Indian", "Thai"]
    private let priceRanges = ["$", "$$", "$$$", "$$$$"]

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    statesSection
                    sizesSection
                    configurationsSection
                    brandColorsSection
                    multiSelectSection
                    singleSelectSection
                    inputChipsSection
                }
                .padding()
            }
            .navigationTitle("ARCChip")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

// MARK: - Sections

@available(iOS 17.0, macOS 14.0, *)
extension ARCChipShowcase {
    @ViewBuilder private var statesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("States")

            VStack(spacing: 12) {
                row("Interactive") {
                    ARCChip("Tap me", isSelected: $selectedChip)
                }

                row("With Icon") {
                    HStack(spacing: 12) {
                        ARCChip("Filter", icon: "line.3.horizontal.decrease", isSelected: .constant(false))
                        ARCChip("Active", icon: "checkmark.circle", isSelected: .constant(true))
                    }
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
                        ARCChip("Small", isSelected: .constant(true), configuration: .init(size: .small))
                        Text("Small").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCChip("Medium", isSelected: .constant(true), configuration: .init(size: .medium))
                        Text("Medium").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCChip("Large", isSelected: .constant(true), configuration: .init(size: .large))
                        Text("Large").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Configurations")

            VStack(spacing: 12) {
                row("Default") {
                    ARCChip("With Checkmark", isSelected: .constant(true))
                }

                row("No Checkmark") {
                    ARCChip("No Checkmark", isSelected: .constant(true), configuration: .init(showCheckmark: false))
                }

                row("Dismissible") {
                    ARCChip("Remove me", isSelected: .constant(true), configuration: .input)
                }

                row("Colors") {
                    HStack(spacing: 8) {
                        ARCChip("Blue", isSelected: .constant(true), configuration: .init(selectedColor: .blue))
                        ARCChip("Green", isSelected: .constant(true), configuration: .init(selectedColor: .green))
                        ARCChip("Purple", isSelected: .constant(true), configuration: .init(selectedColor: .purple))
                    }
                }
            }
        }
    }

    @ViewBuilder private var brandColorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("ARC Brand Colors")

            VStack(spacing: 12) {
                row("Selected") {
                    HStack(spacing: 12) {
                        VStack(spacing: 4) {
                            ARCChip(
                                "Burgundy",
                                isSelected: .constant(true),
                                configuration: .init(selectedColor: .arcBrandBurgundy)
                            )
                            Text("Primary").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCChip(
                                "Gold",
                                isSelected: .constant(true),
                                configuration: .init(selectedColor: .arcBrandGold)
                            )
                            Text("Secondary").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }

                row("Unselected") {
                    HStack(spacing: 12) {
                        ARCChip(
                            "Burgundy",
                            isSelected: .constant(false),
                            configuration: .init(unselectedColor: .arcBrandBurgundy)
                        )
                        ARCChip(
                            "Gold",
                            isSelected: .constant(false),
                            configuration: .init(unselectedColor: .arcBrandGold)
                        )
                    }
                }

                row("With Icons") {
                    HStack(spacing: 12) {
                        ARCChip(
                            "ARC Labs",
                            icon: "star.fill",
                            isSelected: .constant(true),
                            configuration: .init(selectedColor: .arcBrandBurgundy)
                        )
                        ARCChip(
                            "Premium",
                            icon: "crown.fill",
                            isSelected: .constant(true),
                            configuration: .init(selectedColor: .arcBrandGold)
                        )
                    }
                }
            }
        }
    }

    @ViewBuilder private var multiSelectSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Multi-Select (Chip Group)")

            VStack(alignment: .leading, spacing: 12) {
                Text("Select your favorite cuisines:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ARCChipGroup(
                    items: cuisines,
                    selection: $selectedCuisines,
                    selectionMode: .multiple,
                    itemLabel: { $0 }
                )

                Text("Selected: \(selectedCuisines.sorted().joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder private var singleSelectSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Single-Select")

            VStack(alignment: .leading, spacing: 12) {
                Text("Select price range:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ARCChipGroup(
                    items: priceRanges,
                    selection: $selectedPrice,
                    selectionMode: .single,
                    itemLabel: { $0 }
                )

                Text("Selected: \(selectedPrice.first ?? "None")")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder private var inputChipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Input Chips (Dismissible)")

            VStack(alignment: .leading, spacing: 12) {
                Text("Your skills:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                FlowLayoutChipShowcase(spacing: 8) {
                    ForEach(Array(inputTags).sorted(), id: \.self) { tag in
                        ARCChip(
                            tag,
                            isSelected: Binding(
                                get: { inputTags.contains(tag) },
                                set: { if !$0 { inputTags.remove(tag) } }
                            ),
                            configuration: .input
                        )
                    }
                }

                if inputTags.isEmpty {
                    Text("No skills selected")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.vertical, 8)
                }

                Button("Reset") {
                    inputTags = ["Swift", "iOS", "SwiftUI"]
                }
                .font(.caption)
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
                .frame(width: 100, alignment: .leading)

            content()

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - FlowLayout for Showcase

@available(iOS 17.0, macOS 14.0, *)
private struct FlowLayoutChipShowcase: Layout {
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
    ARCChipShowcase()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase - Dark") {
    ARCChipShowcase()
        .preferredColorScheme(.dark)
}
