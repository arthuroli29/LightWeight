//
//  NSManagedObject+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 28/02/24.
//

import CoreData

extension NSManagedObject {
    @objc convenience init(dataManager: DataManager) {
        self.init(context: dataManager.managedObjectContext)
    }
}
