//
//  ARCBottomSheetConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCBottomSheetConfiguration

/// Configuration options for customizing the appearance and behavior of ARCBottomSheet
///
/// `ARCBottomSheetConfiguration` provides comprehensive customization options for the
/// bottom sheet, including handle styling, dismissal behavior, animations, and visual appearance.
///
/// ## Overview
///
/// The configuration controls:
/// - Handle visibility and appearance
/// - Dismissal and interaction behavior
/// - Animation properties
/// - Background dimming
/// - Liquid glass styling
///
/// ## Topics
///
/// ### Handle Properties
///
/// - ``showHandle``
/// - ``handleColor``
/// - ``handleWidth``
/// - ``handleHeight``
///
/// ### Behavior Properties
///
/// - ``isDismissable``
/// - ``isInteractiveDismissDisabled``
/// - ``snapToDetents``
/// - ``tapHandleToCycle``
///
/// ### Presets
///
/// - ``default``
/// - ``modal``
/// - ``persistent``
/// - ``drawer``
/// - ``glass``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// .arcBottomSheet(isPresented: $show, configuration: .default) { }
///
/// // Use a preset
/// .arcPersistentSheet(selectedDetent: $detent, configuration: .drawer) { }
///
/// // Custom configuration
/// let config = ARCBottomSheetConfiguration(
///     showHandle: true,
///     isDismissable: false,
///     dimBackground: true,
///     cornerRadius: 24
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBottomSheetConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Handle Properties

    /// Whether to show the drag handle at the top of the sheet
    ///
    /// Following Apple HIG, a grabber shows people that they can drag
    /// the sheet to resize it; they can also tap it to cycle through detents.
    public let showHandle: Bool

    /// The color of the drag handle
    public let handleColor: Color

    /// The width of the drag handle in points
    public let handleWidth: CGFloat

    /// The height of the drag handle in points
    public let handleHeight: CGFloat

    // MARK: - Behavior Properties

    /// Whether the sheet can be dismissed by dragging below the minimum detent
    ///
    /// When `true`, dragging below the smallest detent will dismiss the sheet.
    /// When `false`, the sheet will snap back to the smallest detent.
    public let isDismissable: Bool

    /// Whether interactive dismissal (swipe down) is disabled
    ///
    /// Useful when the sheet contains unsaved changes or requires explicit
    /// confirmation before closing.
    public let isInteractiveDismissDisabled: Bool

    /// Whether the sheet should snap to defined detents
    ///
    /// When `true`, the sheet snaps to the nearest detent on release.
    /// When `false`, the sheet can rest at any height (not recommended).
    public let snapToDetents: Bool

    /// Whether tapping the handle cycles through available detents
    ///
    /// Following Apple's pattern, tapping the grabber moves the sheet
    /// to the next detent in sequence.
    public let tapHandleToCycle: Bool

    // MARK: - Animation Properties

    /// The animation used for sheet transitions and snapping
    public let animation: Animation

    /// Velocity threshold for directional snapping
    ///
    /// When drag velocity exceeds this value, the sheet snaps to the
    /// next detent in the direction of movement rather than the nearest.
    public let velocityThreshold: CGFloat

    // MARK: - Background Properties

    /// Whether to dim the background when the sheet is presented
    public let dimBackground: Bool

    /// The opacity of the background dim effect (0.0 to 1.0)
    public let dimOpacity: CGFloat

    /// Whether tapping the dimmed background dismisses the sheet
    ///
    /// Only applies when `isDismissable` and `dimBackground` are both `true`.
    public let tapBackgroundToDismiss: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Primary accent color for the sheet
    public let accentColor: Color

    /// Background style for the sheet surface
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the top corners of the sheet
    public let cornerRadius: CGFloat

    /// Shadow configuration for the sheet
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates a bottom sheet configuration with the specified options
    ///
    /// - Parameters:
    ///   - showHandle: Whether to show drag handle (default: true)
    ///   - handleColor: Handle color (default: .secondary.opacity(0.5))
    ///   - handleWidth: Handle width in points (default: 36)
    ///   - handleHeight: Handle height in points (default: 5)
    ///   - isDismissable: Whether sheet can be dismissed by dragging (default: true)
    ///   - isInteractiveDismissDisabled: Disable swipe dismiss (default: false)
    ///   - snapToDetents: Snap to detents on release (default: true)
    ///   - tapHandleToCycle: Tap handle to cycle detents (default: true)
    ///   - animation: Transition animation (default: spring)
    ///   - velocityThreshold: Velocity for directional snap (default: 500)
    ///   - dimBackground: Dim behind sheet (default: true)
    ///   - dimOpacity: Background dim opacity (default: 0.3)
    ///   - tapBackgroundToDismiss: Tap dim to dismiss (default: true)
    ///   - accentColor: Accent color (default: .arcBrandBurgundy)
    ///   - backgroundStyle: Background style (default: .liquidGlass)
    ///   - cornerRadius: Top corner radius (default: 20)
    ///   - shadow: Shadow configuration (default: .prominent)
    public init(
        showHandle: Bool = true,
        handleColor: Color = .secondary.opacity(0.5),
        handleWidth: CGFloat = 36,
        handleHeight: CGFloat = 5,
        isDismissable: Bool = true,
        isInteractiveDismissDisabled: Bool = false,
        snapToDetents: Bool = true,
        tapHandleToCycle: Bool = true,
        animation: Animation = .spring(response: 0.35, dampingFraction: 0.8),
        velocityThreshold: CGFloat = 500,
        dimBackground: Bool = true,
        dimOpacity: CGFloat = 0.3,
        tapBackgroundToDismiss: Bool = true,
        accentColor: Color = .arcBrandBurgundy,
        backgroundStyle: ARCBackgroundStyle = .liquidGlass,
        cornerRadius: CGFloat = 20,
        shadow: ARCShadow = .prominent
    ) {
        self.showHandle = showHandle
        self.handleColor = handleColor
        self.handleWidth = handleWidth
        self.handleHeight = handleHeight
        self.isDismissable = isDismissable
        self.isInteractiveDismissDisabled = isInteractiveDismissDisabled
        self.snapToDetents = snapToDetents
        self.tapHandleToCycle = tapHandleToCycle
        self.animation = animation
        self.velocityThreshold = velocityThreshold
        self.dimBackground = dimBackground
        self.dimOpacity = max(0, min(1, dimOpacity))
        self.tapBackgroundToDismiss = tapBackgroundToDismiss
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetConfiguration {
    /// Default configuration with balanced settings
    ///
    /// Features:
    /// - Handle visible
    /// - Dismissable by dragging
    /// - Background dimmed
    /// - Liquid glass styling
    public static let `default` = ARCBottomSheetConfiguration()

    /// Modal configuration for focused tasks
    ///
    /// Features:
    /// - Handle visible
    /// - Dismissable
    /// - Strong background dimming
    /// - Tap background to dismiss
    public static let modal = ARCBottomSheetConfiguration(
        dimOpacity: 0.4,
        tapBackgroundToDismiss: true,
        backgroundStyle: .material(.regularMaterial),
        shadow: .prominent
    )

    /// Persistent configuration that cannot be dismissed
    ///
    /// Features:
    /// - Minimal handle (always visible)
    /// - Cannot be dismissed
    /// - No background dimming
    /// - Useful for always-visible drawers
    public static let persistent = ARCBottomSheetConfiguration(
        handleColor: .secondary.opacity(0.3),
        handleWidth: 28,
        handleHeight: 4,
        isDismissable: false,
        isInteractiveDismissDisabled: true,
        dimBackground: false,
        backgroundStyle: .translucent,
        shadow: .subtle
    )

    /// Drawer configuration like Apple Maps
    ///
    /// Features:
    /// - Handle visible
    /// - Non-dismissable
    /// - No background dimming
    /// - Semi-transparent background
    /// - Three-detent friendly
    public static let drawer = ARCBottomSheetConfiguration(
        isDismissable: false,
        dimBackground: false,
        tapBackgroundToDismiss: false,
        backgroundStyle: .material(.regularMaterial),
        cornerRadius: 16,
        shadow: .default
    )

    /// Glass configuration with premium liquid glass effect
    ///
    /// Features:
    /// - Handle visible
    /// - Dismissable
    /// - Light background dimming
    /// - Full liquid glass effect
    /// - Larger corner radius
    public static let glass = ARCBottomSheetConfiguration(
        handleColor: .white.opacity(0.5),
        dimOpacity: 0.2,
        backgroundStyle: .liquidGlass,
        cornerRadius: 24,
        shadow: .prominent
    )

    /// Compact configuration for small content
    ///
    /// Features:
    /// - Small handle
    /// - Dismissable
    /// - Smaller corner radius
    /// - Lighter shadow
    public static let compact = ARCBottomSheetConfiguration(
        handleWidth: 28,
        handleHeight: 4,
        dimOpacity: 0.25,
        backgroundStyle: .translucent,
        cornerRadius: 12,
        shadow: .subtle
    )
}
