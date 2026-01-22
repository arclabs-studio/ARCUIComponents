//
//  ARCChipDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCChip component.
///
/// Shows interactive chip selection with single-select, multi-select, and input modes.
@available(iOS 17.0, *)
struct ARCChipDemoScreen: View {
    // MARK: - State

    @State private var selectedChip = false
    @State private var selectedCuisines: Set<String> = ["Italian"]
    @State private var selectedPriceRange: Set<String> = ["$$"]
    @State private var inputTags: Set<String> = ["Swift", "iOS", "SwiftUI"]

    private let cuisines = ["Italian", "Japanese", "Mexican", "Chinese", "Indian", "Thai", "French", "Greek"]
    private let priceRanges = ["$", "$$", "$$$", "$$$$"]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                basicUsageSection
                multiSelectSection
                singleSelectSection
                inputChipsSection
                configurationsSection
            }
            .padding()
        }
        .navigationTitle("ARCChip")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCChipDemoScreen {
    // MARK: - Basic Usage Section

    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Basic Usage", subtitle: "Interactive toggle chips")

            VStack(spacing: 16) {
                usageRow("Interactive", description: "Tap to toggle") {
                    ARCChip("Tap me", isSelected: $selectedChip)
                }

                usageRow("With Icon", description: "Leading icon display") {
                    HStack(spacing: 12) {
                        ARCChip("Filter", icon: "line.3.horizontal.decrease", isSelected: .constant(false))
                        ARCChip("Active", icon: "checkmark.circle", isSelected: .constant(true))
                    }
                }

                usageRow("Sizes", description: "Small, medium, large") {
                    HStack(spacing: 12) {
                        ARCChip("Small", isSelected: .constant(true), configuration: .init(size: .small))
                        ARCChip("Medium", isSelected: .constant(true), configuration: .init(size: .medium))
                        ARCChip("Large", isSelected: .constant(true), configuration: .init(size: .large))
                    }
                }
            }
        }
    }

    private func usageRow(
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

    // MARK: - Multi-Select Section

    private var multiSelectSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Multi-Select", subtitle: "Select multiple options with ARCChipGroup")

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

                Button {
                    withAnimation {
                        selectedCuisines = ["Italian"]
                    }
                } label: {
                    Text("Reset")
                        .font(.caption)
                        .foregroundStyle(Color.arcBrandBurgundy)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Single-Select Section

    private var singleSelectSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Single-Select", subtitle: "Radio-style selection")

            VStack(alignment: .leading, spacing: 12) {
                Text("Select price range:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ARCChipGroup(
                    items: priceRanges,
                    selection: $selectedPriceRange,
                    selectionMode: .single,
                    itemLabel: { $0 }
                )

                Text("Selected: \(selectedPriceRange.first ?? "None")")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Input Chips Section

    private var inputChipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Input Chips", subtitle: "Dismissible tags for forms")

            VStack(alignment: .leading, spacing: 12) {
                Text("Your skills:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                FlowLayoutChipDemo(spacing: 8) {
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

                Button {
                    withAnimation {
                        inputTags = ["Swift", "iOS", "SwiftUI"]
                    }
                } label: {
                    Text("Reset Skills")
                        .font(.caption)
                        .foregroundStyle(Color.arcBrandBurgundy)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Configurations Section

    private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Configurations", subtitle: "Customization options")

            VStack(spacing: 16) {
                configRow("With Checkmark", description: "Default selected indicator") {
                    ARCChip("With Checkmark", isSelected: .constant(true))
                }

                configRow("No Checkmark", description: "Selected without indicator") {
                    ARCChip(
                        "No Checkmark",
                        isSelected: .constant(true),
                        configuration: .init(showCheckmark: false)
                    )
                }

                configRow("Dismissible", description: "Shows X button when selected") {
                    ARCChip("Remove me", isSelected: .constant(true), configuration: .input)
                }

                configRow("Custom Colors", description: "Brand color variations") {
                    HStack(spacing: 8) {
                        ARCChip("Blue", isSelected: .constant(true), configuration: .init(selectedColor: .blue))
                        ARCChip("Green", isSelected: .constant(true), configuration: .init(selectedColor: .green))
                        ARCChip("Purple", isSelected: .constant(true), configuration: .init(selectedColor: .purple))
                        ARCChip("Orange", isSelected: .constant(true), configuration: .init(selectedColor: .orange))
                    }
                }

                configRow("Glass Effect", description: "Liquid glass background") {
                    HStack(spacing: 8) {
                        ARCChip("Glass", isSelected: .constant(false), configuration: .glass)
                        ARCChip("Premium", isSelected: .constant(true), configuration: .glass)
                    }
                }
            }
        }
    }

    private func configRow(
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
private struct FlowLayoutChipDemo: Layout {
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
        ARCChipDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCChipDemoScreen()
    }
    .preferredColorScheme(.dark)
}
