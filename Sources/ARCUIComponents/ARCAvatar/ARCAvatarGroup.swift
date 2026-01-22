//
//  ARCAvatarGroup.swift
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

// MARK: - ARCAvatarGroup

/// A component for displaying multiple avatars in a stacked/overlapping layout
///
/// `ARCAvatarGroup` displays a collection of avatars with configurable overlap,
/// showing a "+N" indicator when there are more avatars than the maximum display count.
///
/// ## Overview
///
/// Use ARCAvatarGroup to show team members, participants, or any collection of users
/// in a compact, visually appealing format.
///
/// ## Usage
///
/// ```swift
/// // Basic usage
/// ARCAvatarGroup(
///     avatars: [
///         ARCAvatar(name: "John Doe"),
///         ARCAvatar(name: "Jane Smith"),
///         ARCAvatar(name: "Bob Wilson")
///     ]
/// )
///
/// // With max display limit
/// ARCAvatarGroup(
///     avatars: teamAvatars,
///     maxDisplay: 4,
///     configuration: .compact
/// )
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAvatarGroup: View {
    // MARK: - Properties

    private let avatars: [ARCAvatar]
    private let maxDisplay: Int
    private let configuration: ARCAvatarGroupConfiguration

    // MARK: - Initialization

    /// Creates an avatar group with the specified avatars
    ///
    /// - Parameters:
    ///   - avatars: Array of ARCAvatar instances to display
    ///   - maxDisplay: Maximum number of avatars to show before "+N" (default: 4)
    ///   - configuration: Group configuration (default: .default)
    public init(
        avatars: [ARCAvatar],
        maxDisplay: Int = 4,
        configuration: ARCAvatarGroupConfiguration = .default
    ) {
        self.avatars = avatars
        self.maxDisplay = max(1, maxDisplay)
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: -overlapAmount) {
            ForEach(displayedAvatars.indices, id: \.self) { index in
                avatarWithBorder(at: index)
                    .zIndex(Double(displayedAvatars.count - index))
            }

            if overflowCount > 0, configuration.showOverflowCount {
                overflowBadge
                    .zIndex(0)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(overflowCount > 0 ? String(localized: "\(overflowCount) more members not shown") : "")
    }

    // MARK: - Avatar with Border

    @ViewBuilder
    private func avatarWithBorder(at index: Int) -> some View {
        let avatar = displayedAvatars[index]
        avatar
            .overlay {
                avatarBorderOverlay
            }
    }

    @ViewBuilder private var avatarBorderOverlay: some View {
        switch configuration.avatarShape {
        case .circle:
            Circle()
                .strokeBorder(configuration.borderColor, lineWidth: configuration.borderWidth)
        case let .roundedSquare(cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(configuration.borderColor, lineWidth: configuration.borderWidth)
        case .squircle:
            RoundedRectangle(cornerRadius: configuration.size.dimension * 0.22, style: .continuous)
                .strokeBorder(configuration.borderColor, lineWidth: configuration.borderWidth)
        }
    }

    // MARK: - Overflow Badge

    private var overflowBadge: some View {
        ZStack {
            Circle()
                .fill(configuration.overflowBackgroundColor)
            Text("+\(overflowCount)")
                .font(.system(
                    size: configuration.size.fontSize * 0.9,
                    weight: .semibold,
                    design: .rounded
                ))
                .foregroundStyle(configuration.overflowForegroundColor)
        }
        .frame(
            width: configuration.size.dimension,
            height: configuration.size.dimension
        )
        .overlay {
            Circle()
                .strokeBorder(configuration.borderColor, lineWidth: configuration.borderWidth)
        }
    }

    // MARK: - Computed Properties

    private var displayedAvatars: [ARCAvatar] {
        Array(avatars.prefix(maxDisplay))
    }

    private var overflowCount: Int {
        max(0, avatars.count - maxDisplay)
    }

    private var overlapAmount: CGFloat {
        configuration.size.dimension * configuration.overlapPercentage
    }

    private var accessibilityLabel: String {
        let count = avatars.count
        if count == 1 {
            return String(localized: "1 team member")
        }
        return String(localized: "\(count) team members")
    }
}

// MARK: - ARCAvatarGroupConfiguration

/// Configuration for ARCAvatarGroup appearance
@available(iOS 17.0, macOS 14.0, *)
public struct ARCAvatarGroupConfiguration: Sendable {
    // MARK: - Properties

    /// Avatar size for all avatars in the group
    public let size: ARCAvatarConfiguration.Size

    /// Avatar shape for all avatars in the group
    public let avatarShape: ARCAvatarConfiguration.Shape

    /// Percentage of avatar width to overlap (0.0 - 0.5)
    public let overlapPercentage: CGFloat

    /// Border color between avatars
    public let borderColor: Color

    /// Border width
    public let borderWidth: CGFloat

    /// Whether to show "+N" for overflow
    public let showOverflowCount: Bool

    /// Background color for overflow badge
    public let overflowBackgroundColor: Color

    /// Foreground color for overflow badge text
    public let overflowForegroundColor: Color

    // MARK: - Initialization

    /// Creates an avatar group configuration
    ///
    /// - Parameters:
    ///   - size: Avatar size (default: .md)
    ///   - avatarShape: Avatar shape (default: .circle)
    ///   - overlapPercentage: Overlap amount as percentage (default: 0.3)
    ///   - borderColor: Border color between avatars (default: system background)
    ///   - borderWidth: Border width (default: 2)
    ///   - showOverflowCount: Show "+N" badge (default: true)
    ///   - overflowBackgroundColor: Overflow badge background (default: .gray)
    ///   - overflowForegroundColor: Overflow badge text color (default: .white)
    public init(
        size: ARCAvatarConfiguration.Size = .md,
        avatarShape: ARCAvatarConfiguration.Shape = .circle,
        overlapPercentage: CGFloat = 0.3,
        borderColor: Color = .white,
        borderWidth: CGFloat = 2,
        showOverflowCount: Bool = true,
        overflowBackgroundColor: Color = .gray,
        overflowForegroundColor: Color = .white
    ) {
        self.size = size
        self.avatarShape = avatarShape
        self.overlapPercentage = min(0.5, max(0, overlapPercentage))
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showOverflowCount = showOverflowCount
        self.overflowBackgroundColor = overflowBackgroundColor
        self.overflowForegroundColor = overflowForegroundColor
    }

    // MARK: - Presets

    /// Default configuration
    public static let `default` = ARCAvatarGroupConfiguration()

    /// Compact configuration with smaller avatars
    public static let compact = ARCAvatarGroupConfiguration(
        size: .sm,
        overlapPercentage: 0.35
    )

    /// Spread configuration with less overlap
    public static let spread = ARCAvatarGroupConfiguration(
        overlapPercentage: 0.2
    )

    /// Large avatars for prominent display
    public static let large = ARCAvatarGroupConfiguration(
        size: .lg,
        overlapPercentage: 0.25
    )
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Avatar Group - Basic") {
    VStack(spacing: 32) {
        ARCAvatarGroup(
            avatars: [
                ARCAvatar(name: "John Doe"),
                ARCAvatar(name: "Jane Smith"),
                ARCAvatar(name: "Bob Wilson"),
            ]
        )

        ARCAvatarGroup(
            avatars: [
                ARCAvatar(name: "Alice"),
                ARCAvatar(name: "Bob"),
                ARCAvatar(name: "Charlie"),
                ARCAvatar(name: "Diana"),
                ARCAvatar(name: "Eve"),
                ARCAvatar(name: "Frank"),
            ],
            maxDisplay: 4
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Avatar Group - Configurations") {
    VStack(spacing: 32) {
        VStack(alignment: .leading, spacing: 8) {
            Text("Default").font(.caption)
            ARCAvatarGroup(
                avatars: sampleAvatars,
                configuration: .default
            )
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Compact").font(.caption)
            ARCAvatarGroup(
                avatars: sampleAvatars,
                configuration: .compact
            )
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Spread").font(.caption)
            ARCAvatarGroup(
                avatars: sampleAvatars,
                configuration: .spread
            )
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Large").font(.caption)
            ARCAvatarGroup(
                avatars: sampleAvatars,
                configuration: .large
            )
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor private var sampleAvatars: [ARCAvatar] {
    [
        ARCAvatar(name: "John Doe"),
        ARCAvatar(name: "Jane Smith"),
        ARCAvatar(name: "Bob Wilson"),
        ARCAvatar(name: "Alice Brown"),
        ARCAvatar(name: "Charlie Davis"),
    ]
}
