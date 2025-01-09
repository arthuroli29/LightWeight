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
    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func seedAll() async throws {
        // First seed MuscleGroups as they are referenced by ExerciseOptions
        var fetchedEntities: [ObjectIdentifier: [UUID: NSManagedObject]] = [:]
        try syncEntities(of: MuscleGroup.self, using: &fetchedEntities)
        try syncEntities(of: ExerciseOption.self, using: &fetchedEntities)
        await dataManager.saveData()
    }

    private func syncEntities<Entity: SeedableEntity>(of entityType: Entity.Type, using fetchedEntities: inout [ObjectIdentifier: [UUID: NSManagedObject]]) throws {
        let context = dataManager.managedObjectContext

        guard let fetchRequest = Entity.fetchRequest() as? NSFetchRequest<Entity> else {
            throw SeedingError.fetchRequestCreationFailed
        }
        fetchRequest.predicate = entityType.seedPredicate

        let existingEntities = try context.fetch(fetchRequest)

        let seeds = Array(Entity.SeedType.allCases)
        let seedsById = Dictionary(uniqueKeysWithValues: seeds.map { ($0.id, $0) })

        let entityTypeId = ObjectIdentifier(Entity.SeedType.self)
        if fetchedEntities[entityTypeId] == nil {
            fetchedEntities[entityTypeId] = [:]
        }

        for entity in existingEntities {
            guard let entityId = entity.id else {
                assertionFailure("Entity \(entity) should have an ID.")
                context.delete(entity)
                continue
            }

            if let matchingSeed = seedsById[entityId] {
                entity.configure(with: matchingSeed, using: fetchedEntities)
                fetchedEntities[entityTypeId]?[entityId] = entity
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
            fetchedEntities[entityTypeId]?[id] = newEntity
        }

        if context.hasChanges {
            try context.save()
        }
    }
}
