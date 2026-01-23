//
//  ARCChip.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCChip

/// An interactive, selectable chip for filtering and input
///
/// `ARCChip` provides toggle-style selection with visual feedback,
/// commonly used in filter interfaces and multi-select forms.
///
/// ## Overview
///
/// Use chips for:
/// - Filter chips (Cuisine type, Price range)
/// - Multi-select options
/// - Toggle buttons in a group
/// - Removable input tokens
///
/// ## Topics
///
/// ### Creating Chips
///
/// - ``init(_:icon:isSelected:configuration:onTap:)``
///
/// ## Usage
///
/// ```swift
/// // Basic chip
/// ARCChip("Sushi", isSelected: $isSelected)
///
/// // Chip with icon
/// ARCChip("Italian", icon: "fork.knife", isSelected: $isItalian)
///
/// // Filter chips in HStack
/// HStack {
///     ForEach(cuisines, id: \.self) { cuisine in
///         ARCChip(
///             cuisine.name,
///             isSelected: .init(
///                 get: { selected.contains(cuisine) },
///                 set: { if $0 { selected.insert(cuisine) } else { selected.remove(cuisine) } }
///             )
///         )
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCChip: View {
    // MARK: - Properties

    private let text: String
    private let icon: String?
    @Binding private var isSelected: Bool
    private let configuration: ARCChipConfiguration
    private let onTap: (() -> Void)?

    // MARK: - Initialization

    /// Creates an interactive chip
    ///
    /// - Parameters:
    ///   - text: The label text
    ///   - icon: Optional SF Symbol name
    ///   - isSelected: Binding to selection state
    ///   - configuration: Chip configuration
    ///   - onTap: Optional tap handler (in addition to toggling selection)
    public init(
        _ text: String,
        icon: String? = nil,
        isSelected: Binding<Bool>,
        configuration: ARCChipConfiguration = .default,
        onTap: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        _isSelected = isSelected
        self.configuration = configuration
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            handleTap()
        } label: {
            HStack(spacing: 6) {
                if configuration.showCheckmark && isSelected {
                    checkmarkView
                }

                if let icon, !isSelected || !configuration.showCheckmark {
                    iconView(icon)
                }

                textView

                if configuration.dismissible, isSelected {
                    dismissButton
                }
            }
            .padding(.horizontal, configuration.size.horizontalPadding)
            .frame(minHeight: configuration.size.height)
            .background(backgroundView)
            .clipShape(Capsule())
            .overlay {
                if !isSelected {
                    Capsule()
                        .strokeBorder(configuration.unselectedColor.opacity(0.3), lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(text)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to \(isSelected ? "deselect" : "select")")
    }

    // MARK: - Checkmark View

    @ViewBuilder private var checkmarkView: some View {
        Image(systemName: "checkmark")
            .font(.system(size: configuration.size.iconSize - 2, weight: .semibold))
            .foregroundStyle(.white)
            .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Icon View

    @ViewBuilder
    private func iconView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: configuration.size.iconSize))
            .foregroundStyle(isSelected ? .white : configuration.unselectedColor)
    }

    // MARK: - Text View

    @ViewBuilder private var textView: some View {
        Text(text)
            .font(.system(size: configuration.size.fontSize, weight: .medium))
            .foregroundStyle(isSelected ? .white : .primary)
    }

    // MARK: - Dismiss Button

    @ViewBuilder private var dismissButton: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                isSelected = false
            }
            triggerHapticIfNeeded()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: configuration.size.iconSize - 4, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
                .padding(4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Background View

    @ViewBuilder private var backgroundView: some View {
        if isSelected {
            configuration.selectedColor
        } else {
            configuration.unselectedColor.opacity(0.1)
        }
    }

    // MARK: - Actions

    private func handleTap() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            isSelected.toggle()
        }
        triggerHapticIfNeeded()
        onTap?()
    }

    private func triggerHapticIfNeeded() {
        #if os(iOS)
        if configuration.hapticFeedback {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        #endif
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Chip States") {
    struct PreviewView: View {
        @State private var selected1 = false
        @State private var selected2 = true
        @State private var selected3 = false

        var body: some View {
            HStack(spacing: 12) {
                ARCChip("Sushi", isSelected: $selected1)
                ARCChip("Pizza", isSelected: $selected2)
                ARCChip("Tacos", isSelected: $selected3)
            }
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Chip with Icons") {
    struct PreviewView: View {
        @State private var selected1 = true
        @State private var selected2 = false

        var body: some View {
            HStack(spacing: 12) {
                ARCChip("Italian", icon: "fork.knife", isSelected: $selected1)
                ARCChip("Japanese", icon: "leaf.fill", isSelected: $selected2)
            }
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dismissible Chips") {
    struct PreviewView: View {
        @State private var selected1 = true
        @State private var selected2 = true
        @State private var selected3 = true

        var body: some View {
            HStack(spacing: 12) {
                ARCChip("Swift", isSelected: $selected1, configuration: .input)
                ARCChip("iOS", isSelected: $selected2, configuration: .input)
                ARCChip("SwiftUI", isSelected: $selected3, configuration: .input)
            }
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Chip Sizes") {
    struct PreviewView: View {
        @State private var selected = true

        var body: some View {
            VStack(spacing: 16) {
                ARCChip("Small", isSelected: $selected, configuration: .init(size: .small))
                ARCChip("Medium", isSelected: $selected, configuration: .init(size: .medium))
                ARCChip("Large", isSelected: $selected, configuration: .init(size: .large))
            }
            .padding()
        }
    }
    return PreviewView()
}
