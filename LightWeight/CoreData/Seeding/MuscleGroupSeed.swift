import Foundation
import CoreData

struct MuscleGroupSeed: EntitySeedable {
    typealias Entity = MuscleGroup

    let type: MuscleGroupType

    var uniqueIdentifier: String {
        return type.id.uuidString
    }

    func configure(_ entity: MuscleGroup, dataManager: DataManager) {
        entity.name = type.rawValue
        entity.id = type.id
    }
}

enum MuscleGroupSeeds: SeedProvider {
    static let defaultSeeds: [MuscleGroupSeed] = MuscleGroupType.allCases.map { type in
        MuscleGroupSeed(type: type)
    }
}