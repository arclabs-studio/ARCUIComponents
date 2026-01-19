//
//  LinearDecoration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - LinearDecoration

/// A view that creates horizontal lines to simulate text or content.
///
/// Use `LinearDecoration` for book covers or document-style artworks
/// where you need to represent text blocks with decorative lines.
///
/// ## Example Usage
/// ```swift
/// LinearDecoration(
///     lineCount: 5,
///     dimension: 200,
///     color: .gray.opacity(0.5)
/// )
/// ```
public struct LinearDecoration: View {

    // MARK: - Properties

    /// The number of lines to render.
    public let lineCount: Int

    /// The reference dimension for sizing.
    public let dimension: CGFloat

    /// The color of the lines.
    public let color: Color

    /// The spacing between lines as a proportion of dimension.
    public let spacing: CGFloat

    /// The vertical start offset as a proportion of dimension.
    public let startOffset: CGFloat

    /// Whether line widths should vary randomly.
    public let randomizeWidths: Bool

    /// The base width proportion for lines (0-1).
    public let baseWidth: CGFloat

    /// The random variation range for widths.
    public let widthVariation: CGFloat

    // MARK: - Initialization

    /// Creates a linear decoration layout.
    ///
    /// - Parameters:
    ///   - lineCount: The number of horizontal lines.
    ///   - dimension: The reference dimension for sizing.
    ///   - color: The color of the lines.
    ///   - spacing: Spacing between lines as proportion of dimension. Defaults to `0.08`.
    ///   - startOffset: Vertical start offset as proportion. Defaults to `0.25`.
    ///   - randomizeWidths: Whether to vary line widths. Defaults to `true`.
    ///   - baseWidth: Base width proportion (0-1). Defaults to `0.5`.
    ///   - widthVariation: Random width variation range. Defaults to `0.3`.
    public init(
        lineCount: Int,
        dimension: CGFloat,
        color: Color,
        spacing: CGFloat = 0.08,
        startOffset: CGFloat = 0.25,
        randomizeWidths: Bool = true,
        baseWidth: CGFloat = 0.5,
        widthVariation: CGFloat = 0.3
    ) {
        self.lineCount = lineCount
        self.dimension = dimension
        self.color = color
        self.spacing = spacing
        self.startOffset = startOffset
        self.randomizeWidths = randomizeWidths
        self.baseWidth = baseWidth
        self.widthVariation = widthVariation
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: dimension * spacing) {
            ForEach(0..<lineCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(
                        width: lineWidth(for: index),
                        height: dimension * 0.025
                    )
            }
        }
        .offset(y: dimension * startOffset)
    }

    // MARK: - Private

    private func lineWidth(for index: Int) -> CGFloat {
        if randomizeWidths {
            let seed = Double(index * 17 + 7)
            let pseudoRandom = (sin(seed) + 1) / 2
            return dimension * (baseWidth + widthVariation * pseudoRandom)
        } else {
            return dimension * baseWidth
        }
    }
}

// MARK: - Preview

#Preview("Text Lines") {
    ZStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 150, height: 220)

        LinearDecoration(
            lineCount: 5,
            dimension: 150,
            color: .gray.opacity(0.5),
            startOffset: -0.1
        )
    }
    .padding()
}

#Preview("Uniform Lines") {
    ZStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 150, height: 220)

        LinearDecoration(
            lineCount: 4,
            dimension: 150,
            color: .gray.opacity(0.5),
            spacing: 0.1,
            startOffset: 0,
            randomizeWidths: false,
            baseWidth: 0.6
        )
    }
    .padding()
}

#Preview("Book Style") {
    ZStack {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(red: 0.15, green: 0.15, blue: 0.18))
            .frame(width: 130, height: 200)

        LinearDecoration(
            lineCount: 6,
            dimension: 130,
            color: Color.gray.opacity(0.3),
            spacing: 0.06,
            startOffset: 0.1
        )
    }
    .padding()
}
