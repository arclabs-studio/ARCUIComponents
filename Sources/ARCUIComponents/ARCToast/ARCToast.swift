//
//  ARCToast.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCToast

/// A toast notification view for non-intrusive, temporary messages
///
/// `ARCToast` provides visual feedback for user actions without blocking
/// the interface. Toasts auto-dismiss after a configurable duration and
/// can include optional action buttons.
///
/// ## Overview
///
/// ARCToast supports:
/// - Multiple visual types (success, error, warning, info, custom)
/// - Configurable position (top or bottom)
/// - Auto-dismiss with configurable duration
/// - Optional action button (undo, retry, etc.)
/// - Swipe to dismiss gesture
/// - Haptic feedback
/// - Full accessibility support
///
/// ## Topics
///
/// ### Creating Toasts
///
/// - ``init(message:type:action:configuration:onDismiss:)``
///
/// ### Types
///
/// - ``ARCToastType``
/// - ``ARCToastAction``
/// - ``ARCToastConfiguration``
///
/// ## Usage
///
/// ```swift
/// // Basic toast
/// ARCToast(message: "Changes saved", type: .success)
///
/// // With action
/// ARCToast(
///     message: "Item deleted",
///     type: .info,
///     action: ARCToastAction("Undo") {
///         viewModel.undoDelete()
///     }
/// )
///
/// // Custom configuration
/// ARCToast(
///     message: "Network error",
///     type: .error,
///     configuration: .persistent
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCToast: View {
    // MARK: - Properties

    private let message: String
    private let type: ARCToastType
    private let action: ARCToastAction?
    private let configuration: ARCToastConfiguration
    private let onDismiss: () -> Void

    // MARK: - State

    @State private var offset: CGFloat = 0
    @State private var isDragging = false

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Scaled Metrics

    @ScaledMetric(relativeTo: .body)
    private var horizontalPadding: CGFloat = 16

    @ScaledMetric(relativeTo: .body)
    private var verticalPadding: CGFloat = 12

    @ScaledMetric(relativeTo: .body)
    private var iconSize: CGFloat = 20

    @ScaledMetric(relativeTo: .body)
    private var spacing: CGFloat = 12

    // MARK: - Initialization

    /// Creates a toast with the specified content and configuration
    ///
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The toast type (determines icon and color)
    ///   - action: Optional action button
    ///   - configuration: Visual and behavioral configuration
    ///   - onDismiss: Closure called when toast is dismissed
    public init(
        message: String,
        type: ARCToastType = .info,
        action: ARCToastAction? = nil,
        configuration: ARCToastConfiguration = .default,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.message = message
        self.type = type
        self.action = action
        self.configuration = configuration
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: spacing) {
            if configuration.showIcon {
                iconView
            }

            messageView

            if let action {
                actionButton(action)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(minHeight: 44)
        .liquidGlass(configuration: configuration)
        .offset(y: offset)
        .gesture(swipeGesture)
        .onTapGesture {
            if configuration.tapToDismiss {
                dismissToast()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isStaticText)
        .accessibilityAction(.escape) {
            dismissToast()
        }
    }

    // MARK: - Icon View

    @ViewBuilder private var iconView: some View {
        Image(systemName: type.icon)
            .font(.system(size: iconSize, weight: .semibold))
            .foregroundStyle(type.color)
            .accessibilityHidden(true)
    }

    // MARK: - Message View

    @ViewBuilder private var messageView: some View {
        Text(message)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.primary)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Action Button

    @ViewBuilder
    private func actionButton(_ action: ARCToastAction) -> some View {
        Button {
            action.action()
            dismissToast()
        } label: {
            Text(action.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(type.color)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Double tap to \(action.title.lowercased())")
    }

    // MARK: - Swipe Gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                guard configuration.swipeToDismiss else { return }
                isDragging = true

                let translation = value.translation.height
                let isCorrectDirection = configuration.position == .top
                    ? translation < 0
                    : translation > 0

                if isCorrectDirection {
                    offset = translation
                } else {
                    // Rubber band effect for wrong direction
                    offset = translation * 0.3
                }
            }
            .onEnded { value in
                guard configuration.swipeToDismiss else { return }
                isDragging = false

                let velocity = value.velocity.height
                let distance = abs(value.translation.height)
                let isCorrectDirection = configuration.position == .top
                    ? value.translation.height < 0
                    : value.translation.height > 0

                // Dismiss if velocity or distance threshold met
                if isCorrectDirection, abs(velocity) > 300 || distance > 50 {
                    dismissToast()
                } else {
                    // Spring back
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = 0
                    }
                }
            }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var label = "\(type.accessibilityPrefix): \(message)"
        if let action {
            label += ". Action available: \(action.title)"
        }
        return label
    }

    // MARK: - Dismiss

    private func dismissToast() {
        onDismiss()
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Toast Types") {
    VStack(spacing: 16) {
        ARCToast(message: "Changes saved successfully", type: .success)
        ARCToast(message: "Failed to upload file", type: .error)
        ARCToast(message: "Low storage space", type: .warning)
        ARCToast(message: "New update available", type: .info)
        ARCToast(
            message: "Custom notification",
            type: .custom(icon: "bell.fill", color: .purple)
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Actions") {
    VStack(spacing: 16) {
        ARCToast(
            message: "Item deleted",
            type: .info,
            action: .undo {}
        )

        ARCToast(
            message: "Network error",
            type: .error,
            action: .retry {}
        )

        ARCToast(
            message: "Message sent",
            type: .success,
            action: .view {}
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Configurations") {
    VStack(spacing: 16) {
        ARCToast(message: "Default", configuration: .default)
        ARCToast(message: "Minimal (no icon)", configuration: .minimal)
        ARCToast(message: "Prominent", configuration: .prominent)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    VStack(spacing: 16) {
        ARCToast(message: "Success in dark mode", type: .success)
        ARCToast(message: "Error in dark mode", type: .error)
        ARCToast(
            message: "With action",
            type: .info,
            action: .undo {}
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
