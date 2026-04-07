//
//  ARCAppLanguage.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import SwiftUI

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
public enum ARCAppLanguage: String, CaseIterable, Identifiable, Sendable, ARCMenuPickerItem {
    case system
    case spanish
    case english

    // MARK: Public Properties

    public var id: String {
        rawValue
    }

    /// Localized display title for the language option
    ///
    /// Returns `LocalizedStringKey` so the consuming app's String Catalog
    /// provides translations. The app owns all user-facing text.
    public var title: LocalizedStringKey {
        switch self {
        case .system:
            "System"
        case .spanish:
            "Spanish"
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
