//
//  ARCAuthTestHelpers.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/03/2026.
//

// MARK: - Spy

final class Spy<T: Sendable>: @unchecked Sendable {
    private(set) var values: [T] = []
    var callCount: Int {
        values.count
    }

    var wasCalled: Bool {
        !values.isEmpty
    }

    func record(_ value: T) {
        values.append(value)
    }
}

// MARK: - Flag

final class Flag: @unchecked Sendable {
    private(set) var count = 0
    var isEmpty: Bool {
        count < 1
    }

    var wasCalled: Bool {
        !isEmpty
    }

    func increment() {
        count += 1
    }
}
