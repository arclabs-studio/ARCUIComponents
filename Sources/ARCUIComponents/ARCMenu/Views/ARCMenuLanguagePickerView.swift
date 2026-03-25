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
/// Displays all ``ARCAppLanguage`` cases (System, Spanish, English) in a Form.
/// This is a **leaf view** — it has no NavigationStack and does not know
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
    private let onDone: (() -> Void)?

    // MARK: Lifecycle

    public init(selectedLanguage: Binding<ARCAppLanguage>,
                navigationTitle: LocalizedStringKey = "Language",
                onDone: (() -> Void)? = nil) {
        _selectedLanguage = selectedLanguage
        navigationTitleKey = navigationTitle
        self.onDone = onDone
    }

    // MARK: View

    public var body: some View {
        Form {
            Section {
                ForEach(ARCAppLanguage.allCases) { language in
                    Button {
                        selectedLanguage = language
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: language.icon)
                                .font(.body)
                                .foregroundStyle(selectedLanguage == language ? Color.accentColor : .secondary)
                                .frame(width: 24)

                            Text(language.title)
                                .foregroundStyle(.primary)

                            Spacer()

                            if selectedLanguage == language {
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
        .toolbar {
            if let onDone {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
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
