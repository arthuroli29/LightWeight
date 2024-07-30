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

    var availableValues: [Int] {
        switch self {
        case .repCount:
            return Array(1...20)
        case .restTime:
            return (1...60).map { $0 * 5 }
        }
    }

    var keyPath: WritableKeyPath<ExerciseSet, Int> {
        switch self {
        case .repCount:
            \ExerciseSet.repCount
        case .restTime:
            \ExerciseSet.restTime
        }
    }

    var defaultValue: Int {
        switch self {
        case .repCount:
            return 12
        case .restTime:
            return 60
        }
    }
}

struct NewExerciseSelection: Identifiable {
    var id = UUID()

    let type: NewExerciseSelectionType
    let selectedIndex: Int?
    var availableValues: [Int] {
        type.availableValues
    }
}

struct ExerciseSet {
    let order: Int
    var repCount: Int
    var restTime: Int

    func getText(for type: NewExerciseSelectionType) -> String {
        switch type {
        case .repCount:
            return "\(repCount)"
        case .restTime:
            return "\(restTime)"
        }
    }
}

final class NewExerciseViewModel: ObservableObject {
    @Published var sets: [ExerciseSet] = (0..<4).map {
        ExerciseSet(
        order: $0,
        repCount: NewExerciseSelectionType.repCount.defaultValue,
        restTime: NewExerciseSelectionType.restTime.defaultValue
        )
    }
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
        sets.append(ExerciseSet(
            order: sets.count,
            repCount: sets.last?.repCount ?? NewExerciseSelectionType.repCount.defaultValue,
            restTime: sets.last?.restTime ?? NewExerciseSelectionType.restTime.defaultValue
        ))
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
        guard let selected else { return }
        if let selectedIndex = selected.selectedIndex {
            sets[selectedIndex][keyPath: selected.type.keyPath] = value
        } else {
            sets.mutateEach { set in
                set[keyPath: selected.type.keyPath] = value
            }
        }
    }

    func getInitialValue() -> Int {
        guard let selected else { return 10 }
        if let selectedIndex = selected.selectedIndex {
            return sets[selectedIndex][keyPath: selected.type.keyPath]
        }
        return sets.first?[keyPath: selected.type.keyPath] ?? 10
    }

    func selectOne(_ type: NewExerciseSelectionType, at index: Int) {
        let selectedIndex = selected?.type == type && selected?.selectedIndex == index ? nil : index
        selected = selectedIndex == nil ? nil : NewExerciseSelection(type: type, selectedIndex: selectedIndex)
    }

    func selectAll(_ type: NewExerciseSelectionType) {
        selected = selected?.type == type && selected?.selectedIndex == nil ?
        nil :
        NewExerciseSelection(type: type, selectedIndex: nil)
    }
}
