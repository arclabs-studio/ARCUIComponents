//
//  ARCTextField+Previews.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("Basic") {
    VStack(spacing: 20) {
        ARCTextField("Enter your name", text: .constant(""))
        ARCTextField("Enter your name", text: .constant("John Doe"))
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("With Label") {
    VStack(spacing: 20) {
        ARCTextField(
            "Enter email",
            text: .constant(""),
            configuration: .email
        )
        ARCTextField(
            "Enter email",
            text: .constant("john@example.com"),
            configuration: .email
        )
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Styles") {
    VStack(spacing: 20) {
        ARCTextField("Outlined", text: .constant(""))
        ARCTextField("Filled", text: .constant(""), configuration: .filled)
        ARCTextField("Underlined", text: .constant(""), configuration: .underlined)
    }
    .padding()
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Glass Style") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            ARCTextField("Search", text: .constant(""), configuration: .glass)
            ARCTextField("Enter text", text: .constant("Hello World"), configuration: .glass)
        }
        .padding()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    VStack(spacing: 20) {
        ARCTextField("Email", text: .constant(""), configuration: .email)
        ARCTextField("Password", text: .constant(""), configuration: .password)
    }
    .padding()
    .preferredColorScheme(.dark)
}
