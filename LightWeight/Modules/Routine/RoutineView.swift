//
//  RoutineView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 29/02/24.
//

import SwiftUI

struct RoutineView: View {
    init(routine: RoutineEntity) {
        _viewModel = StateObject(wrappedValue: RoutineViewModel(routineEntity: routine))
    }
    
    @EnvironmentObject var router: Router
    @StateObject var viewModel: RoutineViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Workouts")
                    .frame(alignment: .center)
                    .font(.headline)
                List {
                    ForEach(viewModel.workouts) { workout in
                        Button {
                            //TODO: open workout
                        } label: {
                            Text(workout.name ?? "Unnamed workout")
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                    .onMove(perform: { indexSet, destination in
                        viewModel.moveWorkout(fromOffsets: indexSet, toOffset: destination)
                    })
                }
                .environment(\.editMode, $viewModel.editMode)
                .listStyle(.plain)
                
                Spacer()
                    .frame(maxHeight: .infinity)
                
                Button {
                    viewModel.toggleActive()
                } label: {
                    Text(viewModel.routine.active ? "Set not active" : "Set active")
                        .vi
                }
            }
            .padding()
            
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .environment(\.editMode, $viewModel.editMode)
            }
            
            ToolbarItem {
                Button {
                    viewModel.isAddWorkoutSheetPresented = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .navigationTitle((viewModel.routine.name ?? "Unnamed routine") + (viewModel.routine.active ? " (active)" : ""))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isAddWorkoutSheetPresented) {
            TextFieldDynamicSheet(text: $viewModel.newWorkoutText,
                                  onDone: {
                viewModel.addWorkout(name: viewModel.newWorkoutText)
                viewModel.isAddWorkoutSheetPresented = false
            }, onCancel: {
                viewModel.newWorkoutText = ""
                viewModel.isAddWorkoutSheetPresented = false
            })
        }
    }
}

#Preview {
    RoutineView(routine: {
        let entity = RoutineEntity(context: DataManager.preview.managedObjectContext)
        entity.name = "Routine 123"
        for newWorkoutIndex in 0...9 {
            let workout = WorkoutEntity(context: DataManager.preview.managedObjectContext)
            workout.name = "Workout \(newWorkoutIndex)"
            workout.routine = entity
        }
        return entity
    }()
    )
}
