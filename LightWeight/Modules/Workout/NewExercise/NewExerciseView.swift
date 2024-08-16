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
            Rectangle()
                .foregroundStyle(.gray.opacity(0.25))
                .frame(maxWidth: .infinity, maxHeight: 75)
                .cornerRadius(20)
                .overlay {
                    HStack {
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.accent)
                            .rotationEffect(.degrees(35))

                        Spacer()
                            .frame(width: 10)

                        Text("Choose the exercise")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 20)


            Spacer()
                .frame(height: 50)

            HStack {
                Button {
                    withAnimation {
                        viewModel.deleteSet()
                    }
                } label: {
                    Image(systemName: "minus")
                        .roundedStyle()
                }
                .disabled(viewModel.isDeleteSetDisabled)

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
                .disabled(viewModel.isAddSetDisabled)
            }

            Spacer()
                .frame(height: 30)

            NewExerciseSelectionView(title: "reps", viewModel: viewModel, selectionType: .repCount)

            Divider()

            Spacer()
                .frame(height: 25)

            NewExerciseSelectionView(title: "rest time", viewModel: viewModel, selectionType: .restTime)

            Divider()

            Spacer()
                .frame(height: 25)

            NewExerciseSelectionView(title: "weight", viewModel: viewModel, selectionType: .weight)

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
