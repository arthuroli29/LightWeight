//
//  ExeciseCell.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 21/03/24.
//

import SwiftUI

struct ExerciseCell: View {
    @StateObject private var viewModel: ExerciseCellViewModel

    init(_ exercise: ExerciseEntity) {
        _viewModel = StateObject(wrappedValue: ExerciseCellViewModel(exercise: exercise))
    }

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .foregroundStyle(.gray.opacity(0.25))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "dumbbell.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.accent)
                        .rotationEffect(.degrees(35))
                }

            Text(viewModel.exercise.exerciseOption?.name ?? "Unnamed exercise")

            Spacer()

            Text(viewModel.setsString ?? "")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .roundedBorder(cornerRadius: 20, color: .gray.opacity(0.25), lineWidth: 2)
        .shadow(radius: 10)
    }
}

#Preview {
    ExerciseCell({
        let exerciseOption = ExerciseOption(dataManager: DataManager.preview)
        exerciseOption.name = "Bench press"

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
        return exerciseEntity
    }())
}
