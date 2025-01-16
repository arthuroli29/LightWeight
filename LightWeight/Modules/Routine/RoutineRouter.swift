import SwiftUI

class RoutineRouter {
    private let rootCoordinator: NavigationCoordinator
    let routine: RoutineEntity
    
    init(rootCoordinator: NavigationCoordinator, routine: RoutineEntity) {
        self.rootCoordinator = rootCoordinator
        self.routine = routine
    }
    
    func routeToWorkout(_ workout: WorkoutEntity) {
        let router = WorkoutRouter(rootCoordinator: rootCoordinator, workout: workout)
        rootCoordinator.push(router)
    }
}

// MARK: - ViewFactory implementation
extension RoutineRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = RoutineViewModel(router: self, routine: routine)
        let view = RoutineView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation
extension RoutineRouter: Hashable {
    static func == (lhs: RoutineRouter, rhs: RoutineRouter) -> Bool {
        lhs.routine == rhs.routine
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(routine)
    }
}