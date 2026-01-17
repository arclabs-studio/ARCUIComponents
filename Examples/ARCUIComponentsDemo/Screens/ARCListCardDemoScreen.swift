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
                basicCardsSection
                imageCardsSection
                accessoryCardsSection
                configurationsSection
            }
            .padding()
        }
        .navigationTitle("ARCListCard")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Private Views

private extension ARCListCardDemoScreen {

    var basicCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Cards")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            ARCListCard(
                title: "Simple Card",
                subtitle: "With a subtitle"
            )

            ARCListCard(
                title: "Card with Action",
                subtitle: "Tap to interact",
                action: {}
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

    var imageCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("With Images")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            ARCListCard(
                image: .system("a.square.fill", color: .arcBrandBurgundy, size: 50),
                title: "ARC Labs Studio",
                subtitle: "Premium UI Components"
            )

            ARCListCard(
                image: .system("star.fill", color: .arcBrandGold, size: 44),
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

    var accessoryCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("With Accessories")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

            ARCListCard(
                image: .system("bell.fill", color: .arcBrandGold, size: 44),
                title: "With Badge",
                subtitle: "Shows a notification count",
                accessories: {
                    Text("5")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.arcBrandBurgundy)
                        .clipShape(Capsule())
                }
            )

            ARCListCard(
                image: .system("moon.fill", color: .arcBrandBurgundy, size: 44),
                title: "With Toggle",
                subtitle: "Interactive accessory",
                accessories: {
                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                        .tint(.arcBrandGold)
                }
            )
        }
    }

    var configurationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configurations")
                .font(.headline)
                .foregroundStyle(Color.arcBrandBurgundy)

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

// MARK: - Previews

#Preview("Light Mode") {
    NavigationStack {
        ARCListCardDemoScreen()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ARCListCardDemoScreen()
    }
    .preferredColorScheme(.dark)
}
