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
    // MARK: - Visual Customization

    /// Primary accent color for the menu
    public let accentColor: Color

    /// Background style for the liquid glass effect
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for the menu container
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

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
        accentColor: Color = .blue,
        backgroundStyle: ARCBackgroundStyle = .liquidGlass,
        cornerRadius: CGFloat = .arcCornerRadiusXLarge,
        shadow: ARCShadow = .default,
        menuWidth: CGFloat = 320,
        topPadding: CGFloat = 0,
        contentInsets: EdgeInsets = .arcPaddingSection,
        sectionSpacing: CGFloat = .arcSpacingXLarge,
        presentationAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.8),
        dismissalAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.85),
        hapticFeedback: ARCMenuHapticStyle = .medium,
        allowsDragToDismiss: Bool = true,
        dismissOnOutsideTap: Bool = true,
        dragDismissalThreshold: CGFloat = 100
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
        cornerRadius: .arcCornerRadiusXLarge
    )

    /// Minimal configuration with subtle effects
    public static let minimal = ARCMenuConfiguration(
        backgroundStyle: .translucent,
        cornerRadius: .arcCornerRadiusLarge,
        shadow: .subtle
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
