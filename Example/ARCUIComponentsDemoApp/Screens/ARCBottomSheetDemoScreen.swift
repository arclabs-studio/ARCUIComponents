//
//  ARCBottomSheetDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCBottomSheet component.
///
/// Shows bottom sheets with various configurations, detent options,
/// and interaction patterns. Demonstrates modal and persistent sheet styles.
@available(iOS 17.0, *)
struct ARCBottomSheetDemoScreen: View {
    // MARK: - State

    @State private var showModalSheet = false
    @State private var showPersistentDemo = false
    @State private var currentDetent: ARCBottomSheetDetent = .medium
    @State private var selectedConfig: ConfigPreset = .default

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                quickActionsSection
                configurationPresetsSection
                detentTypesSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("ARCBottomSheet")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .arcBottomSheet(
                isPresented: $showModalSheet,
                detents: selectedConfig.detents,
                selectedDetent: $currentDetent,
                configuration: selectedConfig.configuration,
                onDismiss: {
                    print("Sheet dismissed")
                }
            ) {
                modalSheetContent
            }
            .fullScreenCover(isPresented: $showPersistentDemo) {
                persistentDemoView
            }
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCBottomSheetDemoScreen {
    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Quick Demo", subtitle: "Tap to see sheets in action")

            Button {
                selectedConfig = .default
                currentDetent = .medium
                showModalSheet = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Launch Modal Sheet")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Dismissable sheet with dimmed background")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.arcBrandBurgundy, Color.arcBrandBurgundy.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 16)
                )
            }
            .buttonStyle(.plain)

            Button {
                showPersistentDemo = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Maps-Style Drawer")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Persistent sheet that can't be dismissed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "map.fill")
                        .font(.title2)
                        .foregroundStyle(Color.arcBrandBurgundy)
                }
                .padding()
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Configuration Presets Section

    private var configurationPresetsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Configuration Presets", subtitle: "Pre-built sheet styles")

            VStack(spacing: 12) {
                presetRow(
                    title: "Default",
                    description: "Balanced settings, dismissable with dimming",
                    icon: "slider.horizontal.3",
                    color: .blue,
                    preset: .default
                )

                presetRow(
                    title: "Modal",
                    description: "Strong dimming, tap to dismiss",
                    icon: "rectangle.portrait.on.rectangle.portrait",
                    color: .purple,
                    preset: .modal
                )

                presetRow(
                    title: "Glass",
                    description: "Premium liquid glass effect",
                    icon: "sparkles",
                    color: .pink,
                    preset: .glass
                )

                presetRow(
                    title: "Compact",
                    description: "Smaller handle, lighter styling",
                    icon: "rectangle.compress.vertical",
                    color: .gray,
                    preset: .compact
                )
            }
        }
    }

    private func presetRow(
        title: String,
        description: String,
        icon: String,
        color: Color,
        preset: ConfigPreset
    ) -> some View {
        Button {
            selectedConfig = preset
            currentDetent = .medium
            showModalSheet = true
        } label: {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.gradient)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                    )

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

    // MARK: - Detent Types Section

    private var detentTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Detent Types", subtitle: "Different sheet heights")

            VStack(spacing: 12) {
                detentRow(
                    title: "Small",
                    description: "~15% or 120pt minimum",
                    detent: .small
                )

                detentRow(
                    title: "Medium",
                    description: "50% of screen height",
                    detent: .medium
                )

                detentRow(
                    title: "Large",
                    description: "90% of screen height",
                    detent: .large
                )

                detentRow(
                    title: "Custom (200pt)",
                    description: "Fixed height in points",
                    detent: .height(200)
                )

                detentRow(
                    title: "Custom (70%)",
                    description: "Fraction of container",
                    detent: .fraction(0.7)
                )
            }
        }
    }

    private func detentRow(
        title: String,
        description: String,
        detent: ARCBottomSheetDetent
    ) -> some View {
        Button {
            selectedConfig = .default
            currentDetent = detent
            showModalSheet = true
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

                detentPreview(detent)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func detentPreview(_ detent: ARCBottomSheetDetent) -> some View {
        let fraction: CGFloat = {
            switch detent {
            case .small: return 0.15
            case .medium: return 0.5
            case .large: return 0.9
            case .fraction(let f): return f
            case .height: return 0.3
            }
        }()

        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                .frame(width: 24, height: 40)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.arcBrandBurgundy.opacity(0.4))
                .frame(width: 24, height: 40 * fraction)
        }
    }

    // MARK: - Interactive Section

    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Features", subtitle: "Key capabilities")

            VStack(spacing: 12) {
                featureRow(
                    icon: "hand.draw",
                    title: "Drag Gestures",
                    description: "Smooth dragging between detents"
                )

                featureRow(
                    icon: "gauge.with.dots.needle.67percent",
                    title: "Velocity Snapping",
                    description: "Fast drags snap to next detent"
                )

                featureRow(
                    icon: "hand.tap",
                    title: "Handle Tap",
                    description: "Tap grabber to cycle through detents"
                )

                featureRow(
                    icon: "sparkles.rectangle.stack",
                    title: "Liquid Glass",
                    description: "Premium glass effect styling"
                )

                featureRow(
                    icon: "accessibility",
                    title: "Accessibility",
                    description: "Full VoiceOver and Dynamic Type support"
                )
            }
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.arcBrandBurgundy)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Modal Sheet Content

    private var modalSheetContent: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedConfig.title)
                        .font(.headline)

                    Text("Detent: \(currentDetent.accessibilityDescription)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    showModalSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            if currentDetent != .small {
                sheetContentItems
            }

            Spacer(minLength: 0)
        }
        .padding()
    }

    private var sheetContentItems: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sheet Content")
                .font(.subheadline.weight(.medium))

            Text("Drag the handle or swipe to resize. Tap outside to dismiss.")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(0..<5, id: \.self) { index in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.arcBrandBurgundy.opacity(0.2))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.arcBrandBurgundy)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("List Item \(index + 1)")
                            .font(.subheadline.weight(.medium))
                        Text("Sample description text")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
            }
        }
    }

    // MARK: - Persistent Demo View

    private var persistentDemoView: some View {
        ZStack {
            // Map-like background
            LinearGradient(
                colors: [.green.opacity(0.2), .blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .overlay {
                VStack {
                    HStack {
                        Button {
                            showPersistentDemo = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.secondary)
                        }
                        .padding()

                        Spacer()
                    }

                    Spacer()

                    VStack(spacing: 8) {
                        Image(systemName: "map")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary.opacity(0.5))

                        Text("Map View")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                    Spacer()
                }
            }
        }
        .arcPersistentSheet(
            selectedDetent: $currentDetent,
            detents: [.small, .medium, .large],
            configuration: .drawer
        ) {
            VStack(alignment: .leading, spacing: 16) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    Text("Search maps")
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))

                if currentDetent != .small {
                    Text("Recent Searches")
                        .font(.headline)

                    ForEach(["Coffee shops", "Restaurants", "Gas stations", "Hotels"], id: \.self) { item in
                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(.secondary)
                            Text(item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            currentDetent = .small
        }
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

// MARK: - ConfigPreset

@available(iOS 17.0, *)
extension ARCBottomSheetDemoScreen {
    fileprivate enum ConfigPreset {
        case `default`
        case modal
        case glass
        case compact

        var title: String {
            switch self {
            case .default: return "Default"
            case .modal: return "Modal"
            case .glass: return "Glass"
            case .compact: return "Compact"
            }
        }

        var configuration: ARCBottomSheetConfiguration {
            switch self {
            case .default: return .default
            case .modal: return .modal
            case .glass: return .glass
            case .compact: return .compact
            }
        }

        var detents: Set<ARCBottomSheetDetent> {
            [.small, .medium, .large]
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    NavigationStack {
        ARCBottomSheetDemoScreen()
    }
}
