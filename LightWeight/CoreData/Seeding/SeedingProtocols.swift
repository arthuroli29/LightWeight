import Foundation
import CoreData

protocol Seedable {
    func seed(into dataManager: DataManager) throws
}

protocol EntitySeedable: Seedable {
    associatedtype Entity: NSManagedObject
    var uniqueIdentifier: String { get }
    static var isNativeEntity: Bool { get }
    func configure(_ entity: Entity, dataManager: DataManager)
}

extension EntitySeedable {
    static var isNativeEntity: Bool { return true }

    func seed(into dataManager: DataManager) throws {
        let entity = Entity(context: dataManager.managedObjectContext)
        configure(entity, dataManager: dataManager)
    }
}

protocol SeedProvider {
    associatedtype SeedType: EntitySeedable
    static var defaultSeeds: [SeedType] { get }
}

enum SeedingError: Error {
    case entityCreationFailed
    case configurationFailed(String)
    case fetchRequestFailed
}
