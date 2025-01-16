import SwiftUI

class WorkoutRouter {
    private let rootCoordinator: NavigationCoordinator
    let workout: WorkoutEntity
    
    init(rootCoordinator: NavigationCoordinator, workout: WorkoutEntity) {
        self.rootCoordinator = rootCoordinator
        self.workout = workout
    }
    
    func routeToNewExercise() {
        let router = NewExerciseRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
}

// MARK: - ViewFactory implementation
extension WorkoutRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = WorkoutViewModel(router: self, workout: workout)
        let view = WorkoutView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation
extension WorkoutRouter: Hashable {
    static func == (lhs: WorkoutRouter, rhs: WorkoutRouter) -> Bool {
        lhs.workout == rhs.workout
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(workout)
    }
}