import Foundation
import CoreData

extension ExerciseOption: IdentifiableEntity {
    @objc var isNative: Bool {
        get {
            let value = primitiveValue(forKey: "isNative") as? Bool
            return value ?? false
        }
        set {
            setPrimitiveValue(newValue, forKey: "isNative")
        }
    }
}

extension MuscleGroup: IdentifiableEntity {
    @objc var isNative: Bool {
        get {
            let value = primitiveValue(forKey: "isNative") as? Bool
            return value ?? false
        }
        set {
            setPrimitiveValue(newValue, forKey: "isNative")
        }
    }
}