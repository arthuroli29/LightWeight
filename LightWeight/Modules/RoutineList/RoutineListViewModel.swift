//
//  RoutinesViewModel.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 25/02/24.
//

import CoreData
import SwiftUI

final class RoutineListViewModel: NSObject, ObservableObject {
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        
        super.init()
        
        fetchRoutines()
    }
    
    @Published var newRoutineText: String = ""
    @Published var isAddRoutineSheetPresented: Bool = false
    
    @Published var routines: [RoutineEntity] = []
    
    private var dataManager: DataManager
    
    private lazy var routinesController = NSFetchedResultsController(fetchRequest: routinesFetchRequest, dataManager: dataManager)
        .with(delegate: self)
    private let routinesFetchRequest = RoutineEntity.fetchRequest()
        .with(sortDescriptors: [NSSortDescriptor(keyPath: \RoutineEntity.order, ascending: true)])
    
    private func fetchRoutines() {
        try? routinesController.performFetch()
        routines = routinesController.fetchedObjects ?? []
    }
    
    public func addRoutine() {
        withAnimation {
            let newItem = RoutineEntity(dataManager: dataManager)
            newItem.order = Int16(self.routines.count) + 1
            newItem.name = self.newRoutineText.emptyDefault("Unnamed routine")
            self.newRoutineText = ""
            
            dataManager.saveData()
        }
    }
    
    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { routines[$0] }.forEach(dataManager.deleteEntity)
            
            dataManager.saveData()
        }
    }
    
    public func moveItem(from source: IndexSet, to destination: Int) {
        guard let affectedItems = ClosedRange.affectedItems(from: source, to: destination) else { return }
        
        routines.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in routines.enumerated() where affectedItems.contains(index) {
            item.order = Int16(index)
        }
        
        dataManager.saveData()
    }
}

extension RoutineListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let routines = controller.fetchedObjects as? [RoutineEntity] {
            self.routines = routines
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let routineEntity = anObject as? RoutineEntity, type == .update else { return }
        if routineEntity.active {
            self.routines.filter({ $0 != routineEntity }).forEach({ $0.active = false })
            self.dataManager.saveData()
        }
    }
}
