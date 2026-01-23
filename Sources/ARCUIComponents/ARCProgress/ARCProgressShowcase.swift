//
//  ARCProgressShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCProgressShowcase

/// Showcase view demonstrating all ARCProgress component variants
///
/// This view provides a comprehensive demonstration of all progress indicator
/// components including linear, circular, and step indicators with various
/// configurations.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCProgressShowcase: View {
    // MARK: - State

    @State private var linearProgress: Double = 0.65
    @State private var circularProgress: Double = 0.75
    @State private var currentStep: Int = 2
    @State private var isAnimating = false

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                headerSection

                linearProgressSection

                circularProgressSection

                stepIndicatorSection

                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Progress Indicators")
    }

    // MARK: - Header Section

    @ViewBuilder private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ARCProgress Components")
                .font(.title2.bold())

            Text("""
            Progress indicators let people know that your app isn't stalled \
            while it loads content or performs lengthy operations.
            """)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Linear Progress Section

    @ViewBuilder private var linearProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Linear Progress")

            VStack(spacing: 16) {
                // Indeterminate
                VStack(alignment: .leading, spacing: 8) {
                    Text("Indeterminate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCLinearProgress()
                }

                // Height variants
                VStack(alignment: .leading, spacing: 8) {
                    Text("Height Variants")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            ARCLinearProgress(progress: 0.6, configuration: .thin)
                            Text("Thin").font(.caption2)
                        }
                        VStack(spacing: 4) {
                            ARCLinearProgress(progress: 0.6)
                            Text("Default").font(.caption2)
                        }
                        VStack(spacing: 4) {
                            ARCLinearProgress(progress: 0.6, configuration: .thick)
                            Text("Thick").font(.caption2)
                        }
                    }
                }

                // With percentage
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Percentage")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCLinearProgress(progress: linearProgress, configuration: .withPercentage)
                }

                // Custom colors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom Colors")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCLinearProgress(
                        progress: 0.8,
                        configuration: ARCLinearProgressConfiguration(progressColor: .green)
                    )
                    ARCLinearProgress(
                        progress: 0.5,
                        configuration: ARCLinearProgressConfiguration(progressColor: .orange)
                    )
                    ARCLinearProgress(
                        progress: 0.3,
                        configuration: ARCLinearProgressConfiguration(progressColor: .red)
                    )
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Circular Progress Section

    @ViewBuilder private var circularProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Circular Progress")

            VStack(spacing: 24) {
                // Indeterminate spinners
                VStack(alignment: .leading, spacing: 12) {
                    Text("Indeterminate (Spinners)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 32) {
                        VStack(spacing: 8) {
                            ARCCircularProgress(configuration: .small)
                            Text("Small").font(.caption2)
                        }
                        VStack(spacing: 8) {
                            ARCCircularProgress()
                            Text("Medium").font(.caption2)
                        }
                        VStack(spacing: 8) {
                            ARCCircularProgress(configuration: .large)
                            Text("Large").font(.caption2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                // Determinate
                VStack(alignment: .leading, spacing: 12) {
                    Text("Determinate")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 32) {
                        ARCCircularProgress(progress: 0.25, configuration: .small)
                        ARCCircularProgress(progress: 0.50)
                        ARCCircularProgress(progress: 0.75, configuration: .large)
                    }
                    .frame(maxWidth: .infinity)
                }

                // With percentage label
                VStack(alignment: .leading, spacing: 12) {
                    Text("With Percentage Label")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 32) {
                        ARCCircularProgress(progress: 0.33, configuration: .labeledProgress)
                        ARCCircularProgress(progress: 0.66, configuration: .labeledProgress)
                        ARCCircularProgress(progress: 0.99, configuration: .labeledProgress)
                    }
                    .frame(maxWidth: .infinity)
                }

                // Line cap styles
                VStack(alignment: .leading, spacing: 12) {
                    Text("Line Cap Styles")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 32) {
                        VStack(spacing: 8) {
                            ARCCircularProgress(
                                progress: 0.6,
                                configuration: ARCCircularProgressConfiguration(lineCap: .round)
                            )
                            Text("Round").font(.caption2)
                        }
                        VStack(spacing: 8) {
                            ARCCircularProgress(
                                progress: 0.6,
                                configuration: ARCCircularProgressConfiguration(lineCap: .butt)
                            )
                            Text("Butt").font(.caption2)
                        }
                        VStack(spacing: 8) {
                            ARCCircularProgress(
                                progress: 0.6,
                                configuration: ARCCircularProgressConfiguration(lineCap: .square)
                            )
                            Text("Square").font(.caption2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Step Indicator Section

    @ViewBuilder private var stepIndicatorSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Step Indicator")

            VStack(spacing: 24) {
                // Numbered horizontal
                VStack(alignment: .leading, spacing: 12) {
                    Text("Numbered (Horizontal)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(totalSteps: 4, currentStep: currentStep)
                        .frame(maxWidth: .infinity)
                }

                // Compact dots
                VStack(alignment: .leading, spacing: 12) {
                    Text("Compact Dots")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(totalSteps: 5, currentStep: 3, configuration: .compact)
                        .frame(maxWidth: .infinity)
                }

                // With icons
                VStack(alignment: .leading, spacing: 12) {
                    Text("With Icons")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(
                        totalSteps: 4,
                        currentStep: 2,
                        configuration: .withIcons([
                            "cart.fill",
                            "truck.box.fill",
                            "creditcard.fill",
                            "checkmark.seal.fill"
                        ])
                    )
                    .frame(maxWidth: .infinity)
                }

                // Vertical with labels
                VStack(alignment: .leading, spacing: 12) {
                    Text("Vertical with Labels")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(
                        totalSteps: 4,
                        currentStep: 2,
                        configuration: .detailed(labels: [
                            "Account Details",
                            "Shipping Address",
                            "Payment Method",
                            "Review Order"
                        ])
                    )
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Interactive Section

    @ViewBuilder private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Interactive Demo")

            VStack(spacing: 24) {
                // Linear progress slider
                VStack(alignment: .leading, spacing: 12) {
                    Text("Linear Progress: \(Int(linearProgress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCLinearProgress(progress: linearProgress, configuration: .thick)

                    Slider(value: $linearProgress, in: 0 ... 1)
                        .tint(.accentColor)
                }

                // Circular progress slider
                VStack(alignment: .leading, spacing: 12) {
                    Text("Circular Progress: \(Int(circularProgress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCCircularProgress(progress: circularProgress, configuration: .labeledProgress)

                    Slider(value: $circularProgress, in: 0 ... 1)
                        .tint(.accentColor)
                }

                // Step indicator controls
                VStack(alignment: .leading, spacing: 12) {
                    Text("Step: \(currentStep) of 4")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(totalSteps: 4, currentStep: currentStep)
                        .frame(maxWidth: .infinity)

                    HStack {
                        Button("Previous") {
                            withAnimation {
                                currentStep = max(1, currentStep - 1)
                            }
                        }
                        .disabled(currentStep <= 1)

                        Spacer()

                        Button("Next") {
                            withAnimation {
                                currentStep = min(4, currentStep + 1)
                            }
                        }
                        .disabled(currentStep >= 4)
                    }
                    .buttonStyle(.bordered)
                }

                // Auto-animate demo
                VStack(alignment: .leading, spacing: 12) {
                    Text("Auto-Animate Demo")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 24) {
                        ARCLinearProgress(
                            progress: isAnimating ? 1.0 : 0.0,
                            configuration: .thick
                        )
                        .frame(width: 120)

                        ARCCircularProgress(
                            progress: isAnimating ? 1.0 : 0.0,
                            configuration: .large
                        )
                    }
                    .frame(maxWidth: .infinity)

                    Button(isAnimating ? "Reset" : "Animate") {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            isAnimating.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Helper Views

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    NavigationStack {
        ARCProgressShowcase()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCProgressShowcase()
    }
    .preferredColorScheme(.dark)
}
