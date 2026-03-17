//
//  ARCProgressDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen showcasing ARCProgress components
///
/// Demonstrates all progress indicator variants including linear bars,
/// circular indicators, and step indicators with interactive examples.
struct ARCProgressDemoScreen: View {
    // MARK: - State

    @State private var downloadProgress: Double = 0.0
    @State private var uploadProgress: Double = 0.0
    @State private var isDownloading = false
    @State private var checkoutStep: Int = 1
    @State private var onboardingStep: Int = 1

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection

                fileDownloadExample

                uploadProgressExample

                loadingSpinnersExample

                checkoutFlowExample

                onboardingDotsExample

                colorVariantsExample
            }
            .padding()
        }
        .navigationTitle("ARCProgress")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Header Section

    @ViewBuilder private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress Indicators")
                .font(.title2.bold())

            Text("""
            Progress indicators let people know that your app isn't stalled \
            while it loads content or performs lengthy operations. Use determinate \
            indicators when the duration is known, and indeterminate when unknown.
            """)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - File Download Example

    @ViewBuilder private var fileDownloadExample: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("File Download")

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "doc.zipper")
                        .font(.title2)
                        .foregroundStyle(.blue)
                        .frame(width: 44, height: 44)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Project_Assets.zip")
                            .font(.headline)

                        if isDownloading {
                            ARCLinearProgress(progress: downloadProgress, configuration: .withPercentage)
                        } else if downloadProgress >= 1.0 {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Download Complete")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.caption)
                        } else {
                            Text("245 MB")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    if !isDownloading, downloadProgress < 1.0 {
                        Button {
                            startDownload()
                        } label: {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                    } else if isDownloading {
                        Button {
                            cancelDownload()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    // MARK: - Upload Progress Example

    @ViewBuilder private var uploadProgressExample: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Photo Upload")

            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Thumbnail placeholder
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "photo.fill")
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Uploading to Cloud...")
                            .font(.subheadline.weight(.medium))

                        ARCLinearProgress(
                            progress: uploadProgress,
                            configuration: ARCLinearProgressConfiguration(
                                height: 6,
                                progressColor: .purple
                            )
                        )

                        Text("\(Int(uploadProgress * 100))% • \(Int((1 - uploadProgress) * 12.5)) MB remaining")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    Button("Start Upload") {
                        startUpload()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .disabled(uploadProgress > 0 && uploadProgress < 1)

                    Button("Reset") {
                        uploadProgress = 0
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    // MARK: - Loading Spinners Example

    @ViewBuilder private var loadingSpinnersExample: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Loading States")

            VStack(spacing: 20) {
                // Indeterminate examples
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        ARCCircularProgress(configuration: .small)
                        Text("Loading")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCCircularProgress()
                        Text("Processing")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ARCCircularProgress(configuration: .large)
                        Text("Syncing")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)

                Divider()

                // Linear indeterminate
                VStack(alignment: .leading, spacing: 8) {
                    Text("Loading content...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ARCLinearProgress()
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

// MARK: - Step Indicator Examples

extension ARCProgressDemoScreen {
    @ViewBuilder var checkoutFlowExample: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Checkout Flow")

            VStack(spacing: 20) {
                ARCStepIndicator(
                    totalSteps: 4,
                    currentStep: checkoutStep,
                    configuration: .withIcons([
                        "cart.fill", "truck.box.fill", "creditcard.fill", "checkmark.seal.fill"
                    ])
                )
                .frame(maxWidth: .infinity)

                VStack(spacing: 12) {
                    Text(checkoutStepTitle).font(.headline)
                    Text(checkoutStepDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                HStack {
                    Button("Back") {
                        withAnimation { checkoutStep = max(1, checkoutStep - 1) }
                    }
                    .buttonStyle(.bordered)
                    .disabled(checkoutStep <= 1)

                    Spacer()

                    Button(checkoutStep < 4 ? "Continue" : "Place Order") {
                        withAnimation { checkoutStep = checkoutStep < 4 ? checkoutStep + 1 : 1 }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    @ViewBuilder var onboardingDotsExample: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Onboarding Progress")

            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(LinearGradient(
                        colors: onboardingColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 150)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: onboardingIcon).font(.system(size: 40))
                            Text(onboardingTitle).font(.headline)
                        }
                        .foregroundStyle(.white)
                    }

                ARCStepIndicator(totalSteps: 5, currentStep: onboardingStep, configuration: .compact)
                    .frame(maxWidth: .infinity)

                HStack {
                    Button { withAnimation { onboardingStep = max(1, onboardingStep - 1) } } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(onboardingStep <= 1)

                    Spacer()
                    Text("Page \(onboardingStep) of 5").font(.caption).foregroundStyle(.secondary)
                    Spacer()

                    Button { withAnimation { onboardingStep = min(5, onboardingStep + 1) } } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(onboardingStep >= 5)
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

// MARK: - Color Variants & Helpers

extension ARCProgressDemoScreen {
    @ViewBuilder var colorVariantsExample: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Color Variants")

            VStack(spacing: 16) {
                colorVariantRow(progress: 1.0, color: .green, title: "Backup Complete")
                colorVariantRow(progress: 0.75, color: .orange, title: "Storage Used")
                colorVariantRow(progress: 0.95, color: .red, title: "Memory Critical")
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    @ViewBuilder
    private func colorVariantRow(progress: Double, color: Color, title: String) -> some View {
        HStack(spacing: 12) {
            ARCCircularProgress(
                progress: progress,
                configuration: ARCCircularProgressConfiguration(progressColor: color, showPercentage: true)
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.medium))
                ARCLinearProgress(
                    progress: progress,
                    configuration: ARCLinearProgressConfiguration(progressColor: color)
                )
            }
        }
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
    }

    var checkoutStepTitle: String {
        switch checkoutStep {
        case 1: "Shopping Cart"
        case 2: "Shipping"
        case 3: "Payment"
        case 4: "Confirmation"
        default: ""
        }
    }

    var checkoutStepDescription: String {
        switch checkoutStep {
        case 1: "Review your items before checkout"
        case 2: "Enter your shipping address"
        case 3: "Add your payment method"
        case 4: "Review and place your order"
        default: ""
        }
    }

    var onboardingColors: [Color] {
        switch onboardingStep {
        case 1: [.blue, .cyan]
        case 2: [.purple, .pink]
        case 3: [.orange, .yellow]
        case 4: [.green, .mint]
        case 5: [.indigo, .purple]
        default: [.gray, .gray]
        }
    }

    var onboardingIcon: String {
        switch onboardingStep {
        case 1: "hand.wave.fill"
        case 2: "sparkles"
        case 3: "bell.badge.fill"
        case 4: "person.2.fill"
        case 5: "checkmark.circle.fill"
        default: "circle"
        }
    }

    var onboardingTitle: String {
        switch onboardingStep {
        case 1: "Welcome"
        case 2: "Discover Features"
        case 3: "Stay Updated"
        case 4: "Connect"
        case 5: "Get Started"
        default: ""
        }
    }
}

// MARK: - Actions

extension ARCProgressDemoScreen {
    func startDownload() {
        isDownloading = true
        downloadProgress = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if downloadProgress < 1.0 {
                downloadProgress += 0.02
            } else {
                timer.invalidate()
                isDownloading = false
            }
        }
    }

    func cancelDownload() {
        isDownloading = false
        downloadProgress = 0
    }

    func startUpload() {
        uploadProgress = 0
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            if uploadProgress < 1.0 {
                uploadProgress += 0.015
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        ARCProgressDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCProgressDemoScreen()
    }
    .preferredColorScheme(.dark)
}
