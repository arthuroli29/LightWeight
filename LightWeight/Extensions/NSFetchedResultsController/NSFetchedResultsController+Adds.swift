//
//  NSFetchedResultsController+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 28/02/24.
//

import CoreData

extension NSFetchedResultsController {
    @objc convenience init(fetchRequest: NSFetchRequest<ResultType>, dataManager: DataManager) {
        self.init(
            fetchRequest: fetchRequest,
            managedObjectContext: dataManager.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    @discardableResult
    @objc func with(delegate: NSFetchedResultsControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}
