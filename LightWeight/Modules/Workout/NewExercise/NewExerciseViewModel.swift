//
//  NewExerciseViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 04/05/24.
//

import Foundation

enum NewExerciseSelectionType {
    case repCount
    case restTime
    
    func availableValues() -> [Int] {
        switch self {
        case .repCount:
            return Array(1...20)
        case .restTime:
            return (1...60).map { $0 * 5 }
        }
    }
}

struct NewExerciseSelection: Identifiable {
    var id: UUID = UUID()
    
    let type: NewExerciseSelectionType
    let selectedIndex: Int?
    var availableValues: [Int] {
        type.availableValues()
    }
}

final class NewExerciseViewModel: ObservableObject {
    
    struct ExerciseSet {
        let order: Int
        var repCount: Int
        var restTime: Int
    }
    
    @Published var sets: [ExerciseSet] = (0..<4).map { ExerciseSet(order: $0, repCount: 12, restTime: 60) }
    var uneditedSets: [ExerciseSet]?
    @Published var selected: NewExerciseSelection? {
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
        if case .repCount = selected?.type {
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
    
    func selectOne(_ type: NewExerciseSelectionType, at index: Int) {
        let selectedIndex = selected?.type == type && selected?.selectedIndex == index ? nil : index
        selected = selectedIndex == nil ? nil : NewExerciseSelection(type: type, selectedIndex: selectedIndex)
    }
    
    func selectAll(_ type: NewExerciseSelectionType) {
        selected = selected?.type == type && selected?.selectedIndex == nil ? nil : NewExerciseSelection(type: type, selectedIndex: nil)
    }
}
