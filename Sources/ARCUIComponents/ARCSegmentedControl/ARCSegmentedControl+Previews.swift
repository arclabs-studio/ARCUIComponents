//
//  ARCSegmentedControl+Previews.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("Filled Style") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            ARCSegmentedControl(
                selection: $selection,
                segments: [
                    .text("All", value: 0),
                    .text("Active", value: 1),
                    .text("Completed", value: 2)
                ]
            )
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Outlined Style") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            ARCSegmentedControl(
                selection: $selection,
                segments: [
                    .text("Day", value: 0),
                    .text("Week", value: 1),
                    .text("Month", value: 2)
                ],
                configuration: .outlined
            )
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Glass Style") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [.purple, .blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .text("Photos", value: 0),
                        .text("Videos", value: 1),
                        .text("Albums", value: 2)
                    ],
                    configuration: .glass
                )
                .padding()
            }
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Underlined Style") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            ARCSegmentedControl(
                selection: $selection,
                segments: [
                    .text("Posts", value: 0),
                    .text("Replies", value: 1),
                    .text("Media", value: 2)
                ],
                configuration: .underlined
            )
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Icons") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            VStack(spacing: 20) {
                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .textAndIcon("Home", icon: "house.fill", value: 0),
                        .textAndIcon("Search", icon: "magnifyingglass", value: 1),
                        .textAndIcon("Profile", icon: "person.fill", value: 2)
                    ]
                )

                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .icon("list.bullet", value: 0, accessibilityLabel: "List view"),
                        .icon("square.grid.2x2", value: 1, accessibilityLabel: "Grid view"),
                        .icon("rectangle.grid.1x2", value: 2, accessibilityLabel: "Gallery view")
                    ],
                    configuration: .pill
                )
            }
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Sizes") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            VStack(spacing: 20) {
                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .text("Small", value: 0),
                        .text("Size", value: 1)
                    ],
                    configuration: .small
                )

                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .text("Medium", value: 0),
                        .text("Size", value: 1)
                    ]
                )

                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .text("Large", value: 0),
                        .text("Size", value: 1)
                    ],
                    configuration: .large
                )
            }
            .padding()
        }
    }
    return PreviewView()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    struct PreviewView: View {
        @State private var selection = 0

        var body: some View {
            VStack(spacing: 20) {
                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .text("All", value: 0),
                        .text("Active", value: 1),
                        .text("Done", value: 2)
                    ]
                )

                ARCSegmentedControl(
                    selection: $selection,
                    segments: [
                        .text("All", value: 0),
                        .text("Active", value: 1),
                        .text("Done", value: 2)
                    ],
                    configuration: .outlined
                )
            }
            .padding()
        }
    }
    return PreviewView()
        .preferredColorScheme(.dark)
}
