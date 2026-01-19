//
//  ArtworkRenderer.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - ArtworkRenderer

/// Internal view that renders artwork layers based on type.
struct ArtworkRenderer: View {

    // MARK: - Properties

    let type: ArtworkType
    let dimension: CGFloat

    private var theme: ArtworkTheme { type.theme }

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundLayer
            decorationLayer
            overlayLayer
        }
        .frame(width: dimension, height: dimension)
    }

    // MARK: - Background Layer

    @ViewBuilder
    private var backgroundLayer: some View {
        switch type {
        case .food(let style):
            foodBackground(style: style)
        case .book(let style):
            bookBackground(style: style)
        }
    }

    // MARK: - Decoration Layer

    @ViewBuilder
    private var decorationLayer: some View {
        switch type {
        case .food(let style):
            foodDecorations(style: style)
        case .book(let style):
            bookDecorations(style: style)
        }
    }

    // MARK: - Overlay Layer

    @ViewBuilder
    private var overlayLayer: some View {
        switch type {
        case .food(let style):
            foodOverlay(style: style)
        case .book(let style):
            bookOverlay(style: style)
        }
    }
}

// MARK: - Food Backgrounds

private extension ArtworkRenderer {

    @ViewBuilder
    func foodBackground(style: ArtworkType.FoodStyle) -> some View {
        switch style {
        case .pizza:
            pizzaBackground
        case .sushi:
            sushiBackground
        case .taco:
            tacoBackground
        }
    }

    var pizzaBackground: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            theme.primaryColor.opacity(0.95),
                            theme.primaryColor.opacity(0.55)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.65
                    )
                )

            Circle()
                .strokeBorder(theme.backgroundColor.opacity(0.35), lineWidth: dimension * 0.05)
                .blur(radius: 0.6)
        }
    }

    var sushiBackground: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            theme.primaryColor.opacity(0.95),
                            theme.primaryColor.opacity(0.7)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.5
                    )
                )

            Circle()
                .strokeBorder(theme.secondaryColor.opacity(0.3), lineWidth: dimension * 0.03)
        }
    }

    var tacoBackground: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.gray.opacity(0.2)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.5
                    )
                )

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.primaryColor,
                            theme.primaryColor.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: dimension * 0.7, height: dimension * 0.35)
                .offset(y: dimension * 0.05)
        }
    }
}

// MARK: - Food Decorations

private extension ArtworkRenderer {

    @ViewBuilder
    func foodDecorations(style: ArtworkType.FoodStyle) -> some View {
        switch style {
        case .pizza:
            pizzaDecorations
        case .sushi:
            sushiDecorations
        case .taco:
            tacoDecorations
        }
    }

    var pizzaDecorations: some View {
        ZStack {
            CircularDecoration(
                count: 6,
                radius: 0.18,
                dimension: dimension
            ) { _, dim in
                DecorationElement.capsule(
                    color: theme.backgroundColor,
                    size: CGSize(width: dim * 0.12, height: dim * 0.52),
                    opacity: 0.85
                )
            }

            CircularDecoration(
                count: 16,
                radius: 0.34,
                dimension: dimension
            ) { index, dim in
                let color = index.isMultiple(of: 2)
                    ? theme.accentColors[safe: 0] ?? .red
                    : theme.accentColors[safe: 1] ?? .green

                return DecorationElement.circle(
                    color: color,
                    diameter: dim * 0.09,
                    blur: 0.4,
                    opacity: index.isMultiple(of: 2) ? 0.85 : 0.75
                )
            }
        }
    }

    var sushiDecorations: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                RoundedRectangle(cornerRadius: dimension * 0.02)
                    .fill(theme.secondaryColor.opacity(0.9))
                    .frame(width: dimension * 0.15, height: dimension * 0.35)
                    .offset(x: CGFloat(index - 1) * dimension * 0.22)
            }

            CircularDecoration(
                count: 6,
                radius: 0.32,
                dimension: dimension
            ) { index, dim in
                let color = index.isMultiple(of: 2)
                    ? theme.accentColors[safe: 0] ?? .orange
                    : theme.accentColors[safe: 1] ?? .green

                return DecorationElement.circle(
                    color: color,
                    diameter: dim * 0.12,
                    opacity: 0.9
                )
            }

            ForEach(0..<2, id: \.self) { index in
                Capsule()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.2))
                    .frame(width: dimension * 0.03, height: dimension * 0.7)
                    .rotationEffect(.degrees(index == 0 ? -15 : 15))
                    .offset(x: dimension * 0.35)
            }
        }
    }

    var tacoDecorations: some View {
        ZStack {
            tacoMeat
            tacoCilantro
            tacoOnion
            tacoSalsa
        }
    }

    private var tacoMeat: some View {
        ForEach(0..<4, id: \.self) { index in
            RoundedRectangle(cornerRadius: dimension * 0.02)
                .fill(theme.secondaryColor.opacity(0.85))
                .frame(width: dimension * 0.12, height: dimension * 0.08)
                .offset(
                    x: CGFloat(index - 2) * dimension * 0.12 + dimension * 0.06,
                    y: -dimension * 0.02
                )
                .rotationEffect(.degrees(tacoMeatRotation(for: index)))
        }
    }

    private var tacoCilantro: some View {
        ForEach(0..<8, id: \.self) { index in
            Circle()
                .fill((theme.accentColors[safe: 0] ?? .green).opacity(0.8))
                .frame(width: dimension * 0.04)
                .offset(
                    x: tacoCilantroOffset(for: index).x,
                    y: tacoCilantroOffset(for: index).y
                )
        }
    }

    private var tacoOnion: some View {
        ForEach(0..<6, id: \.self) { index in
            Circle()
                .fill((theme.accentColors[safe: 1] ?? .white).opacity(0.9))
                .frame(width: dimension * 0.035)
                .offset(
                    x: tacoOnionOffset(for: index).x,
                    y: tacoOnionOffset(for: index).y
                )
        }
    }

    private var tacoSalsa: some View {
        ForEach(0..<3, id: \.self) { index in
            Circle()
                .fill((theme.accentColors[safe: 2] ?? .red).opacity(0.7))
                .frame(width: dimension * 0.05)
                .offset(
                    x: CGFloat(index - 1) * dimension * 0.15,
                    y: dimension * 0.03
                )
                .blur(radius: 0.5)
        }
    }

    private func tacoMeatRotation(for index: Int) -> Double {
        let rotations = [-8.0, 5.0, -3.0, 7.0]
        return rotations[index % rotations.count]
    }

    private func tacoCilantroOffset(for index: Int) -> CGPoint {
        let xOffsets: [CGFloat] = [-0.18, -0.1, -0.02, 0.06, 0.14, 0.2, -0.14, 0.1]
        let yOffsets: [CGFloat] = [-0.06, 0.02, -0.08, 0.0, -0.04, 0.03, 0.05, -0.02]
        return CGPoint(
            x: xOffsets[index % xOffsets.count] * dimension,
            y: yOffsets[index % yOffsets.count] * dimension
        )
    }

    private func tacoOnionOffset(for index: Int) -> CGPoint {
        let xOffsets: [CGFloat] = [-0.15, -0.05, 0.05, 0.15, -0.1, 0.1]
        let yOffsets: [CGFloat] = [-0.03, 0.01, -0.05, 0.02, 0.04, -0.01]
        return CGPoint(
            x: xOffsets[index % xOffsets.count] * dimension,
            y: yOffsets[index % yOffsets.count] * dimension
        )
    }
}

// MARK: - Food Overlays

private extension ArtworkRenderer {

    @ViewBuilder
    func foodOverlay(style: ArtworkType.FoodStyle) -> some View {
        switch style {
        case .pizza:
            pizzaOverlay
        case .sushi:
            sushiOverlay
        case .taco:
            tacoOverlay
        }
    }

    var pizzaOverlay: some View {
        ZStack {
            Circle()
                .strokeBorder(theme.backgroundColor.opacity(0.5), lineWidth: dimension * 0.018)
                .blendMode(.overlay)

            Circle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: dimension * 0.65)
        }
    }

    var sushiOverlay: some View {
        Circle()
            .strokeBorder(Color.white.opacity(0.2), lineWidth: dimension * 0.01)
            .blendMode(.overlay)
    }

    var tacoOverlay: some View {
        Capsule()
            .fill(Color.white.opacity(0.15))
            .frame(width: dimension * 0.5, height: dimension * 0.05)
            .offset(y: -dimension * 0.08)
            .blendMode(.overlay)
    }
}

// MARK: - Book Backgrounds

private extension ArtworkRenderer {

    @ViewBuilder
    func bookBackground(style: ArtworkType.BookStyle) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(bookGradient(style: style))

            RoundedRectangle(cornerRadius: dimension * 0.02)
                .fill(bookSpineColor(style: style))
                .frame(width: dimension * 0.08)
                .offset(x: -dimension * 0.46)
        }
    }

    func bookGradient(style: ArtworkType.BookStyle) -> LinearGradient {
        switch style {
        case .noir:
            return LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .romance:
            return LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .horror:
            return LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    func bookSpineColor(style: ArtworkType.BookStyle) -> Color {
        switch style {
        case .noir:
            return theme.secondaryColor
        case .romance:
            return theme.secondaryColor.opacity(0.5)
        case .horror:
            return theme.secondaryColor.opacity(0.8)
        }
    }
}

// MARK: - Book Decorations

private extension ArtworkRenderer {

    @ViewBuilder
    func bookDecorations(style: ArtworkType.BookStyle) -> some View {
        switch style {
        case .noir:
            noirDecorations
        case .romance:
            romanceDecorations
        case .horror:
            horrorDecorations
        }
    }

    var noirDecorations: some View {
        ZStack {
            LinearDecoration(
                lineCount: 5,
                dimension: dimension,
                color: theme.secondaryColor.opacity(0.5),
                spacing: 0.06,
                startOffset: -0.1
            )

            Circle()
                .fill((theme.accentColors[safe: 0] ?? .red).opacity(0.7))
                .frame(width: dimension * 0.15)
                .offset(x: dimension * 0.25, y: dimension * 0.3)
                .blur(radius: 1)

            Path { path in
                path.move(to: CGPoint(x: dimension * 0.3, y: dimension * 0.6))
                path.addLine(to: CGPoint(x: dimension * 0.5, y: dimension * 0.55))
                path.addLine(to: CGPoint(x: dimension * 0.7, y: dimension * 0.65))
            }
            .stroke(theme.secondaryColor.opacity(0.4), lineWidth: 2)
        }
    }

    var romanceDecorations: some View {
        ZStack {
            HeartShape()
                .fill(theme.secondaryColor.opacity(0.8))
                .frame(width: dimension * 0.25, height: dimension * 0.25)
                .offset(y: -dimension * 0.1)

            romanceSmallHearts

            Path { path in
                path.move(to: CGPoint(x: dimension * 0.2, y: dimension * 0.7))
                path.addQuadCurve(
                    to: CGPoint(x: dimension * 0.8, y: dimension * 0.7),
                    control: CGPoint(x: dimension * 0.5, y: dimension * 0.5)
                )
            }
            .stroke((theme.accentColors[safe: 0] ?? .yellow).opacity(0.5), lineWidth: 2)
        }
    }

    private var romanceSmallHearts: some View {
        ForEach(0..<5, id: \.self) { index in
            HeartShape()
                .fill((theme.accentColors[safe: 1] ?? .pink).opacity(0.6))
                .frame(width: dimension * 0.08, height: dimension * 0.08)
                .offset(
                    x: romanceHeartOffset(for: index).x,
                    y: romanceHeartOffset(for: index).y
                )
                .rotationEffect(.degrees(romanceHeartRotation(for: index)))
        }
    }

    private func romanceHeartOffset(for index: Int) -> CGPoint {
        let xOffsets: [CGFloat] = [-0.25, 0.28, -0.15, 0.2, 0.0]
        let yOffsets: [CGFloat] = [-0.25, -0.2, 0.25, 0.3, 0.35]
        return CGPoint(
            x: xOffsets[index % xOffsets.count] * dimension,
            y: yOffsets[index % yOffsets.count] * dimension
        )
    }

    private func romanceHeartRotation(for index: Int) -> Double {
        let rotations = [-15.0, 20.0, -25.0, 10.0, -5.0]
        return rotations[index % rotations.count]
    }

    var horrorDecorations: some View {
        ZStack {
            horrorDrips
            horrorEyes
            horrorScratches
        }
    }

    private var horrorDrips: some View {
        ForEach(0..<4, id: \.self) { index in
            Capsule()
                .fill((theme.accentColors[safe: 0] ?? .green).opacity(0.7))
                .frame(
                    width: dimension * 0.04,
                    height: dimension * horrorDripHeight(for: index)
                )
                .offset(
                    x: horrorDripXOffset(for: index),
                    y: -dimension * 0.35
                )
                .blur(radius: 0.5)
        }
    }

    private var horrorEyes: some View {
        HStack(spacing: dimension * 0.15) {
            horrorEye
            horrorEye
        }
        .offset(y: dimension * 0.05)
    }

    private var horrorEye: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: dimension * 0.12, height: dimension * 0.12)

            Circle()
                .fill((theme.accentColors[safe: 1] ?? .red).opacity(0.9))
                .frame(width: dimension * 0.06, height: dimension * 0.06)
        }
    }

    private var horrorScratches: some View {
        ForEach(0..<3, id: \.self) { index in
            Path { path in
                let startX = dimension * (0.55 + Double(index) * 0.08)
                let startY = dimension * 0.5
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: startX + dimension * 0.1, y: startY + dimension * 0.2))
            }
            .stroke((theme.accentColors[safe: 1] ?? .red).opacity(0.5), lineWidth: 2)
        }
    }

    private func horrorDripHeight(for index: Int) -> CGFloat {
        let heights: [CGFloat] = [0.15, 0.22, 0.12, 0.18]
        return heights[index % heights.count]
    }

    private func horrorDripXOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-0.25, -0.1, 0.1, 0.25]
        return offsets[index % offsets.count] * dimension
    }
}

// MARK: - Book Overlays

private extension ArtworkRenderer {

    @ViewBuilder
    func bookOverlay(style: ArtworkType.BookStyle) -> some View {
        switch style {
        case .noir:
            noirOverlay
        case .romance:
            romanceOverlay
        case .horror:
            horrorOverlay
        }
    }

    var noirOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .strokeBorder(
                    LinearGradient(
                        colors: [theme.secondaryColor.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: dimension * 0.02
                )

            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(Color.white.opacity(0.03))
                .blendMode(.overlay)
        }
    }

    var romanceOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .strokeBorder(
                    (theme.accentColors[safe: 0] ?? .yellow).opacity(0.4),
                    lineWidth: dimension * 0.015
                )

            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(Color.white.opacity(0.05))
                .blendMode(.overlay)
        }
    }

    var horrorOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: dimension * 0.05)
                .strokeBorder(
                    (theme.accentColors[safe: 1] ?? .red).opacity(0.3),
                    lineWidth: dimension * 0.015
                )

            RoundedRectangle(cornerRadius: dimension * 0.05)
                .fill(
                    RadialGradient(
                        colors: [.clear, theme.primaryColor.opacity(0.5)],
                        center: .center,
                        startRadius: 0,
                        endRadius: dimension * 0.7
                    )
                )
                .blendMode(.multiply)
        }
    }
}

// MARK: - Array Extension

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
