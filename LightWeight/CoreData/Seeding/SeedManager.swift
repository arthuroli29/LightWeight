import Foundation
import CoreData

enum SeedingError: Error {
    case fetchRequestFailed
    case entityCreationFailed
    case invalidEntityType
}

struct SeedManager {
    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func seedAll() async throws {
        do {
            // First seed MuscleGroups as they are referenced by ExerciseOptions
            try updateOrCreateEntities(MuscleGroupSeeds.self)
            try updateOrCreateEntities(ExerciseOptionSeeds.self)
            await dataManager.saveData()
        } catch {
            print("Failed to seed entities: \(error)")
            throw error
        }
    }

    private func updateOrCreateEntities<Provider: SeedProvider>(_ provider: Provider.Type) throws 
    where Provider.SeedType.Entity: NSManagedObject & IdentifiableEntity {
        for seed in provider.defaultSeeds {
            do {
                // Try to find existing entity by ID
                let entityName = String(describing: Provider.SeedType.Entity.self)
                let fetchRequest = NSFetchRequest<Provider.SeedType.Entity>(entityName: entityName)
                fetchRequest.predicate = NSPredicate(format: "id == %@", seed.uniqueIdentifier)
                
                let existingEntities = try dataManager.managedObjectContext.fetch(fetchRequest)
                
                if let existingEntity = existingEntities.first {
                    // Update existing entity
                    seed.configure(existingEntity, dataManager: dataManager)
                } else {
                    // Create new entity if it doesn't exist
                    try seed.seed(into: dataManager)
                }
            } catch {
                print("Failed to update/create entity for seed \(seed): \(error)")
                throw error
            }
        }
        
        // Remove any native entities that are no longer in the seed data
        try removeOrphanedNativeEntities(Provider.SeedType.Entity.self, currentIds: Set(provider.defaultSeeds.map(\.uniqueIdentifier)))
    }
    
    private func removeOrphanedNativeEntities<T: NSManagedObject & IdentifiableEntity>(_ entityType: T.Type, currentIds: Set<String>) throws {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
            fetchRequest.predicate = NSPredicate(format: "isNative == true")
            
            let entities = try dataManager.managedObjectContext.fetch(fetchRequest)
            
            for entity in entities {
                if !currentIds.contains(entity.id?.uuidString ?? "") {
                    print("Removing orphaned native entity: \(entity)")
                    dataManager.deleteEntity(entity)
                }
            }
        } catch {
            print("Failed to remove orphaned entities: \(error)")
            throw SeedingError.fetchRequestFailed
        }
    }
}