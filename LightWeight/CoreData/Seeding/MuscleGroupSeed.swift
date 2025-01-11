//
//  MuscleGroupSeed.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 07/01/25.
//

import Foundation
import CoreData

enum MuscleGroupType: String, Seed {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case core = "Core"

    var id: UUID? {
        switch self {
        case .chest: return UUID(uuidString: "47E42319-F27C-4B74-A0A2-A976B8DBBB99")
        case .back: return UUID(uuidString: "C5B6BBE4-8E9F-4477-B7C6-59DD4F3C4F7B")
        case .legs: return UUID(uuidString: "0B6ADBBB-3188-4B69-A7C7-B0E32A5F79E8")
        case .shoulders: return UUID(uuidString: "D4A2115F-7D8C-4325-B0C2-2684028E5F84")
        case .biceps: return UUID(uuidString: "F7DD1C79-5F6C-4E51-810B-68DBCE4E826C")
        case .triceps: return UUID(uuidString: "A8C2B4E9-0E1D-4F3A-B4C7-93D1F168799E")
        case .core: return UUID(uuidString: "E5D9C678-B6A4-4B8C-A123-F97A29655D4D")
        }
    }
}

extension MuscleGroup: SeedableEntity {
    typealias SeedType = MuscleGroupType
    func configure(with seed: MuscleGroupType, using fetchedEntities: [UUID: NSManagedObject]) {
        name = seed.rawValue
    }
    static var seedPredicate: NSPredicate? {
        nil
    }
}
