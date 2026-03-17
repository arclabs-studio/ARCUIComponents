//
//  ARCBadge.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCBadge

/// A notification-style badge for counts and status indicators
///
/// `ARCBadge` displays numeric counts, text labels, or status dots following
/// Apple's Human Interface Guidelines for badges.
///
/// ## Overview
///
/// Per Apple HIG: "Use a badge to indicate that critical information is available.
/// Reserve badges for critical information so you don't dilute their impact."
///
/// ARCBadge supports three content types:
/// - Count: Numeric value with automatic "99+" overflow
/// - Text: Short labels like "NEW" or "SALE"
/// - Dot: Simple status indicator
///
/// ## Topics
///
/// ### Content Types
///
/// - ``Content``
///
/// ### Creating Badges
///
/// - ``init(_:configuration:)-1h2k3``
/// - ``init(_:configuration:)-5a9bn``
/// - ``init(dot:)``
///
/// ## Usage
///
/// ```swift
/// // Count badge
/// ARCBadge(5)
///
/// // Text badge
/// ARCBadge("NEW")
///
/// // Dot indicator
/// ARCBadge(dot: .success)
///
/// // As overlay on icon
/// Image(systemName: "bell")
///     .arcBadge(count: unreadCount)
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBadge: View {
    // MARK: - Content

    /// Content types for badges
    public enum Content: Equatable, Sendable {
        /// Numeric count with optional overflow
        case count(Int)

        /// Text label
        case text(String)

        /// Simple dot indicator
        case dot
    }

    // MARK: - Properties

    private let content: Content
    private let configuration: ARCBadgeConfiguration

    // MARK: - State

    @State private var animationScale: CGFloat = 1.0

    // MARK: - Initialization

    /// Creates a badge with numeric count
    ///
    /// - Parameters:
    ///   - count: The number to display
    ///   - configuration: Badge configuration
    public init(_ count: Int, configuration: ARCBadgeConfiguration = .default) {
        content = .count(count)
        self.configuration = configuration
    }

    /// Creates a badge with text content
    ///
    /// - Parameters:
    ///   - text: The text to display (keep short)
    ///   - configuration: Badge configuration
    public init(_ text: String, configuration: ARCBadgeConfiguration = .default) {
        content = .text(text)
        self.configuration = configuration
    }

    /// Creates a dot badge
    ///
    /// - Parameter configuration: Badge configuration (default: .dot)
    public init(dot configuration: ARCBadgeConfiguration = .dot) {
        content = .dot
        self.configuration = configuration
    }

    // MARK: - Private Init

    private init(content: Content, configuration: ARCBadgeConfiguration) {
        self.content = content
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if shouldShow {
                badgeContent
                    .scaleEffect(animationScale)
                    .onChange(of: content) { _, _ in
                        animateIfNeeded()
                    }
            }
        }
    }

    // MARK: - Badge Content

    @ViewBuilder private var badgeContent: some View {
        switch content {
        case .dot:
            dotView
        case .count, .text:
            labelView
        }
    }

    @ViewBuilder private var dotView: some View {
        Circle()
            .fill(configuration.style.color)
            .frame(width: configuration.size.height / 2, height: configuration.size.height / 2)
            .accessibilityLabel("Status indicator")
    }

    @ViewBuilder private var labelView: some View {
        Text(displayText)
            .font(.system(size: configuration.size.fontSize, weight: .bold, design: .rounded))
            .foregroundStyle(textColor)
            .padding(.horizontal, horizontalPadding)
            .frame(minWidth: configuration.size.height, minHeight: configuration.size.height)
            .background(backgroundView)
            .clipShape(Capsule())
            .overlay {
                if case .outlined = configuration.style {
                    Capsule()
                        .strokeBorder(configuration.style.color, lineWidth: 1.5)
                }
            }
            .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Background

    @ViewBuilder private var backgroundView: some View {
        switch configuration.style {
        case .filled:
            configuration.style.color
        case .outlined:
            Color.clear
        case .subtle:
            configuration.style.color.opacity(0.15)
        }
    }

    // MARK: - Computed Properties

    private var shouldShow: Bool {
        switch content {
        case let .count(value):
            value > 0 || configuration.showZero
        case .text, .dot:
            true
        }
    }

    private var displayText: String {
        switch content {
        case let .count(value):
            value > configuration.maxCount ? "\(configuration.maxCount)+" : "\(value)"
        case let .text(string):
            string
        case .dot:
            ""
        }
    }

    private var textColor: Color {
        switch configuration.style {
        case .filled:
            .white
        case .outlined:
            configuration.style.color
        case .subtle:
            configuration.style.color
        }
    }

    private var horizontalPadding: CGFloat {
        switch content {
        case let .count(value) where value < 10:
            0 // Single digit, let minWidth handle it
        case let .text(string) where string.count == 1:
            0
        default:
            configuration.size.horizontalPadding
        }
    }

    private var accessibilityLabel: String {
        switch content {
        case let .count(value):
            "\(value) items"
        case let .text(string):
            string
        case .dot:
            "Status indicator"
        }
    }

    // MARK: - Animation

    private func animateIfNeeded() {
        guard configuration.animate else { return }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            animationScale = 1.2
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                animationScale = 1.0
            }
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Badge Types") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            ARCBadge(5)
            ARCBadge(42)
            ARCBadge(100)
        }

        HStack(spacing: 16) {
            ARCBadge("NEW")
            ARCBadge("SALE")
            ARCBadge("PRO")
        }

        HStack(spacing: 16) {
            ARCBadge(dot: .default)
            ARCBadge(dot: .success)
            ARCBadge(dot: .warning)
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Badge Styles") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            ARCBadge(5, configuration: .default)
            ARCBadge(5, configuration: .success)
            ARCBadge(5, configuration: .warning)
            ARCBadge(5, configuration: .info)
        }

        HStack(spacing: 16) {
            ARCBadge(5, configuration: .outlined)
            ARCBadge(5, configuration: .subtle)
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Badge Sizes") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            ARCBadge(5, configuration: ARCBadgeConfiguration(size: .small))
            ARCBadge(5, configuration: ARCBadgeConfiguration(size: .medium))
            ARCBadge(5, configuration: ARCBadgeConfiguration(size: .large))
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Badge on Icon") {
    HStack(spacing: 32) {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "bell")
                .font(.title)
            ARCBadge(3)
                .offset(x: 8, y: -8)
        }

        ZStack(alignment: .topTrailing) {
            Image(systemName: "envelope")
                .font(.title)
            ARCBadge(dot: .default)
                .offset(x: 4, y: -4)
        }

        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart")
                .font(.title)
            ARCBadge("NEW", configuration: .info)
                .offset(x: 12, y: -8)
        }
    }
    .padding()
}
