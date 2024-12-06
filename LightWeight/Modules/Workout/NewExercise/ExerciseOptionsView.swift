//
//  ExerciseSelectionView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 15/08/24.
//

import SwiftUI

//protocol ExerciseOptionServiceProtocol {
//    func fetchExerciseOptions() -> [ExerciseOption]
//}
//
//final class ExerciseOptionService: ExerciseOptionServiceProtocol {
//    func fetchExerciseOptions() -> [ExerciseOption] {
//        DataManager.shared.fetchEntities(ExerciseOption.self)
//    }
//}

class ExerciseOptionsViewModel: ObservableObject {
//    var service: ExerciseOptionServiceProtocol
    var dataManager: DataManager = .shared

//    init(service: ExerciseOptionServiceProtocol = ExerciseOptionService(), dataManager: DataManager = .shared) {
//        self.service = service
//        self.dataManager = dataManager
//        self.exercises = service.fetchExerciseOptions()
//    }

    @Published var exercises: [ExerciseOption] = [ExerciseOption(dataManager: DataManager.shared)]
    var filteredExercises: [ExerciseOption] {
        exercises.filter { exercise in
            return searchText.isEmpty ? true : exercise.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    @Published var searchText = ""
    @Published var isSearching = false
}

struct ExerciseOptionsView: View {
    @StateObject var viewModel = ExerciseOptionsViewModel()

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
    ExerciseOptionsView()
        .environmentObject(DataManager.shared)
        .environmentObject(Router())
}
