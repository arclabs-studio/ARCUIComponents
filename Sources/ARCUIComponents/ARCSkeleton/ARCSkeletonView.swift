//
//  ARCSkeletonView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCSkeletonView

/// A skeleton loading placeholder with shimmer animation
///
/// `ARCSkeletonView` provides visual feedback during content loading, improving
/// perceived performance. The skeleton matches the final content dimensions to
/// prevent layout shifts when content loads.
///
/// ## Overview
///
/// ARCSkeletonView supports multiple shapes (rectangle, rounded rectangle, circle,
/// capsule) and size configurations. The shimmer animation automatically respects
/// the user's reduced motion accessibility preference.
///
/// ## Topics
///
/// ### Creating Skeleton Views
///
/// - ``init(configuration:)``
///
/// ### Configuration
///
/// - ``ARCSkeletonConfiguration``
///
/// ## Usage
///
/// ```swift
/// // Basic skeleton with default configuration
/// ARCSkeletonView()
///     .frame(height: 100)
///
/// // Avatar placeholder
/// ARCSkeletonView(configuration: .avatar)
///
/// // Text line placeholder
/// ARCSkeletonView(configuration: .text)
///
/// // Custom configuration
/// ARCSkeletonView(configuration: ARCSkeletonConfiguration(
///     shape: .roundedRectangle(cornerRadius: 12),
///     size: .fixed(width: 200, height: 50)
/// ))
/// ```
///
/// ## Accessibility
///
/// ARCSkeletonView automatically:
/// - Respects `accessibilityReduceMotion` (disables shimmer)
/// - Provides "Loading" accessibility label
/// - Uses semantic colors for dark/light mode support
@available(iOS 17.0, macOS 14.0, *)
public struct ARCSkeletonView: View {
    // MARK: - Properties

    private let configuration: ARCSkeletonConfiguration

    // MARK: - Initialization

    /// Creates a skeleton view with the specified configuration
    ///
    /// - Parameter configuration: Configuration for shape, size, and animation.
    ///   Defaults to ``ARCSkeletonConfiguration/default``.
    public init(configuration: ARCSkeletonConfiguration = .default) {
        self.configuration = configuration
    }

    // MARK: - Body

    public var body: some View {
        shapeView
            .skeletonShimmer(configuration: configuration)
            .modifier(SizeModifier(size: configuration.size))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Loading content")
            .accessibilityAddTraits(.updatesFrequently)
    }

    // MARK: - Shape View Builder

    @ViewBuilder private var shapeView: some View {
        switch configuration.shape {
        case .rectangle:
            Rectangle()
                .fill(configuration.baseColor)
        case let .roundedRectangle(cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(configuration.baseColor)
        case .circle:
            Circle()
                .fill(configuration.baseColor)
        case .capsule:
            Capsule()
                .fill(configuration.baseColor)
        }
    }
}

// MARK: - Size Modifier

@available(iOS 17.0, macOS 14.0, *)
private struct SizeModifier: ViewModifier {
    let size: ARCSkeletonConfiguration.Size

    func body(content: Content) -> some View {
        switch size {
        case let .fixed(width, height):
            content
                .frame(width: width, height: height)

        case let .flexible(minWidth, maxWidth, height):
            content
                .frame(minWidth: minWidth, maxWidth: maxWidth ?? .infinity, minHeight: height, maxHeight: height)

        case let .aspectRatio(ratio, height):
            content
                .frame(width: height * ratio, height: height)

        case let .fill(height):
            content
                .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
        }
    }
}

// MARK: - Convenience Initializers

@available(iOS 17.0, macOS 14.0, *)
extension ARCSkeletonView {
    /// Creates a text line skeleton
    ///
    /// - Parameter style: Text style preset (default: .text)
    /// - Returns: A skeleton view configured for text
    public static func text(_ style: ARCSkeletonConfiguration = .text) -> ARCSkeletonView {
        ARCSkeletonView(configuration: style)
    }

    /// Creates an avatar skeleton
    ///
    /// - Parameter style: Avatar style preset (default: .avatar)
    /// - Returns: A skeleton view configured for avatars
    public static func avatar(_ style: ARCSkeletonConfiguration = .avatar) -> ARCSkeletonView {
        ARCSkeletonView(configuration: style)
    }

    /// Creates an image skeleton
    ///
    /// - Parameter style: Image style preset (default: .image)
    /// - Returns: A skeleton view configured for images
    public static func image(_ style: ARCSkeletonConfiguration = .image) -> ARCSkeletonView {
        ARCSkeletonView(configuration: style)
    }
}

// MARK: - Preview

#Preview("Default Skeleton") {
    ARCSkeletonView()
        .padding()
}

#Preview("Shapes") {
    VStack(spacing: 20) {
        Text("Rectangle")
            .font(.caption)
            .foregroundStyle(.secondary)
        ARCSkeletonView(configuration: ARCSkeletonConfiguration(
            shape: .rectangle,
            size: .fixed(width: 100, height: 50)
        ))

        Text("Rounded Rectangle")
            .font(.caption)
            .foregroundStyle(.secondary)
        ARCSkeletonView(configuration: ARCSkeletonConfiguration(
            shape: .roundedRectangle(cornerRadius: 12),
            size: .fixed(width: 100, height: 50)
        ))

        Text("Circle")
            .font(.caption)
            .foregroundStyle(.secondary)
        ARCSkeletonView(configuration: .avatar)

        Text("Capsule")
            .font(.caption)
            .foregroundStyle(.secondary)
        ARCSkeletonView(configuration: .button)
    }
    .padding()
}

#Preview("Presets") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            // Text presets
            Text("Text")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .text)

            Text("Text Small")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .textSmall)

            Text("Text Large")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .textLarge)

            Divider()

            // Avatar presets
            Text("Avatar Small")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .avatarSmall)

            Text("Avatar")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .avatar)

            Text("Avatar Large")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .avatarLarge)

            Divider()

            // Other presets
            Text("Button")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .button)

            Text("Icon")
                .font(.caption)
                .foregroundStyle(.secondary)
            ARCSkeletonView(configuration: .icon)
        }
        .padding()
    }
}

#Preview("Dark Mode") {
    VStack(spacing: 16) {
        ARCSkeletonView(configuration: .avatar)
        ARCSkeletonView(configuration: .text)
        ARCSkeletonView(configuration: .textSmall)
            .frame(width: 200)
    }
    .padding()
    .preferredColorScheme(.dark)
}
