//
//  SeedingProtocols.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 06/01/25.
//

import Foundation
import CoreData

protocol Seed: CaseIterable, Hashable {
    var id: UUID? { get }
}

protocol SeedableEntity: NSManagedObject & NSFetchRequestResult {
    var id: UUID? { get set }
    associatedtype SeedType: Seed
    func configure(with seed: SeedType, using fetchedEntities: [UUID: NSManagedObject])
    static var seedPredicate: NSPredicate? { get }
}
