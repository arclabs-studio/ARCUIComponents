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
/// Displays all ``ARCAppearanceMode`` cases (System, Light, Dark) in a Form.
/// This is a **leaf view** — it has no NavigationStack and does not know
/// where it's presented from. The app provides navigation context.
///
/// The navigation title uses `LocalizedStringKey`, so the consuming app's
/// String Catalog provides translations.
///
/// Usage:
/// ```swift
/// NavigationStack {
///     ARCMenuThemePickerView(selectedMode: $appearanceManager.mode)
/// }
/// ```
public struct ARCMenuThemePickerView: View {
    // MARK: Public Properties

    @Binding public var selectedMode: ARCAppearanceMode

    // MARK: Private Properties

    /// Local selection state — only committed to the binding when the view disappears.
    ///
    /// Prevents `@Observable` side effects from invalidating the NavigationStack
    /// while the user is still interacting with the picker.
    @State private var pendingSelection: ARCAppearanceMode
    private let navigationTitleKey: LocalizedStringKey

    // MARK: Lifecycle

    public init(selectedMode: Binding<ARCAppearanceMode>,
                navigationTitle: LocalizedStringKey = "Theme") {
        _selectedMode = selectedMode
        _pendingSelection = State(initialValue: selectedMode.wrappedValue)
        navigationTitleKey = navigationTitle
    }

    // MARK: View

    public var body: some View {
        Form {
            Section {
                ForEach(ARCAppearanceMode.allCases) { mode in
                    Button {
                        pendingSelection = mode
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: mode.icon)
                                .font(.body)
                                .foregroundStyle(pendingSelection == mode ? Color.accentColor : .secondary)
                                .frame(width: 24)

                            Text(mode.title)
                                .foregroundStyle(.primary)

                            Spacer()

                            if pendingSelection == mode {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(navigationTitleKey)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .onDisappear {
                selectedMode = pendingSelection
            }
    }
}

// MARK: - Previews

#Preview("Theme Picker - Dark") {
    NavigationStack {
        ARCMenuThemePickerView(selectedMode: .constant(.system))
    }
    .preferredColorScheme(.dark)
}

#Preview("Theme Picker - Light") {
    NavigationStack {
        ARCMenuThemePickerView(selectedMode: .constant(.light))
    }
    .preferredColorScheme(.light)
}
