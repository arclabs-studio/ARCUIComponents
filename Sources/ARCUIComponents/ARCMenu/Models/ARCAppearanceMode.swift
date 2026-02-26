//
//  ARCAppearanceMode.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import SwiftUI

// MARK: - ARCAppearanceMode

/// Represents the user's preferred appearance mode for the app
///
/// UI-pure enum providing display data for theme pickers.
/// Contains no persistence logic — the app is responsible for storing the selection.
///
/// Usage:
/// ```swift
/// ARCMenuThemePickerView(selectedMode: $appearanceManager.mode)
/// ```
public enum ARCAppearanceMode: String, CaseIterable, Identifiable, Sendable {
    case system
    case light
    case dark

    // MARK: Public Properties

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .system:
            "Sistema"
        case .light:
            "Claro"
        case .dark:
            "Oscuro"
        }
    }

    public var icon: String {
        switch self {
        case .system:
            "circle.lefthalf.filled"
        case .light:
            "sun.max.fill"
        case .dark:
            "moon.fill"
        }
    }

    /// Returns the corresponding ColorScheme for SwiftUI
    /// Returns nil for system mode to use the device setting
    public var colorScheme: ColorScheme? {
        switch self {
        case .system:
            nil
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}
