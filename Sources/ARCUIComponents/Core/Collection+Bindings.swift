//
//  Collection+Bindings.swift
//  ARCUIComponents
//
//  Created by ARC Labs Studio on 05/11/26.
//

import Foundation

extension Set {
    /// Read-write membership, so a toggle-style control can bind to `$set[contains: element]`
    /// instead of a hand-built `Binding(get:set:)`.
    subscript(contains element: Element) -> Bool {
        get { contains(element) }
        set {
            if newValue {
                insert(element)
            } else {
                remove(element)
            }
        }
    }
}

extension Dictionary where Value == Bool {
    /// Read-write flag that treats a missing key as `false`, so a control can bind to
    /// `$dictionary[flag: key]`.
    subscript(flag key: Key) -> Bool {
        get { self[key] ?? false }
        set { self[key] = newValue }
    }
}
