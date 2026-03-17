//
//  ARCOnboardingShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCOnboardingShowcase

/// A comprehensive showcase view demonstrating all ARCOnboarding features
///
/// Use this view to explore different configurations, styles, and customization
/// options available in the ARCOnboarding component.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCOnboardingShowcase: View {
    // MARK: - State

    @State private var selectedDemo: DemoType = .default
    @State private var showOnboarding = false

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            List {
                introSection

                configurationPresetsSection

                indicatorStylesSection

                buttonStylesSection

                customizationSection
            }
            .navigationTitle("ARCOnboarding")
            #if os(iOS)
                .fullScreenCover(isPresented: $showOnboarding) {
                    selectedOnboarding
                }
            #else
                .sheet(isPresented: $showOnboarding) {
                    selectedOnboarding
                        .frame(minWidth: 400, minHeight: 600)
                }
            #endif
        }
    }

    // MARK: - Initialization

    public init() {}

    // MARK: - Intro Section

    @ViewBuilder private var introSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                Text("A customizable onboarding flow component with horizontal page navigation.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    featureTag("Swipe Navigation")
                    featureTag("Page Indicators")
                    featureTag("Accessible")
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Configuration Presets Section

    @ViewBuilder private var configurationPresetsSection: some View {
        Section("Configuration Presets") {
            demoRow(
                title: "Default",
                description: "Balanced settings with skip, back buttons",
                demo: .default,
                color: .blue
            )

            demoRow(
                title: "Minimal",
                description: "Clean look without navigation buttons",
                demo: .minimal,
                color: .gray
            )

            demoRow(
                title: "Prominent",
                description: "Glass effects with larger images",
                demo: .prominent,
                color: .purple
            )

            demoRow(
                title: "Compact",
                description: "Smaller layout for sheets and modals",
                demo: .compact,
                color: .orange
            )
        }
    }

    // MARK: - Indicator Styles Section

    @ViewBuilder private var indicatorStylesSection: some View {
        Section("Indicator Styles") {
            demoRow(
                title: "Dots",
                description: "Traditional circular indicators",
                demo: .indicatorDots,
                color: .blue
            )

            demoRow(
                title: "Lines",
                description: "Modern line-based indicators",
                demo: .indicatorLines,
                color: .green
            )

            demoRow(
                title: "Numbers",
                description: "Numeric page count (1/5)",
                demo: .indicatorNumbers,
                color: .indigo
            )

            demoRow(
                title: "Progress",
                description: "Progress bar indicator",
                demo: .indicatorProgress,
                color: .pink
            )
        }
    }

    // MARK: - Button Styles Section

    @ViewBuilder private var buttonStylesSection: some View {
        Section("Button Styles") {
            demoRow(
                title: "Filled",
                description: "Solid color buttons",
                demo: .buttonFilled,
                color: .blue
            )

            demoRow(
                title: "Text",
                description: "Plain text buttons",
                demo: .buttonText,
                color: .secondary
            )

            demoRow(
                title: "Glass",
                description: "Liquid glass effect buttons",
                demo: .buttonGlass,
                color: .cyan
            )
        }
    }

    // MARK: - Customization Section

    @ViewBuilder private var customizationSection: some View {
        Section("Content Types") {
            demoRow(
                title: "SF Symbols",
                description: "System icons with colors",
                demo: .contentSFSymbols,
                color: .yellow
            )

            demoRow(
                title: "Custom Colors",
                description: "Different accent per page",
                demo: .contentCustomColors,
                color: .red
            )
        }
    }

    // MARK: - Demo Row

    @ViewBuilder
    private func demoRow(
        title: String,
        description: String,
        demo: DemoType,
        color: Color
    ) -> some View {
        Button {
            selectedDemo = demo
            showOnboarding = true
        } label: {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color.gradient)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: demo.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)

                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Feature Tag

    @ViewBuilder
    private func featureTag(_ text: String) -> some View {
        Text(text)
            .font(.caption2.weight(.medium))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(.quaternary)
            )
    }

    // MARK: - Selected Onboarding

    @ViewBuilder private var selectedOnboarding: some View {
        ARCOnboarding(
            pages: selectedDemo.pages,
            configuration: selectedDemo.configuration,
            onComplete: {
                showOnboarding = false
            },
            onSkip: {
                showOnboarding = false
            }
        )
    }
}

// MARK: - DemoType

@available(iOS 17.0, macOS 14.0, *)
extension ARCOnboardingShowcase {
    fileprivate enum DemoType {
        case `default`
        case minimal
        case prominent
        case compact
        case indicatorDots
        case indicatorLines
        case indicatorNumbers
        case indicatorProgress
        case buttonFilled
        case buttonText
        case buttonGlass
        case contentSFSymbols
        case contentCustomColors

        var icon: String {
            switch self {
            case .default: "slider.horizontal.3"
            case .minimal: "minus"
            case .prominent: "sparkles"
            case .compact: "rectangle.compress.vertical"
            case .indicatorDots: "circle.grid.2x1"
            case .indicatorLines: "minus"
            case .indicatorNumbers: "number"
            case .indicatorProgress: "chart.bar.fill"
            case .buttonFilled: "rectangle.fill"
            case .buttonText: "textformat"
            case .buttonGlass: "rectangle.on.rectangle"
            case .contentSFSymbols: "star.fill"
            case .contentCustomColors: "paintpalette.fill"
            }
        }

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
            case .indicatorDots:
                ARCOnboardingConfiguration(indicatorStyle: .dots)
            case .indicatorLines:
                ARCOnboardingConfiguration(indicatorStyle: .lines, accentColor: .arcBrandGold)
            case .indicatorNumbers:
                ARCOnboardingConfiguration(indicatorStyle: .numbers)
            case .indicatorProgress:
                ARCOnboardingConfiguration(indicatorStyle: .progress, accentColor: .arcBrandGold)
            case .buttonFilled:
                ARCOnboardingConfiguration(buttonStyle: .filled)
            case .buttonText:
                ARCOnboardingConfiguration(buttonStyle: .text, accentColor: .arcBrandGold)
            case .buttonGlass:
                ARCOnboardingConfiguration(buttonStyle: .glass)
            case .contentSFSymbols:
                .default
            case .contentCustomColors:
                .default
            }
        }

        var pages: [ARCOnboardingPage] {
            switch self {
            case .contentCustomColors:
                [
                    ARCOnboardingPage(
                        image: .systemImage("heart.fill"),
                        imageColor: .red,
                        title: "Love What You Do",
                        subtitle: "Passion drives everything we create.",
                        accentColor: .red
                    ),
                    ARCOnboardingPage(
                        image: .systemImage("bolt.fill"),
                        imageColor: .yellow,
                        title: "Lightning Fast",
                        subtitle: "Speed without compromising quality.",
                        accentColor: .yellow
                    ),
                    ARCOnboardingPage(
                        image: .systemImage("leaf.fill"),
                        imageColor: .green,
                        title: "Sustainable Growth",
                        subtitle: "Building for the long term.",
                        accentColor: .green
                    )
                ]

            default:
                [
                    .systemImage(
                        "star.fill",
                        color: .yellow,
                        title: "Welcome",
                        subtitle: "Discover amazing features that will transform your daily workflow."
                    ),
                    .systemImage(
                        "bell.fill",
                        color: .blue,
                        title: "Stay Notified",
                        subtitle: "Get timely reminders and never miss important updates."
                    ),
                    .systemImage(
                        "checkmark.circle.fill",
                        color: .green,
                        title: "Track Progress",
                        subtitle: "Visualize your growth and celebrate milestones."
                    ),
                    .systemImage(
                        "sparkles",
                        color: .purple,
                        title: "You're All Set!",
                        subtitle: "Start your journey and make magic happen."
                    )
                ]
            }
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase") {
    ARCOnboardingShowcase()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase - Dark") {
    ARCOnboardingShowcase()
        .preferredColorScheme(.dark)
}
