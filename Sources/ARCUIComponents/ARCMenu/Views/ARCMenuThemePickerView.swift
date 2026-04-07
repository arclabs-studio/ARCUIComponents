//
//  ARCMenuThemePickerView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import SwiftUI

// MARK: - ARCMenuThemePickerView

/// Standalone theme picker screen with checkmark selection
///
/// A thin wrapper around ``ARCMenuPickerView`` specialised for ``ARCAppearanceMode``.
/// Provides a default navigation title ("Theme") and forwards all behaviour to
/// the generic picker, including the deferred commit pattern and optional Done button.
///
/// This is a **leaf view** — it has no `NavigationStack` and does not know
/// where it's presented from. The app provides navigation context.
///
/// Usage:
/// ```swift
/// NavigationStack {
///     ARCMenuThemePickerView(selectedMode: $appearanceManager.mode,
///                            onDone: { dismiss() })
/// }
/// ```
public struct ARCMenuThemePickerView: View {
    // MARK: Public Properties

    @Binding public var selectedMode: ARCAppearanceMode

    // MARK: Private Properties

    private let navigationTitleKey: LocalizedStringKey
    private let onDone: (() -> Void)?

    // MARK: Lifecycle

    public init(selectedMode: Binding<ARCAppearanceMode>,
                navigationTitle: LocalizedStringKey = "Theme",
                onDone: (() -> Void)? = nil) {
        _selectedMode = selectedMode
        navigationTitleKey = navigationTitle
        self.onDone = onDone
    }

    // MARK: View

    public var body: some View {
        ARCMenuPickerView(selection: $selectedMode,
                          navigationTitle: navigationTitleKey,
                          onDone: onDone)
    }
}

// MARK: - Previews

#Preview("Theme Picker - Dark") {
    NavigationStack {
        ARCMenuThemePickerView(selectedMode: .constant(.system), onDone: {})
    }
    .preferredColorScheme(.dark)
}

#Preview("Theme Picker - Light") {
    NavigationStack {
        ARCMenuThemePickerView(selectedMode: .constant(.light), onDone: {})
    }
    .preferredColorScheme(.light)
}
