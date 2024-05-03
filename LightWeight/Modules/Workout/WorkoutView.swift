//
//  WorkoutView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 08/03/24.
//

import SwiftUI

struct WorkoutView: View {
    init(workout: WorkoutEntity) {
        _viewModel = StateObject(wrappedValue: WorkoutViewModel(workoutEntity: workout))
    }
    
    @EnvironmentObject var router: Router
    @StateObject var viewModel: WorkoutViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Text("Exercises")
                        .frame(alignment: .center)
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                            .frame(maxWidth: .infinity)
                        
                        EditButton()
                            .environment(\.editMode, $viewModel.editMode)
                        
                        Button {
                            router.navigate(to: .newExercise)
                        } label: {
                            Label("", systemImage: "plus")
                        }
                    }
                }
                List {
                    ForEach(viewModel.exercises) { exercise in
                        ExerciseCell(exercise)
                    }
                    .onMove(perform: viewModel.moveExercise)
                    .onDelete(perform: viewModel.deleteItems)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    WorkoutView(workout: {
        let workout = WorkoutEntity(context: DataManager.preview.managedObjectContext)
        for index in 0...5 {
            let exerciseOption = ExerciseOption(dataManager: DataManager.preview)
            exerciseOption.name = "Exercise \(index)"
            
            let exerciseEntity = ExerciseEntity(dataManager: DataManager.preview)
            exerciseEntity.exerciseOption = exerciseOption
            
    //                exerciseEntity.name = "Routine 123"
                    for newSetIndex in 0...3 {
                        let set = SetEntity(dataManager: DataManager.preview)
                        set.exercise = exerciseEntity
                        set.repCount = 12 - Int16(newSetIndex * 2)
    //                    set.name = "Set \(newWorkoutIndex)"
    //                    set.routine = exerciseEntity
                    }
            
            exerciseEntity.workout = workout
        }
        return workout
    }())
}
