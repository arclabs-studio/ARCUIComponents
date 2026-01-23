//
//  ARCSegmentedControl.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - ARCSegmentedControl

/// A customizable segmented control with smooth selection animation
///
/// `ARCSegmentedControl` provides a horizontal set of mutually exclusive options,
/// similar to a `Picker` with segmented style but with more customization options
/// and visual styles including Apple's liquid glass effect.
///
/// ## Overview
///
/// Per Apple HIG: "A segmented control is a linear set of two or more segments,
/// each of which functions as a button." ARCSegmentedControl extends this with
/// multiple visual styles and smooth animations.
///
/// Key features:
/// - Multiple visual styles (filled, outlined, glass, underlined)
/// - Smooth sliding selection animation
/// - Text, icon, or combined segment content
/// - Full accessibility support with VoiceOver
/// - Haptic feedback on selection
///
/// ## Topics
///
/// ### Creating Segmented Controls
///
/// - ``init(selection:segments:configuration:)``
/// - ``init(selection:configuration:)-swift.init``
///
/// ## Usage
///
/// ```swift
/// // With enum conforming to CaseIterable
/// enum Tab: String, CaseIterable {
///     case home = "Home"
///     case search = "Search"
///     case profile = "Profile"
/// }
///
/// @State private var selectedTab: Tab = .home
///
/// ARCSegmentedControl(selection: $selectedTab)
///
/// // With custom segments
/// @State private var filter: Filter = .all
///
/// ARCSegmentedControl(
///     selection: $filter,
///     segments: [
///         .text("All", value: .all),
///         .textAndIcon("Favorites", icon: "heart.fill", value: .favorites),
///         .textAndIcon("Recent", icon: "clock.fill", value: .recent)
///     ],
///     configuration: .glass
/// )
///
/// // Icon-only segments
/// ARCSegmentedControl(
///     selection: $viewMode,
///     segments: [
///         .icon("list.bullet", value: .list, accessibilityLabel: "List view"),
///         .icon("square.grid.2x2", value: .grid, accessibilityLabel: "Grid view")
///     ],
///     configuration: .pill
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSegmentedControl<SelectionValue: Hashable & Sendable>: View {
    // MARK: - Properties

    @Binding private var selection: SelectionValue
    private let segments: [ARCSegment<SelectionValue>]
    private let configuration: ARCSegmentedControlConfiguration

    // MARK: - State

    @Namespace private var namespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a segmented control with custom segments
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected value
    ///   - segments: Array of segment items to display
    ///   - configuration: Visual and behavior configuration
    public init(
        selection: Binding<SelectionValue>,
        segments: [ARCSegment<SelectionValue>],
        configuration: ARCSegmentedControlConfiguration = .default
    ) {
        _selection = selection
        self.segments = segments
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        containerView
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Segmented control")
    }

    // MARK: - Container View

    @ViewBuilder private var containerView: some View {
        switch configuration.style {
        case .underlined:
            underlinedContainer
        default:
            standardContainer
        }
    }

    @ViewBuilder private var standardContainer: some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                segmentButton(for: segment)
            }
        }
        .padding(configuration.containerPadding)
        .frame(height: configuration.size.height)
        .background(containerBackground)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
    }

    @ViewBuilder private var underlinedContainer: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(segments) { segment in
                    segmentButton(for: segment)
                }
            }
            .frame(height: configuration.size.height)

            GeometryReader { geometry in
                let segmentWidth = geometry.size.width / CGFloat(segments.count)
                let selectedIndex = segments.firstIndex { $0.value == selection } ?? 0

                Rectangle()
                    .fill(configuration.selectedColor)
                    .frame(width: segmentWidth, height: 2)
                    .offset(x: CGFloat(selectedIndex) * segmentWidth)
                    .animation(animation, value: selection)
            }
            .frame(height: 2)
        }
    }

    // MARK: - Container Background

    @ViewBuilder private var containerBackground: some View {
        switch configuration.backgroundStyle {
        case .liquidGlass:
            glassBackground
        case .translucent:
            configuration.backgroundColor
        case let .solid(color, opacity):
            color.opacity(opacity)
        case let .material(material):
            Rectangle().fill(material)
        }
    }

    @ViewBuilder private var glassBackground: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 0.5
                    )
            }
    }

    // MARK: - Segment Button

    @ViewBuilder
    private func segmentButton(for segment: ARCSegment<SelectionValue>) -> some View {
        let isSelected = segment.value == selection

        Button {
            handleSelection(segment.value)
        } label: {
            segmentContent(for: segment, isSelected: isSelected)
                .frame(maxWidth: segmentMaxWidth)
                .frame(height: configuration.size.height - (configuration.containerPadding * 2))
                .background {
                    if isSelected, configuration.style != .underlined {
                        selectionIndicator
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(segment.resolvedAccessibilityLabel)
        .accessibilityValue(isSelected ? "Selected" : "")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint("Double tap to select")
    }

    @ViewBuilder
    private func segmentContent(for segment: ARCSegment<SelectionValue>, isSelected: Bool) -> some View {
        HStack(spacing: 6) {
            if let icon = segment.icon {
                Image(systemName: icon)
                    .font(.system(size: configuration.size.iconSize, weight: .medium))
            }

            if let label = segment.label {
                Text(label)
                    .font(configuration.size.font)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(isSelected ? configuration.selectedTextColor : configuration.unselectedColor)
        .padding(.horizontal, configuration.size.horizontalPadding)
    }

    // MARK: - Selection Indicator

    @ViewBuilder private var selectionIndicator: some View {
        switch configuration.style {
        case .filled:
            filledIndicator
        case .outlined:
            outlinedIndicator
        case .glass:
            glassIndicator
        case .underlined:
            EmptyView()
        }
    }

    @ViewBuilder private var filledIndicator: some View {
        RoundedRectangle(cornerRadius: configuration.selectionCornerRadius, style: .continuous)
            .fill(configuration.selectedColor)
            .matchedGeometryEffect(id: "selection", in: namespace)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }

    @ViewBuilder private var outlinedIndicator: some View {
        RoundedRectangle(cornerRadius: configuration.selectionCornerRadius, style: .continuous)
            .strokeBorder(configuration.selectedColor, lineWidth: 1.5)
            .matchedGeometryEffect(id: "selection", in: namespace)
    }

    @ViewBuilder private var glassIndicator: some View {
        RoundedRectangle(cornerRadius: configuration.selectionCornerRadius, style: .continuous)
            .fill(configuration.selectedColor)
            .matchedGeometryEffect(id: "selection", in: namespace)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }

    // MARK: - Computed Properties

    private var segmentMaxWidth: CGFloat? {
        switch configuration.segmentWidth {
        case .equal:
            .infinity
        case .proportional:
            nil
        case let .fixed(width):
            width
        }
    }

    private var animation: Animation? {
        guard configuration.animated, !reduceMotion else {
            return nil
        }
        return .spring(response: 0.3, dampingFraction: 0.75)
    }

    // MARK: - Actions

    private func handleSelection(_ value: SelectionValue) {
        guard value != selection else { return }

        if configuration.animated, !reduceMotion {
            withAnimation(animation) {
                selection = value
            }
        } else {
            selection = value
        }

        triggerHapticIfNeeded()
    }

    private func triggerHapticIfNeeded() {
        #if os(iOS)
        guard configuration.hapticFeedback, !reduceMotion else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
}

// MARK: - CaseIterable Convenience Init

@available(iOS 17.0, macOS 14.0, *)
extension ARCSegmentedControl
    where SelectionValue: CaseIterable & RawRepresentable, SelectionValue.AllCases: RandomAccessCollection,
    SelectionValue.RawValue == String {
    /// Creates a segmented control from an enum conforming to CaseIterable
    ///
    /// This convenience initializer automatically creates segments from all cases
    /// of an enum, using the raw value as the label.
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected value
    ///   - configuration: Visual and behavior configuration
    public init(
        selection: Binding<SelectionValue>,
        configuration: ARCSegmentedControlConfiguration = .default
    ) {
        let segments = SelectionValue.allCases.map { value in
            ARCSegment.text(value.rawValue, value: value)
        }
        self.init(selection: selection, segments: segments, configuration: configuration)
    }
}
