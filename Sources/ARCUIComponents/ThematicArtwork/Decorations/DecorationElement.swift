//
//  DecorationElement.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 1/19/26.
//

import SwiftUI

// MARK: - DecorationElement

/// A model representing a single decorative element in a thematic artwork.
///
/// `DecorationElement` encapsulates all the visual properties needed to render
/// a decorative shape, including its shape, color, size, position, rotation,
/// blur, and opacity.
///
/// ## Example Usage
/// ```swift
/// let pepperoni = DecorationElement(
///     shape: AnyShape(Circle()),
///     color: .red,
///     size: CGSize(width: 20, height: 20),
///     offset: CGPoint(x: 0, y: -50),
///     opacity: 0.9
/// )
/// ```
public struct DecorationElement: Identifiable, Sendable {

    // MARK: - Properties

    /// Unique identifier for the element.
    public let id: UUID

    /// The shape of the decoration.
    public let shape: AnyShape

    /// The fill color of the decoration.
    public let color: Color

    /// The size of the decoration.
    public let size: CGSize

    /// The offset from the center of the artwork.
    public let offset: CGPoint

    /// The rotation angle of the decoration.
    public let rotation: Angle

    /// The blur radius applied to the decoration.
    public let blur: CGFloat

    /// The opacity of the decoration.
    public let opacity: Double

    // MARK: - Initialization

    /// Creates a new decoration element.
    ///
    /// - Parameters:
    ///   - shape: The shape to render.
    ///   - color: The fill color.
    ///   - size: The size of the decoration.
    ///   - offset: The offset from center. Defaults to `.zero`.
    ///   - rotation: The rotation angle. Defaults to `.zero`.
    ///   - blur: The blur radius. Defaults to `0`.
    ///   - opacity: The opacity value (0-1). Defaults to `1.0`.
    public init(
        shape: AnyShape,
        color: Color,
        size: CGSize,
        offset: CGPoint = .zero,
        rotation: Angle = .zero,
        blur: CGFloat = 0,
        opacity: Double = 1.0
    ) {
        self.id = UUID()
        self.shape = shape
        self.color = color
        self.size = size
        self.offset = offset
        self.rotation = rotation
        self.blur = blur
        self.opacity = opacity
    }

    /// Creates a new decoration element with a typed shape.
    ///
    /// - Parameters:
    ///   - shape: The shape to render (type-erased automatically).
    ///   - color: The fill color.
    ///   - size: The size of the decoration.
    ///   - offset: The offset from center. Defaults to `.zero`.
    ///   - rotation: The rotation angle. Defaults to `.zero`.
    ///   - blur: The blur radius. Defaults to `0`.
    ///   - opacity: The opacity value (0-1). Defaults to `1.0`.
    public init<S: Shape>(
        _ shape: S,
        color: Color,
        size: CGSize,
        offset: CGPoint = .zero,
        rotation: Angle = .zero,
        blur: CGFloat = 0,
        opacity: Double = 1.0
    ) {
        self.id = UUID()
        self.shape = AnyShape(shape)
        self.color = color
        self.size = size
        self.offset = offset
        self.rotation = rotation
        self.blur = blur
        self.opacity = opacity
    }
}

// MARK: - Convenience Initializers

public extension DecorationElement {

    /// Creates a circular decoration element.
    ///
    /// - Parameters:
    ///   - color: The fill color.
    ///   - diameter: The diameter of the circle.
    ///   - offset: The offset from center. Defaults to `.zero`.
    ///   - blur: The blur radius. Defaults to `0`.
    ///   - opacity: The opacity value. Defaults to `1.0`.
    static func circle(
        color: Color,
        diameter: CGFloat,
        offset: CGPoint = .zero,
        blur: CGFloat = 0,
        opacity: Double = 1.0
    ) -> DecorationElement {
        DecorationElement(
            Circle(),
            color: color,
            size: CGSize(width: diameter, height: diameter),
            offset: offset,
            blur: blur,
            opacity: opacity
        )
    }

    /// Creates a capsule decoration element.
    ///
    /// - Parameters:
    ///   - color: The fill color.
    ///   - size: The size of the capsule.
    ///   - offset: The offset from center. Defaults to `.zero`.
    ///   - rotation: The rotation angle. Defaults to `.zero`.
    ///   - opacity: The opacity value. Defaults to `1.0`.
    static func capsule(
        color: Color,
        size: CGSize,
        offset: CGPoint = .zero,
        rotation: Angle = .zero,
        opacity: Double = 1.0
    ) -> DecorationElement {
        DecorationElement(
            Capsule(),
            color: color,
            size: size,
            offset: offset,
            rotation: rotation,
            opacity: opacity
        )
    }

    /// Creates a rounded rectangle decoration element.
    ///
    /// - Parameters:
    ///   - color: The fill color.
    ///   - size: The size of the rectangle.
    ///   - cornerRadius: The corner radius.
    ///   - offset: The offset from center. Defaults to `.zero`.
    ///   - rotation: The rotation angle. Defaults to `.zero`.
    ///   - opacity: The opacity value. Defaults to `1.0`.
    static func roundedRect(
        color: Color,
        size: CGSize,
        cornerRadius: CGFloat,
        offset: CGPoint = .zero,
        rotation: Angle = .zero,
        opacity: Double = 1.0
    ) -> DecorationElement {
        DecorationElement(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            color: color,
            size: size,
            offset: offset,
            rotation: rotation,
            opacity: opacity
        )
    }
}
