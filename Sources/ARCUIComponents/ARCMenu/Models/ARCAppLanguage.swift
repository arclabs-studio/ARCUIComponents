//
//  ARCAppLanguage.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import Foundation

// MARK: - ARCAppLanguage

/// Represents the user's preferred app language
///
/// UI-pure enum providing display data for language pickers.
/// Contains no locale-switching logic — the app handles actual language changes.
///
/// Usage:
/// ```swift
/// ARCMenuLanguagePickerView(selectedLanguage: $viewModel.selectedLanguage)
/// ```
public enum ARCAppLanguage: String, CaseIterable, Identifiable, Sendable {
    case system
    case spanish
    case english

    // MARK: Public Properties

    public var id: String {
        rawValue
    }

    public var title: String {
        switch self {
        case .system:
            "Sistema"
        case .spanish:
            "Español"
        case .english:
            "English"
        }
    }

    public var icon: String {
        switch self {
        case .system:
            "iphone"
        case .spanish:
            "globe.americas.fill"
        case .english:
            "globe.europe.africa.fill"
        }
    }
}
