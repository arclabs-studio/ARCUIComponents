//
//  FeatureRowView.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import ARCUIComponents
import SwiftUI

struct FeatureRowView: View {
    let icon: String
    let text: String
    var accentColor: Color = .arcBrandGold

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(accentColor)

            Text(text)
                .foregroundStyle(.primary.opacity(0.9))
        }
    }
}

#Preview {
    FeatureRowView(icon: "square.stack", text: "Sectioned layout")
        .padding()
}
