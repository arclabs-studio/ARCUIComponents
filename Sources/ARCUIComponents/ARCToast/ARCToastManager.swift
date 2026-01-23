//
//  ARCToastManager.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ToastItem

/// Internal model representing a queued toast
@available(iOS 17.0, macOS 14.0, *)
public struct ToastItem: Identifiable, Sendable {
    public let id = UUID()
    public let message: String
    public let type: ARCToastType
    public let action: ARCToastAction?
    public let configuration: ARCToastConfiguration
}

// MARK: - ARCToastManager

/// Manages toast presentation and queuing
///
/// `ARCToastManager` provides a centralized way to show toasts from anywhere
/// in your app. It handles queuing multiple toasts and presenting them
/// sequentially.
///
/// ## Overview
///
/// Use the shared instance to show toasts from any view or view model.
/// Toasts are queued and displayed one at a time, with each toast
/// automatically dismissing after its configured duration.
///
/// ## Topics
///
/// ### Showing Toasts
///
/// - ``show(_:type:action:configuration:)``
/// - ``dismiss()``
///
/// ### Convenience Methods
///
/// - ``showSuccess(_:action:)``
/// - ``showError(_:action:)``
/// - ``showWarning(_:action:)``
/// - ``showInfo(_:action:)``
///
/// ## Usage
///
/// ```swift
/// // Basic usage
/// ARCToastManager.shared.show("Changes saved", type: .success)
///
/// // With action
/// ARCToastManager.shared.show(
///     "Item deleted",
///     type: .info,
///     action: ARCToastAction("Undo") {
///         viewModel.undoDelete()
///     }
/// )
///
/// // Convenience methods
/// ARCToastManager.shared.showSuccess("Upload complete")
/// ARCToastManager.shared.showError("Network error", action: .retry {
///     viewModel.retry()
/// })
///
/// // At root of app, add the container
/// WindowGroup {
///     ContentView()
///         .arcToastContainer()
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
@Observable
@MainActor
public final class ARCToastManager {
    // MARK: - Singleton

    /// Shared instance for global toast management
    public static let shared = ARCToastManager()

    // MARK: - Properties

    /// The currently displayed toast, if any
    public private(set) var currentToast: ToastItem?

    /// Whether a toast is currently being displayed
    public var isShowingToast: Bool {
        currentToast != nil
    }

    /// Queue of pending toasts
    private var queue: [ToastItem] = []

    /// Task for auto-dismiss timer
    private var dismissTask: Task<Void, Never>?

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    /// Shows a toast with the specified parameters
    ///
    /// If a toast is already being displayed, the new toast is queued
    /// and will be shown after the current one dismisses.
    ///
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The toast type (default: .info)
    ///   - action: Optional action button
    ///   - configuration: Toast configuration (default: .default)
    public func show(
        _ message: String,
        type: ARCToastType = .info,
        action: ARCToastAction? = nil,
        configuration: ARCToastConfiguration = .default
    ) {
        let item = ToastItem(
            message: message,
            type: type,
            action: action,
            configuration: configuration
        )

        if currentToast == nil {
            presentToast(item)
        } else {
            queue.append(item)
        }
    }

    /// Dismisses the current toast immediately
    ///
    /// If there are queued toasts, the next one will be shown.
    public func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil

        currentToast = nil

        // Show next toast after brief delay
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(200))
            showNextIfAvailable()
        }
    }

    /// Clears all queued toasts
    ///
    /// Does not dismiss the currently displayed toast.
    public func clearQueue() {
        queue.removeAll()
    }

    /// Clears all toasts including the current one
    public func clearAll() {
        dismissTask?.cancel()
        dismissTask = nil
        queue.removeAll()
        currentToast = nil
    }

    // MARK: - Convenience Methods

    /// Shows a success toast
    ///
    /// - Parameters:
    ///   - message: The success message
    ///   - action: Optional action button
    public func showSuccess(_ message: String, action: ARCToastAction? = nil) {
        show(message, type: .success, action: action)
    }

    /// Shows an error toast
    ///
    /// - Parameters:
    ///   - message: The error message
    ///   - action: Optional action button (e.g., retry)
    public func showError(_ message: String, action: ARCToastAction? = nil) {
        show(message, type: .error, action: action, configuration: .error)
    }

    /// Shows a warning toast
    ///
    /// - Parameters:
    ///   - message: The warning message
    ///   - action: Optional action button
    public func showWarning(_ message: String, action: ARCToastAction? = nil) {
        show(message, type: .warning, action: action)
    }

    /// Shows an info toast
    ///
    /// - Parameters:
    ///   - message: The info message
    ///   - action: Optional action button
    public func showInfo(_ message: String, action: ARCToastAction? = nil) {
        show(message, type: .info, action: action)
    }

    // MARK: - Private Methods

    private func presentToast(_ item: ToastItem) {
        currentToast = item

        // Trigger haptic feedback
        #if os(iOS)
        if item.configuration.hapticFeedback {
            item.type.triggerHaptic()
        }
        #endif

        // Schedule auto-dismiss if duration is not indefinite
        if let duration = item.configuration.duration.seconds {
            scheduleAutoDismiss(after: duration)
        }
    }

    private func scheduleAutoDismiss(after seconds: TimeInterval) {
        dismissTask?.cancel()

        dismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(seconds))

            guard !Task.isCancelled else { return }

            dismiss()
        }
    }

    private func showNextIfAvailable() {
        guard currentToast == nil, !queue.isEmpty else { return }

        let nextItem = queue.removeFirst()
        presentToast(nextItem)
    }
}
