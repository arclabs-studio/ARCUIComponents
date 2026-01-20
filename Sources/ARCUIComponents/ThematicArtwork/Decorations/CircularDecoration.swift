//
//  CircularDecoration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - CircularDecoration

/// A view that distributes decoration elements in a circular pattern.
///
/// Use `CircularDecoration` to create evenly-spaced decorations around
/// a center point, such as toppings on a pizza or elements around a plate.
///
/// ## Example Usage
/// ```swift
/// CircularDecoration(
///     count: 8,
///     radius: 0.35,
///     dimension: 200
/// ) { index, dim in
///     DecorationElement.circle(
///         color: index.isMultiple(of: 2) ? .red : .green,
///         diameter: dim * 0.1
///     )
/// }
/// ```
public struct CircularDecoration: View {
    // MARK: - Properties

    /// The number of elements to distribute.
    public let count: Int

    /// The radius as a proportion of the dimension (0-1).
    public let radius: CGFloat

    /// The reference dimension for sizing calculations.
    public let dimension: CGFloat

    /// A closure that creates a decoration element for each index.
    public let elementBuilder: (Int, CGFloat) -> DecorationElement

    // MARK: - Initialization

    /// Creates a circular decoration layout.
    ///
    /// - Parameters:
    ///   - count: The number of elements to distribute evenly around the circle.
    ///   - radius: The radius as a proportion of the dimension (0-1).
    ///   - dimension: The reference dimension for sizing.
    ///   - elementBuilder: A closure that creates an `DecorationElement` for each index.
    public init(
        count: Int,
        radius: CGFloat,
        dimension: CGFloat,
        elementBuilder: @escaping (Int, CGFloat) -> DecorationElement
    ) {
        self.count = count
        self.radius = radius
        self.dimension = dimension
        self.elementBuilder = elementBuilder
    }

    // MARK: - Body

    public var body: some View {
        ForEach(0 ..< count, id: \.self) { index in
            let angle = (360.0 / Double(count)) * Double(index)
            let element = elementBuilder(index, dimension)

            DecorationElementView(element: element)
                .offset(y: -radius * dimension)
                .rotationEffect(.degrees(angle))
        }
    }
}

// MARK: - Preview

#Preview("6 Elements") {
    ZStack {
        Circle()
            .fill(Color.orange.opacity(0.5))
            .frame(width: 200, height: 200)

        CircularDecoration(
            count: 6,
            radius: 0.35,
            dimension: 200
        ) { _, dim in
            DecorationElement.circle(
                color: .black,
                diameter: dim * 0.12,
                opacity: 0.85
            )
        }
    }
    .padding()
}

#Preview("16 Alternating Elements") {
    ZStack {
        Circle()
            .fill(Color.orange.opacity(0.5))
            .frame(width: 200, height: 200)

        CircularDecoration(
            count: 16,
            radius: 0.38,
            dimension: 200
        ) { index, dim in
            DecorationElement.circle(
                color: index.isMultiple(of: 2) ? .red : .green,
                diameter: dim * 0.08,
                blur: 0.4,
                opacity: 0.8
            )
        }
    }
    .padding()
}

#Preview("Capsule Elements") {
    ZStack {
        Circle()
            .fill(Color.orange.opacity(0.5))
            .frame(width: 200, height: 200)

        CircularDecoration(
            count: 6,
            radius: 0.18,
            dimension: 200
        ) { _, dim in
            DecorationElement.capsule(
                color: .black,
                size: CGSize(width: dim * 0.12, height: dim * 0.52),
                opacity: 0.85
            )
        }
    }
    .padding()
}
