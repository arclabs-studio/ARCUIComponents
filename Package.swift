// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCUIComponents",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ARCUIComponents",
            targets: ["ARCUIComponents"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/arclabs-studio/ARCDesignSystem", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "ARCUIComponents",
            dependencies: ["ARCDesignSystem"],
            path: "Sources"
        ),
        .testTarget(
            name: "ARCUIComponentsTests",
            dependencies: ["ARCUIComponents"],
            path: "Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)
