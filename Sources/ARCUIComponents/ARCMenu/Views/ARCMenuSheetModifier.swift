//
//  ARCMenuSheetModifier.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/25/26.
//

import SwiftUI

// MARK: - ARCMenuSheetModifier

/// View modifier that applies ARCMenu sheet styling to any sheet content
///
/// Applies the standard ARCMenu presentation appearance:
/// - Detents (medium + large by default)
/// - Drag indicator
/// - Corner radius (32pt)
/// - Ultra thin material background
/// - Content interaction mode
///
/// ## Usage
///
/// ```swift
/// .sheet(isPresented: $showSheet) {
///     MyCustomContent()
///         .arcMenuSheetStyle()
/// }
///
/// // With sectioned configuration
/// .sheet(isPresented: $showSheet) {
///     MyCustomContent()
///         .arcMenuSheetStyle(configuration: .sectioned)
/// }
/// ```
public struct ARCMenuSheetModifier: ViewModifier {
    let configuration: ARCMenuConfiguration

    public func body(content: Content) -> some View {
        content
            .presentationDetents(configuration.detents,
                                 selection: .constant(configuration.selectedDetent ?? .medium))
            .presentationDragIndicator(configuration.showsGrabber ? .visible : .hidden)
            .presentationCornerRadius(32)
            .presentationBackground(.ultraThinMaterial)
            .presentationContentInteraction(configuration.contentInteraction)
    }
}

// MARK: - View Extension

extension View {
    /// Applies ARCMenu-style sheet presentation to the view
    ///
    /// Use this modifier on sheet content to get the standard ARCMenu appearance
    /// (material background, detents, corner radius) without using the full ARCMenu component.
    ///
    /// - Parameter configuration: Menu configuration for styling (default: `.default`)
    /// - Returns: View with ARCMenu sheet styling applied
    public func arcMenuSheetStyle(configuration: ARCMenuConfiguration = .default) -> some View {
        modifier(ARCMenuSheetModifier(configuration: configuration))
    }
}
