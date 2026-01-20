//
//  DemoHomeView.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Main navigation view for the ARCUIComponents demo.
///
/// Provides access to different component showcases organized by category.
struct DemoHomeView: View {
    // MARK: Body

    var body: some View {
        NavigationStack {
            List {
                componentsSection
                effectsSection
                showcasesSection
                aboutSection
            }
            .navigationTitle("ARCUIComponents")
            .listStyle(.insetGrouped)
            .tint(.arcBrandBurgundy)
        }
    }
}

// MARK: - Private Views

extension DemoHomeView {
    private var componentsSection: some View {
        Section {
            NavigationLink {
                ARCMenuDemoScreen()
            } label: {
                Label("ARCMenu", systemImage: "list.bullet.rectangle")
            }

            NavigationLink {
                ARCFavoriteButtonDemoScreen()
            } label: {
                Label("ARCFavoriteButton", systemImage: "heart.fill")
            }

            NavigationLink {
                ARCListCardDemoScreen()
            } label: {
                Label("ARCListCard", systemImage: "rectangle.stack")
            }

            NavigationLink {
                ARCEmptyStateDemoScreen()
            } label: {
                Label("ARCEmptyState", systemImage: "tray")
            }

            if #available(iOS 18.0, *) {
                NavigationLink {
                    ARCTabViewDemoScreen()
                } label: {
                    Label("ARCTabView", systemImage: "rectangle.split.3x1")
                }
            }
        } header: {
            Text("Components")
        } footer: {
            Text("Tap to explore each component with interactive examples.")
        }
    }

    private var effectsSection: some View {
        Section {
            NavigationLink {
                LiquidGlassDemoScreen()
            } label: {
                Label("Liquid Glass Effect", systemImage: "drop.fill")
            }

            NavigationLink {
                ThematicArtworkDemoScreen()
            } label: {
                Label("Thematic Artwork", systemImage: "paintbrush.fill")
            }
        } header: {
            Text("Effects")
        } footer: {
            Text("Visual effects and modifiers.")
        }
    }

    private var showcasesSection: some View {
        Section {
            NavigationLink {
                ARCMenuShowcase()
            } label: {
                Label("ARCMenu Showcase", systemImage: "sparkles.rectangle.stack")
            }

            NavigationLink {
                ARCListCardShowcase()
            } label: {
                Label("List Card Showcase", systemImage: "list.bullet.rectangle.portrait")
            }

            NavigationLink {
                ARCEmptyStateShowcase()
            } label: {
                Label("Empty State Showcase", systemImage: "tray.circle")
            }

            NavigationLink {
                LiquidGlassShowcase()
            } label: {
                Label("Liquid Glass Showcase", systemImage: "drop.circle")
            }
        } header: {
            Text("Full Showcases")
        } footer: {
            Text("Comprehensive showcases with all variants and configurations.")
        }
    }

    private var aboutSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image("ARC_Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("ARCUIComponents")
                            .font(.headline)
                            .foregroundStyle(Color.arcBrandBurgundy)

                        Text("Version \(ARCUIComponents.version)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Text("Premium UI components for iOS following Apple's Human Interface Guidelines.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.arcBrandBurgundy)
                        .frame(width: 8, height: 8)
                    Circle()
                        .fill(Color.arcBrandGold)
                        .frame(width: 8, height: 8)
                    Circle()
                        .fill(Color.arcBrandBlack)
                        .frame(width: 8, height: 8)
                    Spacer()
                    Text("ARC Labs Studio")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("About")
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    DemoHomeView()
}

#Preview("Dark Mode") {
    DemoHomeView()
        .preferredColorScheme(.dark)
}
