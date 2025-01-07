//
//  WorkoutViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 08/03/24.
//

import SwiftUI
import Combine

final class WorkoutViewModel: ObservableObject {
    init(workoutEntity: WorkoutEntity, dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        self.workout = workoutEntity

        self.workout.publisher(for: \.exercises)
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.dataManager.saveData()
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }

    @Published var newExerciseText: String = ""
    @Published var isAddExerciseSheetPresented: Bool = false
    @Published var editMode: EditMode = .inactive

    private let dataManager: DataManager
    @Published var workout: WorkoutEntity
    var exercises: [ExerciseEntity] {
        self.workout.exercises?.array as? [ExerciseEntity] ?? []
    }

    var cancellables = Set<AnyCancellable>()

    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { exercises[$0] }.forEach(dataManager.deleteEntity)
        }
    }

//    func addExercise(name: String) {
//        withAnimation {
//            let newExercise = ExerciseEntity(context: dataManager.managedObjectContext)
//            newExercise.name = name.emptyDefault("Unnamed exercise")
//            newExercise.workout = self.workout
//            
//            self.newExerciseText = ""
//        }
//    }

    func moveExercise(fromOffsets source: IndexSet, toOffset destination: Int) {
        guard let exercises = workout.exercises, let sourceStart = source.first else { return }
        let mutableSet = NSMutableOrderedSet(orderedSet: exercises)
        // Why do I have to do this?
        let destination = destination > 0 ?
        (destination - sourceStart > 0 ? destination - source.count : destination) :
        0

        mutableSet.moveObjects(at: source, to: destination)
        workout.exercises = mutableSet
    }

//    func toggleActive() {
//        withAnimation {
//            self.workout.active.toggle()
//            self.objectWillChange.send()
//        }
//    }
}
