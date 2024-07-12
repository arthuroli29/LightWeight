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
                
                Text("Sets")
                    .font(.system(size: 25, weight: .medium))
                
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
                .frame(height: 30)
            
            Text("Reps")
                .font(.system(size: 22))
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                ForEach(viewModel.sets, id: \.order) { set in
                    Button {
                        viewModel.selectOne(.repCount, at: set.order)
                    } label: {
                        Text("\(set.repCount)")
                            .font(.system(size: 25))
                            .foregroundColor(viewModel.selected?.type == .repCount && (viewModel.selected?.selectedIndex == nil || viewModel.selected?.selectedIndex == set.order) ? .blue : .primary)
                            .frame(maxWidth: .infinity)
                    }
                    .supportsLongPress {
                        viewModel.selectAll(.repCount)
                    }
                }
            }
            
            Divider()
            
            Spacer()
                .frame(height: 25)
            
            Text("Rest time")
                .font(.system(size: 22))
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                ForEach(viewModel.sets, id: \.order) { set in
                    Button {
                        viewModel.selectOne(.restTime, at: set.order)
                    } label: {
                        Text("\(set.restTime)")
                            .font(.system(size: 25))
                            .foregroundColor(viewModel.selected?.type == .restTime && (viewModel.selected?.selectedIndex == nil || viewModel.selected?.selectedIndex == set.order) ? .blue : .primary)
                            .frame(maxWidth: .infinity)
                    }
                    .supportsLongPress {
                        viewModel.selectAll(.restTime)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
//        .sheet(item: $viewModel.selected) { selected in
//            PickerSheetView<Int>(isPresented: $viewModel.isPickerPresented,
//                                             values: viewModel.selected?.availableValues as? [Int] ?? [],
//                                             initialValue: viewModel.getInitialValue(),
//                                             didSelect: { value in viewModel.selectNewValue(value) },
//                                             didCancel: { viewModel.undo() })
//        }
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
