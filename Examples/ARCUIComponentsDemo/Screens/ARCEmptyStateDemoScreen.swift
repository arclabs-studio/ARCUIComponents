//
//  ARCEmptyStateDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCEmptyState component.
///
/// Shows empty state configurations for common scenarios.
@available(iOS 17.0, *)
struct ARCEmptyStateDemoScreen: View {

    // MARK: Properties

    @State private var selectedPreset: EmptyStatePreset = .noFavorites
    @State private var showAlert = false

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                presetSelector
                previewSection
                presetsGallery
            }
            .padding()
        }
        .navigationTitle("ARCEmptyState")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .alert("Action Triggered", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("The empty state action was tapped.")
            }
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
private extension ARCEmptyStateDemoScreen {

    var presetSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Preset")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            Picker("Preset", selection: $selectedPreset) {
                ForEach(EmptyStatePreset.allCases) { preset in
                    Text(preset.name).tag(preset)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            VStack {
                Spacer()

                ARCEmptyState(configuration: selectedPreset.configuration) {
                    showAlert = true
                }

                Spacer()
            }
            .frame(height: 350)
            .frame(maxWidth: .infinity)
            .background(Color.arcBrandBlack.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    var presetsGallery: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Presets")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(EmptyStatePreset.allCases) { preset in
                    VStack {
                        Image(systemName: preset.configuration.icon)
                            .font(.title)
                            .foregroundStyle(preset.configuration.iconColor)

                        Text(preset.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedPreset == preset ? Color.arcBrandGold.opacity(0.2) : Color.arcBrandBlack.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        selectedPreset == preset ? Color.arcBrandBurgundy : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                    )
                    .onTapGesture {
                        selectedPreset = preset
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Types

@available(iOS 17.0, *)
private enum EmptyStatePreset: String, CaseIterable, Identifiable {
    case noFavorites
    case noResults
    case noData
    case error
    case offline

    var id: String { rawValue }

    var name: String {
        switch self {
        case .noFavorites: "No Favorites"
        case .noResults: "No Results"
        case .noData: "No Data"
        case .error: "Error"
        case .offline: "Offline"
        }
    }

    var configuration: ARCEmptyStateConfiguration {
        switch self {
        case .noFavorites: .noFavorites
        case .noResults: .noResults
        case .noData: .noData
        case .error: .error
        case .offline: .offline
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCEmptyStateDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCEmptyStateDemoScreen()
    }
    .preferredColorScheme(.dark)
}
