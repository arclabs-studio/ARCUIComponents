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

    /// Local selection state — only committed to the binding when Done is tapped.
    ///
    /// Writing directly to the `@Binding` on each tap triggers `@Observable`
    /// side effects in the host (e.g. `LanguageManager`), which can invalidate
    /// the NavigationStack and pop this view. Using local `@State` avoids that.
    @State private var pendingSelection: ARCAppLanguage
    private let navigationTitleKey: LocalizedStringKey
    private let onDone: (() -> Void)?

    // MARK: Lifecycle

    public init(selectedLanguage: Binding<ARCAppLanguage>,
                navigationTitle: LocalizedStringKey = "Language",
                onDone: (() -> Void)? = nil) {
        _selectedLanguage = selectedLanguage
        _pendingSelection = State(initialValue: selectedLanguage.wrappedValue)
        navigationTitleKey = navigationTitle
        self.onDone = onDone
    }

    // MARK: View

    public var body: some View {
        Form {
            Section {
                ForEach(ARCAppLanguage.allCases) { language in
                    Button {
                        pendingSelection = language
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: language.icon)
                                .font(.body)
                                .foregroundStyle(pendingSelection == language ? Color.accentColor : .secondary)
                                .frame(width: 24)

                            Text(language.title)
                                .foregroundStyle(.primary)

                            Spacer()

                            if pendingSelection == language {
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
                        selectedLanguage = pendingSelection
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
