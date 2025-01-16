//
//  ContentView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 31/01/24.
//

import SwiftUI

struct RoutineListView: View {
    init(viewModel: RoutineListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @StateObject var viewModel: RoutineListViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.routines) { routine in
                    Button {
                        viewModel.navigateToRoutine(routine)
                    } label: {
                        Text(routine.name ?? "Unnamed routine")
                    }
                    .background(routine.active ? Color.green.opacity(0.4) : Color.clear)
                }
                .onDelete(perform: viewModel.deleteItems)
                .onMove(perform: viewModel.moveItem)
            }
            .listStyle(.plain)
        }
        .padding()
        .navigationTitle("Routines")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }

            ToolbarItem {
                Button {
                    viewModel.isAddRoutineSheetPresented = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddRoutineSheetPresented) {
            TextFieldDynamicSheet(
                text: $viewModel.newRoutineText,
                onDone: {
                    viewModel.addRoutine()
                    viewModel.isAddRoutineSheetPresented = false
                }, onCancel: {
                    viewModel.newRoutineText = ""
                    viewModel.isAddRoutineSheetPresented = false
                }
            )
        }
    }
}

#Preview {
    let appRouter = AppRouter()
    let routineListRouter = RoutineListRouter(rootCoordinator: appRouter)
    return RoutineListView(viewModel: RoutineListViewModel(router: routineListRouter, dataManager: DataManager.shared))
}
