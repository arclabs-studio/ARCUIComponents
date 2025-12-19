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
        // Note: ARCUIComponentsDemo is intentionally NOT exposed as a product.
        // It's a separate Xcode project in Examples/ARCUIComponentsDemo.xcodeproj
    ],
    dependencies: [
        .package(url: "https://github.com/arclabs-studio/ARCDesignSystem", from: "2.0.0")
    ],
    targets: [
        // Main library
        .target(
            name: "ARCUIComponents",
            dependencies: ["ARCDesignSystem"],
            path: "Sources"
        ),

        // Tests
        .testTarget(
            name: "ARCUIComponentsTests",
            dependencies: ["ARCUIComponents"],
            path: "Tests"
        )
        // Note: iOS demo app is in Examples/ARCUIComponentsDemo.xcodeproj
        // It's a separate Xcode project that imports this package locally.
    ],
    swiftLanguageModes: [.v6]
)
