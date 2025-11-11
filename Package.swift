// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCUIComponents",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "ARCUIComponents",
            targets: ["ARCUIComponents"]
        ),
    ],
    targets: [
        .target(
            name: "ARCUIComponents",
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
