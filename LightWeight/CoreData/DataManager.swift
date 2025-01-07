//
//  DataManager.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 25/02/24.
//
//  Inspired by Santiago Garcia Santos on https://medium.com/@santiagogarciasantos/core-data-and-swiftui-a-solution-c0404a01c1aa

import Foundation
import CoreData

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager()
    public var managedObjectContext: NSManagedObjectContext

    override init() {
        let inMemory = {
            #if targetEnvironment(simulator)
            return true
            #else
            return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
            #endif
        }()

        let persistentStore = PersistenceController(inMemory: inMemory)
        self.managedObjectContext = persistentStore.container.viewContext
        super.init()

        Task {
            await updateNativeExercises()
            if inMemory {
                await setUpMockData()
            }
        }
    }

    private func updateNativeExercises() async {
        do {
            let seedManager = SeedManager(dataManager: self)
            try await seedManager.seedAll()
        } catch {
            assertionFailure("Failed to update native data: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func setUpMockData() async {
        for number in 0..<10 {
            let newItem = RoutineEntity(dataManager: self)
            newItem.order = Int16(number)
            newItem.name = "Routine \(number)"
            newItem.active = number == 4
        }

        await self.saveData()
    }

    @MainActor
    public func saveData() async {
        guard managedObjectContext.hasChanges else { return }
        do {
            try self.managedObjectContext.save()
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

    func fetchEntities<T: NSManagedObject & NSFetchRequestResult>(_ entityType: T.Type) -> [T] {
        guard let fetchRequest = entityType.fetchRequest() as? NSFetchRequest<T> else {
            assertionFailure()
            return []
        }
        return fetchData(fetchRequest: fetchRequest)
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
        let fetchRequest = RoutineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "active == YES")

        let results = fetchData(fetchRequest: fetchRequest)
        return results.first
    }
}
