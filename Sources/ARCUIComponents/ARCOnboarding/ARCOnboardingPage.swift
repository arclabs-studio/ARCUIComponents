//
//  ARCOnboardingPage.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCOnboardingPage

/// A model representing a single page in an onboarding flow
///
/// `ARCOnboardingPage` encapsulates the content for one step in an onboarding sequence,
/// including the visual element (image, SF Symbol, or custom view), title, and subtitle.
///
/// ## Overview
///
/// Each onboarding page consists of:
/// - A visual element (SF Symbol, asset image, URL, or custom view)
/// - A title that describes the feature or benefit
/// - A subtitle that provides additional context
/// - Optional accent color for visual customization
///
/// ## Topics
///
/// ### Creating Pages
///
/// - ``init(image:imageColor:title:subtitle:accentColor:)``
/// - ``systemImage(_:color:title:subtitle:)``
/// - ``assetImage(_:title:subtitle:)``
///
/// ### Image Types
///
/// - ``ImageType``
///
/// ## Usage
///
/// ```swift
/// // Using SF Symbols
/// let page1 = ARCOnboardingPage.systemImage(
///     "star.fill",
///     color: .yellow,
///     title: "Welcome",
///     subtitle: "Discover amazing features"
/// )
///
/// // Using asset images
/// let page2 = ARCOnboardingPage.assetImage(
///     "onboarding-1",
///     title: "Track Progress",
///     subtitle: "See your growth over time"
/// )
///
/// // Using custom view
/// let page3 = ARCOnboardingPage(
///     image: .custom(AnyView(MyCustomAnimation())),
///     title: "You're All Set!",
///     subtitle: "Start exploring now"
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCOnboardingPage: Identifiable, Sendable {
    // MARK: - Properties

    /// Unique identifier for the page
    public let id: UUID

    /// The type of image to display
    public let image: ImageType

    /// Optional color override for the image
    ///
    /// When set, applies this color to SF Symbol images.
    /// Has no effect on asset images or custom views.
    public let imageColor: Color?

    /// The main title text for the page
    public let title: String

    /// The subtitle or description text
    public let subtitle: String

    /// Optional accent color for the page
    ///
    /// When set, overrides the default accent color for this specific page.
    /// Useful for creating themed onboarding experiences.
    public let accentColor: Color?

    // MARK: - Initialization

    /// Creates an onboarding page with the specified content
    ///
    /// - Parameters:
    ///   - image: The image type to display
    ///   - imageColor: Optional color for SF Symbol images
    ///   - title: The main title text
    ///   - subtitle: The subtitle or description text
    ///   - accentColor: Optional accent color override
    public init(
        image: ImageType,
        imageColor: Color? = nil,
        title: String,
        subtitle: String,
        accentColor: Color? = nil
    ) {
        id = UUID()
        self.image = image
        self.imageColor = imageColor
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
    }
}

// MARK: - ImageType

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingPage {
    /// The type of visual content to display on an onboarding page
    ///
    /// Supports multiple image sources for maximum flexibility:
    /// - SF Symbols for consistent iconography
    /// - Asset images for custom illustrations
    /// - Remote URLs for dynamically loaded images
    /// - Custom views for animations or complex content
    public enum ImageType: @unchecked Sendable {
        /// An SF Symbol image
        ///
        /// - Parameter name: The SF Symbol name (e.g., "star.fill")
        case systemImage(String)

        /// An image from the asset catalog
        ///
        /// - Parameter name: The asset catalog image name
        case assetImage(String)

        /// A remote image URL
        ///
        /// - Parameter url: The URL to load the image from
        case url(URL)

        /// A custom SwiftUI view
        ///
        /// - Parameter view: Any SwiftUI view wrapped in AnyView
        case custom(AnyView)
    }
}

// MARK: - Convenience Initializers

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingPage {
    /// Creates an onboarding page with an SF Symbol image
    ///
    /// This convenience initializer provides a quick way to create pages
    /// using SF Symbols, which are ideal for system-consistent iconography.
    ///
    /// - Parameters:
    ///   - name: The SF Symbol name (e.g., "heart.fill", "star.fill")
    ///   - color: The color for the symbol (defaults to accent color)
    ///   - title: The main title text
    ///   - subtitle: The subtitle or description text
    /// - Returns: A configured onboarding page
    ///
    /// ## Example
    ///
    /// ```swift
    /// let page = ARCOnboardingPage.systemImage(
    ///     "bell.fill",
    ///     color: .blue,
    ///     title: "Stay Notified",
    ///     subtitle: "Get alerts when it matters"
    /// )
    /// ```
    public static func systemImage(
        _ name: String,
        color: Color = .accentColor,
        title: String,
        subtitle: String
    ) -> Self {
        ARCOnboardingPage(
            image: .systemImage(name),
            imageColor: color,
            title: title,
            subtitle: subtitle
        )
    }

    /// Creates an onboarding page with an asset catalog image
    ///
    /// This convenience initializer provides a quick way to create pages
    /// using custom illustrations from your asset catalog.
    ///
    /// - Parameters:
    ///   - name: The asset catalog image name
    ///   - title: The main title text
    ///   - subtitle: The subtitle or description text
    /// - Returns: A configured onboarding page
    ///
    /// ## Example
    ///
    /// ```swift
    /// let page = ARCOnboardingPage.assetImage(
    ///     "onboarding-welcome",
    ///     title: "Welcome to MyApp",
    ///     subtitle: "Let's get you started"
    /// )
    /// ```
    public static func assetImage(
        _ name: String,
        title: String,
        subtitle: String
    ) -> Self {
        ARCOnboardingPage(
            image: .assetImage(name),
            title: title,
            subtitle: subtitle
        )
    }

    /// Creates an onboarding page with a remote image URL
    ///
    /// - Parameters:
    ///   - url: The URL to load the image from
    ///   - title: The main title text
    ///   - subtitle: The subtitle or description text
    /// - Returns: A configured onboarding page
    ///
    /// ## Example
    ///
    /// ```swift
    /// let page = ARCOnboardingPage.remoteImage(
    ///     URL(string: "https://example.com/image.png")!,
    ///     title: "Cloud Connected",
    ///     subtitle: "Access your data anywhere"
    /// )
    /// ```
    public static func remoteImage(
        _ url: URL,
        title: String,
        subtitle: String
    ) -> Self {
        ARCOnboardingPage(
            image: .url(url),
            title: title,
            subtitle: subtitle
        )
    }
}
