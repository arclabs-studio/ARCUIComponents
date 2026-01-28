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
/// Uses native SwiftUI sheet APIs with Material backgrounds for an Apple-native experience.
/// Supports iOS 26+ Liquid Glass effect when available.
///
/// ## Usage
///
/// ```swift
/// // Default configuration
/// .arcMenu(isPresented: $showMenu)
///
/// // Custom configuration
/// .arcMenu(isPresented: $showMenu, configuration: .init(accentColor: .purple))
/// ```
///
/// - Note: Conforms to `Sendable` for Swift 6 concurrency safety
public struct ARCMenuConfiguration: Sendable {
    // MARK: - Presentation Style

    /// How the menu is presented on screen
    ///
    /// - `bottomSheet`: Native sheet from bottom (Apple standard, default)
    /// - `trailingPanel`: Custom drawer from trailing edge (iPad/Mac optimized)
    public let presentationStyle: ARCMenuPresentationStyle

    // MARK: - Visual Customization

    /// Primary accent color for the menu
    ///
    /// Used for badges, selected states, and interactive elements.
    /// Default: `.arcBrandGold`
    public let accentColor: Color

    /// Corner radius for the sheet
    ///
    /// Only applies to trailingPanel style; native sheet uses system default.
    public let cornerRadius: CGFloat

    /// Style for menu item icons
    ///
    /// - `.subtle`: Low-opacity accent background with primary icon (default)
    /// - `.prominent`: Dark background with accent-colored icon
    public let iconStyle: ARCMenuIconStyle

    // MARK: - Sheet Detents (Native)

    /// Available heights where the sheet can rest
    ///
    /// Uses native `PresentationDetent`. Default: `[.medium, .large]`
    public let detents: Set<PresentationDetent>

    /// The initially selected detent when the sheet appears
    public let selectedDetent: PresentationDetent?

    // MARK: - Layout Configuration

    /// Width of the menu (used for trailingPanel style only)
    public let menuWidth: CGFloat

    /// Edge insets for menu content
    public let contentInsets: EdgeInsets

    /// Spacing between menu sections
    public let sectionSpacing: CGFloat

    // MARK: - Header Configuration

    /// Whether to show the native drag indicator (grabber)
    public let showsGrabber: Bool

    /// Whether to show a close button (X icon)
    public let showsCloseButton: Bool

    /// Title displayed in the sheet header (optional)
    public let sheetTitle: String?

    // MARK: - Behavior Configuration

    /// Haptic feedback on open/close
    public let hapticFeedback: ARCMenuHapticStyle

    /// Whether users can interact with content behind the sheet
    ///
    /// When enabled at `.medium` detent, users can tap content below.
    public let allowsBackgroundInteraction: Bool

    // MARK: - Initialization

    /// Creates a new menu configuration
    ///
    /// - Parameters:
    ///   - presentationStyle: How the menu is presented (default: `.bottomSheet`)
    ///   - accentColor: Primary accent color (default: `.arcBrandGold`)
    ///   - cornerRadius: Corner radius for trailingPanel style
    ///   - iconStyle: Style for menu item icons (default: `.subtle`)
    ///   - detents: Available sheet heights (default: `[.medium, .large]`)
    ///   - selectedDetent: Initial detent (default: `.medium`)
    ///   - menuWidth: Width for trailingPanel style (default: 320)
    ///   - contentInsets: Content padding
    ///   - sectionSpacing: Spacing between sections
    ///   - showsGrabber: Show drag indicator (default: true)
    ///   - showsCloseButton: Show X button (default: true)
    ///   - sheetTitle: Optional header title
    ///   - hapticFeedback: Haptic style (default: `.medium`)
    ///   - allowsBackgroundInteraction: Allow taps behind sheet (default: false)
    public init(
        presentationStyle: ARCMenuPresentationStyle = .bottomSheet,
        accentColor: Color = .arcBrandGold,
        cornerRadius: CGFloat = .arcCornerRadiusXLarge,
        iconStyle: ARCMenuIconStyle = .subtle,
        detents: Set<PresentationDetent> = [.medium, .large],
        selectedDetent: PresentationDetent? = .medium,
        menuWidth: CGFloat = 320,
        contentInsets: EdgeInsets = .arcPaddingSection,
        sectionSpacing: CGFloat = .arcSpacingXLarge,
        showsGrabber: Bool = true,
        showsCloseButton: Bool = true,
        sheetTitle: String? = nil,
        hapticFeedback: ARCMenuHapticStyle = .medium,
        allowsBackgroundInteraction: Bool = false
    ) {
        self.presentationStyle = presentationStyle
        self.accentColor = accentColor
        self.cornerRadius = cornerRadius
        self.iconStyle = iconStyle
        self.detents = detents
        self.selectedDetent = selectedDetent
        self.menuWidth = menuWidth
        self.contentInsets = contentInsets
        self.sectionSpacing = sectionSpacing
        self.showsGrabber = showsGrabber
        self.showsCloseButton = showsCloseButton
        self.sheetTitle = sheetTitle
        self.hapticFeedback = hapticFeedback
        self.allowsBackgroundInteraction = allowsBackgroundInteraction
    }

    // MARK: - Presets

    /// Default configuration using native sheet with Material background
    ///
    /// - Accent: `.arcBrandGold`
    /// - Detents: `.medium` and `.large`
    /// - Shows grabber and close button
    public static let `default` = ARCMenuConfiguration()

    /// Configuration with trailing panel presentation (drawer style)
    ///
    /// Optimized for iPad and Mac where a side panel feels more natural.
    /// Uses custom implementation since native sheets don't support trailing edge.
    public static let trailingPanel = ARCMenuConfiguration(
        presentationStyle: .trailingPanel,
        showsGrabber: false
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
