//
//  MuscleGroupSelection.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 13/01/25.
//

import SwiftUI

protocol MuscleGroupServiceProtocol {
    func getMuscleGroups() -> [MuscleGroup]
}

struct MuscleGroupService: MuscleGroupServiceProtocol {
    func getMuscleGroups() -> [MuscleGroup] {
        DataManager.shared.fetchEntities(MuscleGroup.self)
    }
}

final class MuscleGroupSelectionViewModel: ObservableObject {
    @Published var muscleGroups: [MuscleGroup]
    @Published var selectedMuscleGroup: MuscleGroup?

    init(muscleGroupServiceProtocol: MuscleGroupServiceProtocol = MuscleGroupService()) {
        self.muscleGroups = muscleGroupServiceProtocol.getMuscleGroups()
    }

    var isButtonEnabled: Bool {
        selectedMuscleGroup != nil
    }

    func didSelect(_ muscleGroup: MuscleGroup) {
        selectedMuscleGroup = selectedMuscleGroup === muscleGroup ? nil : muscleGroup
    }
}

struct MuscleGroupSelectionView: View {
    @ObservedObject var viewModel = MuscleGroupSelectionViewModel()
    @EnvironmentObject var router: Router
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: 28)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.muscleGroups, id: \.id) { muscle in
                            MuscleGroupCell(
                                muscle: muscle,
                                selected: muscle === viewModel.selectedMuscleGroup,
                                onSelect: { viewModel.didSelect(muscle) },
                                enabled: true
                            )
                        }
                    }

                    Spacer()
                        .frame(height: 50)
                }
            }
            .scrollIndicators(.never)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                if viewModel.isButtonEnabled,
                    let selectedMuscleGroup = viewModel.selectedMuscleGroup {
                    router.navigate(to: .exerciseOptionSelection(selectedMuscleGroup))
                }
            } label: {
                Text("Next")
                    .frame(maxWidth: 100)
                    .foregroundStyle(
                        viewModel.isButtonEnabled ?
                        Color(UIColor.label) :
                        Color(UIColor.systemBackground)
                    )
                    .font(.system(size: 17, weight: .medium))
                    .padding(.vertical, 14)
                    .background(viewModel.isButtonEnabled ? .accent : Color(UIColor.systemGray2))
                    .cornerRadius(.infinity)
            }
            .removingTapAnimation(true)
            .padding(.horizontal, 35)
        }
    }
}

#Preview {
    MuscleGroupSelectionView(viewModel: MuscleGroupSelectionViewModel())
        .environmentObject(Router())
}
