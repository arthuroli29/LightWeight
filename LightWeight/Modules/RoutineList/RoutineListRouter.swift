import SwiftUI

class RoutineListRouter {
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToRoutine(_ routine: RoutineEntity) {
        let router = RoutineRouter(rootCoordinator: rootCoordinator, routine: routine)
        rootCoordinator.push(router)
    }
}

// MARK: - ViewFactory implementation
extension RoutineListRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = RoutineListViewModel(router: self)
        let view = RoutineListView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation
extension RoutineListRouter: Hashable {
    static func == (lhs: RoutineListRouter, rhs: RoutineListRouter) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}