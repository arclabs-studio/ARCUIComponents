//
//  ARCOnboardingConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCOnboardingConfiguration

/// Configuration options for customizing the appearance and behavior of ARCOnboarding
///
/// `ARCOnboardingConfiguration` provides comprehensive customization options for the
/// onboarding flow, including navigation controls, visual styling, and animations.
///
/// ## Overview
///
/// The configuration controls:
/// - Navigation buttons (skip, back, next, finish)
/// - Visual appearance (button style, indicator style, fonts)
/// - Animations and transitions
/// - Liquid glass effect properties
///
/// ## Topics
///
/// ### Configuration Properties
///
/// - ``showSkipButton``
/// - ``showBackButton``
/// - ``buttonStyle``
/// - ``indicatorStyle``
/// - ``pageTransition``
///
/// ### Presets
///
/// - ``default``
/// - ``minimal``
/// - ``prominent``
/// - ``compact``
///
/// ## Usage
///
/// ```swift
/// // Use default configuration
/// ARCOnboarding(pages: pages, configuration: .default) { }
///
/// // Use a preset
/// ARCOnboarding(pages: pages, configuration: .minimal) { }
///
/// // Custom configuration
/// let config = ARCOnboardingConfiguration(
///     showSkipButton: true,
///     buttonStyle: .glass,
///     indicatorStyle: .lines
/// )
/// ARCOnboarding(pages: pages, configuration: config) { }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCOnboardingConfiguration: Sendable, LiquidGlassConfigurable {
    // MARK: - Navigation Properties

    /// Whether to show the skip button
    ///
    /// When enabled, displays a skip button that allows users to bypass
    /// the remaining onboarding pages.
    public let showSkipButton: Bool

    /// Whether to show the back button
    ///
    /// When enabled, displays a back button for navigating to previous pages.
    /// Default is `false` - users navigate back using swipe gestures, following
    /// Apple's standard onboarding pattern.
    public let showBackButton: Bool

    /// The title for the skip button
    public let skipButtonTitle: String

    /// The title for the next button
    public let nextButtonTitle: String

    /// The title for the finish button (shown on last page)
    public let finishButtonTitle: String

    // MARK: - Appearance Properties

    /// The style for navigation buttons
    public let buttonStyle: ButtonStyle

    /// The style for page indicators
    public let indicatorStyle: IndicatorStyle

    /// The position of page indicators
    public let indicatorPosition: IndicatorPosition

    /// The size of the image area
    ///
    /// Defines the height proportion of the image area relative to the screen.
    /// Value should be between 0.2 and 0.5.
    public let imageHeight: CGFloat

    /// The font for page titles
    public let titleFont: Font

    /// The font for page subtitles
    public let subtitleFont: Font

    // MARK: - Animation Properties

    /// The transition style between pages
    public let pageTransition: PageTransition

    /// Whether to animate images when pages appear
    public let animateImages: Bool

    // MARK: - LiquidGlassConfigurable Properties

    /// Primary accent color for the component
    public let accentColor: Color

    /// Background style for buttons
    public let backgroundStyle: ARCBackgroundStyle

    /// Corner radius for buttons
    public let cornerRadius: CGFloat

    /// Shadow configuration
    public let shadow: ARCShadow

    // MARK: - Initialization

    /// Creates an onboarding configuration with the specified options
    ///
    /// - Parameters:
    ///   - showSkipButton: Whether to show skip button (default: true)
    ///   - showBackButton: Whether to show back button (default: false, use swipe)
    ///   - skipButtonTitle: Skip button title (default: "Skip")
    ///   - nextButtonTitle: Next button title (default: "Continue")
    ///   - finishButtonTitle: Finish button title (default: "Get Started")
    ///   - buttonStyle: Navigation button style (default: .filled)
    ///   - indicatorStyle: Page indicator style (default: .dots)
    ///   - indicatorPosition: Position of page indicators (default: .aboveButtons)
    ///   - imageHeight: Height proportion for images (default: 0.35)
    ///   - titleFont: Font for titles (default: .title.bold())
    ///   - subtitleFont: Font for subtitles (default: .body)
    ///   - pageTransition: Page transition animation (default: .slide)
    ///   - animateImages: Whether to animate images (default: true)
    ///   - accentColor: Accent color (default: .arcBrandBurgundy)
    ///   - backgroundStyle: Button background style (default: .liquidGlass)
    ///   - cornerRadius: Button corner radius (default: 16)
    ///   - shadow: Shadow configuration (default: .subtle)
    public init(
        showSkipButton: Bool = true,
        showBackButton: Bool = false,
        skipButtonTitle: String = "Skip",
        nextButtonTitle: String = "Continue",
        finishButtonTitle: String = "Get Started",
        buttonStyle: ButtonStyle = .filled,
        indicatorStyle: IndicatorStyle = .dots,
        indicatorPosition: IndicatorPosition = .aboveButtons,
        imageHeight: CGFloat = 0.35,
        titleFont: Font = .title.bold(),
        subtitleFont: Font = .body,
        pageTransition: PageTransition = .slide,
        animateImages: Bool = true,
        accentColor: Color = .arcBrandBurgundy,
        backgroundStyle: ARCBackgroundStyle = .liquidGlass,
        cornerRadius: CGFloat = 16,
        shadow: ARCShadow = .subtle
    ) {
        self.showSkipButton = showSkipButton
        self.showBackButton = showBackButton
        self.skipButtonTitle = skipButtonTitle
        self.nextButtonTitle = nextButtonTitle
        self.finishButtonTitle = finishButtonTitle
        self.buttonStyle = buttonStyle
        self.indicatorStyle = indicatorStyle
        self.indicatorPosition = indicatorPosition
        self.imageHeight = max(0.2, min(0.5, imageHeight))
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.pageTransition = pageTransition
        self.animateImages = animateImages
        self.accentColor = accentColor
        self.backgroundStyle = backgroundStyle
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
}

// MARK: - ButtonStyle

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingConfiguration {
    /// The visual style for navigation buttons
    public enum ButtonStyle: Sendable {
        /// Plain text button
        case text

        /// Filled button with accent color background
        case filled

        /// Liquid glass effect button
        case glass
    }
}

// MARK: - IndicatorStyle

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingConfiguration {
    /// The visual style for page indicators
    public enum IndicatorStyle: Sendable {
        /// Traditional dot indicators
        case dots

        /// Line/bar indicators
        case lines

        /// Numeric indicators (1/5, 2/5, etc.)
        case numbers

        /// Progress bar indicator
        case progress
    }
}

// MARK: - IndicatorPosition

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingConfiguration {
    /// The position of page indicators
    public enum IndicatorPosition: Sendable {
        /// At the top of the screen
        case top

        /// Above the navigation buttons
        case aboveButtons

        /// At the bottom of the screen
        case bottom
    }
}

// MARK: - PageTransition

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingConfiguration {
    /// The animation style for page transitions
    public enum PageTransition: Sendable {
        /// Standard slide transition
        case slide

        /// Fade in/out transition
        case fade

        /// Scale transition
        case scale

        /// Parallax effect (image moves slower than content)
        case parallax
    }
}

// MARK: - Presets

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingConfiguration {
    /// Default configuration with balanced settings
    ///
    /// Features:
    /// - Skip button enabled
    /// - Swipe navigation for going back (no back button)
    /// - Filled button style
    /// - Dot indicators
    /// - Slide transitions
    public static let `default` = ARCOnboardingConfiguration()

    /// Minimal configuration without distractions
    ///
    /// Features:
    /// - No skip button
    /// - No back button
    /// - Text button style
    /// - Simple dot indicators
    /// - Fade transitions
    public static let minimal = ARCOnboardingConfiguration(
        showSkipButton: false,
        showBackButton: false,
        buttonStyle: .text,
        indicatorStyle: .dots,
        pageTransition: .fade,
        backgroundStyle: .translucent
    )

    /// Prominent configuration with glass effects
    ///
    /// Features:
    /// - Skip button enabled
    /// - Swipe navigation for going back (no back button)
    /// - Glass button style
    /// - Line indicators
    /// - Slide transitions with image animation
    public static let prominent = ARCOnboardingConfiguration(
        buttonStyle: .glass,
        indicatorStyle: .lines,
        imageHeight: 0.4,
        pageTransition: .slide,
        animateImages: true,
        backgroundStyle: .liquidGlass,
        shadow: .default
    )

    /// Compact configuration for sheets and modals
    ///
    /// Features:
    /// - Skip button enabled
    /// - No back button
    /// - Text button style
    /// - Progress indicator
    /// - Smaller image area
    public static let compact = ARCOnboardingConfiguration(
        showBackButton: false,
        buttonStyle: .text,
        indicatorStyle: .progress,
        indicatorPosition: .top,
        imageHeight: 0.25,
        titleFont: .headline.bold(),
        subtitleFont: .subheadline,
        pageTransition: .fade,
        animateImages: false,
        backgroundStyle: .translucent,
        shadow: .none
    )
}
