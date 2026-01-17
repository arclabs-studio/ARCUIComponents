//
//  ARCMenuViewModel.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import Observation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// View model for ARCMenu
///
/// Manages menu state, animations, and user interactions.
/// Uses Swift's `@Observable` macro for reactive updates.
///
/// - Note: Conforms to `@MainActor` for UI thread safety with Swift 6
@MainActor
@Observable
// swiftlint:disable:next observable_viewmodel
public final class ARCMenuViewModel {
    // MARK: - Published State

    /// Whether the menu is currently presented
    public private(set) var isPresented = false

    /// Current drag offset for dismissal gesture
    public private(set) var dragOffset: CGFloat = 0

    /// Opacity of the backdrop overlay
    public private(set) var backdropOpacity: Double = 0

    /// Menu user information
    public var user: ARCMenuUser?

    /// Menu items to display
    public var menuItems: [ARCMenuItem] = []

    /// Menu configuration
    public var configuration: ARCMenuConfiguration

    // MARK: - Private State

    #if os(iOS)
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    #endif

    // MARK: - Initialization

    /// Creates a new ARCMenu view model
    /// - Parameters:
    ///   - user: User information to display
    ///   - menuItems: Items to show in the menu
    ///   - configuration: Menu configuration
    public init(
        user: ARCMenuUser? = nil,
        menuItems: [ARCMenuItem] = [],
        configuration: ARCMenuConfiguration = .default
    ) {
        self.user = user
        self.menuItems = menuItems
        self.configuration = configuration
        prepareFeedbackGenerator()
    }

    // MARK: - Public Methods

    /// Presents the menu with animation
    public func present() {
        configuration.hapticFeedback.perform()

        withAnimation(configuration.presentationAnimation) {
            isPresented = true
            backdropOpacity = 1.0
        }
    }

    /// Dismisses the menu with animation
    public func dismiss() {
        configuration.hapticFeedback.perform()

        withAnimation(configuration.dismissalAnimation) {
            isPresented = false
            backdropOpacity = 0
            dragOffset = 0
        }
    }

    /// Toggles the menu presentation state
    public func toggle() {
        if isPresented {
            dismiss()
        } else {
            present()
        }
    }

    /// Updates drag offset during drag gesture
    /// - Parameters:
    ///   - offset: Current drag offset
    ///   - isVertical: Whether the drag is vertical (bottomSheet) or horizontal (trailingPanel)
    public func updateDragOffset(_ offset: CGFloat, isVertical: Bool = false) {
        // Only allow dragging in the dismissal direction (positive offset)
        if offset > 0 {
            dragOffset = offset

            // Update backdrop opacity based on drag progress
            let progress = min(offset / configuration.dragDismissalThreshold, 1.0)
            backdropOpacity = 1.0 - (progress * 0.5)

            // Trigger haptic at threshold
            if offset >= configuration.dragDismissalThreshold {
                triggerDismissalHaptic()
            }
        }
    }

    /// Handles end of drag gesture
    /// - Parameters:
    ///   - offset: Final drag offset
    ///   - isVertical: Whether the drag is vertical (bottomSheet) or horizontal (trailingPanel)
    public func endDrag(at offset: CGFloat, isVertical: Bool = false) {
        if offset >= configuration.dragDismissalThreshold {
            dismiss()
        } else {
            // Snap back with spring animation
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                dragOffset = 0
                backdropOpacity = 1.0
            }
        }
    }

    /// Executes a menu item action and dismisses the menu
    /// - Parameter item: The menu item to execute
    public func executeAction(for item: ARCMenuItem) {
        // Perform light haptic for item selection
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif

        // Dismiss menu first for better UX
        dismiss()

        // Execute action after a brief delay to complete animation
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            item.action()
        }
    }

    // MARK: - Private Methods

    private func prepareFeedbackGenerator() {
        #if os(iOS)
        feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator?.prepare()
        #endif
    }

    private func triggerDismissalHaptic() {
        #if os(iOS)
        // Only trigger once at threshold
        if dragOffset == configuration.dragDismissalThreshold {
            feedbackGenerator?.impactOccurred()
            feedbackGenerator?.prepare()
        }
        #endif
    }
}

// MARK: - Convenience Initializers

extension ARCMenuViewModel {
    /// Creates a view model with common menu items
    /// - Parameters:
    ///   - user: User information
    ///   - configuration: Menu configuration
    ///   - onSettings: Settings action handler
    ///   - onProfile: Profile action handler
    ///   - onPlan: Plan action handler
    ///   - onContact: Contact action handler
    ///   - onAbout: About action handler
    ///   - onLogout: Logout action handler
    /// - Returns: Configured view model with standard menu items
    public static func standard(
        user: ARCMenuUser?,
        configuration: ARCMenuConfiguration = .default,
        onSettings: (@Sendable () -> Void)? = nil,
        onProfile: (@Sendable () -> Void)? = nil,
        onPlan: (@Sendable () -> Void)? = nil,
        onContact: (@Sendable () -> Void)? = nil,
        onAbout: (@Sendable () -> Void)? = nil,
        onLogout: (@Sendable () -> Void)? = nil
    ) -> ARCMenuViewModel {
        var items: [ARCMenuItem] = []

        if let onProfile {
            items.append(.Common.profile(action: onProfile))
        }

        if let onSettings {
            items.append(.Common.settings(action: onSettings))
        }

        if let onPlan {
            items.append(.Common.plan(action: onPlan))
        }

        if let onContact {
            items.append(.Common.contact(action: onContact))
        }

        if let onAbout {
            items.append(.Common.about(action: onAbout))
        }

        if let onLogout {
            items.append(.Common.logout(action: onLogout))
        }

        return ARCMenuViewModel(
            user: user,
            menuItems: items,
            configuration: configuration
        )
    }
}
