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
        // Main library - this is what consumers import
        .library(
            name: "ARCUIComponents",
            targets: ["ARCUIComponents"]
        )
        // Note: ARCUIComponentsDemoApp is intentionally NOT exposed as a product.
        // It's a separate Xcode project in Example/ARCUIComponentsDemoApp/
    ],
    dependencies: [
        .package(url: "https://github.com/arclabs-studio/ARCDesignSystem", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3")
    ],
    targets: [
        // Main library
        .target(
            name: "ARCUIComponents",
            dependencies: ["ARCDesignSystem"],
            path: "Sources",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),

        // Tests
        .testTarget(
            name: "ARCUIComponentsTests",
            dependencies: ["ARCUIComponents"],
            path: "Tests",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
        // Note: iOS demo app is in Example/ARCUIComponentsDemoApp/
        // It's a separate Xcode project that imports this package locally.
    ],
    swiftLanguageModes: [.v6]
)
