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
/// Usage:
/// ```swift
/// NavigationStack {
///     ARCMenuThemePickerView(selectedMode: $appearanceManager.mode)
/// }
/// ```
public struct ARCMenuThemePickerView: View {
    // MARK: Public Properties

    @Binding public var selectedMode: ARCAppearanceMode

    // MARK: Lifecycle

    public init(selectedMode: Binding<ARCAppearanceMode>) {
        _selectedMode = selectedMode
    }

    // MARK: View

    public var body: some View {
        Form {
            Section {
                ForEach(ARCAppearanceMode.allCases) { mode in
                    Button {
                        selectedMode = mode
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: mode.icon)
                                .font(.body)
                                .foregroundStyle(selectedMode == mode ? Color.accentColor : .secondary)
                                .frame(width: 24)

                            Text(mode.title)
                                .foregroundStyle(.primary)

                            Spacer()

                            if selectedMode == mode {
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
        .navigationTitle("Tema")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
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
