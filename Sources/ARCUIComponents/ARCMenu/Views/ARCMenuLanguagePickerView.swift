//
//  ARCMenuLanguagePickerView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 26/02/2026.
//

import SwiftUI

// MARK: - ARCMenuLanguagePickerView

/// Standalone language picker screen with checkmark selection
///
/// A thin wrapper around ``ARCMenuPickerView`` specialised for ``ARCAppLanguage``.
/// Provides a default navigation title ("Language") and forwards all behaviour to
/// the generic picker, including the deferred commit pattern and optional Done button.
///
/// This is a **leaf view** — it has no `NavigationStack` and does not know
/// where it's presented from. The app provides navigation context.
///
/// The navigation title and Done button label use `LocalizedStringKey`,
/// so the consuming app's String Catalog provides translations.
///
/// Usage:
/// ```swift
/// NavigationStack {
///     ARCMenuLanguagePickerView(
///         selectedLanguage: $viewModel.selectedLanguage,
///         onDone: { dismiss() }
///     )
/// }
/// ```
public struct ARCMenuLanguagePickerView: View {
    // MARK: Public Properties

    @Binding public var selectedLanguage: ARCAppLanguage

    // MARK: Private Properties

    private let navigationTitleKey: LocalizedStringKey
    private let appliesImmediately: Bool
    private let onDone: (() -> Void)?

    // MARK: Lifecycle

    public init(selectedLanguage: Binding<ARCAppLanguage>,
                navigationTitle: LocalizedStringKey = "Language",
                appliesImmediately: Bool = false,
                onDone: (() -> Void)? = nil) {
        _selectedLanguage = selectedLanguage
        navigationTitleKey = navigationTitle
        self.appliesImmediately = appliesImmediately
        self.onDone = onDone
    }

    // MARK: View

    public var body: some View {
        ARCMenuPickerView(selection: $selectedLanguage,
                          navigationTitle: navigationTitleKey,
                          appliesImmediately: appliesImmediately,
                          onDone: onDone)
    }
}

// MARK: - Previews

#Preview("Language Picker - Dark") {
    NavigationStack {
        ARCMenuLanguagePickerView(selectedLanguage: .constant(.system))
    }
    .preferredColorScheme(.dark)
}

#Preview("Language Picker - Light") {
    NavigationStack {
        ARCMenuLanguagePickerView(selectedLanguage: .constant(.spanish))
    }
    .preferredColorScheme(.light)
}
