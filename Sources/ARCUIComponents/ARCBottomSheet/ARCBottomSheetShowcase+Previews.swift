//
//  ARCBottomSheetShowcase+Previews.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 22/1/26.
//

import SwiftUI

// MARK: - Previews

@available(iOS 17.0, macOS 14.0, *)
#Preview("ARCBottomSheetShowcase") {
    NavigationStack {
        ARCBottomSheetShowcase()
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview("Dark Mode") {
    NavigationStack {
        ARCBottomSheetShowcase()
    }
    .preferredColorScheme(.dark)
}
