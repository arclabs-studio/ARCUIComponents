//
//  ARCAvatar.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - ARCAvatar

/// A reusable avatar component for displaying user profile images
///
/// `ARCAvatar` displays user profile images, initials, or placeholder icons
/// following Apple's Human Interface Guidelines for profile imagery.
///
/// ## Overview
///
/// ARCAvatar supports multiple content types:
/// - **Image**: A SwiftUI Image (local or from bundle)
/// - **URL**: Async image loading with placeholder
/// - **Initials**: Extracted from name or provided directly
/// - **System Image**: SF Symbol as placeholder
/// - **Placeholder**: Default person icon
///
/// ## Topics
///
/// ### Content Types
///
/// - ``Content``
///
/// ### Creating Avatars
///
/// - ``init(image:status:configuration:accessibilityLabel:)``
/// - ``init(url:status:configuration:accessibilityLabel:)``
/// - ``init(name:status:configuration:)``
/// - ``init(initials:status:configuration:)``
///
/// ## Usage
///
/// ```swift
/// // From URL
/// ARCAvatar(url: user.avatarURL)
///
/// // From Image
/// ARCAvatar(image: Image("profile"))
///
/// // From Name (extracts initials)
/// ARCAvatar(name: "John Doe")
///
/// // With Status
/// ARCAvatar(url: user.avatarURL, status: .online)
///
/// // Custom Configuration
/// ARCAvatar(name: user.name, configuration: .profile)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAvatar: View {
    // MARK: - Content

    /// Content types for avatars
    public enum Content: Sendable {
        /// A SwiftUI Image
        case image(Image)

        /// A URL for async image loading
        case url(URL?)

        /// Initials string (1-2 characters)
        case initials(String)

        /// SF Symbol name
        case systemImage(String)

        /// Default placeholder
        case placeholder
    }

    // MARK: - Properties

    private let content: Content
    private let status: ARCAvatarStatus
    private let configuration: ARCAvatarConfiguration
    private let accessibilityLabel: String?
    private let initialsBackgroundColor: Color?

    // MARK: - Initialization

    /// Creates an avatar with an image
    ///
    /// - Parameters:
    ///   - image: The image to display
    ///   - status: Status indicator (default: .none)
    ///   - configuration: Avatar configuration (default: .default)
    ///   - accessibilityLabel: Custom accessibility label
    public init(
        image: Image,
        status: ARCAvatarStatus = .none,
        configuration: ARCAvatarConfiguration = .default,
        accessibilityLabel: String? = nil
    ) {
        content = .image(image)
        self.status = status
        self.configuration = configuration
        self.accessibilityLabel = accessibilityLabel
        initialsBackgroundColor = nil
    }

    /// Creates an avatar from a URL with async loading
    ///
    /// - Parameters:
    ///   - url: The URL to load the image from
    ///   - status: Status indicator (default: .none)
    ///   - configuration: Avatar configuration (default: .default)
    ///   - accessibilityLabel: Custom accessibility label
    public init(
        url: URL?,
        status: ARCAvatarStatus = .none,
        configuration: ARCAvatarConfiguration = .default,
        accessibilityLabel: String? = nil
    ) {
        content = .url(url)
        self.status = status
        self.configuration = configuration
        self.accessibilityLabel = accessibilityLabel
        initialsBackgroundColor = nil
    }

    /// Creates an avatar with initials extracted from a name
    ///
    /// - Parameters:
    ///   - name: The full name to extract initials from
    ///   - status: Status indicator (default: .none)
    ///   - configuration: Avatar configuration (default: .default)
    public init(
        name: String,
        status: ARCAvatarStatus = .none,
        configuration: ARCAvatarConfiguration = .default
    ) {
        content = .initials(name.initials)
        self.status = status
        self.configuration = configuration
        accessibilityLabel = "\(name)'s profile picture"
        initialsBackgroundColor = name.consistentColor
    }

    /// Creates an avatar with explicit initials
    ///
    /// - Parameters:
    ///   - initials: The initials to display (1-2 characters recommended)
    ///   - status: Status indicator (default: .none)
    ///   - configuration: Avatar configuration (default: .default)
    ///   - backgroundColor: Custom background color for initials
    public init(
        initials: String,
        status: ARCAvatarStatus = .none,
        configuration: ARCAvatarConfiguration = .default,
        backgroundColor: Color? = nil
    ) {
        content = .initials(String(initials.prefix(2)).uppercased())
        self.status = status
        self.configuration = configuration
        accessibilityLabel = nil
        initialsBackgroundColor = backgroundColor
    }

    /// Creates an avatar with a system image (SF Symbol)
    ///
    /// - Parameters:
    ///   - systemImage: The SF Symbol name
    ///   - status: Status indicator (default: .none)
    ///   - configuration: Avatar configuration (default: .default)
    public init(
        systemImage: String,
        status: ARCAvatarStatus = .none,
        configuration: ARCAvatarConfiguration = .default
    ) {
        content = .systemImage(systemImage)
        self.status = status
        self.configuration = configuration
        accessibilityLabel = nil
        initialsBackgroundColor = nil
    }

    /// Creates a placeholder avatar
    ///
    /// - Parameters:
    ///   - status: Status indicator (default: .none)
    ///   - configuration: Avatar configuration (default: .default)
    public init(
        status: ARCAvatarStatus = .none,
        configuration: ARCAvatarConfiguration = .default
    ) {
        content = .placeholder
        self.status = status
        self.configuration = configuration
        accessibilityLabel = nil
        initialsBackgroundColor = nil
    }

    // MARK: - Private Init

    private init(
        content: Content,
        status: ARCAvatarStatus,
        configuration: ARCAvatarConfiguration,
        accessibilityLabel: String?,
        initialsBackgroundColor: Color?
    ) {
        self.content = content
        self.status = status
        self.configuration = configuration
        self.accessibilityLabel = accessibilityLabel
        self.initialsBackgroundColor = initialsBackgroundColor
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: configuration.statusBadgePosition.alignment) {
            clippedAvatarContent

            if status != .none, configuration.showStatusBadge {
                statusBadge
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(computedAccessibilityLabel)
        .accessibilityValue(status.accessibilityDescription)
        .accessibilityAddTraits(.isImage)
    }

    // MARK: - Clipped Avatar Content

    @ViewBuilder private var clippedAvatarContent: some View {
        let size = configuration.size.dimension
        let borderColor = configuration.borderColor
        let borderWidth = configuration.borderWidth

        switch configuration.shape {
        case .circle:
            avatarContent
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay {
                    if let borderColor, borderWidth > 0 {
                        Circle().strokeBorder(borderColor, lineWidth: borderWidth)
                    }
                }

        case let .roundedSquare(cornerRadius):
            avatarContent
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay {
                    if let borderColor, borderWidth > 0 {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(borderColor, lineWidth: borderWidth)
                    }
                }

        case .squircle:
            let squircleRadius = size * 0.22
            avatarContent
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: squircleRadius, style: .continuous))
                .overlay {
                    if let borderColor, borderWidth > 0 {
                        RoundedRectangle(cornerRadius: squircleRadius, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: borderWidth)
                    }
                }
        }
    }

    // MARK: - Avatar Content

    @ViewBuilder private var avatarContent: some View {
        switch content {
        case let .image(image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)

        case let .url(url):
            asyncImageContent(url: url)

        case let .initials(text):
            initialsContent(text)

        case let .systemImage(name):
            systemImageContent(name)

        case .placeholder:
            systemImageContent(configuration.placeholderIcon)
        }
    }

    @ViewBuilder
    private func asyncImageContent(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                loadingPlaceholder

            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            case .failure:
                fallbackContent

            @unknown default:
                fallbackContent
            }
        }
    }

    @ViewBuilder
    private func initialsContent(_ text: String) -> some View {
        let bgColor = initialsBackgroundColor ?? configuration.backgroundColor
        ZStack {
            bgColor
            Text(text)
                .font(.system(
                    size: configuration.size.fontSize,
                    weight: .semibold,
                    design: .rounded
                ))
                .foregroundStyle(textColorForBackground(bgColor))
        }
    }

    @ViewBuilder
    private func systemImageContent(_ name: String) -> some View {
        ZStack {
            configuration.backgroundColor
            Image(systemName: name)
                .font(.system(size: configuration.size.fontSize))
                .foregroundStyle(configuration.foregroundColor)
        }
    }

    private var loadingPlaceholder: some View {
        ZStack {
            configuration.backgroundColor
            ProgressView()
                .scaleEffect(configuration.size.dimension < 40 ? 0.6 : 0.8)
        }
    }

    private var fallbackContent: some View {
        systemImageContent(configuration.placeholderIcon)
    }

    // MARK: - Status Badge

    private var statusBadge: some View {
        Circle()
            .fill(status.color)
            .frame(
                width: configuration.size.statusBadgeSize,
                height: configuration.size.statusBadgeSize
            )
            .overlay {
                Circle()
                    .strokeBorder(
                        statusBadgeBorderColor,
                        lineWidth: configuration.size.statusBadgeBorderWidth
                    )
            }
    }

    private var statusBadgeBorderColor: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }

    // MARK: - Computed Properties

    private var computedAccessibilityLabel: String {
        if let label = accessibilityLabel {
            return label
        }

        switch content {
        case .image, .url:
            return String(localized: "Profile picture")
        case let .initials(text):
            return String(localized: "Avatar with initials \(text)")
        case .systemImage, .placeholder:
            return String(localized: "Avatar placeholder")
        }
    }

    private func textColorForBackground(_ color: Color) -> Color {
        // Use white text for darker backgrounds, dark text for lighter backgrounds
        // This is a simplified check - in production, calculate luminance
        configuration.foregroundColor == .primary ? .white : configuration.foregroundColor
    }
}

// MARK: - String Extension for Initials

extension String {
    /// Extracts initials from a name string
    ///
    /// - Examples:
    ///   - "John Doe" → "JD"
    ///   - "Alice" → "A"
    ///   - "María García" → "MG"
    var initials: String {
        let components = split(separator: " ")
        let initials = components.prefix(2).compactMap { $0.first }
        return String(initials).uppercased()
    }

    /// Generates a consistent color based on the string hash
    ///
    /// This ensures the same name always produces the same color.
    var consistentColor: Color {
        let hash = abs(hashValue)
        let hue = Double(hash % 360) / 360.0
        return Color(hue: hue, saturation: 0.5, brightness: 0.7)
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Avatar Content Types") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            ARCAvatar(name: "John Doe")
            ARCAvatar(name: "Alice Smith")
            ARCAvatar(initials: "AB")
            ARCAvatar(systemImage: "person.crop.circle")
            ARCAvatar()
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Avatar Sizes") {
    HStack(spacing: 16) {
        ARCAvatar(name: "Test", configuration: ARCAvatarConfiguration(size: .xs))
        ARCAvatar(name: "Test", configuration: ARCAvatarConfiguration(size: .sm))
        ARCAvatar(name: "Test", configuration: ARCAvatarConfiguration(size: .md))
        ARCAvatar(name: "Test", configuration: ARCAvatarConfiguration(size: .lg))
        ARCAvatar(name: "Test", configuration: ARCAvatarConfiguration(size: .xl))
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Avatar Status") {
    HStack(spacing: 16) {
        ARCAvatar(name: "Online", status: .online)
        ARCAvatar(name: "Offline", status: .offline)
        ARCAvatar(name: "Busy", status: .busy)
        ARCAvatar(name: "Away", status: .away)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Avatar Shapes") {
    HStack(spacing: 16) {
        ARCAvatar(
            name: "Circle",
            configuration: ARCAvatarConfiguration(shape: .circle)
        )
        ARCAvatar(
            name: "Square",
            configuration: ARCAvatarConfiguration(shape: .roundedSquare(cornerRadius: 8))
        )
        ARCAvatar(
            name: "Squircle",
            configuration: ARCAvatarConfiguration(shape: .squircle)
        )
    }
    .padding()
}
