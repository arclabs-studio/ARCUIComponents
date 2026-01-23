//
//  ARCToastType.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCToastType

/// Defines the visual style and semantic meaning of a toast notification
///
/// `ARCToastType` determines the icon, color, and haptic feedback for a toast.
/// Each type conveys different levels of information to the user.
///
/// ## Overview
///
/// Use the predefined types for common scenarios:
/// - `.success` for completed actions
/// - `.error` for failures requiring attention
/// - `.warning` for cautionary information
/// - `.info` for neutral information
///
/// For custom branding, use `.custom(icon:color:)`.
///
/// ## Topics
///
/// ### Types
///
/// - ``success``
/// - ``error``
/// - ``warning``
/// - ``info``
/// - ``custom(icon:color:)``
///
/// ## Usage
///
/// ```swift
/// // Predefined types
/// ARCToast(message: "Saved", type: .success)
/// ARCToast(message: "Failed to load", type: .error)
///
/// // Custom type
/// ARCToast(
///     message: "New message",
///     type: .custom(icon: "envelope.fill", color: .purple)
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public enum ARCToastType: Sendable, Equatable, Hashable {
    /// Success notification - green checkmark
    ///
    /// Use for completed actions like saves, uploads, or successful operations.
    case success

    /// Error notification - red X
    ///
    /// Use for failures that require user attention or action.
    case error

    /// Warning notification - orange triangle
    ///
    /// Use for cautionary information that doesn't block the user.
    case warning

    /// Info notification - blue info circle
    ///
    /// Use for neutral information or status updates.
    case info

    /// Custom notification with specified icon and color
    ///
    /// - Parameters:
    ///   - icon: SF Symbol name for the icon
    ///   - color: Color for the icon
    case custom(icon: String, color: Color)

    // MARK: - Properties

    /// SF Symbol name for this toast type
    public var icon: String {
        switch self {
        case .success:
            "checkmark.circle.fill"
        case .error:
            "xmark.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        case .info:
            "info.circle.fill"
        case let .custom(icon, _):
            icon
        }
    }

    /// Color associated with this toast type
    public var color: Color {
        switch self {
        case .success:
            .green
        case .error:
            .red
        case .warning:
            .orange
        case .info:
            .blue
        case let .custom(_, color):
            color
        }
    }

    /// Accessibility prefix for VoiceOver announcements
    public var accessibilityPrefix: String {
        switch self {
        case .success:
            "Success"
        case .error:
            "Error"
        case .warning:
            "Warning"
        case .info:
            "Information"
        case .custom:
            "Notification"
        }
    }

    // MARK: - Equatable

    public static func == (lhs: ARCToastType, rhs: ARCToastType) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success),
             (.error, .error),
             (.warning, .warning),
             (.info, .info):
            true
        case let (.custom(lIcon, _), .custom(rIcon, _)):
            lIcon == rIcon
        default:
            false
        }
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .success:
            hasher.combine(0)
        case .error:
            hasher.combine(1)
        case .warning:
            hasher.combine(2)
        case .info:
            hasher.combine(3)
        case let .custom(icon, _):
            hasher.combine(4)
            hasher.combine(icon)
        }
    }
}

// MARK: - Haptic Feedback

#if os(iOS)
import UIKit

@available(iOS 17.0, *)
extension ARCToastType {
    /// Triggers the appropriate haptic feedback for this toast type
    @MainActor
    public func triggerHaptic() {
        switch self {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .info, .custom:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
#endif
