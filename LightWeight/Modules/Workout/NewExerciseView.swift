//
//  NewWorkoutView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 27/04/24.
//

import SwiftUI

final class NewExerciseViewModel: ObservableObject {
    
    struct ExerciseSet {
        let order: Int
        var repCount: Int
        var restTime: Int
    }
    
    @Published var sets: [ExerciseSet] = (0..<4).map { ExerciseSet(order: $0, repCount: 12, restTime: 60) }
    @Published var selectedSetIndex: Int?
    @Published var isPickerPresented: Bool = false {
        didSet {
            if !isPickerPresented {
                selectedSetIndex = nil
                selectedSetPreviousNumber = nil
            }
        }
    }
    
    func addSet() {
        sets.append(ExerciseSet(order: sets.count, repCount: sets.last!.repCount, restTime: sets.last!.restTime))
    }
    
    func deleteSet() {
        sets = sets.dropLast()
    }
    
    var selectedSetPreviousNumber: Int?
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
                        let selectedIndex = set.order == viewModel.selectedSetIndex ? nil : set.order
                        viewModel.selectedSetIndex = selectedIndex
                        viewModel.isPickerPresented = selectedIndex != nil
                        viewModel.selectedSetPreviousNumber = selectedIndex == nil ? nil : viewModel.sets[selectedIndex!].repCount
                        
                    } label: {
                        Text("\(set.repCount)")
                            .font(.system(size: 25))
                            .foregroundColor(viewModel.selectedSetIndex == set.order ? .blue : .primary)
                            .frame(maxWidth: .infinity)
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
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $viewModel.isPickerPresented, content: {
            PickerSheetView<Int>(selectedValue: $viewModel.sets[viewModel.selectedSetIndex!].repCount,
                            isPresented: $viewModel.isPickerPresented,
                            previousValue: viewModel.selectedSetPreviousNumber,
                            values: Array(1...20))
        })
    }
}

#Preview {
    NewExerciseView()
}
