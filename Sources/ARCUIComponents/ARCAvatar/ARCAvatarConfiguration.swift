//
//  ARCAvatarConfiguration.swift
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

// MARK: - ARCAvatarConfiguration

/// Configuration for ARCAvatar appearance and behavior
///
/// Provides customization options for avatar size, shape, colors, and status badge
/// positioning following Apple's Human Interface Guidelines.
///
/// ## Overview
///
/// ARCAvatar is designed for displaying user profile images, initials, or placeholder
/// icons. This configuration allows fine-grained control over the avatar's appearance.
///
/// ## Topics
///
/// ### Size
///
/// - ``Size-swift.enum``
///
/// ### Shape
///
/// - ``Shape-swift.enum``
///
/// ### Status Badge Position
///
/// - ``StatusBadgePosition-swift.enum``
///
/// ### Presets
///
/// - ``default``
/// - ``small``
/// - ``large``
/// - ``profile``
/// - ``listItem``
/// - ``comment``
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAvatarConfiguration: Sendable {
    // MARK: - Size

    /// Size variants for avatars
    public enum Size: CaseIterable, Sendable {
        /// Extra small avatar (24pt)
        case xs

        /// Small avatar (32pt)
        case sm

        /// Medium avatar (40pt) - default
        case md

        /// Large avatar (56pt)
        case lg

        /// Extra large avatar (80pt)
        case xl

        /// Extra extra large avatar (120pt) - for profile headers
        case xxl

        /// Dimension in points
        public var dimension: CGFloat {
            switch self {
            case .xs: 24
            case .sm: 32
            case .md: 40
            case .lg: 56
            case .xl: 80
            case .xxl: 120
            }
        }

        /// Font size for initials
        public var fontSize: CGFloat {
            dimension * 0.4
        }

        /// Status badge size
        public var statusBadgeSize: CGFloat {
            max(8, dimension * 0.25)
        }

        /// Border width for status badge
        public var statusBadgeBorderWidth: CGFloat {
            dimension < 40 ? 1.5 : 2
        }
    }

    // MARK: - Shape

    /// Shape variants for avatars
    public enum Shape: Sendable, Equatable {
        /// Circular avatar (most common)
        case circle

        /// Rounded square with custom corner radius
        case roundedSquare(cornerRadius: CGFloat)

        /// iOS app icon style squircle
        case squircle

        /// Corner radius for the shape
        public var cornerRadius: CGFloat {
            switch self {
            case .circle:
                .infinity
            case let .roundedSquare(radius):
                radius
            case .squircle:
                .infinity // Uses continuous corner curve
            }
        }
    }

    // MARK: - Status Badge Position

    /// Position options for status badge
    public enum StatusBadgePosition: Sendable {
        /// Bottom trailing corner (default)
        case bottomTrailing

        /// Top trailing corner
        case topTrailing

        /// Bottom leading corner
        case bottomLeading

        /// Top leading corner
        case topLeading

        /// Alignment for the badge
        var alignment: Alignment {
            switch self {
            case .bottomTrailing: .bottomTrailing
            case .topTrailing: .topTrailing
            case .bottomLeading: .bottomLeading
            case .topLeading: .topLeading
            }
        }
    }

    // MARK: - Properties

    /// Avatar size
    public let size: Size

    /// Avatar shape
    public let shape: Shape

    /// Background color for initials/placeholder
    public let backgroundColor: Color

    /// Foreground color for initials/icons
    public let foregroundColor: Color

    /// Optional border color
    public let borderColor: Color?

    /// Border width (0 for no border)
    public let borderWidth: CGFloat

    /// Whether to show status badge
    public let showStatusBadge: Bool

    /// Position for status badge
    public let statusBadgePosition: StatusBadgePosition

    /// Placeholder icon when no content is available
    public let placeholderIcon: String

    // MARK: - Initialization

    /// Creates an avatar configuration with the specified options
    ///
    /// - Parameters:
    ///   - size: Avatar size (default: .md)
    ///   - shape: Avatar shape (default: .circle)
    ///   - backgroundColor: Background color for initials/placeholder (default: .gray.opacity(0.3))
    ///   - foregroundColor: Foreground color for initials/icons (default: .primary)
    ///   - borderColor: Optional border color (default: nil)
    ///   - borderWidth: Border width (default: 0)
    ///   - showStatusBadge: Whether to show status badge (default: true)
    ///   - statusBadgePosition: Position for status badge (default: .bottomTrailing)
    ///   - placeholderIcon: SF Symbol for placeholder (default: "person.fill")
    public init(
        size: Size = .md,
        shape: Shape = .circle,
        backgroundColor: Color = .gray.opacity(0.3),
        foregroundColor: Color = .primary,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        showStatusBadge: Bool = true,
        statusBadgePosition: StatusBadgePosition = .bottomTrailing,
        placeholderIcon: String = "person.fill"
    ) {
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showStatusBadge = showStatusBadge
        self.statusBadgePosition = statusBadgePosition
        self.placeholderIcon = placeholderIcon
    }

    // MARK: - Presets

    /// Default avatar (medium, circular)
    public static let `default` = ARCAvatarConfiguration()

    /// Small avatar for compact spaces
    public static let small = ARCAvatarConfiguration(size: .sm)

    /// Large avatar for prominent display
    public static let large = ARCAvatarConfiguration(size: .lg)

    /// Extra large avatar for profile headers
    public static let profile = ARCAvatarConfiguration(size: .xxl)

    /// Small avatar for list rows
    public static let listItem = ARCAvatarConfiguration(size: .sm)

    /// Medium avatar for comments
    public static let comment = ARCAvatarConfiguration(size: .md)

    /// Extra small avatar for compact UI
    public static let compact = ARCAvatarConfiguration(size: .xs)

    /// Avatar with border
    public static let bordered = ARCAvatarConfiguration(
        borderColor: .white,
        borderWidth: 2
    )
}

// MARK: - ARCAvatarStatus

/// Status indicator for avatars
@available(iOS 17.0, macOS 14.0, *)
public enum ARCAvatarStatus: Sendable, Equatable {
    /// No status indicator
    case none

    /// User is online (green)
    case online

    /// User is offline (gray)
    case offline

    /// User is busy/do not disturb (red)
    case busy

    /// User is away (yellow/orange)
    case away

    /// Custom status color
    case custom(Color)

    /// Color for the status indicator
    public var color: Color {
        switch self {
        case .none:
            .clear
        case .online:
            .green
        case .offline:
            .gray
        case .busy:
            .red
        case .away:
            .orange
        case let .custom(color):
            color
        }
    }

    /// Accessibility description for the status
    public var accessibilityDescription: String {
        switch self {
        case .none:
            ""
        case .online:
            String(localized: "Online")
        case .offline:
            String(localized: "Offline")
        case .busy:
            String(localized: "Busy")
        case .away:
            String(localized: "Away")
        case .custom:
            String(localized: "Custom status")
        }
    }
}
