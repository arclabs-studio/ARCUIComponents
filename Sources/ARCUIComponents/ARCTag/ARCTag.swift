//
//  ARCTag.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCTag

/// A static label for categorization and attributes
///
/// `ARCTag` displays category labels, attributes, or status information.
/// Unlike chips, tags are not interactive - they're purely informational.
///
/// ## Overview
///
/// Use tags for:
/// - Genre labels (Action, Comedy, Drama)
/// - Food attributes (Vegan, Gluten-Free)
/// - Status labels (Open, Closed, Coming Soon)
/// - Skill tags (Swift, SwiftUI, iOS)
///
/// ## Topics
///
/// ### Creating Tags
///
/// - ``init(_:icon:configuration:)``
///
/// ## Usage
///
/// ```swift
/// // Simple tag
/// ARCTag("Swift")
///
/// // Tag with icon
/// ARCTag("Italian", icon: "fork.knife")
///
/// // Status tag
/// ARCTag("Open", configuration: .status)
///
/// // In a flow layout
/// FlowLayout {
///     ForEach(genres, id: \.self) { genre in
///         ARCTag(genre, configuration: .category)
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, *)
public struct ARCTag: View {
    // MARK: - Properties

    private let text: String
    private let icon: String?
    private let configuration: ARCTagConfiguration

    // MARK: - Initialization

    /// Creates a tag with the specified content
    ///
    /// - Parameters:
    ///   - text: The label text
    ///   - icon: Optional SF Symbol name
    ///   - configuration: Tag configuration
    public init(
        _ text: String,
        icon: String? = nil,
        configuration: ARCTagConfiguration = .default
    ) {
        self.text = text
        self.icon = icon
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 4) {
            if configuration.iconPosition == .leading, let icon {
                iconView(icon)
            }

            textView

            if configuration.iconPosition == .trailing, let icon {
                iconView(icon)
            }
        }
        .padding(.horizontal, configuration.size.horizontalPadding)
        .padding(.vertical, configuration.size.verticalPadding)
        .frame(minHeight: configuration.size.height)
        .background(backgroundView)
        .clipShape(tagShape)
        .overlay {
            if configuration.style == .outlined {
                tagShape
                    .strokeBorder(configuration.color, lineWidth: 1)
            }
        }
        .accessibilityLabel("Category: \(text)")
        .accessibilityAddTraits(.isStaticText)
    }

    // MARK: - Icon View

    @ViewBuilder
    private func iconView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: configuration.size.iconSize))
            .foregroundStyle(iconColor)
    }

    // MARK: - Text View

    @ViewBuilder private var textView: some View {
        Text(text)
            .font(.system(size: configuration.size.fontSize, weight: .medium))
            .foregroundStyle(computedTextColor)
    }

    // MARK: - Background View

    @ViewBuilder private var backgroundView: some View {
        switch configuration.style {
        case .filled:
            configuration.color
        case .outlined:
            Color.clear
        case .subtle:
            configuration.color.opacity(0.12)
        case .glass:
            LiquidGlassBackground(configuration: configuration)
        }
    }

    // MARK: - Shape

    private var tagShape: some InsettableShape {
        if configuration.cornerRadius > 0 {
            AnyInsettableShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
        } else {
            AnyInsettableShape(Capsule())
        }
    }

    // MARK: - Colors

    private var computedTextColor: Color {
        if let textColor = configuration.textColor {
            return textColor
        }

        switch configuration.style {
        case .filled:
            return .white
        case .outlined, .subtle:
            return configuration.color
        case .glass:
            return .primary
        }
    }

    private var iconColor: Color {
        computedTextColor
    }
}

// MARK: - AnyInsettableShape

@available(iOS 17.0, macOS 14.0, *)
private struct AnyInsettableShape: InsettableShape, @unchecked Sendable {
    private let _path: @Sendable (CGRect) -> Path
    private let _inset: @Sendable (CGFloat) -> AnyInsettableShape

    init(_ shape: some InsettableShape & Sendable) {
        _path = { shape.path(in: $0) }
        _inset = { AnyInsettableShape(shape.inset(by: $0)) }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }

    func inset(by amount: CGFloat) -> AnyInsettableShape {
        _inset(amount)
    }
}

// MARK: - Liquid Glass Background

@available(iOS 17.0, macOS 14.0, *)
private struct LiquidGlassBackground: View {
    let configuration: ARCTagConfiguration

    var body: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius > 0 ? configuration.cornerRadius : 100)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: configuration.cornerRadius > 0 ? configuration.cornerRadius : 100)
                    .fill(configuration.accentColor.opacity(0.05))
            }
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Tag Styles") {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            ARCTag("Default")
            ARCTag("Category", configuration: .category)
            ARCTag("Status", configuration: .status)
        }

        HStack(spacing: 8) {
            ARCTag("Outlined", configuration: .outlined)
            ARCTag("Glass", configuration: .glass)
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Tags with Icons") {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            ARCTag("Italian", icon: "fork.knife")
            ARCTag("Vegan", icon: "leaf.fill")
            ARCTag("Spicy", icon: "flame.fill")
        }

        HStack(spacing: 8) {
            ARCTag("Swift", icon: "swift", configuration: .init(color: .orange))
            ARCTag("iOS", icon: "iphone", configuration: .init(color: .blue))
        }
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Tag Sizes") {
    VStack(spacing: 16) {
        ARCTag("Small", configuration: ARCTagConfiguration(size: .small))
        ARCTag("Medium", configuration: ARCTagConfiguration(size: .medium))
        ARCTag("Large", configuration: ARCTagConfiguration(size: .large))
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Tag Colors") {
    VStack(spacing: 12) {
        HStack(spacing: 8) {
            ARCTag("Red", configuration: .init(style: .filled, color: .red))
            ARCTag("Orange", configuration: .init(style: .filled, color: .orange))
            ARCTag("Green", configuration: .init(style: .filled, color: .green))
            ARCTag("Blue", configuration: .init(style: .filled, color: .blue))
        }

        HStack(spacing: 8) {
            ARCTag("Red", configuration: .init(style: .subtle, color: .red))
            ARCTag("Orange", configuration: .init(style: .subtle, color: .orange))
            ARCTag("Green", configuration: .init(style: .subtle, color: .green))
            ARCTag("Blue", configuration: .init(style: .subtle, color: .blue))
        }
    }
    .padding()
}
