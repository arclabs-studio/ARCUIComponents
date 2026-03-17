//
//  ARCToastDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCToast component.
///
/// Shows toast notifications with various types, configurations, and actions.
/// Demonstrates both binding-based and manager-based toast presentation.
@available(iOS 17.0, *)
struct ARCToastDemoScreen: View {
    // MARK: - State

    @State private var showBindingToast = false
    @State private var selectedType: ARCToastType = .success
    @State private var selectedPosition: ARCToastConfiguration.Position = .bottom
    @State private var showIcon = true
    @State private var includeAction = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                managerBasedSection
                typesSection
                configurationsSection
                actionsSection
                bindingBasedSection
                interactiveBuilderSection
            }
            .padding()
        }
        .navigationTitle("ARCToast")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .arcToastContainer()
            .arcToast(
                isPresented: $showBindingToast,
                message: "Binding-controlled toast",
                type: selectedType,
                action: includeAction ? .dismiss() : nil,
                configuration: ARCToastConfiguration(
                    position: selectedPosition,
                    showIcon: showIcon
                )
            )
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCToastDemoScreen {
    // MARK: - Manager Based Section

    private var managerBasedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Quick Actions", subtitle: "Using ARCToastManager.shared")

            HStack(spacing: 12) {
                quickActionButton("Success", color: .green) {
                    ARCToastManager.shared.showSuccess("Operation completed!")
                }

                quickActionButton("Error", color: .red) {
                    ARCToastManager.shared.showError("Something went wrong")
                }

                quickActionButton("Warning", color: .orange) {
                    ARCToastManager.shared.showWarning("Please review")
                }

                quickActionButton("Info", color: .blue) {
                    ARCToastManager.shared.showInfo("New update available")
                }
            }
        }
    }

    private func quickActionButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(color, in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Types Section

    private var typesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Toast Types", subtitle: "Visual styles for different scenarios")

            VStack(spacing: 12) {
                typeRow("Success", icon: "checkmark.circle.fill", color: .green, type: .success)
                typeRow("Error", icon: "xmark.circle.fill", color: .red, type: .error)
                typeRow("Warning", icon: "exclamationmark.triangle.fill", color: .orange, type: .warning)
                typeRow("Info", icon: "info.circle.fill", color: .blue, type: .info)
                typeRow(
                    "Custom",
                    icon: "bell.fill",
                    color: .purple,
                    type: .custom(icon: "bell.fill", color: .purple)
                )
            }
        }
    }

    private func typeRow(_ title: String, icon: String, color: Color, type: ARCToastType) -> some View {
        Button {
            ARCToastManager.shared.show("This is a \(title.lowercased()) toast", type: type)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                    .frame(width: 32)

                Text(title)
                    .font(.body)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Configurations Section

    private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Configuration Presets", subtitle: "Pre-built configurations")

            VStack(spacing: 12) {
                configRow("Default", description: "Standard bottom toast", config: .default)
                configRow("Minimal", description: "No icon, short duration", config: .minimal)
                configRow("Prominent", description: "Top position, liquid glass", config: .prominent)
                configRow("Persistent", description: "Won't auto-dismiss", config: .persistent)
                configRow("Top", description: "Top position toast", config: .top)
            }
        }
    }

    private func configRow(_ title: String, description: String, config: ARCToastConfiguration) -> some View {
        Button {
            ARCToastManager.shared.show("This is a \(title.lowercased()) configuration", configuration: config)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Toast Actions", subtitle: "Interactive buttons on toasts")

            VStack(spacing: 12) {
                actionRow("Undo", description: "Reversible action") {
                    ARCToastManager.shared.show(
                        "Item deleted",
                        type: .info,
                        action: .undo { print("Undo tapped") }
                    )
                }

                actionRow("Retry", description: "Try again on failure") {
                    ARCToastManager.shared.showError(
                        "Upload failed",
                        action: .retry { print("Retry tapped") }
                    )
                }

                actionRow("View", description: "Navigate to content") {
                    ARCToastManager.shared.showSuccess(
                        "Photo uploaded",
                        action: .view { print("View tapped") }
                    )
                }

                actionRow("Dismiss", description: "Manual dismissal") {
                    ARCToastManager.shared.show(
                        "Persistent toast",
                        type: .info,
                        action: .dismiss(),
                        configuration: .persistent
                    )
                }
            }
        }
    }

    private func actionRow(_ title: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1), in: Capsule())
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Binding Based Section

    private var bindingBasedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Binding-Based Toast", subtitle: "Control with @State binding")

            Button {
                showBindingToast = true
            } label: {
                HStack {
                    Image(systemName: "link")
                        .foregroundStyle(.blue)
                    Text("Show Binding Toast")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Interactive Builder Section

    private var interactiveBuilderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Toast Builder", subtitle: "Customize and preview")

            // Type picker
            VStack(alignment: .leading, spacing: 8) {
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
            VStack(alignment: .leading, spacing: 8) {
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
            Toggle("Include Action", isOn: $includeAction)

            // Preview button
            Button {
                let config = ARCToastConfiguration(
                    position: selectedPosition,
                    showIcon: showIcon
                )
                ARCToastManager.shared.show(
                    "Custom configured toast",
                    type: selectedType,
                    action: includeAction ? .dismiss() : nil,
                    configuration: config
                )
            } label: {
                Text("Show Custom Toast")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.arcBrandBurgundy, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            // Queue demo
            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Queue Demo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

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
                    .padding()
                    .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCToastDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCToastDemoScreen()
    }
    .preferredColorScheme(.dark)
}
