//
//  ARCButtonShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCButtonShowcase

/// Comprehensive showcase demonstrating all ARCButton variants and configurations
///
/// This view displays:
/// - All visual styles (filled, outlined, ghost, glass)
/// - All size variants (small, medium, large)
/// - Icon combinations (leading, trailing, icon-only)
/// - Interactive states (normal, loading, disabled)
/// - Full width layout options
@available(iOS 17.0, macOS 14.0, *)
public struct ARCButtonShowcase: View {
    // MARK: - State

    @State private var isLoading1 = false
    @State private var isLoading2 = false
    @State private var isLoading3 = false

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                stylesSection
                sizesSection
                iconSection
                statesSection
                fullWidthSection
                glassSection
                semanticSection
            }
            .padding()
        }
        .navigationTitle("ARCButton")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, macOS 14.0, *)
extension ARCButtonShowcase {
    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Button Styles", subtitle: "Visual style variants")

            VStack(spacing: 12) {
                styleRow("Filled", description: "Solid background, high emphasis") {
                    ARCButton("Filled Button") {}
                }

                styleRow("Outlined", description: "Border only, medium emphasis") {
                    ARCButton("Outlined Button", configuration: .secondary) {}
                }

                styleRow("Ghost", description: "Text only, low emphasis") {
                    ARCButton("Ghost Button", configuration: .ghost) {}
                }

                styleRow("Destructive", description: "Red, for destructive actions") {
                    ARCButton("Delete", configuration: .destructive) {}
                }
            }
        }
    }

    // MARK: - Sizes Section

    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Button Sizes", subtitle: "Small (32pt), Medium (44pt), Large (56pt)")

            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    ARCButton("Small", configuration: .small) {}
                    Text("32pt").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCButton("Medium") {}
                    Text("44pt").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCButton("Large", configuration: .large) {}
                    Text("56pt").font(.caption2).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Icon Section

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Icon Variants", subtitle: "With SF Symbols")

            VStack(spacing: 12) {
                styleRow("Leading Icon", description: "Icon before text") {
                    ARCButton("Add to Cart", icon: "cart.fill") {}
                }

                styleRow("Trailing Icon", description: "Icon after text") {
                    ARCButton("Continue", icon: "arrow.right", iconPosition: .trailing) {}
                }

                styleRow("Icon Only", description: "Square button with icon") {
                    HStack(spacing: 12) {
                        ARCButton(icon: "plus") {}
                        ARCButton(icon: "heart.fill", configuration: .destructive) {}
                        ARCButton(icon: "square.and.arrow.up", configuration: .secondary) {}
                        ARCButton(icon: "ellipsis", configuration: .ghost) {}
                    }
                }
            }
        }
    }

    // MARK: - States Section

    private var statesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Button States", subtitle: "Normal, loading, and disabled")

            VStack(spacing: 12) {
                styleRow("Normal", description: "Default interactive state") {
                    ARCButton("Tap Me") {}
                }

                styleRow("Loading", description: "Shows progress indicator") {
                    HStack(spacing: 12) {
                        ARCButton("Save", isLoading: $isLoading1) {
                            simulateLoading($isLoading1)
                        }

                        ARCButton(
                            "Submit",
                            isLoading: $isLoading2,
                            configuration: .secondary
                        ) {
                            simulateLoading($isLoading2)
                        }

                        ARCButton(
                            icon: "arrow.clockwise",
                            isLoading: $isLoading3
                        ) {
                            simulateLoading($isLoading3)
                        }
                    }
                }

                styleRow("Disabled", description: "Non-interactive state") {
                    HStack(spacing: 12) {
                        ARCButton(
                            "Disabled",
                            configuration: ARCButtonConfiguration(isDisabled: true)
                        ) {}

                        ARCButton(
                            "Disabled",
                            configuration: ARCButtonConfiguration(
                                style: .outlined,
                                isDisabled: true
                            )
                        ) {}
                    }
                }
            }
        }
    }

    // MARK: - Full Width Section

    private var fullWidthSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Full Width", subtitle: "Buttons that span container width")

            VStack(spacing: 12) {
                ARCButton(
                    "Continue",
                    configuration: ARCButtonConfiguration(isFullWidth: true)
                ) {}

                ARCButton(
                    "Get Started",
                    icon: "arrow.right",
                    iconPosition: .trailing,
                    configuration: ARCButtonConfiguration(
                        size: .large,
                        isFullWidth: true
                    )
                ) {}

                ARCButton(
                    "Learn More",
                    configuration: ARCButtonConfiguration(
                        style: .outlined,
                        isFullWidth: true
                    )
                ) {}
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Glass Section

    private var glassSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Glass Style", subtitle: "Liquid glass effect for floating UI")

            ZStack {
                LinearGradient(
                    colors: [.purple, .blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(spacing: 16) {
                    ARCButton("Glass Button", configuration: .glass) {}

                    ARCButton(
                        "Apply Filter",
                        icon: "slider.horizontal.3",
                        configuration: .glass
                    ) {}

                    HStack(spacing: 12) {
                        ARCButton(icon: "heart.fill", configuration: .glass) {}
                        ARCButton(icon: "bookmark.fill", configuration: .glass) {}
                        ARCButton(icon: "square.and.arrow.up", configuration: .glass) {}
                    }
                }
                .padding(24)
            }
            .frame(height: 200)
        }
    }

    // MARK: - Semantic Section

    private var semanticSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Semantic Presets", subtitle: "Pre-configured button styles")

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        ARCButton("Primary", configuration: .primary) {}
                        Text(".primary").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCButton("Secondary", configuration: .secondary) {}
                        Text(".secondary").font(.caption2).foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        ARCButton("Destructive", configuration: .destructive) {}
                        Text(".destructive").font(.caption2).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        ARCButton("Ghost", configuration: .ghost) {}
                        Text(".ghost").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func styleRow(
        _ title: String,
        description: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    private func simulateLoading(_ binding: Binding<Bool>) {
        binding.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            binding.wrappedValue = false
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCButtonShowcase()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCButtonShowcase()
    }
    .preferredColorScheme(.dark)
}
