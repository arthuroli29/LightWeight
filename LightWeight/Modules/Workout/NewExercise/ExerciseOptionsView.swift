//
//  ExerciseSelectionView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 15/08/24.
//

import SwiftUI

class ExerciseOptionsViewModel: ObservableObject {
    var dataManager: DataManager = .shared

    init(dataManager: DataManager = .shared, muscleGroup: MuscleGroup) {
        self.dataManager = dataManager
        self.exercises = muscleGroup.exerciseOptions?.allObjects as? [ExerciseOption] ?? []
    }

    @Published var exercises: [ExerciseOption] = []
    var filteredExercises: [ExerciseOption] {
        exercises.filter { exercise in
            return searchText.isEmpty ? true : exercise.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    @Published var searchText = ""
    @Published var isSearching = false
}

struct ExerciseOptionsView: View {
    @StateObject private var viewModel: ExerciseOptionsViewModel

    init(muscleGroup: MuscleGroup) {
        _viewModel = StateObject(wrappedValue: ExerciseOptionsViewModel(muscleGroup: muscleGroup))
    }

    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            SearchTextField(text: $viewModel.searchText, placeholder: "Search exercise")
                .padding(.horizontal)

            List {
                ForEach(viewModel.filteredExercises) { exercise in
                    ExerciseOptionCell(exercise: exercise)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct ExerciseOptionCell: View {
    var exercise: ExerciseOption

    var body: some View {
        HStack {
            Text(exercise.name ?? "Unnamed exercise")
            Spacer()
        }
    }
}

#Preview {
    ExerciseOptionsView(muscleGroup: {
        let context = DataManager.shared.managedObjectContext
        let muscleGroup = MuscleGroup(context: context)
        muscleGroup.name = "Chest"

        let exercise1 = ExerciseOption(context: context)
        exercise1.name = "Bench Press"
        exercise1.addToMuscleGroups(muscleGroup)

        let exercise2 = ExerciseOption(context: context)
        exercise2.name = "Push-ups"
        exercise2.addToMuscleGroups(muscleGroup)

        return muscleGroup
    }())
    .environmentObject(DataManager.shared)
    .environmentObject(Router())
}
