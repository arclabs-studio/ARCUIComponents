//
//  ARCMenuConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Configuration for ARCMenu appearance and behavior
///
/// Provides extensive customization options while maintaining
/// Apple's design principles and Human Interface Guidelines.
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
public struct ARCMenuConfiguration: Sendable {
    // MARK: - Visual Customization

    /// Primary accent color for the menu
    public let accentColor: Color

    /// Background style for the liquid glass effect
    public let backgroundStyle: ARCMenuBackgroundStyle

    /// Corner radius for the menu container
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCMenuShadow

    // MARK: - Layout Configuration

    /// Width of the menu (default: 320)
    public let menuWidth: CGFloat

    /// Top padding from safe area (default: 0)
    public let topPadding: CGFloat

    /// Edge insets for menu content
    public let contentInsets: EdgeInsets

    /// Spacing between menu sections
    public let sectionSpacing: CGFloat

    // MARK: - Animation Configuration

    /// Animation used for menu presentation
    public let presentationAnimation: Animation

    /// Animation used for menu dismissal
    public let dismissalAnimation: Animation

    /// Haptic feedback style
    public let hapticFeedback: ARCMenuHapticStyle

    // MARK: - Behavior Configuration

    /// Whether the menu can be dismissed by dragging
    public let allowsDragToDismiss: Bool

    /// Whether tapping outside dismisses the menu
    public let dismissOnOutsideTap: Bool

    /// Minimum drag distance to trigger dismissal
    public let dragDismissalThreshold: CGFloat

    // MARK: - Initialization

    /// Creates a new menu configuration
    public init(
        accentColor: Color = .arcHighlight,
        backgroundStyle: ARCMenuBackgroundStyle = .liquidGlass,
        cornerRadius: CGFloat = .arcCornerRadiusLarge,
        shadow: ARCMenuShadow = .default,
        menuWidth: CGFloat = 320,
        topPadding: CGFloat = 0,
        contentInsets: EdgeInsets = .arcPaddingCard,
        sectionSpacing: CGFloat = .arcSpacingLarge,
        presentationAnimation: Animation = .arcAnimationSmooth,
        dismissalAnimation: Animation = .arcAnimationBase,
        hapticFeedback: ARCMenuHapticStyle = .soft,
        allowsDragToDismiss: Bool = true,
        dismissOnOutsideTap: Bool = true,
        dragDismissalThreshold: CGFloat = .arcSpacingXXLarge * 3
    ) {
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.menuWidth = menuWidth
        self.topPadding = topPadding
        self.contentInsets = contentInsets
        self.sectionSpacing = sectionSpacing
        self.presentationAnimation = presentationAnimation
        self.dismissalAnimation = dismissalAnimation
        self.hapticFeedback = hapticFeedback
        self.allowsDragToDismiss = allowsDragToDismiss
        self.dismissOnOutsideTap = dismissOnOutsideTap
        self.dragDismissalThreshold = dragDismissalThreshold
    }

    // MARK: - Presets

    /// Default configuration matching Apple Music style
    public static let `default` = ARCMenuConfiguration()

    /// Configuration for dark-themed apps (e.g., Podcasts)
    public static let dark = ARCMenuConfiguration(
        accentColor: .purple,
        backgroundStyle: .liquidGlass
    )

    /// Configuration for fitness/health apps
    public static let fitness = ARCMenuConfiguration(
        accentColor: .green,
        backgroundStyle: .liquidGlass,
        presentationAnimation: .spring(response: 0.45, dampingFraction: 0.82)
    )

    /// Configuration for premium/subscription apps
    public static let premium = ARCMenuConfiguration(
        accentColor: .orange,
        backgroundStyle: .liquidGlass,
        cornerRadius: 32
    )

    /// Minimal configuration with subtle effects
    public static let minimal = ARCMenuConfiguration(
        backgroundStyle: .translucent,
        cornerRadius: 24,
        shadow: .subtle
    )
}

// MARK: - ARCMenuBackgroundStyle

/// Background style options for the menu
public enum ARCMenuBackgroundStyle: Sendable {
    /// Apple's liquid glass effect (ultra thin material with vibrancy)
    case liquidGlass

    /// Translucent background with blur
    case translucent

    /// Solid background with opacity
    case solid(Color, opacity: Double)

    /// Custom material effect
    case material(Material)
}

// MARK: - ARCMenuShadow

/// Shadow configuration for the menu
public struct ARCMenuShadow: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    /// Default shadow (subtle, matching Apple's style)
    public static let `default` = ARCMenuShadow(
        color: Color.arcShadowMedium,
        radius: 20,
        x: 0,
        y: 10
    )

    /// Subtle shadow
    public static let subtle = ARCMenuShadow(
        color: Color.arcShadowLight,
        radius: 10,
        x: 0,
        y: 5
    )

    /// Prominent shadow
    public static let prominent = ARCMenuShadow(
        color: Color.arcShadowStrong,
        radius: 30,
        x: 0,
        y: 15
    )

    /// No shadow
    public static let none = ARCMenuShadow(
        color: .clear,
        radius: 0,
        x: 0,
        y: 0
    )
}

// MARK: - ARCMenuHapticStyle

/// Haptic feedback options
public enum ARCMenuHapticStyle: Sendable {
    case none
    case light
    case medium
    case heavy
    case soft
    case rigid

    /// Returns the corresponding SwiftUI SensoryFeedback value
    @available(iOS 17.0, *)
    var sensoryFeedback: SensoryFeedback {
        switch self {
        case .none:
            return .selection // Will be ignored when .none is used
        case .light:
            return .impact(flexibility: .soft, intensity: 0.5)
        case .medium:
            return .impact(flexibility: .solid, intensity: 0.7)
        case .heavy:
            return .impact(weight: .heavy)
        case .soft:
            return .impact(flexibility: .soft)
        case .rigid:
            return .impact(flexibility: .rigid)
        }
    }

    /// Performs the haptic feedback
    @MainActor
    func perform() {
        #if os(iOS)
        if #available(iOS 17.0, *) {
            // Use SwiftUI's SensoryFeedback in iOS 17+
            // Note: Direct triggering requires a view context
            // This method is kept for backward compatibility but should be triggered via .sensoryFeedback modifier
        }
        #endif
    }
}
