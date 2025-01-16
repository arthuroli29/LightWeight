import SwiftUI

class AppRouter: ObservableObject {
    @Published var paths = NavigationPath()
    
    func resolveInitialRouter() -> any Routable {
        let routineListRouter = RoutineListRouter(rootCoordinator: self)
        return routineListRouter
    }
}

// MARK: - NavigationCoordinator implementation
extension AppRouter: NavigationCoordinator {
    func push(_ router: any Routable) {
        DispatchQueue.main.async {
            let wrappedRouter = AnyRoutable(router)
            self.paths.append(wrappedRouter)
        }
    }
    
    func popLast() {
        DispatchQueue.main.async {
            self.paths.removeLast()
        }
    }
    
    func popToRoot() {
        DispatchQueue.main.async {
            self.paths.removeLast(self.paths.count)
        }
    }
}