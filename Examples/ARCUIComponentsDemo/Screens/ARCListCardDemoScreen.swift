//
//  ARCListCardDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for ARCListCard component.
///
/// Shows list cards with various configurations and content types.
struct ARCListCardDemoScreen: View {
    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Basic Cards
                basicCardsSection

                // With Images
                imageCardsSection

                // With Accessories
                accessoryCardsSection

                // Configurations
                configurationsSection
            }
            .padding()
        }
        .navigationTitle("ARCListCard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: Sections

    private var basicCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Cards")
                .font(.headline)

            ARCListCard(
                title: "Simple Card",
                subtitle: "With a subtitle"
            )

            ARCListCard(
                title: "Card with Action",
                subtitle: "Tap to interact",
                action: {
                    print("Card tapped")
                }
            )

            ARCListCard(
                title: "Card with Chevron",
                subtitle: "Shows navigation indicator",
                accessories: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
            )
        }
    }

    private var imageCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("With Images")
                .font(.headline)

            ARCListCard(
                image: .system("star.fill", color: .yellow, size: 44),
                title: "System Image",
                subtitle: "Using SF Symbols"
            )

            ARCListCard(
                image: .url(
                    URL(string: "https://picsum.photos/100")!,
                    size: 60
                ),
                title: "Remote Image",
                subtitle: "Loaded from URL"
            )
        }
    }

    private var accessoryCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("With Accessories")
                .font(.headline)

            ARCListCard(
                image: .system("bell.fill", color: .blue, size: 44),
                title: "With Badge",
                subtitle: "Shows a notification count",
                accessories: {
                    Text("5")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            )

            ARCListCard(
                image: .system("moon.fill", color: .purple, size: 44),
                title: "With Toggle",
                subtitle: "Interactive accessory",
                accessories: {
                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                }
            )
        }
    }

    private var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configurations")
                .font(.headline)

            ARCListCard(
                configuration: .default,
                title: "Default Style",
                subtitle: "Standard configuration"
            )

            ARCListCard(
                configuration: .prominent,
                title: "Prominent Style",
                subtitle: "More visual emphasis"
            )

            ARCListCard(
                configuration: .subtle,
                title: "Subtle Style",
                subtitle: "Minimal styling"
            )
        }
    }
}

#Preview {
    NavigationStack {
        ARCListCardDemoScreen()
    }
}
