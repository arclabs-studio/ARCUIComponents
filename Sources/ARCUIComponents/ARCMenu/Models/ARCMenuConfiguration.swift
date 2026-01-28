//
//  ARCMenuConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Configuration for ARCMenu appearance and behavior
///
/// Provides extensive customization options while maintaining
/// Apple's design principles and Human Interface Guidelines.
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
/// - Note: Conforms to `LiquidGlassConfigurable` to leverage unified liquid glass effect
public struct ARCMenuConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Presentation Style

    /// How the menu is presented on screen
    ///
    /// - `bottomSheet`: Slides up from the bottom (Apple standard, default)
    /// - `trailingPanel`: Slides in from the trailing edge (drawer style)
    public let presentationStyle: ARCMenuPresentationStyle

    // MARK: - Visual Customization

    /// Primary accent color for the menu
    public let accentColor: Color

    /// Background style for the liquid glass effect
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the menu container
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    /// Style for menu item icons
    ///
    /// Determines how icons are rendered in menu item rows.
    /// Use `.subtle` (default) for minimal appearance or `.prominent`
    /// for category-style menus where icons should stand out.
    public let iconStyle: ARCMenuIconStyle

    // MARK: - Layout Configuration

    /// Width of the menu (used for trailingPanel style, default: 320)
    public let menuWidth: CGFloat

    /// Top padding from safe area (used for trailingPanel style, default: 0)
    public let topPadding: CGFloat

    /// Edge insets for menu content
    public let contentInsets: EdgeInsets

    /// Spacing between menu sections
    public let sectionSpacing: CGFloat

    // MARK: - Bottom Sheet Configuration

    /// Whether to show the grabber handle for bottomSheet style
    public let showsGrabber: Bool

    /// Whether to show a close button in the header for bottomSheet style
    public let showsCloseButton: Bool

    /// Title displayed in the sheet header (optional)
    public let sheetTitle: String?

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
    /// - Parameters:
    ///   - presentationStyle: How the menu is presented (default: `.bottomSheet`)
    ///   - accentColor: Primary accent color for the menu
    ///   - backgroundStyle: Background style for the liquid glass effect
    ///   - cornerRadius: Corner radius for the menu container
    ///   - shadow: Shadow configuration
    ///   - iconStyle: Style for menu item icons (default: `.subtle`)
    ///   - menuWidth: Width of the menu (for trailingPanel style)
    ///   - topPadding: Top padding from safe area (for trailingPanel style)
    ///   - contentInsets: Edge insets for menu content
    ///   - sectionSpacing: Spacing between menu sections
    ///   - showsGrabber: Whether to show the grabber handle (for bottomSheet style)
    ///   - showsCloseButton: Whether to show a close button in the header
    ///   - sheetTitle: Title displayed in the sheet header
    ///   - presentationAnimation: Animation used for menu presentation
    ///   - dismissalAnimation: Animation used for menu dismissal
    ///   - hapticFeedback: Haptic feedback style
    ///   - allowsDragToDismiss: Whether the menu can be dismissed by dragging
    ///   - dismissOnOutsideTap: Whether tapping outside dismisses the menu
    ///   - dragDismissalThreshold: Minimum drag distance to trigger dismissal
    public init(
        presentationStyle: ARCMenuPresentationStyle = .bottomSheet,
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .liquidGlass,
        cornerRadius: CGFloat = .arcCornerRadiusXLarge,
        shadow: ARCShadow = .default,
        iconStyle: ARCMenuIconStyle = .subtle,
        menuWidth: CGFloat = 320,
        topPadding: CGFloat = 0,
        contentInsets: EdgeInsets = .arcPaddingSection,
        sectionSpacing: CGFloat = .arcSpacingXLarge,
        showsGrabber: Bool = true,
        showsCloseButton: Bool = true,
        sheetTitle: String? = nil,
        presentationAnimation: Animation = .arcGentle,
        dismissalAnimation: Animation = .arcSmooth,
        hapticFeedback: ARCMenuHapticStyle = .medium,
        allowsDragToDismiss: Bool = true,
        dismissOnOutsideTap: Bool = true,
        dragDismissalThreshold: CGFloat = 100
    ) {
        self.presentationStyle = presentationStyle
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.iconStyle = iconStyle
        self.menuWidth = menuWidth
        self.topPadding = topPadding
        self.contentInsets = contentInsets
        self.sectionSpacing = sectionSpacing
        self.showsGrabber = showsGrabber
        self.showsCloseButton = showsCloseButton
        self.sheetTitle = sheetTitle
        self.presentationAnimation = presentationAnimation
        self.dismissalAnimation = dismissalAnimation
        self.hapticFeedback = hapticFeedback
        self.allowsDragToDismiss = allowsDragToDismiss
        self.dismissOnOutsideTap = dismissOnOutsideTap
        self.dragDismissalThreshold = dragDismissalThreshold
    }

    // MARK: - Presets

    /// Default configuration with bottomSheet presentation (Apple standard)
    public static let `default` = ARCMenuConfiguration()

    /// Configuration with trailing panel presentation (drawer style)
    public static let trailingPanel = ARCMenuConfiguration(
        presentationStyle: .trailingPanel,
        showsGrabber: false,
        showsCloseButton: false
    )

    /// Configuration for dark-themed apps (e.g., Podcasts)
    public static let dark = ARCMenuConfiguration(
        accentColor: .purple,
        backgroundStyle: .liquidGlass
    )

    /// Configuration for fitness/health apps
    public static let fitness = ARCMenuConfiguration(
        accentColor: .green,
        backgroundStyle: .liquidGlass,
        presentationAnimation: .arcGentle
    )

    /// Configuration for premium/subscription apps
    public static let premium = ARCMenuConfiguration(
        accentColor: .orange,
        backgroundStyle: .liquidGlass,
        cornerRadius: .arcCornerRadiusXLarge
    )

    /// Minimal configuration with subtle effects
    public static let minimal = ARCMenuConfiguration(
        backgroundStyle: .translucent,
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .subtle
    )

    /// Configuration with prominent icons (category-style menus)
    ///
    /// Uses dark muted backgrounds with accent-colored icons
    /// for a bold, category-style appearance similar to cuisine lists.
    public static let prominent = ARCMenuConfiguration(
        accentColor: .orange,
        iconStyle: .prominent
    )

    /// Configuration for restaurant/food apps with prominent icons
    ///
    /// Amber accent color with prominent icon style, ideal for
    /// cuisine category menus and food-related applications.
    public static let restaurant = ARCMenuConfiguration(
        accentColor: Color(red: 0.95, green: 0.75, blue: 0.3),
        iconStyle: .prominent
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

    /// Performs the haptic feedback
    @MainActor
    func perform() {
        #if os(iOS)
        switch self {
        case .none:
            break
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .rigid:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
        #endif
    }
}
