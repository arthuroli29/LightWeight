//
//  RoutineViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 29/02/24.
//

import SwiftUI
import Combine

final class RoutineViewModel: ObservableObject {
    init(routineEntity: RoutineEntity, dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        self.routine = routineEntity
        
        self.routine.publisher(for: \.workouts)
            .sink { [weak self] _ in
                self?.dataManager.saveData()
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    @Published var newWorkoutText: String = ""
    @Published var isAddWorkoutSheetPresented: Bool = false
    
    private let dataManager: DataManager
    @Published var routine: RoutineEntity
    var workouts: [WorkoutEntity] {
        self.routine.workouts?.array as? [WorkoutEntity] ?? []
    }
    
    var cancellables = Set<AnyCancellable>()
    
    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(dataManager.deleteEntity)
        }
    }
    
    func addWorkout(name: String) {
        withAnimation {
            let newWorkout = WorkoutEntity(context: dataManager.managedObjectContext)
            newWorkout.name = name.emptyDefault("Unnamed workout")
            newWorkout.routine = self.routine
            
            self.newWorkoutText = ""
        }
    }
    
    func moveWorkout(fromOffsets source: IndexSet, toOffset destination: Int) {
        guard let workouts = routine.workouts else { return }
        let mutableSet = NSMutableOrderedSet(orderedSet: workouts)
        mutableSet.moveObjects(at: source, to: destination)
        routine.workouts = mutableSet
    }
    
    func setActive() {
        withAnimation {
            self.routine.active = true
            self.dataManager.saveData()
            self.objectWillChange.send()
        }
    }
}
