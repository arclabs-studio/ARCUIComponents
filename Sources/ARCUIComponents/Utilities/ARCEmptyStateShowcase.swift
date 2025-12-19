//
//  ARCEmptyStateShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import SwiftUI

/// Showcase demonstrating ARCEmptyState in various configurations
///
/// This view provides a visual gallery of empty state components,
/// demonstrating all preset configurations and custom variations.
///
/// Use this showcase to:
/// - Preview empty states in different contexts
/// - Test visual appearance in Light and Dark modes
/// - Compare different icon, color, and message combinations
/// - Verify accessibility and Dynamic Type support
@available(iOS 17.0, *)
public struct ARCEmptyStateShowcase: View {
    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .presets
    @State private var showAlert = false
    @State private var alertMessage = ""

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // Tabs
                    Picker("Showcase Tab", selection: $selectedTab) {
                        ForEach(ShowcaseTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top)

                    // Content
                    Group {
                        switch selectedTab {
                        case .presets:
                            presetsContent
                        case .custom:
                            customContent
                        case .contexts:
                            contextsContent
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Empty States")
            .navigationBarTitleDisplayMode(.large)
            .alert("Action Triggered", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Presets Content

    private var presetsContent: some View {
        VStack(spacing: 60) {
            SectionHeader(
                title: "Presets",
                subtitle: "Ready-to-use configurations"
            )
            .padding(.horizontal)

            // No Results
            PresetExample(
                title: "No Results",
                description: "For empty search results"
            ) {
                ARCEmptyState(configuration: .noResults)
            }

            Divider()
                .padding(.horizontal)

            // No Favorites
            PresetExample(
                title: "No Favorites",
                description: "For empty favorites list"
            ) {
                ARCEmptyState(configuration: .noFavorites) {
                    triggerAction("Browse action")
                }
            }

            Divider()
                .padding(.horizontal)

            // No Data
            PresetExample(
                title: "No Data",
                description: "For empty content"
            ) {
                ARCEmptyState(configuration: .noData)
            }

            Divider()
                .padding(.horizontal)

            // Error
            PresetExample(
                title: "Error",
                description: "For failed operations"
            ) {
                ARCEmptyState(configuration: .error) {
                    triggerAction("Retry action")
                }
            }

            Divider()
                .padding(.horizontal)

            // Offline
            PresetExample(
                title: "Offline",
                description: "For no network connection"
            ) {
                ARCEmptyState(configuration: .offline) {
                    triggerAction("Open Settings")
                }
            }
        }
    }

    // MARK: - Custom Content

    private var customContent: some View {
        VStack(spacing: 60) {
            SectionHeader(
                title: "Custom Configurations",
                subtitle: "Custom icons, colors, and messages"
            )
            .padding(.horizontal)

            // Custom 1: Photos
            PresetExample(
                title: "No Photos",
                description: "Custom photo empty state"
            ) {
                ARCEmptyState(
                    icon: "photo.on.rectangle",
                    iconColor: .blue,
                    title: "No Photos",
                    message: "Take a photo or choose from your library to get started.",
                    actionTitle: "Add Photo",
                    showsAction: true,
                    accentColor: .blue
                ) {
                    triggerAction("Add Photo")
                }
            }

            Divider()
                .padding(.horizontal)

            // Custom 2: Messages
            PresetExample(
                title: "No Messages",
                description: "Custom messaging empty state"
            ) {
                ARCEmptyState(
                    icon: "message",
                    iconColor: .green,
                    title: "No Messages",
                    message: "Start a conversation to see your messages here.",
                    actionTitle: "New Message",
                    showsAction: true,
                    accentColor: .green
                ) {
                    triggerAction("New Message")
                }
            }

            Divider()
                .padding(.horizontal)

            // Custom 3: Calendar
            PresetExample(
                title: "No Events",
                description: "Custom calendar empty state"
            ) {
                ARCEmptyState(
                    icon: "calendar",
                    iconColor: .red,
                    title: "No Events Today",
                    message: "You have no scheduled events. Enjoy your free time!",
                    actionTitle: "Add Event",
                    showsAction: true,
                    accentColor: .red
                ) {
                    triggerAction("Add Event")
                }
            }

            Divider()
                .padding(.horizontal)

            // Custom 4: Notes
            PresetExample(
                title: "No Notes",
                description: "Custom notes empty state"
            ) {
                ARCEmptyState(
                    icon: "note.text",
                    iconColor: .orange,
                    title: "No Notes",
                    message: "Create your first note to capture your thoughts and ideas.",
                    actionTitle: "New Note",
                    showsAction: true,
                    accentColor: .orange
                ) {
                    triggerAction("New Note")
                }
            }
        }
    }

    // MARK: - Contexts Content

    private var contextsContent: some View {
        VStack(spacing: 60) {
            SectionHeader(
                title: "In Context",
                subtitle: "Empty states in realistic layouts"
            )
            .padding(.horizontal)

            // List Context
            ContextExample(
                title: "In a List",
                description: "Empty state within a list view"
            ) {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Favorites")
                            .font(.largeTitle.bold())
                        Spacer()
                    }
                    .padding()

                    // Empty State
                    Spacer()
                    ARCEmptyState(configuration: .noFavorites) {
                        triggerAction("Browse")
                    }
                    Spacer()
                }
                .frame(height: 400)
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            // Search Context
            ContextExample(
                title: "In Search",
                description: "Empty search results"
            ) {
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        Text("Search for items...")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding()
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()

                    // Empty State
                    Spacer()
                    ARCEmptyState(configuration: .noResults)
                    Spacer()
                }
                .frame(height: 400)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Helper Methods

    private func triggerAction(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}

// MARK: - Supporting Views

@available(iOS 17.0, *)
private struct PresetExample<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            content()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
        }
    }
}

@available(iOS 17.0, *)
private struct ContextExample<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            content()
                .padding(.horizontal)
        }
    }
}

@available(iOS 17.0, *)
private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Showcase Tab

@available(iOS 17.0, *)
private enum ShowcaseTab: String, CaseIterable {
    case presets = "Presets"
    case custom = "Custom"
    case contexts = "Contexts"
}

// MARK: - Preview

#Preview("Showcase - Light") {
    ARCEmptyStateShowcase()
        .preferredColorScheme(.light)
}

#Preview("Showcase - Dark") {
    ARCEmptyStateShowcase()
        .preferredColorScheme(.dark)
}

#Preview("Showcase - Accessibility") {
    ARCEmptyStateShowcase()
        .environment(\.dynamicTypeSize, .accessibility2)
}
