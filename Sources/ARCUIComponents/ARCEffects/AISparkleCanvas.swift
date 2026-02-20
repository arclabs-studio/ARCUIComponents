//
//  AISparkleCanvas.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 2/19/26.
//

import Foundation
import SwiftUI

/// Floating sparkle particles rendered along a card's perimeter
///
/// Uses `TimelineView` with a `Canvas` to draw 4-point star sparkles
/// that fade in and out at staggered intervals. Particles are positioned
/// along the rounded rectangle perimeter for an organic twinkle effect.
///
/// Hidden entirely when `accessibilityReduceMotion` is enabled.
@available(iOS 17.0, macOS 14.0, *) struct AISparkleCanvas: View {
    // MARK: - Properties

    /// Corner radius of the card shape
    let cornerRadius: CGFloat

    /// Accent color for sparkle tinting
    let accentColor: Color

    // MARK: - State

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Sparkle particle definitions (generated once)
    @State private var sparkles: [SparkleParticle] = SparkleParticle.generate(count: 8)

    // MARK: - Body

    var body: some View {
        if !reduceMotion {
            TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate

                    for sparkle in sparkles {
                        let position = sparkle.position(in: size, cornerRadius: cornerRadius)
                        let opacity = sparkle.opacity(at: time)

                        guard opacity > 0.05 else { continue }

                        let sparkleSize = sparkle.size * CGFloat(opacity)

                        var path = Path()
                        drawStar(in: &path, center: position, size: sparkleSize)

                        let color = sparkle.isWhite
                            ? Color.white.opacity(opacity * 0.8)
                            : accentColor.opacity(opacity * 0.6)

                        context.fill(path, with: .color(color))
                    }
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }

    // MARK: - Star Drawing

    /// Draws a 4-point star at the given center
    private func drawStar(in path: inout Path, center: CGPoint, size: CGFloat) {
        let outerRadius = Double(size / 2)
        let innerRadius: Double = outerRadius * 0.3

        for pointIndex in 0 ..< 4 {
            let angle = Double(pointIndex) * (.pi / 2)
            let outerPoint = CGPoint(x: Double(center.x) + outerRadius * Foundation.cos(angle),
                                     y: Double(center.y) + outerRadius * Foundation.sin(angle))
            let midAngle1: Double = angle - .pi / 4
            let midAngle2: Double = angle + .pi / 4
            let innerPoint1 = CGPoint(x: Double(center.x) + innerRadius * Foundation.cos(midAngle1),
                                      y: Double(center.y) + innerRadius * Foundation.sin(midAngle1))
            let innerPoint2 = CGPoint(x: Double(center.x) + innerRadius * Foundation.cos(midAngle2),
                                      y: Double(center.y) + innerRadius * Foundation.sin(midAngle2))

            if pointIndex == 0 {
                path.move(to: outerPoint)
            } else {
                path.addLine(to: innerPoint1)
                path.addLine(to: outerPoint)
            }
            path.addLine(to: innerPoint2)
        }

        // Close back to first inner point
        let firstInnerAngle: Double = -.pi / 4
        let firstInnerPoint = CGPoint(x: Double(center.x) + innerRadius * Foundation.cos(firstInnerAngle),
                                      y: Double(center.y) + innerRadius * Foundation.sin(firstInnerAngle))
        path.addLine(to: firstInnerPoint)
        path.closeSubpath()
    }
}

// MARK: - SparkleParticle

/// Individual sparkle particle with position and animation parameters
private struct SparkleParticle: Identifiable {
    let id = UUID()

    /// Normalized position along the perimeter (0.0–1.0)
    let perimeterPosition: CGFloat

    /// Phase offset for the opacity sine wave
    let phaseOffset: Double

    /// Duration of one full opacity cycle (seconds)
    let cycleDuration: Double

    /// Base size of the sparkle
    let size: CGFloat

    /// Whether this sparkle is white (vs accent-colored)
    let isWhite: Bool

    // MARK: - Calculations

    /// Calculates the opacity at a given time using a sine wave
    func opacity(at time: Double) -> Double {
        let phase = (time / cycleDuration) + phaseOffset
        let raw = sin(phase * 2.0 * .pi)
        // Map [-1, 1] to [0, 1] and apply easing
        return max(0, raw * raw * raw + raw) / 2.0
    }

    /// Converts the normalized perimeter position to a CGPoint
    func position(in size: CGSize, cornerRadius: CGFloat) -> CGPoint {
        // Distribute points along the rounded rectangle perimeter
        let progress = perimeterPosition
        let width = size.width
        let height = size.height
        let radius = min(cornerRadius, min(width, height) / 2)

        // Perimeter segments: top, right, bottom, left (excluding corners for simplicity)
        let straightTop = width - 2 * radius
        let straightRight = height - 2 * radius
        let straightBottom = width - 2 * radius
        let straightLeft = height - 2 * radius
        let totalStraight = straightTop + straightRight + straightBottom + straightLeft

        let distance = progress * totalStraight

        if distance < straightTop {
            // Top edge
            return CGPoint(x: radius + distance, y: 0)
        } else if distance < straightTop + straightRight {
            // Right edge
            let offset = distance - straightTop
            return CGPoint(x: width, y: radius + offset)
        } else if distance < straightTop + straightRight + straightBottom {
            // Bottom edge
            let offset = distance - straightTop - straightRight
            return CGPoint(x: width - radius - offset, y: height)
        } else {
            // Left edge
            let offset = distance - straightTop - straightRight - straightBottom
            return CGPoint(x: 0, y: height - radius - offset)
        }
    }

    // MARK: - Factory

    /// Generate a set of sparkle particles with random parameters
    static func generate(count: Int) -> [SparkleParticle] {
        (0 ..< count).map { index in
            SparkleParticle(perimeterPosition: CGFloat(index) / CGFloat(count) + CGFloat.random(in: -0.03 ... 0.03),
                            phaseOffset: Double.random(in: 0 ... 1),
                            cycleDuration: Double.random(in: 1.5 ... 3.0),
                            size: CGFloat.random(in: 4 ... 8),
                            isWhite: index % 3 == 0)
        }
    }
}
