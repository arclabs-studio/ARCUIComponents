//
//  ARCSearchButton.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 11/14/25.
//

import ARCDesignSystem
import SwiftUI

/// Search button component following Apple's Human Interface Guidelines
///
/// A button for triggering search functionality, matching the design patterns
/// found throughout iOS in apps like Mail, Messages, Photos, and Settings.
///
/// ## Overview
///
/// ARCSearchButton provides a consistent search entry point with:
/// - Multiple visual styles (plain, bordered, filled)
/// - Adaptive sizing for different contexts
/// - Smooth press animations
/// - Haptic feedback
/// - Full accessibility support
/// - Minimum 44x44pt touch target per HIG
///
/// ## Topics
///
/// ### Creating Search Buttons
///
/// - ``init(configuration:action:)``
///
/// ### Convenience Initializers
///
/// - ``init(style:size:accentColor:action:)``
///
/// ## Usage
///
/// ```swift
/// // Simple search button
/// ARCSearchButton {
///     presentSearchView()
/// }
///
/// // Customized prominent button
/// ARCSearchButton(
///     style: .filled,
///     accentColor: .blue
/// ) {
///     presentSearchView()
/// }
///
/// // In toolbar
/// .toolbar {
///     ToolbarItem(placement: .topBarTrailing) {
///         ARCSearchButton {
///             showSearch = true
///         }
///     }
/// }
/// ```
///
/// - Note: The button automatically handles animations, haptics, and accessibility.
///   You only need to provide the action closure.
@available(iOS 17.0, *)
public struct ARCSearchButton: View {
    // MARK: - Properties

    /// Configuration for appearance
    private let configuration: ARCSearchButtonConfiguration

    /// Action to perform when tapped
    private let action: () -> Void

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a search button with configuration
    ///
    /// - Parameters:
    ///   - configuration: Visual configuration
    ///   - action: Action to perform when tapped
    public init(
        configuration: ARCSearchButtonConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.action = action
    }

    /// Creates a search button with common parameters
    ///
    /// - Parameters:
    ///   - style: Visual style
    ///   - size: Button size
    ///   - accentColor: Icon color
    ///   - action: Action to perform when tapped
    public init(
        style: ARCSearchButtonConfiguration.ButtonStyle = .plain,
        size: ARCSearchButtonConfiguration.ButtonSize = .medium,
        accentColor: Color = .secondary,
        action: @escaping () -> Void
    ) {
        self.configuration = ARCSearchButtonConfiguration(
            accentColor: accentColor,
            size: size,
            style: style
        )
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            Image(systemName: configuration.icon)
                .font(.system(size: configuration.size.iconSize, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(
                    width: configuration.size.frameSize,
                    height: configuration.size.frameSize
                )
                .background(backgroundView)
                .contentShape(Rectangle())
        }
        .buttonStyle(SearchButtonPressStyle(isPressed: $isPressed))
        .accessibilityLabel("Search")
        .accessibilityHint("Tap to search")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Computed Properties

    private var iconColor: Color {
        switch configuration.style {
        case .filled:
            return configuration.accentColor
        case .bordered, .plain:
            return isPressed ? configuration.accentColor.opacity(0.6) : configuration.accentColor
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch configuration.style {
        case .plain:
            if configuration.showsBackgroundWhenIdle || isPressed {
                Circle()
                    .fill(configuration.backgroundColor.opacity(isPressed ? 0.3 : 0.1))
            }

        case .bordered:
            Circle()
                .strokeBorder(configuration.accentColor.opacity(0.3), lineWidth: 1)
                .background(
                    Circle()
                        .fill(
                            isPressed || configuration.showsBackgroundWhenIdle
                                ? configuration.backgroundColor
                                : .clear
                        )
                )

        case .filled:
            Circle()
                .fill(
                    isPressed
                        ? configuration.backgroundColor.opacity(0.8)
                        : configuration.backgroundColor
                )
        }
    }

    // MARK: - Actions

    private func handleTap() {
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Perform action
        action()
    }
}

// MARK: - Button Style

@available(iOS 17.0, *)
private struct SearchButtonPressStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Preview

#Preview("Default Style") {
    VStack(spacing: 40) {
        ARCSearchButton {
            print("Search tapped")
        }

        ARCSearchButton(size: .small) {
            print("Search tapped")
        }

        ARCSearchButton(size: .large) {
            print("Search tapped")
        }
    }
    .padding()
}

#Preview("Bordered Style") {
    VStack(spacing: 40) {
        ARCSearchButton(
            style: .bordered,
            size: .small,
            accentColor: .blue
        ) {
            print("Search tapped")
        }

        ARCSearchButton(
            style: .bordered,
            accentColor: .blue
        ) {
            print("Search tapped")
        }

        ARCSearchButton(
            style: .bordered,
            size: .large,
            accentColor: .blue
        ) {
            print("Search tapped")
        }
    }
    .padding()
}

#Preview("Filled Style") {
    VStack(spacing: 40) {
        ARCSearchButton(configuration: .prominent) {
            print("Search tapped")
        }

        ARCSearchButton(
            style: .filled,
            accentColor: .white
        ) {
            print("Search tapped")
        }
    }
    .padding()
}

#Preview("In Toolbar") {
    NavigationStack {
        List(1...20, id: \.self) { item in
            Text("Item \(item)")
        }
        .navigationTitle("Search Demo")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ARCSearchButton {
                    print("Search tapped")
                }
            }
        }
    }
}

#Preview("Dark Mode") {
    VStack(spacing: 40) {
        ARCSearchButton(style: .bordered, accentColor: .blue) {
            print("Search tapped")
        }

        ARCSearchButton(configuration: .prominent) {
            print("Search tapped")
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Color Variations") {
    HStack(spacing: 30) {
        ARCSearchButton(
            style: .filled,
            accentColor: .white
        ) {
            print("Blue search")
        }

        ARCSearchButton(
            style: .filled,
            accentColor: .white
        ) {
            print("Green search")
        }

        ARCSearchButton(
            style: .filled,
            accentColor: .white
        ) {
            print("Orange search")
        }
    }
    .padding()
}
