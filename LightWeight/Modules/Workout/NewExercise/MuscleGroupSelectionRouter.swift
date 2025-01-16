import SwiftUI

class MuscleGroupSelectionRouter {
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToExerciseOptions(_ muscleGroup: MuscleGroup) {
        let router = ExerciseOptionsRouter(rootCoordinator: rootCoordinator, muscleGroup: muscleGroup)
        rootCoordinator.push(router)
    }
}

// MARK: - ViewFactory implementation
extension MuscleGroupSelectionRouter: Routable {
    func makeView() -> AnyView {
        let view = MuscleGroupSelectionView()
        return AnyView(view)
    }
}

// MARK: - Hashable implementation
extension MuscleGroupSelectionRouter: Hashable {
    static func == (lhs: MuscleGroupSelectionRouter, rhs: MuscleGroupSelectionRouter) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}