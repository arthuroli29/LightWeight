//
//  ExerciseOptionSeed.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 07/01/25.
//


import Foundation
import CoreData

enum ExerciseType: String, Seed {
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

    var id: UUID? {
        switch self {
        case .barbellBenchPress: UUID(uuidString: "1A2B3C4D-5E6F-7A8B-9C0D-1E2F3A4B5C6D")
        case .barbellRow: UUID(uuidString: "2B3C4D5E-6F7A-8B9C-0D1E-2F3A4B5C6D7E")
        case .barbellSquat: UUID(uuidString: "3C4D5E6F-7A8B-9C0D-1E2F-3A4B5C6D7E8F")
        case .barbellDeadlift: UUID(uuidString: "4D5E6F7A-8B9C-0D1E-2F3A-4B5C6D7E8F9A")
        case .dumbbellBenchPress: UUID(uuidString: "5E6F7A8B-9C0D-1E2F-3A4B-5C6D7E8F9A0B")
        case .dumbbellRow: UUID(uuidString: "6F7A8B9C-0D1E-2F3A-4B5C-6D7E8F9A0B1C")
        case .dumbbellShoulderPress: UUID(uuidString: "7A8B9C0D-1E2F-3A4B-5C6D-7E8F9A0B1C2D")
        case .dumbbellCurl: UUID(uuidString: "8B9C0D1E-2F3A-4B5C-6D7E-8F9A0B1C2D3E")
        case .kettlebellSwing: UUID(uuidString: "9C0D1E2F-3A4B-5C6D-7E8F-9A0B1C2D3E4F")
        case .kettlebellGobletSquat: UUID(uuidString: "0D1E2F3A-4B5C-6D7E-8F9A-0B1C2D3E4F5A")
        case .pushup: UUID(uuidString: "1E2F3A4B-5C6D-7E8F-9A0B-1C2D3E4F5A6B")
        case .pullup: UUID(uuidString: "2F3A4B5C-6D7E-8F9A-0B1C-2D3E4F5A6B7C")
        case .bodyweightSquat: UUID(uuidString: "3A4B5C6D-7E8F-9A0B-1C2D-3E4F5A6B7C8D")
        case .plank: UUID(uuidString: "4B5C6D7E-8F9A-0B1C-2D3E-4F5A6B7C8D9E")
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

extension ExerciseOption: SeedableEntity {
    typealias SeedType = ExerciseType
    func configure(with seed: ExerciseType, using fetchedEntities: [ObjectIdentifier: [UUID: NSManagedObject]]) {
        name = seed.rawValue
        isNative = true
        let muscleGroupIds = seed.muscleGroups.compactMap { $0.id }
        let muscleGroupsEntities = muscleGroupIds.compactMap {
            fetchedEntities[ObjectIdentifier(MuscleGroup.SeedType.self)]?[$0] as? MuscleGroup
        }
        addToMuscleGroups(NSSet(array: muscleGroupsEntities))
    }
    static var seedPredicate: NSPredicate? {
        NSPredicate(format: "isNative == true")
    }
}
