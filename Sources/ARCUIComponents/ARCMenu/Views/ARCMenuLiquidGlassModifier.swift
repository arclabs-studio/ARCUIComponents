//
//  ARCMenuLiquidGlassModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

// MARK: - Legacy Compatibility

/// Legacy extension for ARCMenu-specific liquid glass effect
///
/// This extension maintains backward compatibility while leveraging
/// the new unified ``LiquidGlassModifier`` under the hood.
///
/// - Note: New code should use the generic `.liquidGlass(configuration:)` modifier directly.
@available(iOS 17.0, *)
extension View {
    /// Applies the liquid glass effect to a view using ARCMenu configuration
    ///
    /// This is a convenience wrapper around the unified liquid glass modifier,
    /// maintained for backward compatibility with existing ARCMenu code.
    ///
    /// - Parameter configuration: Menu configuration containing style settings
    /// - Returns: View with liquid glass effect applied
    ///
    /// ## Example
    ///
    /// ```swift
    /// MenuContentView()
    ///     .liquidGlass(configuration: menuConfig)
    /// ```
    func arcMenuLiquidGlass(configuration: ARCMenuConfiguration) -> some View {
        liquidGlass(configuration: configuration)
    }
}

// MARK: - Backdrop Blur Modifier

/// Backdrop blur effect for the overlay behind the menu
///
/// Creates a darkened overlay with tap-to-dismiss functionality,
/// commonly used for modal presentations.
///
/// ## Overview
///
/// This modifier adds a semi-transparent black overlay that dims the
/// background content when a menu or modal is presented. It includes
/// tap gesture recognition for dismissing the overlay.
///
/// The opacity value controls both the visibility and the dimming effect,
/// making it easy to coordinate with presentation animations.
struct ARCMenuBackdropModifier: ViewModifier {
    /// Opacity of the backdrop (0-1)
    let opacity: Double

    /// Action to perform when backdrop is tapped
    let onTap: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                if opacity > 0 {
                    Color.black
                        .opacity(opacity * 0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            onTap()
                        }
                        .accessibilityHidden(true)
                }
            }
    }
}

// MARK: - View Extension

@available(iOS 17.0, *)
extension View {
    /// Applies a backdrop blur overlay
    ///
    /// Adds a semi-transparent black overlay that responds to taps,
    /// typically used to dismiss modals or menus when tapping outside.
    ///
    /// - Parameters:
    ///   - opacity: Opacity of the backdrop (0-1). At 0, the backdrop is hidden.
    ///   - onTap: Action to perform when backdrop is tapped
    /// - Returns: View with backdrop overlay
    ///
    /// ## Example
    ///
    /// ```swift
    /// ContentView()
    ///     .backdrop(opacity: isPresented ? 1.0 : 0.0) {
    ///         isPresented = false
    ///     }
    /// ```
    func backdrop(opacity: Double, onTap: @escaping () -> Void) -> some View {
        modifier(ARCMenuBackdropModifier(opacity: opacity, onTap: onTap))
    }
}
