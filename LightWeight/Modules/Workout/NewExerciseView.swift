//
//  NewWorkoutView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 27/04/24.
//

import SwiftUI

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

struct NewExerciseView: View {
    @StateObject var viewModel = NewExerciseViewModel()
    
    var body: some View {
        VStack {
            Text("Exercise")
            
            Spacer()
                .frame(height: 20)
            
            Text("Reps")
                .font(.system(size: 20))
            
            HStack {
                
                Button {
                    withAnimation {
                        viewModel.deleteSet()
                    }
                } label: {
                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Color.gray
                                .opacity(0.25)
                                .cornerRadius(8)
                        }
                }
                .disabled(viewModel.sets.count == 1)
                
                ForEach(viewModel.sets, id: \.order) { set in
                    Button {
                        let selectedIndex = viewModel.selected is RepCountSelection && viewModel.selected?.selectedIndex == set.order ? nil : set.order
                        viewModel.selected = selectedIndex == nil ? nil : RepCountSelection(selectedIndex: selectedIndex)
                    } label: {
                        Text("\(set.repCount)")
                            .font(.system(size: 25))
                            .foregroundColor(viewModel.selected is RepCountSelection && (viewModel.selected?.selectedIndex == nil || viewModel.selected?.selectedIndex == set.order) ? .blue : .primary)
                            .frame(maxWidth: .infinity)
                    }
                    .supportsLongPress {
                        viewModel.selected = viewModel.selected is RepCountSelection && viewModel.selected?.selectedIndex == nil ? nil : RepCountSelection(selectedIndex: nil)
                    }
                }
                
                Button {
                    withAnimation {
                        viewModel.addSet()
                    }
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Color.gray
                                .opacity(0.25)
                                .cornerRadius(8)
                        }
                }
                .scaledToFit()
                .disabled(viewModel.sets.count == 6)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .sheet(isPresented: $viewModel.isPickerPresented) {
            PickerSheetView<Int>(isPresented: $viewModel.isPickerPresented,
                                 values: viewModel.selected?.availableValues as? [Int] ?? [],
                                 initialValue: viewModel.getInitialValue(),
                                 didSelect: { value in viewModel.selectNewValue(value) },
                                 didCancel: { viewModel.undo() })
        }
    }
}

#Preview {
    NewExerciseView()
}

extension MutableCollection {
    mutating func mutateEach(_ body: (inout Element) throws -> Void) rethrows {
        for index in self.indices {
            try body(&self[index])
        }
    }
}
