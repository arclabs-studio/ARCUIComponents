//
//  ARCSplashView.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 16/03/2026.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCSplashView

/// Loading screen shown while the app determines the initial auth state.
///
/// Displays the app hero icon from `ARCAuthConfiguration` alongside a
/// circular progress indicator. Typically visible for less than a second
/// while a Firebase / backend auth check resolves.
///
/// ## Usage
///
/// ```swift
/// let config = ARCAuthConfiguration(
///     appIcon: "fork.knife.circle.fill",
///     appName: "MyApp"
/// )
///
/// ARCSplashView(configuration: config)
/// ```
@available(iOS 17.0, macOS 14.0, *) public struct ARCSplashView: View {
    // MARK: Private Properties

    private let configuration: ARCAuthConfiguration

    // MARK: Initialization

    /// Creates a splash view.
    ///
    /// - Parameter configuration: Branding configuration supplying the app icon and sizing.
    public init(configuration: ARCAuthConfiguration) {
        self.configuration = configuration
    }

    // MARK: View

    public var body: some View {
        ZStack {
            #if os(iOS)
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            #else
            Color(NSColor.windowBackgroundColor)
                .ignoresSafeArea()
            #endif

            VStack(spacing: .arcSpacingLarge) {
                Image(systemName: configuration.appIcon)
                    .font(.system(size: configuration.heroIconSize * 0.8))
                    .foregroundStyle(.tint)

                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.secondary)
            }
        }
    }
}

// MARK: - Previews

#Preview("Splash - Dark") {
    ARCSplashView(configuration: .default(appName: "MyApp"))
        .preferredColorScheme(.dark)
}

#Preview("Splash - Light") {
    ARCSplashView(configuration: .default(appName: "MyApp"))
        .preferredColorScheme(.light)
}
