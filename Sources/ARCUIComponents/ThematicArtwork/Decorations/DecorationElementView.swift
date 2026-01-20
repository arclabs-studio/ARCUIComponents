//
//  DecorationElementView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - DecorationElementView

/// A view that renders a `DecorationElement`.
///
/// Use `DecorationElementView` to display individual decoration elements
/// within a thematic artwork's decoration layer.
///
/// ## Example Usage
/// ```swift
/// let element = DecorationElement.circle(
///     color: .red,
///     diameter: 20,
///     offset: CGPoint(x: 0, y: -30)
/// )
///
/// DecorationElementView(element: element)
/// ```
public struct DecorationElementView: View {
    // MARK: - Properties

    /// The decoration element to render.
    public let element: DecorationElement

    // MARK: - Initialization

    /// Creates a view for the given decoration element.
    ///
    /// - Parameter element: The decoration element to render.
    public init(element: DecorationElement) {
        self.element = element
    }

    // MARK: - Body

    public var body: some View {
        element.shape
            .fill(element.color.opacity(element.opacity))
            .frame(width: element.size.width, height: element.size.height)
            .rotationEffect(element.rotation)
            .offset(x: element.offset.x, y: element.offset.y)
            .blur(radius: element.blur)
    }
}

// MARK: - Preview

#Preview("Circle Decoration") {
    let element = DecorationElement.circle(
        color: .red,
        diameter: 40,
        offset: CGPoint(x: 0, y: -50),
        opacity: 0.9
    )

    ZStack {
        Circle()
            .fill(Color.orange.opacity(0.3))
            .frame(width: 200, height: 200)

        DecorationElementView(element: element)
    }
    .padding()
}

#Preview("Capsule Decoration") {
    let element = DecorationElement.capsule(
        color: .black,
        size: CGSize(width: 20, height: 80),
        offset: CGPoint(x: 0, y: -30),
        rotation: .degrees(45),
        opacity: 0.85
    )

    ZStack {
        Circle()
            .fill(Color.orange.opacity(0.3))
            .frame(width: 200, height: 200)

        DecorationElementView(element: element)
    }
    .padding()
}

#Preview("Multiple Decorations") {
    ZStack {
        Circle()
            .fill(Color.orange.opacity(0.3))
            .frame(width: 200, height: 200)

        ForEach(0..<6, id: \.self) { index in
            let element = DecorationElement.circle(
                color: index.isMultiple(of: 2) ? .red : .green,
                diameter: 20,
                offset: CGPoint(x: 0, y: -70),
                opacity: 0.8
            )

            DecorationElementView(element: element)
                .rotationEffect(.degrees(Double(index) * 60))
        }
    }
    .padding()
}
