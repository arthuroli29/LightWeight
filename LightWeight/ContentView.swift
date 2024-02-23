//
//  ContentView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 31/01/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var router: Router
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RoutineEntity.order, ascending: true)],
        animation: .default)
    private var routines: FetchedResults<RoutineEntity>
    
    @State var text: String = ""
    
    @State var isAddRoutineSheetPresented: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        NavigationView {
            VStack
            {
                List {
                    ForEach(routines) { routine in
                        Button {
                            router.navigate(to: .routine(routine))
                        } label: {
                            Text(routine.name ?? "Unnamed routine")
                        }
                    }
                    .onDelete(perform: deleteItems)
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
                        isAddRoutineSheetPresented = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddRoutineSheetPresented) {
                VStack{
                    
                    Spacer(minLength: 10)
                    
                    TextField("Routine name", text: $text, axis: .vertical)
                        .padding(10)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                    
                    Spacer(minLength: 40)
                    
                    Button {
                        addRoutine(name: text)
                        text = ""
                        isAddRoutineSheetPresented = false
                    } label: {
                        Text("Done")
                            .frame(maxWidth: .infinity)
                            .frame(height: 25)
                    }
                    .padding(.horizontal)
                    .buttonStyle(.borderedProminent)
                    
                    Spacer(minLength: 15)
                    
                    Button(role: .destructive) {
                        text = ""
                        isAddRoutineSheetPresented = false
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .frame(height: 25)
                    }
                    .padding(.horizontal)
                    .buttonStyle(.bordered)
                }
                .padding()
                .fixedSize(horizontal: false, vertical: true)
                .modifier(GetHeightModifier(height: $sheetHeight))
                .presentationDetents([.height(sheetHeight)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func addRoutine(name: String) {
        withAnimation {
            let newItem = RoutineEntity(context: viewContext)
            newItem.order = Int16(self.routines.count) + 1
            newItem.name = name
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { routines[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
