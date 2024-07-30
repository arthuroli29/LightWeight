//
//  NSFetchRequest+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 28/02/24.
//

import CoreData

extension NSFetchRequest {
    @discardableResult
    @objc func with(sortDescriptors: [NSSortDescriptor]) -> Self {
        self.sortDescriptors = sortDescriptors
        return self
    }
}
