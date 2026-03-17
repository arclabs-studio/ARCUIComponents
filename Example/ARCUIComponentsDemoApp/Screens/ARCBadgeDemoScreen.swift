//
//  ARCBadgeDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 22/1/26.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCBadge component.
///
/// Shows badge notifications with various content types, styles, and overlay usage.
@available(iOS 17.0, *)
struct ARCBadgeDemoScreen: View {
    // MARK: - State

    @State private var notificationCount = 5
    @State private var messageCount = 12
    @State private var cartCount = 3

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                contentTypesSection
                stylesSection
                overlayDemoSection
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

// MARK: - Private Views

@available(iOS 17.0, *)
extension ARCBadgeDemoScreen {
    // MARK: - Content Types Section

    private var contentTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Content Types", subtitle: "Count, text, and dot badges")

            VStack(spacing: 16) {
                contentRow("Count Badge", description: "Shows numeric counts") {
                    HStack(spacing: 20) {
                        ARCBadge(1)
                        ARCBadge(42)
                        ARCBadge(99)
                        ARCBadge(150)
                    }
                }

                contentRow("Text Badge", description: "Shows text labels") {
                    HStack(spacing: 16) {
                        ARCBadge("NEW")
                        ARCBadge("SALE")
                        ARCBadge("PRO")
                    }
                }

                contentRow("Dot Badge", description: "Simple status indicators") {
                    HStack(spacing: 24) {
                        VStack(spacing: 4) {
                            ARCBadge(dot: .default)
                            Text("Default").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCBadge(dot: .success)
                            Text("Success").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCBadge(dot: .warning)
                            Text("Warning").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 4) {
                            ARCBadge(dot: .info)
                            Text("Info").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private func contentRow(
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

    // MARK: - Styles Section

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Badge Styles", subtitle: "Different visual treatments")

            VStack(spacing: 16) {
                styleRow("Filled", description: "Solid background") {
                    HStack(spacing: 16) {
                        ARCBadge(5, configuration: .default)
                        ARCBadge(5, configuration: .success)
                        ARCBadge(5, configuration: .warning)
                        ARCBadge(5, configuration: .info)
                    }
                }

                styleRow("Outlined", description: "Border only") {
                    HStack(spacing: 16) {
                        ARCBadge(5, configuration: .outlined)
                        ARCBadge(5, configuration: .init(style: .outlined(.green)))
                        ARCBadge(5, configuration: .init(style: .outlined(.orange)))
                    }
                }

                styleRow("Subtle", description: "Tinted background") {
                    HStack(spacing: 16) {
                        ARCBadge(5, configuration: .subtle)
                        ARCBadge(5, configuration: .init(style: .subtle(.green)))
                        ARCBadge(5, configuration: .init(style: .subtle(.blue)))
                    }
                }
            }
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

    // MARK: - Overlay Demo Section

    private var overlayDemoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Badge Overlays", subtitle: "Attach badges to icons")

            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Image(systemName: "bell")
                        .font(.largeTitle)
                        .arcBadge(count: notificationCount)
                    Text("Notifications")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    Image(systemName: "envelope")
                        .font(.largeTitle)
                        .arcBadge(count: messageCount, configuration: .info)
                    Text("Messages")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    Image(systemName: "cart")
                        .font(.largeTitle)
                        .arcBadge(text: "NEW", configuration: .success)
                    Text("Cart")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    Image(systemName: "person.circle")
                        .font(.largeTitle)
                        .arcBadgeDot(configuration: .success)
                    Text("Status")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Interactive Section

    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Interactive Demo", subtitle: "Control badge counts")

            VStack(spacing: 20) {
                // Notifications stepper
                HStack {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .arcBadge(count: notificationCount)

                    Text("Notifications")
                        .padding(.leading, 8)

                    Spacer()

                    Stepper("", value: $notificationCount, in: 0 ... 150)
                        .labelsHidden()
                }

                // Messages stepper
                HStack {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                        .arcBadge(count: messageCount, configuration: .info)

                    Text("Messages")
                        .padding(.leading, 8)

                    Spacer()

                    Stepper("", value: $messageCount, in: 0 ... 150)
                        .labelsHidden()
                }

                // Cart stepper
                HStack {
                    Image(systemName: "cart.fill")
                        .font(.title2)
                        .arcBadge(count: cartCount, configuration: .success)

                    Text("Cart Items")
                        .padding(.leading, 8)

                    Spacer()

                    Stepper("", value: $cartCount, in: 0 ... 150)
                        .labelsHidden()
                }

                Divider()

                // Reset button
                Button {
                    withAnimation {
                        notificationCount = 5
                        messageCount = 12
                        cartCount = 3
                    }
                } label: {
                    Text("Reset All")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.arcBrandBurgundy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.arcBrandBurgundy.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
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

// MARK: - Previews

@available(iOS 17.0, *)
#Preview("Light Mode") {
    NavigationStack {
        ARCBadgeDemoScreen()
    }
}

@available(iOS 17.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCBadgeDemoScreen()
    }
    .preferredColorScheme(.dark)
}
