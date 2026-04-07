//
//  ARCMenuPickerItem.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 08/04/2026.
//

import SwiftUI

// MARK: - ARCMenuPickerItem

/// Protocol for items displayed in ``ARCMenuPickerView``
///
/// Conforming types provide an SF Symbol icon name and a localized title.
/// The consuming app's String Catalog resolves translations for `title`.
///
/// Both ``ARCAppearanceMode`` and ``ARCAppLanguage`` conform to this protocol,
/// enabling the generic ``ARCMenuPickerView`` to back both picker screens.
///
/// Usage:
/// ```swift
/// enum MyOption: String, ARCMenuPickerItem {
///     case a, b, c
///     var title: LocalizedStringKey { LocalizedStringKey(rawValue) }
///     var icon: String { "star" }
/// }
/// ```
public protocol ARCMenuPickerItem: CaseIterable, Identifiable, Hashable, Sendable
where AllCases: RandomAccessCollection {
    /// Localized display title — the consuming app's String Catalog provides translations
    var title: LocalizedStringKey { get }
    /// SF Symbol name for the row icon
    var icon: String { get }
}
