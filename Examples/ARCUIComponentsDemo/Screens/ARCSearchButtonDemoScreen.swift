//
//  ARCSearchButtonDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCSearchButton component.
///
/// Shows search buttons in various styles and contexts.
struct ARCSearchButtonDemoScreen: View {
    // MARK: Properties

    @State private var showSearchSheet = false

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Styles Section
                stylesSection

                // Sizes Section
                sizesSection

                // In Toolbar
                toolbarSection

                // In Context
                contextSection
            }
            .padding()
        }
        .navigationTitle("ARCSearchButton")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .sheet(isPresented: $showSearchSheet) {
                SearchSheetView()
            }
    }

    // MARK: Sections

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Styles")
                .font(.headline)

            HStack(spacing: 24) {
                VStack {
                    ARCSearchButton(configuration: .default) {
                        showSearchSheet = true
                    }
                    Text("Default")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    ARCSearchButton(configuration: .prominent) {
                        showSearchSheet = true
                    }
                    Text("Prominent")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    ARCSearchButton(configuration: .minimal) {
                        showSearchSheet = true
                    }
                    Text("Minimal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sizes")
                .font(.headline)

            HStack(spacing: 24) {
                VStack {
                    ARCSearchButton(
                        configuration: .init(size: .small)
                    ) {}
                    Text("Small")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    ARCSearchButton(
                        configuration: .init(size: .medium)
                    ) {}
                    Text("Medium")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    ARCSearchButton(
                        configuration: .init(size: .large)
                    ) {}
                    Text("Large")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var toolbarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Toolbar")
                .font(.headline)

            Text("The search button is commonly placed in the navigation bar toolbar.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Visual representation
            HStack {
                Text("Title")
                    .font(.headline)

                Spacer()

                ARCSearchButton {}
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Context")
                .font(.headline)

            // Simulated search bar alternative
            Button {
                showSearchSheet = true
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    Text("Search...")
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            Text("Tap the field above to open search")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - Search Sheet

private struct SearchSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Search",
                        systemImage: "magnifyingglass",
                        description: Text("Enter a search term")
                    )
                } else {
                    List(1 ... 5, id: \.self) { index in
                        Text("Result \(index) for \"\(searchText)\"")
                    }
                }

                Spacer()
            }
            .navigationTitle("Search")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        ARCSearchButtonDemoScreen()
    }
}
