//
//  NewExerciseViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 04/05/24.
//

import Foundation

protocol SelectionType<T> {
    associatedtype T: Hashable
    var selectedIndex: Int? { get }
    var availableValues: [T] { get }
}

struct RepCountSelection: SelectionType {
    typealias T = Int
    
    let availableValues: [Int] = Array(1...20)
    var selectedIndex: Int?
}

final class NewExerciseViewModel: ObservableObject {
    
    struct ExerciseSet {
        let order: Int
        var repCount: Int
        var restTime: Int
    }
    
    @Published var sets: [ExerciseSet] = (0..<4).map { ExerciseSet(order: $0, repCount: 12, restTime: 60) }
    var uneditedSets: [ExerciseSet]?
    @Published var selected: (any SelectionType)? {
        didSet {
            if selected != nil {
                uneditedSets = sets
                isPickerPresented = true
            }
        }
    }
    @Published var isPickerPresented: Bool = false {
        didSet {
            if !isPickerPresented && selected != nil {
                selected = nil
            }
        }
    }
    
    var notEditedSets: [ExerciseSet]?
    
    func addSet() {
        sets.append(ExerciseSet(order: sets.count, repCount: sets.last!.repCount, restTime: sets.last!.restTime))
    }
    
    func deleteSet() {
        sets = sets.dropLast()
    }
    
    func undo() {
        if let uneditedSets = uneditedSets {
            sets = uneditedSets
            self.uneditedSets = nil
        }
    }
    
    func selectNewValue(_ value: Int) {
        if selected is RepCountSelection {
            if let selectedIndex = selected?.selectedIndex {
                sets[selectedIndex].repCount = value
            } else {
                sets.mutateEach { set in
                    set.repCount = value
                }
            }
        }
    }
    
    func getInitialValue() -> Int {
        if let selectedIndex = selected?.selectedIndex {
            return sets[selectedIndex].repCount
        }
        return sets.first!.repCount
    }
}
