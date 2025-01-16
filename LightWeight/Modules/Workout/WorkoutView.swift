//
//  WorkoutView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 08/03/24.
//

import SwiftUI

struct WorkoutView: View {
    init(viewModel: WorkoutViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
                            viewModel.navigateToNewExercise()
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
    let appRouter = AppRouter()
    let workout = {
        let workout = WorkoutEntity(context: DataManager.shared.managedObjectContext)
        for index in 0...5 {
            let exerciseOption = ExerciseOption(dataManager: DataManager.shared)
            exerciseOption.name = "Exercise \(index)"

            let exerciseEntity = ExerciseEntity(dataManager: DataManager.shared)
            exerciseEntity.exerciseOption = exerciseOption

            for newSetIndex in 0...3 {
                let set = SetEntity(dataManager: DataManager.shared)
                set.exercise = exerciseEntity
                set.repCount = 12 - Int16(newSetIndex * 2)
            }

            exerciseEntity.workout = workout
        }
        return workout
    }()
    let workoutRouter = WorkoutRouter(rootCoordinator: appRouter, workout: workout)
    return WorkoutView(viewModel: WorkoutViewModel(router: workoutRouter, workoutEntity: workout))
}
