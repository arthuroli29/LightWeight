//
//  SeedManager.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 06/01/25.
//

import Foundation
import CoreData

enum SeedingError: Error {
    case fetchRequestCreationFailed
}

struct SeedManager {
    private static let currentSeedVersion = 1
    private static let seedVersionKey = "SeedManagerVersion"
    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func seedAllIfNeeded() throws {
        guard Self.currentSeedVersion > UserDefaults.standard.integer(forKey: Self.seedVersionKey) else { return }

        var fetchedEntities: [UUID: NSManagedObject] = [:]
        try syncEntities(of: MuscleGroup.self, using: &fetchedEntities)
        try syncEntities(of: ExerciseOption.self, using: &fetchedEntities)
        dataManager.saveData()

        UserDefaults.standard.set(Self.currentSeedVersion, forKey: Self.seedVersionKey)
    }

    private func syncEntities<Entity: SeedableEntity>(of entityType: Entity.Type, using fetchedEntities: inout [UUID: NSManagedObject]) throws {
        let context = dataManager.managedObjectContext

        guard let fetchRequest = Entity.fetchRequest() as? NSFetchRequest<Entity> else {
            throw SeedingError.fetchRequestCreationFailed
        }
        fetchRequest.predicate = entityType.seedPredicate

        let existingEntities = try context.fetch(fetchRequest)

        let seeds = Array(Entity.SeedType.allCases)
        let seedsById = Dictionary(uniqueKeysWithValues: seeds.map { ($0.id, $0) })

        for entity in existingEntities {
            guard let entityId = entity.id else {
                assertionFailure("Entity \(entity) should have an ID.")
                context.delete(entity)
                continue
            }

            if let matchingSeed = seedsById[entityId] {
                entity.configure(with: matchingSeed, using: fetchedEntities)
                fetchedEntities[entityId] = entity
            } else {
                context.delete(entity)
            }
        }

        let existingIds = Set(existingEntities.compactMap { $0.id })

        for seed in seeds {
            guard let id = seed.id else {
                assertionFailure("Seed \(seed) should have an ID.")
                continue
            }
            guard !existingIds.contains(id) else {
                continue
            }
            let newEntity = Entity(context: context)
            newEntity.id = seed.id
            newEntity.configure(with: seed, using: fetchedEntities)
            fetchedEntities[id] = newEntity
        }

        if context.hasChanges {
            try context.save()
        }
    }
}
