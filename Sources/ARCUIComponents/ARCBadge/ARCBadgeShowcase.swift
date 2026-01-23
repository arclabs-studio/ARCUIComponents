//
//  ARCBadgeShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCBadgeShowcase

/// A comprehensive showcase of all ARCBadge configurations
@available(iOS 17.0, macOS 14.0, *)
public struct ARCBadgeShowcase: View {
    // MARK: - State

    @State private var badgeCount = 5
    @State private var showAnimation = false

    // MARK: - Body

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    contentTypesSection
                    stylesSection
                    brandColorsSection
                    sizesSection
                    overlaySection
                    interactiveSection
                }
                .padding()
            }
            .navigationTitle("ARCBadge")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

// MARK: - Sections

@available(iOS 17.0, macOS 14.0, *)
extension ARCBadgeShowcase {
    @ViewBuilder private var contentTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Content Types")

            VStack(spacing: 12) {
                row("Count") {
                    HStack(spacing: 16) {
                        ARCBadge(1)
                        ARCBadge(42)
                        ARCBadge(99)
                        ARCBadge(150)
                    }
                }

                row("Text") {
                    HStack(spacing: 16) {
                        ARCBadge("NEW")
                        ARCBadge("SALE")
                        ARCBadge("PRO")
                    }
                }

                row("Dot") {
                    HStack(spacing: 16) {
                        ARCBadge(dot: .default)
                        ARCBadge(dot: .success)
                        ARCBadge(dot: .warning)
                        ARCBadge(dot: .info)
                    }
                }
            }
        }
    }

    @ViewBuilder private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Styles")

            VStack(spacing: 12) {
                row("Filled") {
                    HStack(spacing: 16) {
                        ARCBadge(5, configuration: .default)
                        ARCBadge(5, configuration: .success)
                        ARCBadge(5, configuration: .warning)
                        ARCBadge(5, configuration: .info)
                    }
                }

                row("Outlined") {
                    HStack(spacing: 16) {
                        ARCBadge(5, configuration: .outlined)
                        ARCBadge(5, configuration: .init(style: .outlined(.green)))
                        ARCBadge(5, configuration: .init(style: .outlined(.orange)))
                    }
                }

                row("Subtle") {
                    HStack(spacing: 16) {
                        ARCBadge(5, configuration: .subtle)
                        ARCBadge(5, configuration: .init(style: .subtle(.green)))
                        ARCBadge(5, configuration: .init(style: .subtle(.blue)))
                    }
                }
            }
        }
    }

    @ViewBuilder private var brandColorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("ARC Brand Colors")

            VStack(spacing: 12) {
                row("Filled") {
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            ARCBadge(5, configuration: .init(style: .filled(.arcBrandBurgundy)))
                            Text("Burgundy").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCBadge(5, configuration: .init(style: .filled(.arcBrandGold)))
                            Text("Gold").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }

                row("Outlined") {
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            ARCBadge(5, configuration: .init(style: .outlined(.arcBrandBurgundy)))
                            Text("Burgundy").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCBadge(5, configuration: .init(style: .outlined(.arcBrandGold)))
                            Text("Gold").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }

                row("Subtle") {
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            ARCBadge(5, configuration: .init(style: .subtle(.arcBrandBurgundy)))
                            Text("Burgundy").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCBadge(5, configuration: .init(style: .subtle(.arcBrandGold)))
                            Text("Gold").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }

                row("Text") {
                    HStack(spacing: 16) {
                        ARCBadge("ARC", configuration: .init(style: .filled(.arcBrandBurgundy)))
                        ARCBadge("PRO", configuration: .init(style: .filled(.arcBrandGold)))
                    }
                }
            }
        }
    }

    @ViewBuilder private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Sizes")

            row("Comparison") {
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        ARCBadge(5, configuration: .init(size: .small))
                        Text("Small").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCBadge(5, configuration: .init(size: .medium))
                        Text("Medium").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCBadge(5, configuration: .init(size: .large))
                        Text("Large").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder private var overlaySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("As Overlay")

            row("On Icons") {
                HStack(spacing: 32) {
                    Image(systemName: "bell")
                        .font(.title)
                        .arcBadge(count: 3)

                    Image(systemName: "envelope")
                        .font(.title)
                        .arcBadge(count: 12, configuration: .info)

                    Image(systemName: "cart")
                        .font(.title)
                        .arcBadge(text: "NEW", configuration: .success)

                    Image(systemName: "person.circle")
                        .font(.title)
                        .arcBadgeDot(configuration: .success)
                }
            }
        }
    }

    @ViewBuilder private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Interactive Demo")

            VStack(spacing: 16) {
                HStack {
                    Text("Count: \(badgeCount)")
                    Spacer()
                    Stepper("", value: $badgeCount, in: 0 ... 150)
                        .labelsHidden()
                }

                HStack(spacing: 24) {
                    Image(systemName: "bell.fill")
                        .font(.largeTitle)
                        .arcBadge(count: badgeCount)

                    Image(systemName: "message.fill")
                        .font(.largeTitle)
                        .arcBadge(count: badgeCount, configuration: .info)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    private func row(_ label: String, @ViewBuilder content: () -> some View) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            content()

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase") {
    ARCBadgeShowcase()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Showcase - Dark") {
    ARCBadgeShowcase()
        .preferredColorScheme(.dark)
}
