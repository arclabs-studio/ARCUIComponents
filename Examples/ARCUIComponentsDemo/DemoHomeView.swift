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
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Components Section

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
                        ARCSearchButtonDemoScreen()
                    } label: {
                        Label("ARCSearchButton", systemImage: "magnifyingglass")
                    }

                    NavigationLink {
                        ARCEmptyStateDemoScreen()
                    } label: {
                        Label("ARCEmptyState", systemImage: "tray")
                    }
                } header: {
                    Text("Components")
                } footer: {
                    Text("Tap to explore each component with interactive examples.")
                }

                // MARK: - Effects Section

                Section {
                    NavigationLink {
                        LiquidGlassDemoScreen()
                    } label: {
                        Label("Liquid Glass Effect", systemImage: "drop.fill")
                    }
                } header: {
                    Text("Effects")
                } footer: {
                    Text("Visual effects and modifiers.")
                }

                // MARK: - Showcases Section

                Section {
                    NavigationLink {
                        ARCMenuShowcase()
                    } label: {
                        Label("ARCMenu Showcase", systemImage: "sparkles.rectangle.stack")
                    }

                    NavigationLink {
                        ARCFavoriteButtonShowcase()
                    } label: {
                        Label("Favorite Button Showcase", systemImage: "sparkles")
                    }

                    NavigationLink {
                        ARCListCardShowcase()
                    } label: {
                        Label("List Card Showcase", systemImage: "list.bullet.rectangle.portrait")
                    }

                    NavigationLink {
                        ARCSearchButtonShowcase()
                    } label: {
                        Label("Search Button Showcase", systemImage: "magnifyingglass.circle")
                    }

                    NavigationLink {
                        ARCEmptyStateShowcase()
                    } label: {
                        Label("Empty State Showcase", systemImage: "tray.circle")
                    }
                } header: {
                    Text("Full Showcases")
                } footer: {
                    Text("Comprehensive showcases with all variants and configurations.")
                }

                // MARK: - Info Section

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ARCUIComponents")
                            .font(.headline)

                        Text("Version \(ARCUIComponents.version)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Premium UI components for iOS following Apple's Human Interface Guidelines.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("ARCUIComponents")
        }
    }
}

#Preview {
    DemoHomeView()
}
