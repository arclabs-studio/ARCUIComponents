//
//  ARCAuthTestHelpers.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 17/03/2026.
//

import os

// MARK: - Spy

final class Spy<T: Sendable>: Sendable {
    private let storage = OSAllocatedUnfairLock<[T]>(initialState: [])

    var values: [T] {
        storage.withLock { $0 }
    }

    var callCount: Int {
        values.count
    }

    var wasCalled: Bool {
        !values.isEmpty
    }

    func record(_ value: T) {
        storage.withLock { $0.append(value) }
    }
}

// MARK: - Flag

final class Flag: Sendable {
    private let storage = OSAllocatedUnfairLock(initialState: 0)

    var count: Int {
        storage.withLock { $0 }
    }

    var isEmpty: Bool {
        count < 1
    }

    var wasCalled: Bool {
        !isEmpty
    }

    func increment() {
        storage.withLock { $0 += 1 }
    }
}
