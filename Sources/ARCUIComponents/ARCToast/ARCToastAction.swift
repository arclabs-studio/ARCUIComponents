//
//  ARCToastAction.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import Foundation

// MARK: - ARCToastAction

/// An optional action button displayed in a toast notification
///
/// `ARCToastAction` allows users to respond to a toast with a single tap,
/// commonly used for undo operations, retries, or navigation.
///
/// ## Overview
///
/// Toast actions provide a way for users to interact with notifications
/// without navigating away from their current context. The action button
/// appears on the trailing edge of the toast.
///
/// ## Topics
///
/// ### Creating Actions
///
/// - ``init(_:action:)``
///
/// ## Usage
///
/// ```swift
/// // Undo action
/// ARCToastAction("Undo") {
///     viewModel.undoDelete()
/// }
///
/// // Retry action
/// ARCToastAction("Retry") {
///     await viewModel.fetchData()
/// }
///
/// // View action
/// ARCToastAction("View") {
///     router.navigate(to: .details)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCToastAction: Sendable {
    // MARK: - Properties

    /// The title displayed on the action button
    public let title: String

    /// The closure executed when the action is tapped
    public let action: @Sendable @MainActor () -> Void

    // MARK: - Initialization

    /// Creates a toast action with the specified title and handler
    ///
    /// - Parameters:
    ///   - title: The button title (keep it short: "Undo", "Retry", "View")
    ///   - action: The closure to execute when tapped
    public init(_ title: String, action: @escaping @Sendable @MainActor () -> Void) {
        self.title = title
        self.action = action
    }
}

// MARK: - Common Actions

@available(iOS 17.0, macOS 14.0, *)
extension ARCToastAction {
    /// Creates an "Undo" action
    ///
    /// - Parameter action: The undo handler
    /// - Returns: An ARCToastAction with "Undo" title
    public static func undo(_ action: @escaping @Sendable @MainActor () -> Void) -> ARCToastAction {
        ARCToastAction("Undo", action: action)
    }

    /// Creates a "Retry" action
    ///
    /// - Parameter action: The retry handler
    /// - Returns: An ARCToastAction with "Retry" title
    public static func retry(_ action: @escaping @Sendable @MainActor () -> Void) -> ARCToastAction {
        ARCToastAction("Retry", action: action)
    }

    /// Creates a "View" action
    ///
    /// - Parameter action: The view handler
    /// - Returns: An ARCToastAction with "View" title
    public static func view(_ action: @escaping @Sendable @MainActor () -> Void) -> ARCToastAction {
        ARCToastAction("View", action: action)
    }

    /// Creates a "Dismiss" action
    ///
    /// - Parameter action: The dismiss handler (optional, defaults to empty)
    /// - Returns: An ARCToastAction with "Dismiss" title
    public static func dismiss(_ action: @escaping @Sendable @MainActor () -> Void = {}) -> ARCToastAction {
        ARCToastAction("Dismiss", action: action)
    }
}
