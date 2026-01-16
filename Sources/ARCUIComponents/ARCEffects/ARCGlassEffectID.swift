//
//  ARCGlassEffectID.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/16/26.
//

import SwiftUI

// MARK: - Glass Effect ID Extension

@available(iOS 17.0, macOS 14.0, *)
public extension View {
    /// Assigns a glass effect ID for morphing animations
    ///
    /// On iOS 26+, this enables morphing animations between glass effects
    /// within an ``ARCGlassContainer``. When views with glass effects are
    /// added or removed, they smoothly morph into each other instead of
    /// simply appearing/disappearing.
    ///
    /// On iOS 17-25, this modifier has no effect (no-op).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// @Namespace var namespace
    /// @State var showSecondButton = false
    ///
    /// ARCGlassContainer(spacing: 40) {
    ///     HStack(spacing: 40) {
    ///         Button("First") { }
    ///             .liquidGlass(configuration: config)
    ///             .arcGlassEffectID("first", in: namespace)
    ///
    ///         if showSecondButton {
    ///             Button("Second") { }
    ///                 .liquidGlass(configuration: config)
    ///                 .arcGlassEffectID("second", in: namespace)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this glass effect within the namespace.
    ///     Use consistent IDs across state changes to enable morphing.
    ///   - namespace: The namespace that groups related glass effects together.
    ///     Create with `@Namespace var namespace`.
    /// - Returns: The view with the glass effect ID applied (iOS 26+) or unchanged (iOS 17-25).
    ///
    /// - Note: This modifier only affects glass effects applied via
    ///   ``SwiftUI/View/liquidGlass(configuration:isInteractive:)`` or
    ///   the native `.glassEffect()` modifier.
    @ViewBuilder
    func arcGlassEffectID<ID: Hashable & Sendable>(
        _ id: ID,
        in namespace: Namespace.ID
    ) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffectID(id, in: namespace)
        } else {
            self
        }
    }

    /// Combines multiple glass effects into a single unified shape
    ///
    /// On iOS 26+, this modifier causes multiple glass effects to render
    /// as a single combined shape, even when they're at rest. This is useful
    /// for creating grouped controls that appear as one glass element.
    ///
    /// On iOS 17-25, this modifier has no effect (no-op).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// @Namespace var namespace
    ///
    /// ARCGlassContainer(spacing: 20) {
    ///     HStack(spacing: 20) {
    ///         ForEach(items) { item in
    ///             Button(item.name) { }
    ///                 .liquidGlass(configuration: config)
    ///                 .arcGlassEffectUnion(id: "toolbar", in: namespace)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - id: The shared identifier for all effects that should combine.
    ///   - namespace: The namespace that groups related glass effects together.
    /// - Returns: The view with union applied (iOS 26+) or unchanged (iOS 17-25).
    @ViewBuilder
    func arcGlassEffectUnion<ID: Hashable & Sendable>(
        id: ID,
        in namespace: Namespace.ID
    ) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.glassEffectUnion(id: id, namespace: namespace)
        } else {
            self
        }
    }
}
