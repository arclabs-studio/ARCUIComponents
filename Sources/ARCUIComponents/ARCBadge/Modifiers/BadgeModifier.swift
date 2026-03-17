//
//  BadgeModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - BadgeModifier

/// View modifier for adding badge overlays to views
@available(iOS 17.0, macOS 14.0, *)
struct BadgeModifier: ViewModifier {
    // MARK: - Properties

    let content: ARCBadge.Content
    let configuration: ARCBadgeConfiguration
    let alignment: Alignment
    let offset: CGPoint

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                badgeView
                    .offset(x: offset.x, y: offset.y)
            }
    }

    // MARK: - Badge View

    @ViewBuilder private var badgeView: some View {
        switch content {
        case let .count(value):
            ARCBadge(value, configuration: configuration)
        case let .text(string):
            ARCBadge(string, configuration: configuration)
        case .dot:
            ARCBadge(dot: configuration)
        }
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, *)
extension View {
    /// Adds a count badge overlay to this view
    ///
    /// The badge appears in the top-trailing corner by default.
    ///
    /// - Parameters:
    ///   - count: The number to display
    ///   - configuration: Badge configuration (default: .default)
    ///   - alignment: Overlay alignment (default: .topTrailing)
    ///   - offset: Additional offset from alignment position
    /// - Returns: A view with badge overlay
    ///
    /// ## Example
    ///
    /// ```swift
    /// Image(systemName: "bell")
    ///     .arcBadge(count: 5)
    ///
    /// Image(systemName: "envelope")
    ///     .arcBadge(count: unreadCount, configuration: .info)
    /// ```
    public func arcBadge(
        count: Int,
        configuration: ARCBadgeConfiguration = .default,
        alignment: Alignment = .topTrailing,
        offset: CGPoint = CGPoint(x: 8, y: -8)
    ) -> some View {
        modifier(
            BadgeModifier(
                content: .count(count),
                configuration: configuration,
                alignment: alignment,
                offset: offset
            )
        )
    }

    /// Adds a text badge overlay to this view
    ///
    /// The badge appears in the top-trailing corner by default.
    ///
    /// - Parameters:
    ///   - text: The text to display
    ///   - configuration: Badge configuration (default: .default)
    ///   - alignment: Overlay alignment (default: .topTrailing)
    ///   - offset: Additional offset from alignment position
    /// - Returns: A view with badge overlay
    ///
    /// ## Example
    ///
    /// ```swift
    /// Image(systemName: "star")
    ///     .arcBadge(text: "NEW")
    /// ```
    public func arcBadge(
        text: String,
        configuration: ARCBadgeConfiguration = .default,
        alignment: Alignment = .topTrailing,
        offset: CGPoint = CGPoint(x: 12, y: -8)
    ) -> some View {
        modifier(
            BadgeModifier(
                content: .text(text),
                configuration: configuration,
                alignment: alignment,
                offset: offset
            )
        )
    }

    /// Adds a dot badge overlay to this view
    ///
    /// The badge appears in the top-trailing corner by default.
    ///
    /// - Parameters:
    ///   - configuration: Badge configuration (default: .dot)
    ///   - alignment: Overlay alignment (default: .topTrailing)
    ///   - offset: Additional offset from alignment position
    /// - Returns: A view with dot badge overlay
    ///
    /// ## Example
    ///
    /// ```swift
    /// Image(systemName: "person.circle")
    ///     .arcBadgeDot(configuration: .success) // Online indicator
    /// ```
    public func arcBadgeDot(
        configuration: ARCBadgeConfiguration = .dot,
        alignment: Alignment = .topTrailing,
        offset: CGPoint = CGPoint(x: 4, y: -4)
    ) -> some View {
        modifier(
            BadgeModifier(
                content: .dot,
                configuration: configuration,
                alignment: alignment,
                offset: offset
            )
        )
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Badge Modifiers") {
    HStack(spacing: 32) {
        Image(systemName: "bell")
            .font(.title)
            .arcBadge(count: 5)

        Image(systemName: "envelope")
            .font(.title)
            .arcBadge(count: 42, configuration: .info)

        Image(systemName: "star")
            .font(.title)
            .arcBadge(text: "NEW", configuration: .success)

        Image(systemName: "person.circle")
            .font(.title)
            .arcBadgeDot(configuration: .success)
    }
    .padding(32)
}
