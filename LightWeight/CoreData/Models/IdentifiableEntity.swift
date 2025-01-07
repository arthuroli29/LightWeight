import Foundation
import CoreData

protocol IdentifiableEntity {
    var id: UUID? { get set }
    var isNative: Bool { get set }
}