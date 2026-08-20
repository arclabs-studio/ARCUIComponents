//
//  ARCPhotoPickerConfiguration.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 18/3/26.
//

import ARCDesignSystem
import SwiftUI

// MARK: - ARCPhotoPickerConfiguration

/// Configuration for `ARCPhotoPicker`.
///
/// Available on iOS only — `PhotosPicker` is not available on macOS via this API.
@available(iOS 17.0, *) public struct ARCPhotoPickerConfiguration: Sendable {
    // MARK: - Properties

    /// Maximum number of photos the user can select in a single session.
    public let maxSelectionCount: Int

    /// SF Symbol name for the picker trigger button.
    public let buttonIcon: String

    /// Label shown next to the icon.
    public let buttonLabel: String

    // MARK: - Initialization

    public init(maxSelectionCount: Int = 10,
                buttonIcon: String = "plus.circle.fill",
                buttonLabel: String = String(localized: "Add Photos")) {
        self.maxSelectionCount = maxSelectionCount
        self.buttonIcon = buttonIcon
        self.buttonLabel = buttonLabel
    }

    // MARK: - Presets

    /// Default — up to 10 photos, "Add Photos" label.
    public static let `default` = ARCPhotoPickerConfiguration()

    /// Single photo selection.
    public static let singlePhoto = ARCPhotoPickerConfiguration(maxSelectionCount: 1,
                                                                buttonIcon: "camera.fill",
                                                                buttonLabel: String(localized: "Add Photo"))

    /// Compact icon-only trigger (no label visible).
    public static let iconOnly = ARCPhotoPickerConfiguration(maxSelectionCount: 10,
                                                             buttonIcon: "plus",
                                                             buttonLabel: String(localized: "Add Photos"))
}
