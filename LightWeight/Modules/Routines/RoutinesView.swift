//
//  ContentView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 31/01/24.
//

import SwiftUI

struct RoutinesView: View {
    
    @EnvironmentObject var router: Router
    @StateObject var viewModel = RoutinesViewModel()
    
    var body: some View {
        NavigationView {
            VStack
            {
                List {
                    ForEach(viewModel.routines) { routine in
                        Button {
                            router.navigate(to: .routine(routine))
                        } label: {
                            Text(routine.name ?? "Unnamed routine")
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
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
                DynamicHeightSheet {
                    VStack {
                        
                        Spacer(minLength: 10)
                        
                        TextField("Routine name", text: $viewModel.text, axis: .vertical)
                            .padding(10)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                        
                        Spacer(minLength: 40)
                        
                        Button {
                            viewModel.addRoutine()
                            viewModel.isAddRoutineSheetPresented = false
                        } label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                                .frame(height: 25)
                        }
                        .padding(.horizontal)
                        .buttonStyle(.borderedProminent)
                        
                        Spacer(minLength: 15)
                        
                        Button(role: .destructive) {
                            viewModel.text = ""
                            viewModel.isAddRoutineSheetPresented = false
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .frame(height: 25)
                        }
                        .padding(.horizontal)
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    RoutinesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
