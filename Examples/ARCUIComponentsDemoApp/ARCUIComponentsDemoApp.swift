//
//  ARCUIComponentsDemoApp.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import os
import SwiftUI

/// Shared logger for the demo app, so callback output goes through unified logging.
let demoLogger = Logger(subsystem: "com.arclabs.ARCUIComponentsDemoApp", category: "Demo")

/// Main entry point for the ARCUIComponents demo application.
///
/// This app showcases all ARCUIComponents in real-world UI contexts,
/// providing a hands-on way to explore each component's features
/// and customization options.
@main
struct ARCUIComponentsDemoApp: App {
    // MARK: Initialization

    init() {
        ARCBrandFont.registerFonts()
    }

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            DemoHomeView()
        }
    }
}
