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
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        fetchRoutines()
    }
    
    private var dataManager: DataManager
    
    @Published var text: String = ""
    @Published var isAddRoutineSheetPresented: Bool = false
    
    @Published var routines: [RoutineEntity] = []
    
    private let fetchRequest = {
        let request: NSFetchRequest<RoutineEntity> = RoutineEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RoutineEntity.order, ascending: true)]
        return request
    }()
    
    private func fetchRoutines() {
        routines = dataManager.fetchData(fetchRequest: fetchRequest)
    }
    
    public func addRoutine() {
        withAnimation {
            
            let newItem = RoutineEntity(context: dataManager.managedObjectContext)
            newItem.order = Int16(self.routines.count) + 1
            newItem.name = self.text
            self.text = ""
            
            dataManager.saveData()
            fetchRoutines()
        }
    }
    
    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { routines[$0] }.forEach(dataManager.deleteEntity)
            
            fetchRoutines()
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
