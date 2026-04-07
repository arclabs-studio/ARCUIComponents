//
//  ARCMenuPickerView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 08/04/2026.
//

import SwiftUI

// MARK: - ARCMenuPickerView

/// Generic settings picker screen with icon + title rows and checkmark selection
///
/// Displays all cases of any ``ARCMenuPickerItem`` conforming type in a `Form`.
/// This is a **leaf view** — it has no `NavigationStack` and does not know
/// where it's presented from. The app provides navigation context.
///
/// Uses a **deferred commit pattern**: a local `pendingSelection` state tracks
/// the user's in-progress choice without triggering `@Observable` side effects
/// on the host (e.g. `AppearanceManager`, `LanguageManager`) that could
/// invalidate the `NavigationStack` and dismiss the view mid-interaction.
///
/// Commit strategy:
/// - When `onDone` is provided: selection is committed and `onDone` is called
///   when the user taps the Done toolbar button. Navigating back without
///   tapping Done discards the pending change.
/// - When `onDone` is `nil`: selection is committed on `.onDisappear`
///   (backward-compatible fallback for consumers that don't provide a done action).
///
/// The navigation title and Done button label use `LocalizedStringKey`,
/// so the consuming app's String Catalog provides translations.
///
/// Usage:
/// ```swift
/// // Theme picker with Done button that dismisses the sheet
/// NavigationStack {
///     ARCMenuPickerView(selection: $appearanceManager.mode,
///                       navigationTitle: "Theme",
///                       onDone: { dismiss() })
/// }
///
/// // Simple picker without Done button (commits on back navigation)
/// NavigationStack {
///     ARCMenuPickerView(selection: $viewModel.option,
///                       navigationTitle: "Option")
/// }
/// ```
public struct ARCMenuPickerView<Item: ARCMenuPickerItem>: View {
    // MARK: Public Properties

    @Binding public var selection: Item

    // MARK: Private Properties

    /// Local selection state — only committed to the binding when Done is tapped
    /// (or on disappear when `onDone` is nil).
    ///
    /// Prevents `@Observable` side effects from invalidating the NavigationStack
    /// while the user is still interacting with the picker.
    @State private var pendingSelection: Item
    private let navigationTitleKey: LocalizedStringKey
    private let onDone: (() -> Void)?

    // MARK: Lifecycle

    public init(selection: Binding<Item>,
                navigationTitle: LocalizedStringKey,
                onDone: (() -> Void)? = nil) {
        _selection = selection
        _pendingSelection = State(initialValue: selection.wrappedValue)
        navigationTitleKey = navigationTitle
        self.onDone = onDone
    }

    // MARK: View

    public var body: some View {
        Form {
            Section {
                ForEach(Item.allCases, id: \.id) { item in
                    Button {
                        pendingSelection = item
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: item.icon)
                                .font(.body)
                                .foregroundStyle(pendingSelection == item ? Color.accentColor : .secondary)
                                .frame(width: 24)

                            Text(item.title)
                                .foregroundStyle(.primary)

                            Spacer()

                            if pendingSelection == item {
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
                        selection = pendingSelection
                        onDone()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onDisappear {
            if onDone == nil {
                selection = pendingSelection
            }
        }
    }
}

// MARK: - Previews

#Preview("Picker - Dark") {
    NavigationStack {
        ARCMenuPickerView(selection: .constant(ARCAppearanceMode.system),
                          navigationTitle: "Theme",
                          onDone: {})
    }
    .preferredColorScheme(.dark)
}

#Preview("Picker - Light") {
    NavigationStack {
        ARCMenuPickerView(selection: .constant(ARCAppearanceMode.light),
                          navigationTitle: "Theme",
                          onDone: {})
    }
    .preferredColorScheme(.light)
}
