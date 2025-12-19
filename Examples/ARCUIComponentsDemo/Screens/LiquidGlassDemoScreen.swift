//
//  LiquidGlassDemoScreen.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

/// Demo screen for Liquid Glass effect.
///
/// Shows the glassmorphism effect with various backgrounds and configurations.
@available(iOS 17.0, *)
struct LiquidGlassDemoScreen: View {
    // MARK: Properties

    @State private var backgroundStyle: BackgroundStyleOption = .gradient

    // MARK: Body

    var body: some View {
        ZStack {
            // Dynamic Background
            backgroundView
                .ignoresSafeArea()

            // Content with Liquid Glass
            ScrollView {
                VStack(spacing: 24) {
                    // Background Picker
                    backgroundPicker

                    // Glass Card Demo
                    glassCardDemo

                    // Multiple Cards
                    multipleCardsDemo

                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .navigationTitle("Liquid Glass")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: Background

    @ViewBuilder private var backgroundView: some View {
        switch backgroundStyle {
        case .gradient:
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .image:
            AsyncImage(url: URL(string: "https://picsum.photos/800/1200")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }

        case .solid:
            Color.indigo

        case .animated:
            TimelineView(.animation) { timeline in
                let phase = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 10) / 10
                LinearGradient(
                    colors: [
                        Color(hue: phase, saturation: 0.8, brightness: 0.9),
                        Color(hue: (phase + 0.3).truncatingRemainder(dividingBy: 1), saturation: 0.8, brightness: 0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    // MARK: Sections

    private var backgroundPicker: some View {
        VStack(spacing: 8) {
            Text("Background")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))

            Picker("Background", selection: $backgroundStyle) {
                ForEach(BackgroundStyleOption.allCases) { style in
                    Text(style.name).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var glassCardDemo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Liquid Glass Effect")
                .font(.title2.bold())

            Text(
                "This card uses the liquid glass modifier to create a premium glassmorphism effect. Notice how it blurs and tints the background while maintaining readability."
            )
            .font(.body)
            .foregroundStyle(.secondary)

            HStack {
                Label("Premium Feel", systemImage: "sparkles")
                Spacer()
                Label("iOS Native", systemImage: "apple.logo")
            }
            .font(.caption)
            .foregroundStyle(.tertiary)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
    }

    private var multipleCardsDemo: some View {
        VStack(spacing: 16) {
            ForEach(0 ..< 3) { index in
                HStack(spacing: 16) {
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image(systemName: ["star.fill", "heart.fill", "bolt.fill"][index])
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading) {
                        Text(["Featured", "Popular", "Trending"][index])
                            .font(.headline)

                        Text("Card \(index + 1) description")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

// MARK: - Supporting Types

@available(iOS 17.0, *)
private enum BackgroundStyleOption: String, CaseIterable, Identifiable {
    case gradient
    case image
    case solid
    case animated

    var id: String { rawValue }

    var name: String {
        switch self {
        case .gradient: "Gradient"
        case .image: "Image"
        case .solid: "Solid"
        case .animated: "Animated"
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    NavigationStack {
        LiquidGlassDemoScreen()
    }
}
