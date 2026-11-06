//
//  CodeSnippetRow.swift
//  ARCUIComponentsDemo
//
//  Created by ARC Labs Studio on 19/12/2025.
//

import SwiftUI

// MARK: - Code Snippet Row

struct CodeSnippetRow: View {
    let label: String
    let code: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .trailing)

            Text(code)
                .font(.caption2.monospaced())
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    CodeSnippetRow(label: "Layout", code: ".sectioned")
        .padding()
}
