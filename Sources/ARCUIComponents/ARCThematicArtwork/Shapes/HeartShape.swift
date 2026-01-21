//
//  HeartShape.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - HeartShape

/// A custom heart shape for use in thematic artworks.
///
/// Use `HeartShape` to add romantic or decorative heart elements
/// to your artworks, particularly for romance-themed book covers.
///
/// ## Example Usage
/// ```swift
/// HeartShape()
///     .fill(.pink)
///     .frame(width: 50, height: 50)
/// ```
public struct HeartShape: Shape {
    // MARK: - Shape

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: width * 0.5, y: height * 0.25))

        path.addCurve(
            to: CGPoint(x: width * 0.1, y: height * 0.4),
            control1: CGPoint(x: width * 0.5, y: height * 0.1),
            control2: CGPoint(x: width * 0.2, y: height * 0.1)
        )

        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.9),
            control1: CGPoint(x: 0, y: height * 0.6),
            control2: CGPoint(x: width * 0.3, y: height * 0.9)
        )

        path.addCurve(
            to: CGPoint(x: width * 0.9, y: height * 0.4),
            control1: CGPoint(x: width * 0.7, y: height * 0.9),
            control2: CGPoint(x: width, y: height * 0.6)
        )

        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.25),
            control1: CGPoint(x: width * 0.8, y: height * 0.1),
            control2: CGPoint(x: width * 0.5, y: height * 0.1)
        )

        return path
    }
}

// MARK: - Preview

#Preview("Heart Shape") {
    HeartShape()
        .fill(.pink)
        .frame(width: 100, height: 100)
        .padding()
}

#Preview("Heart Variations") {
    HStack(spacing: 20) {
        HeartShape()
            .fill(.red)
            .frame(width: 40, height: 40)

        HeartShape()
            .fill(.pink.opacity(0.8))
            .frame(width: 60, height: 60)

        HeartShape()
            .fill(
                LinearGradient(
                    colors: [.pink, .red],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 80, height: 80)
    }
    .padding()
}

#Preview("Heart Stroke") {
    HeartShape()
        .stroke(.red, lineWidth: 3)
        .frame(width: 100, height: 100)
        .padding()
}

#Preview("Multiple Hearts") {
    ZStack {
        Circle()
            .fill(Color.pink.opacity(0.2))
            .frame(width: 200, height: 200)

        ForEach(0..<5, id: \.self) { _ in
            HeartShape()
                .fill(Color.pink.opacity(0.6))
                .frame(width: 25, height: 25)
                .offset(
                    x: CGFloat.random(in: -60...60),
                    y: CGFloat.random(in: -60...60)
                )
                .rotationEffect(.degrees(Double.random(in: -30...30)))
        }
    }
    .padding()
}
