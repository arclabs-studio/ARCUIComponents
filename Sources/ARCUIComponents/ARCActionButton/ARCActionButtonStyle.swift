//
//  ARCActionButtonStyle.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCActionButtonStyle

/// Custom ButtonStyle for ARCActionButton press animations
///
/// Provides smooth scale and opacity transitions when the button is pressed,
/// following Apple's Human Interface Guidelines:
/// "Always include a press state for a custom button.
/// Without a press state, a button can feel unresponsive."
///
/// ## Overview
///
/// This style handles the visual feedback during button interaction,
/// including scale reduction and opacity changes. The animation is
/// quick and subtle to feel responsive without being distracting.
@available(iOS 17.0, macOS 14.0, *)
struct ARCActionButtonStyle: ButtonStyle {
    // MARK: - Properties

    /// Button configuration for press behavior
    let buttonConfiguration: ARCActionButtonConfiguration

    /// Whether the button is in loading state
    let isLoading: Bool

    // MARK: - ButtonStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(scaleEffect(for: configuration))
            .opacity(opacity(for: configuration))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }

    // MARK: - Private Methods

    private func scaleEffect(for configuration: Configuration) -> CGFloat {
        guard !buttonConfiguration.isDisabled, !isLoading else { return 1.0 }
        return configuration.isPressed ? buttonConfiguration.pressedScale : 1.0
    }

    private func opacity(for configuration: Configuration) -> Double {
        guard !buttonConfiguration.isDisabled, !isLoading else { return 1.0 }
        return configuration.isPressed ? 0.9 : 1.0
    }
}
