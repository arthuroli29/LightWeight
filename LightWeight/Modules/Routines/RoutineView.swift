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
                    ForEach(viewModel.workouts, id: \.self) { workout in
                        Text(workout.name ?? "Unnamed workout")
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
                .listStyle(.plain)
            }
            .navigationTitle(viewModel.routine.name ?? "Unnamed routine")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button {
                        viewModel.addWorkout()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .padding()
        }
    }
}

final class RoutineViewModel: ObservableObject {
    init(routineEntity: RoutineEntity, dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        self.routine = routineEntity
    }
    
    private let dataManager: DataManager
    @Published var routine: RoutineEntity {
        didSet {
            print("\(routine.workouts?.count ?? 0)")
        }
    }
    var workouts: [WorkoutEntity] {
        self.routine.workouts?.array as? [WorkoutEntity] ?? []
    }
    
    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(dataManager.deleteEntity)
            
            dataManager.saveData()
            self.objectWillChange.send()
        }
    }
    
    func addWorkout() {
        withAnimation {
            let newWorkout = WorkoutEntity(context: dataManager.managedObjectContext)
            newWorkout.name = "New workout"
            newWorkout.routine = self.routine
            
            dataManager.saveData()
            self.objectWillChange.send()
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
