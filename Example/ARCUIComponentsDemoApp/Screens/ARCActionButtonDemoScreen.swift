//
//  ARCActionButtonDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCActionButton component.
///
/// Shows action buttons with various styles, sizes, loading states, and interactive examples.
@available(iOS 17.0, *)
struct ARCActionButtonDemoScreen: View {
    // MARK: - State

    @State private var isSaving = false
    @State private var isSubmitting = false
    @State private var isDeleting = false
    @State private var actionCount = 0

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                stylesSection
                sizesSection
                iconSection
                loadingSection
                interactiveSection
                fullWidthSection
            }
            .padding()
        }
        .navigationTitle("ARCActionButton")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCActionButtonDemoScreen {
    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Button Styles", subtitle: "Different visual treatments")

            VStack(spacing: 12) {
                styleRow("Primary", description: "High emphasis CTA") {
                    ARCActionButton("Get Started", configuration: .primary) {}
                }

                styleRow("Secondary", description: "Medium emphasis") {
                    ARCActionButton("Learn More", configuration: .secondary) {}
                }

                styleRow("Destructive", description: "Dangerous actions") {
                    ARCActionButton("Delete Account", configuration: .destructive) {}
                }

                styleRow("Ghost", description: "Low emphasis") {
                    ARCActionButton("Skip", configuration: .ghost) {}
                }
            }
        }
    }

    // MARK: - Sizes Section

    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Button Sizes", subtitle: "Small, Medium, Large")

            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    ARCActionButton("Small", configuration: .small) {}
                    Text("32pt").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCActionButton("Medium") {}
                    Text("44pt").font(.caption2).foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    ARCActionButton("Large", configuration: .large) {}
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
            sectionHeader("With Icons", subtitle: "SF Symbols integration")

            VStack(spacing: 12) {
                styleRow("Leading Icon", description: "Icon before text") {
                    ARCActionButton("Add to Cart", icon: "cart.fill") {}
                }

                styleRow("Trailing Icon", description: "Icon after text") {
                    ARCActionButton("Continue", icon: "arrow.right", iconPosition: .trailing) {}
                }

                styleRow("Icon Only", description: "Compact square buttons") {
                    HStack(spacing: 12) {
                        ARCActionButton(icon: "plus") {}
                        ARCActionButton(icon: "heart.fill", configuration: .destructive) {}
                        ARCActionButton(icon: "square.and.arrow.up", configuration: .secondary) {}
                        ARCActionButton(icon: "ellipsis", configuration: .ghost) {}
                    }
                }
            }
        }
    }

    // MARK: - Loading Section

    private var loadingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Loading States", subtitle: "Async action feedback")

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    ARCActionButton("Save", isLoading: $isSaving) {
                        simulateAction($isSaving)
                    }

                    ARCActionButton(
                        "Submit",
                        isLoading: $isSubmitting,
                        configuration: .secondary
                    ) {
                        simulateAction($isSubmitting)
                    }

                    ARCActionButton(
                        "Delete",
                        isLoading: $isDeleting,
                        configuration: .destructive
                    ) {
                        simulateAction($isDeleting)
                    }
                }
                .frame(maxWidth: .infinity)

                Text("Tap any button to see loading state")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Interactive Section

    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Interactive Demo", subtitle: "Buttons with real actions")

            VStack(spacing: 16) {
                HStack {
                    Text("Action Count:")
                        .font(.body.weight(.medium))
                    Spacer()
                    Text("\(actionCount)")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.arcBrandBurgundy)
                }

                HStack(spacing: 12) {
                    ARCActionButton("Increment", icon: "plus") {
                        withAnimation {
                            actionCount += 1
                        }
                    }

                    ARCActionButton(
                        "Decrement",
                        icon: "minus",
                        configuration: .secondary
                    ) {
                        withAnimation {
                            if actionCount > 0 {
                                actionCount -= 1
                            }
                        }
                    }

                    ARCActionButton(
                        "Reset",
                        icon: "arrow.counterclockwise",
                        configuration: .ghost
                    ) {
                        withAnimation {
                            actionCount = 0
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Full Width Section

    private var fullWidthSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Full Width Buttons", subtitle: "Span container width")

            VStack(spacing: 12) {
                ARCActionButton(
                    "Continue to Checkout",
                    icon: "cart",
                    configuration: ARCActionButtonConfiguration(isFullWidth: true)
                ) {}

                ARCActionButton(
                    "Create Account",
                    icon: "person.badge.plus",
                    configuration: ARCActionButtonConfiguration(
                        size: .large,
                        isFullWidth: true
                    )
                ) {}

                ARCActionButton(
                    "Already have an account? Sign In",
                    configuration: ARCActionButtonConfiguration(
                        style: .ghost,
                        isFullWidth: true
                    )
                ) {}
            }
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
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

    private func simulateAction(_ binding: Binding<Bool>) {
        binding.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            binding.wrappedValue = false
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCActionButtonDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCActionButtonDemoScreen()
    }
    .preferredColorScheme(.dark)
}
