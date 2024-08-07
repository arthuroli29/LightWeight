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
                .disabled(viewModel.sets.count == 6)
            }

            Spacer()
                .frame(height: 30)

            NewExerciseSelectionView(title: "Reps", viewModel: viewModel, selectionType: .repCount)

            Divider()

            Spacer()
                .frame(height: 25)

            NewExerciseSelectionView(title: "Rest time", viewModel: viewModel, selectionType: .restTime)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .sheet(isPresented: $viewModel.isPickerPresented) {
            PickerSheetView<Int>(
                isPresented: $viewModel.isPickerPresented,
                values: viewModel.selected?.availableValues as? [Int] ?? [],
                initialValue: viewModel.getInitialValue(),
                didSelect: { value in viewModel.selectNewValue(value) },
                didCancel: { viewModel.undo() }
            )
        }
        //        .sheet(item: $viewModel.selected) { selected in
        //            PickerSheetView<Int>(isPresented: $viewModel.isPickerPresented,
        //                                             values: viewModel.selected?.availableValues as? [Int] ?? [],
        //                                             initialValue: viewModel.getInitialValue(),
        //                                             didSelect: { value in viewModel.selectNewValue(value) },
        //                                             didCancel: { viewModel.undo() })
        //        }
    }
}

#Preview {
    NewExerciseView()
}
