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
                ZStack {
                    Text("Workouts")
                        .frame(alignment: .center)
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                            .frame(maxWidth: .infinity)
                        
                        EditButton()
                            .environment(\.editMode, $viewModel.editMode)
                        
                        Button {
                            viewModel.isAddWorkoutSheetPresented = true
                        } label: {
                            Label("", systemImage: "plus")
                        }
                    }
                }
                List {
                    ForEach(viewModel.workouts) { workout in
                        Button {
                            router.navigate(to: .workout(workout))
                        } label: {
                            Text(workout.name ?? "Unnamed workout")
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                    .onMove(perform: viewModel.moveWorkout)
                }
                .environment(\.editMode, $viewModel.editMode)
                .listStyle(.plain)
                
                Spacer()
                    .frame(maxHeight: .infinity)
                
                Button {
                    viewModel.toggleActive()
                } label: {
                    Text(viewModel.routine.active ? "Set not active" : "Set active")
                        .contentTransition(.numericText())
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    
                    Button {
                        
                    } label: {
                        Text("Confirm")
                    }
                    
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .padding()
            
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                
                Button {
                    
                } label: {
                    Text("Confirm")
                }
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }
            }
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
