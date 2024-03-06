//
//  DataManager.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 25/02/24.
//
//  Inspired by Santiago Garcia Santos on https://medium.com/@santiagogarciasantos/core-data-and-swiftui-a-solution-c0404a01c1aa

import Foundation
import CoreData

enum DataManagerType {
    case normal
    case preview
    case testing
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
    public var managedObjectContext: NSManagedObjectContext
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistenceController()
            self.managedObjectContext = persistentStore.container.viewContext
        case .preview:
            let persistentStore = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentStore.container.viewContext
        case .testing:
            let persistentStore = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentStore.container.viewContext
        }
        super.init()
        
        if type == .preview {
            setUpMockData()
        }
    }
    
    private func setUpMockData() {
        for number in 0..<10 {
            let newItem = RoutineEntity(dataManager: self)
            newItem.order = Int16(number)
            newItem.name = "Routine \(number)"
            newItem.active = number == 4
        }
        
        self.saveData()
    }
    
    public func saveData() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            assertionFailure("Unresolved error saving context: \(error.localizedDescription)")
        }
    }
    
    public func fetchData<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            assertionFailure("Unresolved error fetching data: \(error.localizedDescription)")
            return []
        }
    }
    
    public func deleteEntities(_ entities: [NSManagedObject]) {
        entities.forEach { entity in
            managedObjectContext.delete(entity)
        }
    }
    
    public func deleteEntity(_ entity: NSManagedObject) {
        managedObjectContext.delete(entity)
    }
    
    func fetchActiveRoutine() -> RoutineEntity? {
        let fetchRequest = NSFetchRequest<RoutineEntity>(entityName: "RoutineEntity")
        fetchRequest.predicate = NSPredicate(format: "active == YES")

        let results = fetchData(fetchRequest: fetchRequest)
        return results.first
    }
}
