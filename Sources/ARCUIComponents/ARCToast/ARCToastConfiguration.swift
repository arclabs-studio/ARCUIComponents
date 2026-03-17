//
//  ARCToastConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCToastConfiguration

/// Configuration for ARCToast appearance and behavior
///
/// Provides customization options for toast positioning, duration, animation,
/// and visual styling while maintaining Apple's Human Interface Guidelines.
///
/// ## Overview
///
/// ARCToastConfiguration conforms to ``LiquidGlassConfigurable``, enabling
/// the unified liquid glass effect system used across ARC components.
///
/// ## Topics
///
/// ### Position
///
/// - ``Position-swift.enum``
///
/// ### Duration
///
/// - ``Duration-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``minimal``
/// - ``prominent``
/// - ``persistent``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// ARCToast(message: "Saved", configuration: .default)
///
/// // Use preset
/// ARCToast(message: "Item deleted", configuration: .persistent)
///
/// // Custom configuration
/// let config = ARCToastConfiguration(
///     position: .top,
///     duration: .medium,
///     showIcon: true,
///     hapticFeedback: true
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCToastConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Position

    /// Screen position for toast display
    public enum Position: Sendable {
        /// Toast appears at the top of the screen (below safe area)
        case top

        /// Toast appears at the bottom of the screen (above safe area)
        case bottom
    }

    // MARK: - Duration

    /// Auto-dismiss duration for toasts
    public enum Duration: Sendable {
        /// Short duration (2 seconds)
        case short

        /// Medium duration (3.5 seconds) - default
        case medium

        /// Long duration (5 seconds)
        case long

        /// No auto-dismiss - requires manual dismissal or action
        case indefinite

        /// Custom duration in seconds
        case custom(TimeInterval)

        /// Duration in seconds, nil for indefinite
        public var seconds: TimeInterval? {
            switch self {
            case .short:
                2
            case .medium:
                3.5
            case .long:
                5
            case .indefinite:
                nil
            case let .custom(time):
                time
            }
        }
    }

    // MARK: - Properties

    /// Screen position for the toast
    public let position: Position

    /// Auto-dismiss duration
    public let duration: Duration

    /// Whether to show the type icon
    public let showIcon: Bool

    /// Whether to trigger haptic feedback
    public let hapticFeedback: Bool

    /// Whether swipe gesture can dismiss the toast
    public let swipeToDismiss: Bool

    /// Whether tapping the toast dismisses it
    public let tapToDismiss: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Accent color for the toast (uses type color if nil)
    public let accentColor: Color

    /// Background style for the toast
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the toast
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a toast configuration with the specified options
    ///
    /// - Parameters:
    ///   - position: Screen position (default: .bottom)
    ///   - duration: Auto-dismiss duration (default: .medium)
    ///   - showIcon: Whether to show icon (default: true)
    ///   - hapticFeedback: Whether to trigger haptics (default: true)
    ///   - swipeToDismiss: Whether swipe dismisses (default: true)
    ///   - tapToDismiss: Whether tap dismisses (default: false)
    ///   - accentColor: Accent color (default: .blue)
    ///   - backgroundStyle: Background style (default: material)
    ///   - cornerRadius: Corner radius (default: 12)
    ///   - shadow: Shadow configuration (default: .default)
    public init(
        position: Position = .bottom,
        duration: Duration = .medium,
        showIcon: Bool = true,
        hapticFeedback: Bool = true,
        swipeToDismiss: Bool = true,
        tapToDismiss: Bool = false,
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .material(.regularMaterial),
        cornerRadius: CGFloat = .arcCornerRadiusSmall,
        shadow: ARCShadow = .default
    ) {
        self.position = position
        self.duration = duration
        self.showIcon = showIcon
        self.hapticFeedback = hapticFeedback
        self.swipeToDismiss = swipeToDismiss
        self.tapToDismiss = tapToDismiss
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }

    // MARK: - Presets

    /// Default toast configuration
    ///
    /// Bottom position, medium duration, with icon and haptics.
    public static let `default` = ARCToastConfiguration()

    /// Minimal toast configuration
    ///
    /// No icon, short duration, subtle appearance.
    public static let minimal = ARCToastConfiguration(
        duration: .short,
        showIcon: false,
        hapticFeedback: false,
        shadow: .subtle
    )

    /// Prominent toast configuration
    ///
    /// Top position, long duration, liquid glass effect.
    public static let prominent = ARCToastConfiguration(
        position: .top,
        duration: .long,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusMedium,
        shadow: .prominent
    )

    /// Persistent toast configuration
    ///
    /// Indefinite duration, requires action to dismiss.
    public static let persistent = ARCToastConfiguration(
        duration: .indefinite,
        swipeToDismiss: false
    )

    /// Top position toast configuration
    ///
    /// Same as default but positioned at top.
    public static let top = ARCToastConfiguration(
        position: .top
    )

    /// Error-focused toast configuration
    ///
    /// Longer duration for error messages.
    public static let error = ARCToastConfiguration(
        duration: .long,
        backgroundStyle: .material(.regularMaterial)
    )
}
