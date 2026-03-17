//
//  ExampleArtwork.swift
//  ARCUIComponentsDemoApp
//
//  Created by ARC Labs Studio on 1/20/26.
//

import ARCUIComponents
import SwiftUI

// MARK: - ExampleArtwork

/// Example artwork type demonstrating how to implement `ArtworkTypeProtocol`.
///
/// This enum showcases the basic structure for creating custom artwork types.
/// Use this as a reference for implementing artwork in your own apps.
enum ExampleArtwork: String, ArtworkTypeProtocol, CaseIterable {

    /// A circular pattern artwork.
    case circles

    /// A card-like rectangular pattern.
    case card

    /// A starburst pattern.
    case starburst

    // MARK: - ArtworkTypeProtocol

    var theme: ArtworkTheme {
        switch self {
        case .circles:
            return .warm
        case .card:
            return .cool
        case .starburst:
            return .nature
        }
    }

    var recommendedConfiguration: ArtworkConfiguration {
        switch self {
        case .circles, .starburst:
            return .circular
        case .card:
            return .card
        }
    }

    @ViewBuilder
    func makeContent(dimension: CGFloat) -> some View {
        switch self {
        case .circles:
            CirclesArtworkContent(dimension: dimension, theme: theme)
        case .card:
            CardArtworkContent(dimension: dimension, theme: theme)
        case .starburst:
            StarburstArtworkContent(dimension: dimension, theme: theme)
        }
    }

    // MARK: - Display

    var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - CirclesArtworkContent

/// Content view for the circles artwork style.
private struct CirclesArtworkContent: View {

    let dimension: CGFloat
    let theme: ArtworkTheme

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [theme.primaryColor, theme.primaryColor.opacity(0.6)],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.5
                    )
                )

            CircularDecoration(
                count: 8,
                radius: 0.3,
                dimension: dimension
            ) { index, dim in
                let color = index.isMultiple(of: 2)
                    ? theme.secondaryColor
                    : theme.accentColors.first ?? theme.secondaryColor

                return DecorationElement.circle(
                    color: color,
                    diameter: dim * 0.12,
                    opacity: 0.8
                )
            }

            Circle()
                .fill(theme.secondaryColor.opacity(0.8))
                .frame(width: dimension * 0.2, height: dimension * 0.2)
        }
        .frame(width: dimension, height: dimension)
    }
}

// MARK: - CardArtworkContent

/// Content view for the card artwork style.
private struct CardArtworkContent: View {

    let dimension: CGFloat
    let theme: ArtworkTheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.08)
                .fill(
                    LinearGradient(
                        colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: dimension * 0.06) {
                RoundedRectangle(cornerRadius: dimension * 0.02)
                    .fill(theme.secondaryColor.opacity(0.5))
                    .frame(height: dimension * 0.25)
                    .padding(.horizontal, dimension * 0.1)

                LinearDecoration(
                    lineCount: 3,
                    dimension: dimension,
                    color: theme.secondaryColor.opacity(0.4),
                    spacing: 0.08,
                    startOffset: 0.1
                )
            }

            RoundedRectangle(cornerRadius: dimension * 0.08)
                .strokeBorder(theme.secondaryColor.opacity(0.3), lineWidth: dimension * 0.02)
        }
        .frame(width: dimension, height: dimension)
    }
}

// MARK: - StarburstArtworkContent

/// Content view for the starburst artwork style.
private struct StarburstArtworkContent: View {

    let dimension: CGFloat
    let theme: ArtworkTheme

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [theme.primaryColor.opacity(0.9), theme.primaryColor.opacity(0.5)],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.5
                    )
                )

            ForEach(0..<12, id: \.self) { index in
                Capsule()
                    .fill(theme.secondaryColor.opacity(0.7))
                    .frame(width: dimension * 0.04, height: dimension * 0.35)
                    .offset(y: -dimension * 0.15)
                    .rotationEffect(.degrees(Double(index) * 30))
            }

            Circle()
                .fill(theme.accentColors.first ?? theme.secondaryColor)
                .frame(width: dimension * 0.25, height: dimension * 0.25)

            Circle()
                .fill(theme.primaryColor.opacity(0.9))
                .frame(width: dimension * 0.12, height: dimension * 0.12)
        }
        .frame(width: dimension, height: dimension)
    }
}
