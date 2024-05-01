//
//  ExeciseCell.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 21/03/24.
//

import SwiftUI

final class ExerciseCellViewModel: ObservableObject {
    init(exercise: ExerciseEntity) {
        self.exercise = exercise
    }
    @Published var exercise: ExerciseEntity
    
    public var setsString: String? {
        guard let sets = exercise.sets else { return nil }
        var setsString = ""
        for (index, set) in sets.enumerated() {
            if let setEntity = set as? SetEntity {
                setsString += index == 0 ? "\(setEntity.repCount)" : " / \(setEntity.repCount)"
            }
        }
//        let array = sets.enumerated().map({ index, set in
//            guard let setEntity = set as? SetEntity else { return "" }
//                return "\(setEntity.repCount)"
//        })
//        return astring + array
        return setsString
    }
}

struct ExerciseCell: View {
    
    @StateObject private var viewModel: ExerciseCellViewModel
    
    init(_ exercise: ExerciseEntity) {
        _viewModel = StateObject(wrappedValue: ExerciseCellViewModel(exercise: exercise))
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .foregroundStyle(Color.green)
                .frame(width: 60, height: 60)
            
            Text(viewModel.exercise.exerciseOption?.name ?? "Unnamed exercise")
            
            Spacer()
            
            Text(viewModel.setsString ?? "")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background{
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(Color.gray, lineWidth: 1)
                .shadow(radius: 10)
        }
        
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
