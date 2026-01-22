//
//  ARCToastShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCToastShowcase

/// A comprehensive showcase of all ARCToast components and configurations
///
/// Use this view to preview all toast variants and test different configurations
/// in both light and dark modes.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCToastShowcase: View {
    // MARK: - State

    @State private var selectedSection: ShowcaseSection = .types
    @State private var selectedType: ARCToastType = .success
    @State private var selectedPosition: ARCToastConfiguration.Position = .bottom
    @State private var showIcon = true
    @State private var showAction = false

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .arcSpacingXLarge) {
                    sectionPicker

                    switch selectedSection {
                    case .types:
                        typesSection
                    case .configurations:
                        configurationsSection
                    case .interactive:
                        interactiveSection
                    case .realWorld:
                        realWorldSection
                    }
                }
                .padding()
            }
            .navigationTitle("ARCToast")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
                .arcToastContainer()
        }
    }

    // MARK: - Section Picker

    @ViewBuilder private var sectionPicker: some View {
        Picker("Section", selection: $selectedSection) {
            ForEach(ShowcaseSection.allCases, id: \.self) { section in
                Text(section.rawValue).tag(section)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Types Section

    @ViewBuilder private var typesSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Toast Types")

            VStack(spacing: .arcSpacingMedium) {
                typeButton("Success", type: .success, message: "Changes saved successfully")
                typeButton("Error", type: .error, message: "Failed to save changes")
                typeButton("Warning", type: .warning, message: "Low storage space")
                typeButton("Info", type: .info, message: "New update available")
                typeButton(
                    "Custom",
                    type: .custom(icon: "bell.fill", color: .purple),
                    message: "You have a new notification"
                )
            }

            Divider()

            sectionHeader("Static Preview")

            VStack(spacing: .arcSpacingMedium) {
                ARCToast(message: "Success toast", type: .success)
                ARCToast(message: "Error toast", type: .error)
                ARCToast(message: "Warning toast", type: .warning)
                ARCToast(message: "Info toast", type: .info)
            }
        }
    }

    // MARK: - Configurations Section

    @ViewBuilder private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Presets")

            VStack(spacing: .arcSpacingMedium) {
                configButton("Default", config: .default)
                configButton("Minimal", config: .minimal)
                configButton("Prominent", config: .prominent)
                configButton("Top Position", config: .top)
                configButton("Persistent", config: .persistent)
            }

            Divider()

            sectionHeader("With Actions")

            VStack(spacing: .arcSpacingMedium) {
                actionButton("Undo Action", action: .undo {})
                actionButton("Retry Action", action: .retry {})
                actionButton("View Action", action: .view {})
                actionButton("Dismiss Action", action: .dismiss())
            }

            Divider()

            sectionHeader("Static with Actions")

            VStack(spacing: .arcSpacingMedium) {
                ARCToast(
                    message: "Item deleted",
                    type: .info,
                    action: .undo {}
                )

                ARCToast(
                    message: "Network error",
                    type: .error,
                    action: .retry {}
                )
            }
        }
    }

    // MARK: - Interactive Section

    @ViewBuilder private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Build Your Toast")

            // Type picker
            VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                Text("Type")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("Type", selection: $selectedType) {
                    Text("Success").tag(ARCToastType.success)
                    Text("Error").tag(ARCToastType.error)
                    Text("Warning").tag(ARCToastType.warning)
                    Text("Info").tag(ARCToastType.info)
                }
                .pickerStyle(.segmented)
            }

            // Position picker
            VStack(alignment: .leading, spacing: .arcSpacingSmall) {
                Text("Position")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("Position", selection: $selectedPosition) {
                    Text("Top").tag(ARCToastConfiguration.Position.top)
                    Text("Bottom").tag(ARCToastConfiguration.Position.bottom)
                }
                .pickerStyle(.segmented)
            }

            // Options
            Toggle("Show Icon", isOn: $showIcon)
            Toggle("Include Action", isOn: $showAction)

            // Preview button
            Button {
                let config = ARCToastConfiguration(
                    position: selectedPosition,
                    showIcon: showIcon
                )
                ARCToastManager.shared.show(
                    "Custom configured toast",
                    type: selectedType,
                    action: showAction ? .dismiss() : nil,
                    configuration: config
                )
            } label: {
                Text("Show Toast")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Divider()

            sectionHeader("Live Preview")

            ARCToast(
                message: "Preview toast message",
                type: selectedType,
                action: showAction ? .dismiss() : nil,
                configuration: ARCToastConfiguration(
                    position: selectedPosition,
                    showIcon: showIcon
                )
            )
        }
    }

    // MARK: - Real World Section

    @ViewBuilder private var realWorldSection: some View {
        VStack(alignment: .leading, spacing: .arcSpacingLarge) {
            sectionHeader("Common Scenarios")

            VStack(spacing: .arcSpacingMedium) {
                scenarioButton(
                    "Save Success",
                    icon: "square.and.arrow.down",
                    description: "User saves a document"
                ) {
                    ARCToastManager.shared.showSuccess("Document saved")
                }

                scenarioButton(
                    "Delete with Undo",
                    icon: "trash",
                    description: "User deletes an item"
                ) {
                    ARCToastManager.shared.show(
                        "Item moved to trash",
                        type: .info,
                        action: .undo {}
                    )
                }

                scenarioButton(
                    "Network Error",
                    icon: "wifi.slash",
                    description: "API request fails"
                ) {
                    ARCToastManager.shared.showError(
                        "Connection failed",
                        action: .retry {}
                    )
                }

                scenarioButton(
                    "Upload Complete",
                    icon: "arrow.up.circle",
                    description: "File upload finishes"
                ) {
                    ARCToastManager.shared.showSuccess(
                        "Photo uploaded",
                        action: .view {}
                    )
                }

                scenarioButton(
                    "Low Storage",
                    icon: "externaldrive.badge.exclamationmark",
                    description: "Device running low on space"
                ) {
                    ARCToastManager.shared.showWarning("Storage almost full")
                }
            }

            Divider()

            sectionHeader("Queue Demo")

            Button {
                ARCToastManager.shared.show("Processing step 1...", type: .info)
                ARCToastManager.shared.show("Processing step 2...", type: .info)
                ARCToastManager.shared.show("Processing step 3...", type: .info)
                ARCToastManager.shared.showSuccess("All steps complete!")
            } label: {
                HStack {
                    Image(systemName: "list.number")
                    Text("Show Queued Toasts")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Showcase Section

@available(iOS 17.0, macOS 14.0, *)
extension ARCToastShowcase {
    enum ShowcaseSection: String, CaseIterable {
        case types = "Types"
        case configurations = "Config"
        case interactive = "Builder"
        case realWorld = "Scenarios"
    }
}

// MARK: - Helper Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCToastShowcase {
    @ViewBuilder
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    func typeButton(_ title: String, type: ARCToastType, message: String) -> some View {
        Button {
            ARCToastManager.shared.show(message, type: type)
        } label: {
            HStack {
                Image(systemName: type.icon)
                    .foregroundStyle(type.color)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func configButton(_ title: String, config: ARCToastConfiguration) -> some View {
        Button {
            ARCToastManager.shared.show("This is a \(title.lowercased()) toast", configuration: config)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func actionButton(_ title: String, action: ARCToastAction) -> some View {
        Button {
            ARCToastManager.shared.show(
                "Toast with \(action.title) action",
                type: .info,
                action: action
            )
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(action.title)
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func scenarioButton(
        _ title: String,
        icon: String,
        description: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: .arcSpacingMedium) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "play.circle")
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase") {
    ARCToastShowcase()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase - Dark") {
    ARCToastShowcase()
        .preferredColorScheme(.dark)
}
