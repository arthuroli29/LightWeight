`import Foundation
import CoreData

enum ExerciseType: String, CaseIterable {
    case barbellBenchPress = "Barbell Bench Press"
    case barbellRow = "Barbell Row"
    case barbellSquat = "Barbell Squat"
    case barbellDeadlift = "Barbell Deadlift"
    case dumbbellBenchPress = "Dumbbell Bench Press"
    case dumbbellRow = "Dumbbell Row"
    case dumbbellShoulderPress = "Dumbbell Shoulder Press"
    case dumbbellCurl = "Dumbbell Curl"
    case kettlebellSwing = "Kettlebell Swing"
    case kettlebellGobletSquat = "Kettlebell Goblet Squat"
    case pushup = "Push-up"
    case pullup = "Pull-up"
    case bodyweightSquat = "Bodyweight Squat"
    case plank = "Plank"

    var id: UUID {
        switch self {
        case .barbellBenchPress: return UUID(uuidString: "1A2B3C4D-5E6F-7A8B-9C0D-1E2F3A4B5C6D")!
        case .barbellRow: return UUID(uuidString: "2B3C4D5E-6F7A-8B9C-0D1E-2F3A4B5C6D7E")!
        case .barbellSquat: return UUID(uuidString: "3C4D5E6F-7A8B-9C0D-1E2F-3A4B5C6D7E8F")!
        case .barbellDeadlift: return UUID(uuidString: "4D5E6F7A-8B9C-0D1E-2F3A-4B5C6D7E8F9A")!
        case .dumbbellBenchPress: return UUID(uuidString: "5E6F7A8B-9C0D-1E2F-3A4B-5C6D7E8F9A0B")!
        case .dumbbellRow: return UUID(uuidString: "6F7A8B9C-0D1E-2F3A-4B5C-6D7E8F9A0B1C")!
        case .dumbbellShoulderPress: return UUID(uuidString: "7A8B9C0D-1E2F-3A4B-5C6D-7E8F9A0B1C2D")!
        case .dumbbellCurl: return UUID(uuidString: "8B9C0D1E-2F3A-4B5C-6D7E-8F9A0B1C2D3E")!
        case .kettlebellSwing: return UUID(uuidString: "9C0D1E2F-3A4B-5C6D-7E8F-9A0B1C2D3E4F")!
        case .kettlebellGobletSquat: return UUID(uuidString: "0D1E2F3A-4B5C-6D7E-8F9A-0B1C2D3E4F5A")!
        case .pushup: return UUID(uuidString: "1E2F3A4B-5C6D-7E8F-9A0B-1C2D3E4F5A6B")!
        case .pullup: return UUID(uuidString: "2F3A4B5C-6D7E-8F9A-0B1C-2D3E4F5A6B7C")!
        case .bodyweightSquat: return UUID(uuidString: "3A4B5C6D-7E8F-9A0B-1C2D-3E4F5A6B7C8D")!
        case .plank: return UUID(uuidString: "4B5C6D7E-8F9A-0B1C-2D3E-4F5A6B7C8D9E")!
        }
    }

    var muscleGroups: [MuscleGroupType] {
        switch self {
        case .barbellBenchPress: return [.chest, .shoulders, .triceps]
        case .barbellRow: return [.back, .biceps]
        case .barbellSquat: return [.legs, .core]
        case .barbellDeadlift: return [.back, .legs, .core]
        case .dumbbellBenchPress: return [.chest, .shoulders, .triceps]
        case .dumbbellRow: return [.back, .biceps]
        case .dumbbellShoulderPress: return [.shoulders, .triceps]
        case .dumbbellCurl: return [.biceps]
        case .kettlebellSwing: return [.back, .legs, .core]
        case .kettlebellGobletSquat: return [.legs, .core]
        case .pushup: return [.chest, .shoulders, .triceps, .core]
        case .pullup: return [.back, .biceps, .core]
        case .bodyweightSquat: return [.legs, .core]
        case .plank: return [.core]
        }
    }
}

struct ExerciseOptionSeed: EntitySeedable {
    typealias Entity = ExerciseOption

    let type: ExerciseType

    var uniqueIdentifier: String {
        return type.id.uuidString
    }

    func configure(_ entity: ExerciseOption, dataManager: DataManager) throws {
        entity.name = type.rawValue
        entity.id = type.id
        entity.isNative = true
        
        // Connect with muscle groups
        let fetchRequest = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        fetchRequest.predicate = NSPredicate(format: "id IN %@", type.muscleGroups.map(\.id) as [UUID])
        
        do {
            let muscleGroups = try dataManager.managedObjectContext.fetch(fetchRequest)
            
            // Verify that we found all required muscle groups
            let foundIds = Set(muscleGroups.compactMap { $0.id })
            let requiredIds = Set(type.muscleGroups.map(\.id))
            
            guard foundIds == requiredIds else {
                print("Warning: Not all muscle groups were found for \(type.rawValue)")
                print("Missing: \(requiredIds.subtracting(foundIds).map { $0.uuidString })")
            }
            
            let set = NSSet(array: muscleGroups)
            entity.muscleGroups = set
        } catch {
            print("Failed to fetch muscle groups for \(type.rawValue): \(error)")
            throw error
        }
    }
}

enum ExerciseOptionSeeds: SeedProvider {
    static let defaultSeeds: [ExerciseOptionSeed] = ExerciseType.allCases.map { type in
        ExerciseOptionSeed(type: type)
    }
}