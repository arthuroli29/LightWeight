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
    @ObservedObject var muscleGroupSelection: MuscleGroupSelectionViewModel
    var body: some View {
        VStack {
            Spacer()
            Text("Choose a game type")
                .font(.system(size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
                .multilineTextAlignment(.leading)

            Spacer()
                .frame(height: 28)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(muscleGroupSelection.muscleGroups, id: \.id) { muscle in
                    MuscleGroupCell(
                        muscle: muscle,
                        selected: muscle === muscleGroupSelection.selectedMuscleGroup,
                        onSelect: { muscleGroupSelection.didSelect(muscle) },
                        enabled: true
                    )
                }
            }

            Spacer()
                .frame(height: 71)

            Button {
                if muscleGroupSelection.isButtonEnabled {
                    // router.navigate(to: .newGameStep3(dto: dto))
                }
            } label: {
                Text("Next")
                    .frame(maxWidth: 100)
                    .foregroundStyle(muscleGroupSelection.isButtonEnabled ? .white : .black)
                    .font(.system(size: 17, weight: .medium))
                    .padding(.vertical, 14)
                    .background(Color.gray)
                    .cornerRadius(.infinity)
            }
            .padding(.horizontal, 35)

            Spacer()
                .frame(height: 25)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MuscleGroupSelectionView(muscleGroupSelection: MuscleGroupSelectionViewModel())
}
