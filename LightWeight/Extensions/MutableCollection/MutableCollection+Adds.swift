//
//  MutableCollection+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 04/05/24.
//

import Foundation

/// Method to mutate elements in a collection of structs
extension MutableCollection {
    mutating func mutateEach(_ body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
    }
}
