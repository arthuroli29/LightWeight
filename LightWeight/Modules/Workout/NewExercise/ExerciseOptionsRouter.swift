import SwiftUI

class ExerciseOptionsRouter {
    private let rootCoordinator: NavigationCoordinator
    let muscleGroup: MuscleGroup
    
    init(rootCoordinator: NavigationCoordinator, muscleGroup: MuscleGroup) {
        self.rootCoordinator = rootCoordinator
        self.muscleGroup = muscleGroup
    }
}

// MARK: - ViewFactory implementation
extension ExerciseOptionsRouter: Routable {
    func makeView() -> AnyView {
        let view = ExerciseOptionsView(muscleGroup: muscleGroup)
        return AnyView(view)
    }
}

// MARK: - Hashable implementation
extension ExerciseOptionsRouter: Hashable {
    static func == (lhs: ExerciseOptionsRouter, rhs: ExerciseOptionsRouter) -> Bool {
        lhs.muscleGroup == rhs.muscleGroup
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(muscleGroup)
    }
}