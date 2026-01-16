//
//  ARCGlassContainer.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/16/26.
//

import SwiftUI

/// Container for combining multiple Liquid Glass effects with morphing animations
///
/// On iOS 26+, this wraps Apple's native `GlassEffectContainer` to enable
/// fluid morphing animations between glass elements. On iOS 17-25, it acts
/// as a simple passthrough container.
///
/// ## Overview
///
/// When multiple views with glass effects are placed inside an `ARCGlassContainer`,
/// their glass backgrounds can blend together and morph during animations.
/// This creates sophisticated visual transitions similar to those seen in
/// system apps like Music and Podcasts.
///
/// ## Platform Behavior
///
/// - **iOS 26+**: Uses native `GlassEffectContainer` for optimized rendering
///   and morphing animations between glass elements.
/// - **iOS 17-25**: Acts as a passthrough container. Glass effects render
///   independently without morphing.
///
/// ## Usage
///
/// ```swift
/// @Namespace var namespace
///
/// ARCGlassContainer(spacing: 40) {
///     HStack(spacing: 40) {
///         Button("Edit") { }
///             .liquidGlass(configuration: config, isInteractive: true)
///             .arcGlassEffectID("edit", in: namespace)
///
///         if showDelete {
///             Button("Delete") { }
///                 .liquidGlass(configuration: config, isInteractive: true)
///                 .arcGlassEffectID("delete", in: namespace)
///         }
///     }
/// }
/// ```
///
/// ## Spacing
///
/// The `spacing` parameter controls how close elements need to be for their
/// glass effects to blend together:
/// - Larger spacing = effects blend sooner during transitions
/// - Smaller spacing = effects stay separate longer
///
/// When the spacing matches the layout spacing, effects blend naturally
/// during animations.
///
/// - Note: For morphing to work, each glass element should have a unique
///   ID assigned via ``SwiftUI/View/arcGlassEffectID(_:in:)``.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCGlassContainer<Content: View>: View {
    // MARK: - Properties

    /// Spacing that controls when glass effects blend together
    private let spacing: CGFloat

    /// The content to display inside the container
    private let content: Content

    // MARK: - Initialization

    /// Creates a glass effect container with the specified spacing
    ///
    /// - Parameters:
    ///   - spacing: The spacing value that determines when glass effects blend.
    ///     Default is 40 points, which works well for most layouts.
    ///   - content: The views to display inside the container.
    public init(
        spacing: CGFloat = 40,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        #if compiler(>=6.2)
        if #available(iOS 26.0, macOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                content
            }
        } else {
            // On iOS 17-25, just render content without container
            content
        }
        #else
        // On older compilers without iOS 26 SDK, just render content
        content
        #endif
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCGlassContainer") {
    ARCGlassContainer(spacing: 40) {
        HStack(spacing: 40) {
            Text("Item 1")
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

            Text("Item 2")
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
        }
    }
    .padding()
}
