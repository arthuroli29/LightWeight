//
//  ExerciseCellViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 15/08/24.
//

import Foundation

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
        return setsString
    }
}
