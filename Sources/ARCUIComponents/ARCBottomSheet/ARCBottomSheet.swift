//
//  ARCBottomSheet.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCBottomSheet

/// A customizable bottom sheet component with drag gestures and multiple detents
///
/// `ARCBottomSheet` provides more control than SwiftUI's native `.sheet()` with
/// `presentationDetents`, supporting liquid glass styling, custom detents, drag gestures,
/// and interactive dismissal. This pattern is used extensively in Apple Maps, Shortcuts, and Music.
///
/// ## Overview
///
/// ARCBottomSheet supports:
/// - Multiple detents (collapsed, half, expanded, custom)
/// - Smooth drag interaction between detents
/// - Velocity-based snapping
/// - Liquid glass background styling
/// - Interruptible animations
/// - Persistent mode (non-dismissable)
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating Bottom Sheets
///
/// - ``init(selectedDetent:detents:configuration:content:)``
///
/// ### Types
///
/// - ``ARCBottomSheetDetent``
/// - ``ARCBottomSheetConfiguration``
///
/// ## Usage
///
/// ```swift
/// // Basic modal sheet
/// @State private var detent: ARCBottomSheetDetent = .medium
///
/// Map()
///     .overlay(alignment: .bottom) {
///         ARCBottomSheet(
///             selectedDetent: $detent,
///             detents: [.small, .medium, .large]
///         ) {
///             SearchResultsList()
///         }
///     }
///
/// // With custom configuration
/// ARCBottomSheet(
///     selectedDetent: $detent,
///     detents: [.height(200), .fraction(0.6), .large],
///     configuration: .drawer
/// ) {
///     SheetContent()
/// }
/// ```
///
/// - Note: For presenting as an overlay, use the
/// ``View/arcBottomSheet(isPresented:detents:selectedDetent:configuration:onDismiss:content:)``
///   view modifier instead.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBottomSheet<Content: View>: View {
    // MARK: - Properties

    @Binding private var selectedDetent: ARCBottomSheetDetent
    private let detents: Set<ARCBottomSheetDetent>
    private let configuration: ARCBottomSheetConfiguration
    private let content: () -> Content

    // MARK: - State

    @GestureState private var dragOffset: CGFloat = 0
    @State private var containerHeight: CGFloat = 0

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Computed Properties

    private var sortedDetents: [ARCBottomSheetDetent] {
        detents.sorted()
    }

    private var currentHeight: CGFloat {
        selectedDetent.height(in: containerHeight)
    }

    private var displayHeight: CGFloat {
        let baseHeight = currentHeight - dragOffset
        let minHeight = minimumDetentHeight * 0.5
        let maxHeight = containerHeight * 0.95
        return max(minHeight, min(maxHeight, baseHeight))
    }

    private var minimumDetentHeight: CGFloat {
        sortedDetents.first?.height(in: containerHeight) ?? 120
    }

    private var maximumDetentHeight: CGFloat {
        sortedDetents.last?.height(in: containerHeight) ?? containerHeight * 0.9
    }

    // MARK: - Initialization

    /// Creates a bottom sheet with the specified detent binding and content
    ///
    /// - Parameters:
    ///   - selectedDetent: Binding to the currently selected detent
    ///   - detents: Set of available detents the sheet can snap to
    ///   - configuration: Configuration options for appearance and behavior
    ///   - content: The content to display inside the sheet
    public init(
        selectedDetent: Binding<ARCBottomSheetDetent>,
        detents: Set<ARCBottomSheetDetent> = [.medium, .large],
        configuration: ARCBottomSheetConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _selectedDetent = selectedDetent
        self.detents = detents.isEmpty ? [.medium, .large] : detents
        self.configuration = configuration
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color.clear
                    .onAppear {
                        containerHeight = geometry.size.height
                    }
                    .onChange(of: geometry.size.height) { _, newValue in
                        containerHeight = newValue
                    }

                sheetView
                    .frame(height: displayHeight)
                    .offset(y: 0)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Bottom sheet")
        .accessibilityValue(selectedDetent.accessibilityDescription)
        .accessibilityHint("Drag to resize")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                expandToNextDetent()
            case .decrement:
                collapseToNextDetent()
            @unknown default:
                break
            }
        }
    }

    // MARK: - Sheet View

    @ViewBuilder private var sheetView: some View {
        VStack(spacing: 0) {
            if configuration.showHandle {
                ARCBottomSheetHandle(
                    configuration: configuration,
                    onTap: cycleToNextDetent
                )
            }

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .background(sheetBackground)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: configuration.cornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: configuration.cornerRadius
            )
        )
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
        .gesture(dragGesture)
        .animation(
            reduceMotion ? .none : configuration.animation,
            value: selectedDetent
        )
    }

    // MARK: - Background

    @ViewBuilder private var sheetBackground: some View {
        switch configuration.backgroundStyle {
        case .liquidGlass:
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.15),
                                .white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Rectangle()
                    .fill(configuration.accentColor.opacity(0.03))
            }

        case .translucent:
            Rectangle()
                .fill(.thinMaterial)

        case let .solid(color, opacity):
            Rectangle()
                .fill(color.opacity(opacity))

        case let .material(material):
            Rectangle()
                .fill(material)
        }
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                if !configuration.isInteractiveDismissDisabled {
                    state = value.translation.height
                }
            }
            .onEnded { value in
                guard !configuration.isInteractiveDismissDisabled else { return }

                let velocity = value.predictedEndLocation.y - value.location.y
                let projectedHeight = currentHeight - value.translation.height - velocity * 0.2

                handleDragEnd(projectedHeight: projectedHeight, velocity: velocity)
            }
    }

    // MARK: - Snap Logic

    private func handleDragEnd(projectedHeight: CGFloat, velocity: CGFloat) {
        if abs(velocity) > configuration.velocityThreshold {
            if velocity < 0 {
                expandToNextDetent()
            } else {
                collapseToNextDetent()
            }
        } else {
            snapToNearestDetent(for: projectedHeight)
        }
    }

    private func snapToNearestDetent(for height: CGFloat) {
        var closestDetent = sortedDetents.first ?? .medium
        var minDistance = CGFloat.infinity

        for detent in sortedDetents {
            let detentHeight = detent.height(in: containerHeight)
            let distance = abs(height - detentHeight)

            if distance < minDistance {
                minDistance = distance
                closestDetent = detent
            }
        }

        withAnimation(reduceMotion ? .none : configuration.animation) {
            selectedDetent = closestDetent
        }
    }

    private func expandToNextDetent() {
        guard let currentIndex = sortedDetents.firstIndex(of: selectedDetent) else {
            snapToNearestDetent(for: currentHeight)
            return
        }

        let nextIndex = min(currentIndex + 1, sortedDetents.count - 1)
        withAnimation(reduceMotion ? .none : configuration.animation) {
            selectedDetent = sortedDetents[nextIndex]
        }
    }

    private func collapseToNextDetent() {
        guard let currentIndex = sortedDetents.firstIndex(of: selectedDetent) else {
            snapToNearestDetent(for: currentHeight)
            return
        }

        let previousIndex = max(currentIndex - 1, 0)
        withAnimation(reduceMotion ? .none : configuration.animation) {
            selectedDetent = sortedDetents[previousIndex]
        }
    }

    private func cycleToNextDetent() {
        guard let currentIndex = sortedDetents.firstIndex(of: selectedDetent) else { return }

        let nextIndex = (currentIndex + 1) % sortedDetents.count
        withAnimation(reduceMotion ? .none : configuration.animation) {
            selectedDetent = sortedDetents[nextIndex]
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCBottomSheet") {
    struct PreviewWrapper: View {
        @State private var detent: ARCBottomSheetDetent = .medium

        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    Text("Main Content")
                        .font(.largeTitle)
                        .foregroundStyle(.white)

                    Text("Current: \(detent.accessibilityDescription)")
                        .foregroundStyle(.white.opacity(0.8))
                }

                ARCBottomSheet(
                    selectedDetent: $detent,
                    detents: [.small, .medium, .large],
                    configuration: .default
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sheet Content")
                            .font(.headline)

                        Text("Drag the handle or swipe to change detents.")
                            .foregroundStyle(.secondary)

                        ForEach(0 ..< 5) { index in
                            HStack {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 40, height: 40)

                                VStack(alignment: .leading) {
                                    Text("Item \(index + 1)")
                                        .font(.body.weight(.medium))
                                    Text("Description text")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    return PreviewWrapper()
}
