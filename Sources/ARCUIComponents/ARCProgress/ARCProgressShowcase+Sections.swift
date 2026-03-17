//
//  ARCProgressShowcase+Sections.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 23/1/26.
//

import SwiftUI

// MARK: - Linear Progress Section

@available(iOS 17.0, macOS 14.0, *)
extension ARCProgressShowcase {
    @ViewBuilder var linearProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Linear Progress")

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Indeterminate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCLinearProgress()
                }

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

                VStack(alignment: .leading, spacing: 8) {
                    Text("With Percentage")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCLinearProgress(progress: linearProgress, configuration: .withPercentage)
                }

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
}

// MARK: - Circular Progress Section

@available(iOS 17.0, macOS 14.0, *)
extension ARCProgressShowcase {
    @ViewBuilder var circularProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Circular Progress")

            VStack(spacing: 24) {
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
}

// MARK: - Step Indicator Section

@available(iOS 17.0, macOS 14.0, *)
extension ARCProgressShowcase {
    @ViewBuilder var stepIndicatorSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Step Indicator")

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Numbered (Horizontal)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(totalSteps: 4, currentStep: currentStep)
                        .frame(maxWidth: .infinity)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Compact Dots")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCStepIndicator(totalSteps: 5, currentStep: 3, configuration: .compact)
                        .frame(maxWidth: .infinity)
                }

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
}

// MARK: - Interactive Section

@available(iOS 17.0, macOS 14.0, *)
extension ARCProgressShowcase {
    @ViewBuilder var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader("Interactive Demo")

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Linear Progress: \(Int(linearProgress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCLinearProgress(progress: linearProgress, configuration: .thick)

                    Slider(value: $linearProgress, in: 0 ... 1)
                        .tint(.accentColor)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Circular Progress: \(Int(circularProgress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ARCCircularProgress(progress: circularProgress, configuration: .labeledProgress)

                    Slider(value: $circularProgress, in: 0 ... 1)
                        .tint(.accentColor)
                }

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
}
