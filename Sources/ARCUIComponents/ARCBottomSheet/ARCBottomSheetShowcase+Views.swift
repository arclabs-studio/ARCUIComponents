//
//  ARCBottomSheetShowcase+Views.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 23/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - Configurations Tab

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetShowcase {
    var configurationsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionHeader("Configuration Presets")

                ForEach(ConfigOption.allCases) { option in
                    configurationCard(option)
                }
            }
            .padding()
        }
    }

    func configurationCard(_ option: ConfigOption) -> some View {
        Button {
            selectedConfig = option
            currentDetent = .medium
            showSheet = true
        } label: {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(option.color.gradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: option.icon)
                            .font(.title3)
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(option.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Detents Tab

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetShowcase {
    var detentsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionHeader("Detent Types")

                detentCard(
                    title: "Small",
                    description: "~15% height or 120pt minimum",
                    detent: .small
                )

                detentCard(
                    title: "Medium",
                    description: "50% of screen height",
                    detent: .medium
                )

                detentCard(
                    title: "Large",
                    description: "90% of screen height",
                    detent: .large
                )

                Divider()
                    .padding(.vertical, 8)

                sectionHeader("Custom Detents")

                detentCard(
                    title: "Fixed Height (200pt)",
                    description: "Absolute height in points",
                    detent: .height(200)
                )

                detentCard(
                    title: "Fraction (60%)",
                    description: "Percentage of container",
                    detent: .fraction(0.6)
                )
            }
            .padding()
        }
    }

    func detentCard(title: String, description: String, detent: ARCBottomSheetDetent) -> some View {
        Button {
            selectedConfig = .default
            currentDetent = detent
            showSheet = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                detentPreview(detent)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    func fractionForDetent(_ detent: ARCBottomSheetDetent) -> CGFloat {
        switch detent {
        case .small: 0.15
        case .medium: 0.5
        case .large: 0.9
        case let .fraction(value): value
        case .height: 0.3
        }
    }

    @ViewBuilder
    func detentPreview(_ detent: ARCBottomSheetDetent) -> some View {
        let fraction = fractionForDetent(detent)

        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                .frame(width: 30, height: 50)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.arcBrandBurgundy.opacity(0.3))
                .frame(width: 30, height: 50 * fraction)
        }
    }
}

// MARK: - Interactive Tab

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetShowcase {
    var interactiveTab: some View {
        ScrollView {
            VStack(spacing: 24) {
                sectionHeader("Interactive Demo")

                currentDetentDisplay

                detentButtons

                launchButton
            }
            .padding()
        }
    }

    var currentDetentDisplay: some View {
        VStack(spacing: 8) {
            Text("Current Detent")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(currentDetent.accessibilityDescription.capitalized)
                .font(.title2.bold())
                .foregroundStyle(Color.arcBrandBurgundy)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    var detentButtons: some View {
        HStack(spacing: 12) {
            ForEach([ARCBottomSheetDetent.small, .medium, .large], id: \.id) { detent in
                Button {
                    currentDetent = detent
                } label: {
                    Text(detent.accessibilityDescription.capitalized)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(currentDetent == detent ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            currentDetent == detent
                                ? Color.arcBrandBurgundy
                                : Color.secondary.opacity(0.1),
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    var launchButton: some View {
        Button {
            selectedConfig = .default
            showSheet = true
        } label: {
            HStack {
                Image(systemName: "arrow.up.circle.fill")
                Text("Launch Interactive Sheet")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.arcBrandBurgundy, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sheet Overlay

@available(iOS 17.0, macOS 14.0, *)
extension ARCBottomSheetShowcase {
    @ViewBuilder var sheetOverlay: some View {
        ZStack(alignment: .bottom) {
            if selectedConfig.configuration.dimBackground {
                Color.black
                    .opacity(selectedConfig.configuration.dimOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if selectedConfig.configuration.tapBackgroundToDismiss {
                            showSheet = false
                        }
                    }
            }

            ARCBottomSheet(
                selectedDetent: $currentDetent,
                detents: [.small, .medium, .large],
                configuration: selectedConfig.configuration
            ) {
                sheetContent
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    var sheetContent: some View {
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
                    showSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            if currentDetent != .small {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sheet Content")
                        .font(.subheadline.weight(.medium))

                    Text("""
                    Drag the handle to resize between detents. \
                    The sheet supports velocity-based snapping for natural interaction.
                    """)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    ForEach(0 ..< 5, id: \.self) { index in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.arcBrandBurgundy.opacity(0.2))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.arcBrandBurgundy)
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Item \(index + 1)")
                                    .font(.subheadline.weight(.medium))
                                Text("Sample content description")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding()
    }
}
