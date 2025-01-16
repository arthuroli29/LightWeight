import SwiftUI

class NewExerciseRouter {
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToMuscleGroupSelection() {
        let router = MuscleGroupSelectionRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
}

// MARK: - ViewFactory implementation
extension NewExerciseRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = NewExerciseViewModel(router: self)
        let view = NewExerciseView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation
extension NewExerciseRouter: Hashable {
    static func == (lhs: NewExerciseRouter, rhs: NewExerciseRouter) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}