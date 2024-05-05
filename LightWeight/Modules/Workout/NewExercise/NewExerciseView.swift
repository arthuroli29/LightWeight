//
//  NewWorkoutView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 27/04/24.
//

import SwiftUI

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
                        .roundedStyle()
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
                        .roundedStyle()
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