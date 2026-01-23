//
//  ARCChipGroup.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCChipGroup

/// A container for managing multiple chips with single or multi-select
///
/// `ARCChipGroup` handles selection logic for a group of chips,
/// supporting both single-select (radio) and multi-select modes.
///
/// ## Overview
///
/// Use chip groups for:
/// - Filter interfaces with multiple options
/// - Category selection
/// - Multi-select forms
///
/// ## Topics
///
/// ### Selection Mode
///
/// - ``SelectionMode``
///
/// ## Usage
///
/// ```swift
/// // Multi-select chips
/// ARCChipGroup(
///     items: cuisineTypes,
///     selection: $selectedCuisines,
///     selectionMode: .multiple,
///     itemLabel: { $0.name }
/// )
///
/// // Single-select chips
/// ARCChipGroup(
///     items: priceRanges,
///     selection: $selectedPrice,
///     selectionMode: .single,
///     itemLabel: { $0.label },
///     itemIcon: { $0.icon }
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCChipGroup<Item: Hashable>: View {
    // MARK: - Selection Mode

    /// Selection behavior for the chip group
    public enum SelectionMode: Sendable {
        /// Only one item can be selected at a time
        case single

        /// Multiple items can be selected
        case multiple
    }

    // MARK: - Properties

    private let items: [Item]
    @Binding private var selection: Set<Item>
    private let selectionMode: SelectionMode
    private let itemLabel: (Item) -> String
    private let itemIcon: ((Item) -> String?)?
    private let configuration: ARCChipConfiguration

    // MARK: - Initialization

    /// Creates a chip group with the specified items
    ///
    /// - Parameters:
    ///   - items: The items to display as chips
    ///   - selection: Binding to the set of selected items
    ///   - selectionMode: Single or multiple selection
    ///   - itemLabel: Closure to get label text from item
    ///   - itemIcon: Optional closure to get icon from item
    ///   - configuration: Chip configuration (applied to all chips)
    public init(
        items: [Item],
        selection: Binding<Set<Item>>,
        selectionMode: SelectionMode = .multiple,
        itemLabel: @escaping (Item) -> String,
        itemIcon: ((Item) -> String?)? = nil,
        configuration: ARCChipConfiguration = .default
    ) {
        self.items = items
        _selection = selection
        self.selectionMode = selectionMode
        self.itemLabel = itemLabel
        self.itemIcon = itemIcon
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { item in
                chipView(for: item)
            }
        }
    }

    // MARK: - Chip View

    @ViewBuilder
    private func chipView(for item: Item) -> some View {
        ARCChip(
            itemLabel(item),
            icon: itemIcon?(item),
            isSelected: binding(for: item),
            configuration: configuration
        )
    }

    // MARK: - Selection Binding

    private func binding(for item: Item) -> Binding<Bool> {
        Binding(
            get: { selection.contains(item) },
            set: { isSelected in
                if isSelected {
                    if selectionMode == .single {
                        selection = [item]
                    } else {
                        selection.insert(item)
                    }
                } else {
                    selection.remove(item)
                }
            }
        )
    }
}

// MARK: - FlowLayout

/// A layout that arranges views in a flowing grid
@available(iOS 17.0, macOS 14.0, *)
struct FlowLayout: Layout {
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
#Preview("Multi-Select") {
    struct PreviewView: View {
        @State private var selection: Set<String> = ["Italian", "Japanese"]

        let cuisines = ["Italian", "Japanese", "Mexican", "Chinese", "Indian", "Thai", "French", "Greek"]

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Select cuisines:")
                    .font(.headline)

                ARCChipGroup(
                    items: cuisines,
                    selection: $selection,
                    selectionMode: .multiple,
                    itemLabel: { $0 }
                )

                Text("Selected: \(selection.sorted().joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Single-Select") {
    struct PreviewView: View {
        @State private var selection: Set<String> = ["$$"]

        let priceRanges = ["$", "$$", "$$$", "$$$$"]

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Price range:")
                    .font(.headline)

                ARCChipGroup(
                    items: priceRanges,
                    selection: $selection,
                    selectionMode: .single,
                    itemLabel: { $0 }
                )

                Text("Selected: \(selection.first ?? "None")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
    return PreviewView()
}
