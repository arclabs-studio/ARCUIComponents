//
//  ARCProgressShowcase.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - ARCProgressShowcase

/// Showcase view demonstrating all ARCProgress component variants
///
/// This view provides a comprehensive demonstration of all progress indicator
/// components including linear, circular, and step indicators with various
/// configurations.
@available(iOS 17.0, macOS 14.0, *)
public struct ARCProgressShowcase: View {
    // MARK: - State

    @State var linearProgress: Double = 0.65
    @State var circularProgress: Double = 0.75
    @State var currentStep: Int = 2
    @State var isAnimating = false

    // MARK: - Body

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                headerSection

                linearProgressSection

                circularProgressSection

                stepIndicatorSection

                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Progress Indicators")
    }

    // MARK: - Header Section

    @ViewBuilder var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ARCProgress Components")
                .font(.title2.bold())

            Text("""
            Progress indicators let people know that your app isn't stalled \
            while it loads content or performs lengthy operations.
            """)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Helper Views

    @ViewBuilder
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    NavigationStack {
        ARCProgressShowcase()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCProgressShowcase()
    }
    .preferredColorScheme(.dark)
}
