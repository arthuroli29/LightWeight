//
//  RoutinesViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 25/02/24.
//

import CoreData
import Combine
import SwiftUI

class RoutinesViewModel: ObservableObject {
    
    init() {
        fetchRoutines()
    }
    
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    @Published var text: String = ""
    @Published var isAddRoutineSheetPresented: Bool = false
    
    @Published var routines: [RoutineEntity] = []
    
    var anyCancellable: AnyCancellable? = nil
    
    func fetchRoutines() {
        let request: NSFetchRequest<RoutineEntity> = RoutineEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RoutineEntity.order, ascending: true)]
        
        do {
            routines = try viewContext.fetch(request)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func addRoutine() {
        withAnimation {
            let newItem = RoutineEntity(context: viewContext)
            newItem.order = Int16(self.routines.count) + 1
            newItem.name = self.text
            self.text = ""
            
            save()
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { routines[$0] }.forEach(viewContext.delete)
            
            save()
        }
    }
    
    func save() {
        do {
            try viewContext.save()
            fetchRoutines()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
