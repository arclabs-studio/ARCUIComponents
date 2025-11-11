import SwiftUI

/// Liquid Glass effect modifier
///
/// Implements Apple's modern glassmorphism effect seen in apps like Music,
/// Podcasts, and Fitness. Combines ultra-thin materials, vibrancy, and
/// subtle blur for a premium, depth-rich appearance.
///
/// This effect creates a sense of layering and hierarchy while maintaining
/// readability and following Apple's design language.
struct ARCMenuLiquidGlassModifier: ViewModifier {
    let configuration: ARCMenuConfiguration

    func body(content: Content) -> some View {
        content
            .background {
                backgroundView
            }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch configuration.backgroundStyle {
        case .liquidGlass:
            liquidGlassBackground

        case .translucent:
            translucentBackground

        case .solid(let color, let opacity):
            solidBackground(color: color, opacity: opacity)

        case .material(let material):
            materialBackground(material: material)
        }
    }

    // MARK: - Liquid Glass Background

    private var liquidGlassBackground: some View {
        ZStack {
            // Base ultra-thin material for system-aware blur
            Rectangle()
                .fill(.ultraThinMaterial)

            // Subtle gradient overlay for depth
            LinearGradient(
                colors: [
                    Color.white.opacity(0.1),
                    Color.white.opacity(0.05),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Vibrancy layer for content that sits on top
            Rectangle()
                .fill(.ultraThinMaterial.shadow(.inner(radius: 1, y: 1)))

            // Accent color tint (very subtle)
            configuration.accentColor
                .opacity(0.03)
                .blendMode(.overlay)
        }
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay {
            // Stroke border for definition
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
    }

    // MARK: - Alternative Backgrounds

    private var translucentBackground: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)

            configuration.accentColor
                .opacity(0.05)
                .blendMode(.overlay)
        }
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
    }

    private func solidBackground(color: Color, opacity: Double) -> some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(color.opacity(opacity))
            .shadow(
                color: configuration.shadow.color,
                radius: configuration.shadow.radius,
                x: configuration.shadow.x,
                y: configuration.shadow.y
            )
    }

    private func materialBackground(material: Material) -> some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .fill(material)
            .shadow(
                color: configuration.shadow.color,
                radius: configuration.shadow.radius,
                x: configuration.shadow.x,
                y: configuration.shadow.y
            )
    }
}

// MARK: - View Extension

extension View {
    /// Applies the liquid glass effect to a view
    /// - Parameter configuration: Menu configuration containing style settings
    /// - Returns: View with liquid glass effect applied
    func liquidGlass(configuration: ARCMenuConfiguration) -> some View {
        modifier(ARCMenuLiquidGlassModifier(configuration: configuration))
    }
}

// MARK: - Backdrop Blur Modifier

/// Backdrop blur effect for the overlay behind the menu
struct ARCMenuBackdropModifier: ViewModifier {
    let opacity: Double
    let onTap: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                if opacity > 0 {
                    Color.black
                        .opacity(opacity * 0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            onTap()
                        }
                }
            }
    }
}

extension View {
    /// Applies a backdrop blur overlay
    /// - Parameters:
    ///   - opacity: Opacity of the backdrop (0-1)
    ///   - onTap: Action to perform when backdrop is tapped
    /// - Returns: View with backdrop overlay
    func backdrop(opacity: Double, onTap: @escaping () -> Void) -> some View {
        modifier(ARCMenuBackdropModifier(opacity: opacity, onTap: onTap))
    }
}
