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
/// - When `appliesImmediately` is `true`: each tap writes through to the binding
///   immediately (the caller sees the change live). Done just calls `onDone()`.
/// - When `appliesImmediately` is `false` (default, deferred): selection is held
///   in a local `pendingSelection` state and committed when Done is tapped
///   (`onDone` provided) or on `.onDisappear` (fallback when `onDone` is `nil`).
///   Navigating back without tapping Done discards the pending change.
///
/// The navigation title and Done button label use `LocalizedStringKey`,
/// so the consuming app's String Catalog provides translations.
///
/// Usage:
/// ```swift
/// // Instant apply — change is visible live, Done just dismisses
/// NavigationStack {
///     ARCMenuPickerView(selection: $appearanceManager.mode,
///                       navigationTitle: "Theme",
///                       appliesImmediately: true,
///                       onDone: { dismiss() })
/// }
///
/// // Deferred apply — committed on Done tap (default)
/// NavigationStack {
///     ARCMenuPickerView(selection: $viewModel.option,
///                       navigationTitle: "Option",
///                       onDone: { dismiss() })
/// }
/// ```
public struct ARCMenuPickerView<Item: ARCMenuPickerItem>: View {
    // MARK: Public Properties

    @Binding public var selection: Item

    // MARK: Private Properties

    /// Local selection state — mirrors `selection` for the deferred commit path.
    ///
    /// When `appliesImmediately` is `false` this is the only value that changes
    /// during interaction, preventing `@Observable` side effects from invalidating
    /// the NavigationStack. When `appliesImmediately` is `true` it stays in sync
    /// with `selection` and is used only to drive the checkmark highlight.
    @State private var pendingSelection: Item
    private let navigationTitleKey: LocalizedStringKey
    private let appliesImmediately: Bool
    private let onDone: (() -> Void)?

    // MARK: Lifecycle

    public init(selection: Binding<Item>,
                navigationTitle: LocalizedStringKey,
                appliesImmediately: Bool = false,
                onDone: (() -> Void)? = nil) {
        _selection = selection
        _pendingSelection = State(initialValue: selection.wrappedValue)
        navigationTitleKey = navigationTitle
        self.appliesImmediately = appliesImmediately
        self.onDone = onDone
    }

    // MARK: View

    public var body: some View {
        Form {
            Section {
                ForEach(Item.allCases, id: \.id) { item in
                    Button {
                        pendingSelection = item
                        if appliesImmediately {
                            selection = item
                        }
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
                        if !appliesImmediately {
                            selection = pendingSelection
                        }
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
