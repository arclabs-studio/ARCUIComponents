// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCUIComponents",
    platforms: [
        .iOS(.v17)
        // Note: ARCMenu is designed specifically for iOS/iPadOS.
        // For macOS, tvOS, or watchOS, use native platform patterns.
        // See docs/Platform-Alternatives.md for guidance.
    ],
    products: [
        .library(
            name: "ARCUIComponents",
            targets: ["ARCUIComponents"]
        ),
    ],
    dependencies: [
        .package(path: "../ARCDesignSystem")
    ],
    targets: [
        .target(
            name: "ARCUIComponents",
            dependencies: [
                "ARCDesignSystem"
            ],
            path: "Sources",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency"),
                .enableUpcomingFeature("ImplicitOpenExistentials"),
                .enableUpcomingFeature("DeprecateApplicationMain")
            ]
        ),
        .testTarget(
            name: "ARCUIComponentsTests",
            dependencies: ["ARCUIComponents"],
            path: "Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)
