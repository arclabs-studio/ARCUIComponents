//
//  ARCOnboardingDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCOnboarding component.
///
/// Shows onboarding flows with various configurations, indicator styles,
/// and button styles. Demonstrates different onboarding experiences.
@available(iOS 17.0, *)
struct ARCOnboardingDemoScreen: View {
    // MARK: - State

    @State private var showOnboarding = false
    @State private var selectedConfig: ConfigPreset = .default
    @State private var selectedIndicator: ARCOnboardingConfiguration.IndicatorStyle = .dots
    @State private var selectedButtonStyle: ARCOnboardingConfiguration.ButtonStyle = .filled
    @State private var showSkipButton = true
    @State private var showBackButton = true

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                quickActionsSection
                configurationPresetsSection
                indicatorStylesSection
                buttonStylesSection
                interactiveBuilderSection
            }
            .padding()
        }
        .navigationTitle("ARCOnboarding")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .fullScreenCover(isPresented: $showOnboarding) {
                selectedOnboardingView
            }
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCOnboardingDemoScreen {
    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Quick Demo", subtitle: "Tap to see onboarding in action")

            Button {
                selectedConfig = .default
                showOnboarding = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Launch Demo Onboarding")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("4 pages with default configuration")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "play.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.arcBrandBurgundy, .arcBrandBurgundy.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 16)
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Configuration Presets Section

    private var configurationPresetsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Configuration Presets", subtitle: "Pre-built onboarding styles")

            VStack(spacing: 12) {
                presetRow(
                    title: "Default",
                    description: "Balanced settings with skip & back buttons",
                    icon: "slider.horizontal.3",
                    color: .blue,
                    preset: .default
                )

                presetRow(
                    title: "Minimal",
                    description: "Clean look without navigation buttons",
                    icon: "minus",
                    color: .gray,
                    preset: .minimal
                )

                presetRow(
                    title: "Prominent",
                    description: "Glass effects with larger images",
                    icon: "sparkles",
                    color: .purple,
                    preset: .prominent
                )

                presetRow(
                    title: "Compact",
                    description: "Smaller layout for sheets and modals",
                    icon: "rectangle.compress.vertical",
                    color: .orange,
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
            showOnboarding = true
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

    // MARK: - Indicator Styles Section

    private var indicatorStylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Indicator Styles", subtitle: "Different ways to show progress")

            VStack(spacing: 12) {
                indicatorRow(
                    title: "Dots",
                    description: "Traditional circular indicators",
                    style: .dots
                )

                indicatorRow(
                    title: "Lines",
                    description: "Modern line-based indicators",
                    style: .lines
                )

                indicatorRow(
                    title: "Numbers",
                    description: "Numeric page count (1/5)",
                    style: .numbers
                )

                indicatorRow(
                    title: "Progress",
                    description: "Progress bar indicator",
                    style: .progress
                )
            }
        }
    }

    private func indicatorRow(
        title: String,
        description: String,
        style: ARCOnboardingConfiguration.IndicatorStyle
    ) -> some View {
        Button {
            selectedConfig = .customIndicator(style)
            showOnboarding = true
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

                indicatorPreview(style: style)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func indicatorPreview(style: ARCOnboardingConfiguration.IndicatorStyle) -> some View {
        switch style {
        case .dots:
            HStack(spacing: 4) {
                Circle().fill(Color.arcBrandBurgundy).frame(width: 8, height: 8)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
            }
        case .lines:
            HStack(spacing: 2) {
                Capsule().fill(Color.arcBrandBurgundy).frame(width: 20, height: 4)
                Capsule().fill(Color.gray.opacity(0.3)).frame(width: 12, height: 4)
                Capsule().fill(Color.gray.opacity(0.3)).frame(width: 12, height: 4)
            }
        case .numbers:
            Text("1/3")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        case .progress:
            ZStack(alignment: .leading) {
                Capsule().fill(Color.gray.opacity(0.3)).frame(width: 40, height: 4)
                Capsule().fill(Color.arcBrandBurgundy).frame(width: 15, height: 4)
            }
        }
    }

    // MARK: - Button Styles Section

    private var buttonStylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Button Styles", subtitle: "Navigation button appearances")

            VStack(spacing: 12) {
                buttonStyleRow(
                    title: "Filled",
                    description: "Solid accent color buttons",
                    style: .filled
                )

                buttonStyleRow(
                    title: "Text",
                    description: "Plain text buttons",
                    style: .text
                )

                buttonStyleRow(
                    title: "Glass",
                    description: "Liquid glass effect buttons",
                    style: .glass
                )
            }
        }
    }

    private func buttonStyleRow(
        title: String,
        description: String,
        style: ARCOnboardingConfiguration.ButtonStyle
    ) -> some View {
        Button {
            selectedConfig = .customButton(style)
            showOnboarding = true
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

                buttonPreview(style: style)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func buttonPreview(style: ARCOnboardingConfiguration.ButtonStyle) -> some View {
        switch style {
        case .filled:
            Text("Continue")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.arcBrandBurgundy, in: RoundedRectangle(cornerRadius: 6))

        case .text:
            Text("Continue")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Color.arcBrandBurgundy)

        case .glass:
            Text("Continue")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
        }
    }

    // MARK: - Interactive Builder Section

    private var interactiveBuilderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Onboarding Builder", subtitle: "Customize and preview")

            VStack(alignment: .leading, spacing: 16) {
                // Indicator picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Indicator Style")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Picker("Indicator", selection: $selectedIndicator) {
                        Text("Dots").tag(ARCOnboardingConfiguration.IndicatorStyle.dots)
                        Text("Lines").tag(ARCOnboardingConfiguration.IndicatorStyle.lines)
                        Text("Numbers").tag(ARCOnboardingConfiguration.IndicatorStyle.numbers)
                        Text("Progress").tag(ARCOnboardingConfiguration.IndicatorStyle.progress)
                    }
                    .pickerStyle(.segmented)
                }

                // Button style picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Button Style")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Picker("Button Style", selection: $selectedButtonStyle) {
                        Text("Filled").tag(ARCOnboardingConfiguration.ButtonStyle.filled)
                        Text("Text").tag(ARCOnboardingConfiguration.ButtonStyle.text)
                        Text("Glass").tag(ARCOnboardingConfiguration.ButtonStyle.glass)
                    }
                    .pickerStyle(.segmented)
                }

                // Options
                Toggle("Show Skip Button", isOn: $showSkipButton)
                Toggle("Show Back Button", isOn: $showBackButton)

                // Preview button
                Button {
                    selectedConfig = .custom(
                        indicator: selectedIndicator,
                        button: selectedButtonStyle,
                        showSkip: showSkipButton,
                        showBack: showBackButton
                    )
                    showOnboarding = true
                } label: {
                    Text("Launch Custom Onboarding")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.arcBrandBurgundy, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Selected Onboarding View

    @ViewBuilder private var selectedOnboardingView: some View {
        ARCOnboarding(
            pages: samplePages,
            configuration: selectedConfig.configuration,
            onComplete: {
                showOnboarding = false
            },
            onSkip: {
                showOnboarding = false
            }
        )
    }

    // MARK: - Sample Pages

    private var samplePages: [ARCOnboardingPage] {
        [
            .systemImage("star.fill", color: .yellow, title: "Welcome", subtitle: "Discover features."),
            .systemImage("bell.fill", color: .blue, title: "Stay Notified", subtitle: "Get reminders."),
            .systemImage("sparkles", color: .purple, title: "You're Set!", subtitle: "Start now.")
        ]
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline).foregroundStyle(Color.arcBrandBurgundy)
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - ConfigPreset

@available(iOS 17.0, *)
extension ARCOnboardingDemoScreen {
    fileprivate enum ConfigPreset {
        case `default`
        case minimal
        case prominent
        case compact
        case customIndicator(ARCOnboardingConfiguration.IndicatorStyle)
        case customButton(ARCOnboardingConfiguration.ButtonStyle)
        case custom(
            indicator: ARCOnboardingConfiguration.IndicatorStyle,
            button: ARCOnboardingConfiguration.ButtonStyle,
            showSkip: Bool,
            showBack: Bool
        )

        var configuration: ARCOnboardingConfiguration {
            switch self {
            case .default:
                .default
            case .minimal:
                .minimal
            case .prominent:
                .prominent
            case .compact:
                .compact
            case let .customIndicator(style):
                ARCOnboardingConfiguration(indicatorStyle: style)
            case let .customButton(style):
                ARCOnboardingConfiguration(buttonStyle: style)
            case let .custom(indicator, button, showSkip, showBack):
                ARCOnboardingConfiguration(
                    showSkipButton: showSkip,
                    showBackButton: showBack,
                    buttonStyle: button,
                    indicatorStyle: indicator
                )
            }
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    NavigationStack {
        ARCOnboardingDemoScreen()
    }
}
