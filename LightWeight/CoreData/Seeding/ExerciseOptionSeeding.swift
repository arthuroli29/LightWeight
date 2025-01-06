import Foundation
import CoreData

// MARK: - Exercise Option Seeding

struct ExerciseOptionSeed: EntitySeedable {
    typealias Entity = ExerciseOption

    let name: String
    let id: UUID

    var uniqueIdentifier: String {
        return id.uuidString
    }

    func configure(_ entity: ExerciseOption, dataManager: DataManager) {
        entity.name = name
        entity.id = id
        entity.isNative = true
    }
}

enum ExerciseOptionSeeds: SeedProvider {
    static let defaultSeeds: [ExerciseOptionSeed] = [
        ExerciseOptionSeed(name: "Barbell", id: UUID()),
        ExerciseOptionSeed(name: "Dumbbell", id: UUID()),
        ExerciseOptionSeed(name: "Kettlebell", id: UUID()),
        ExerciseOptionSeed(name: "Bodyweight", id: UUID())
    ]
}

// MARK: - Muscle Group Seeding

struct MuscleGroupSeed: EntitySeedable {
    typealias Entity = MuscleGroup

    let name: String
    let id: UUID

    var uniqueIdentifier: String {
        return id.uuidString
    }

    func configure(_ entity: MuscleGroup, dataManager: DataManager) {
        entity.name = name
        entity.id = id
    }
}

enum MuscleGroupSeeds: SeedProvider {
    static let defaultSeeds: [MuscleGroupSeed] = [
        MuscleGroupSeed(name: "Chest", id: UUID()),
        MuscleGroupSeed(name: "Back", id: UUID()),
        MuscleGroupSeed(name: "Legs", id: UUID()),
        MuscleGroupSeed(name: "Shoulders", id: UUID()),
        MuscleGroupSeed(name: "Biceps", id: UUID()),
        MuscleGroupSeed(name: "Triceps", id: UUID()),
        MuscleGroupSeed(name: "Core", id: UUID())
    ]
}

// MARK: - Seed Manager

struct SeedManager {
    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func seedAll() throws {
        try seedEntities(ExerciseOptionSeeds.self)
        try seedEntities(MuscleGroupSeeds.self)
        dataManager.saveData()
    }

    private func seedEntities<Provider: SeedProvider>(_ provider: Provider.Type) throws {
        try removeExistingNativeEntities(Provider.SeedType.Entity.self)

        for seed in provider.defaultSeeds {
            try seed.seed(into: dataManager)
        }
    }

    private func removeExistingNativeEntities<T: NSManagedObject>(_ entityType: T.Type) throws {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        fetchRequest.predicate = NSPredicate(format: "isNative == true")

        guard let entities = try? dataManager.managedObjectContext.fetch(fetchRequest) else {
            throw SeedingError.fetchRequestFailed
        }

        entities.forEach { dataManager.deleteEntity($0) }
    }
}
