////
////  DataManager.swift
////  LightWeight
////
////  Created by Arthur Oliveira on 25/02/24.
////
////  Inspired by Santiago Garcia Santos on https://medium.com/@santiagogarciasantos/core-data-and-swiftui-a-solution-c0404a01c1aa
//
//import Foundation
//import CoreData
//
//enum DataManagerType {
//    case normal
//    case preview
//    case testing
//}
//
//class DataManager: NSObject, ObservableObject {
//    
//    static let shared = DataManager(type: .normal)
//    static let preview = DataManager(type: .preview)
//    static let testing = DataManager(type: .testing)
//    
//    @Published var entities: [ObjectIdentifier: ManagedEntity<NSManagedObject>] = [:]
//    
//    class ManagedEntity<T: NSManagedObject>: ObservableObject {
//        @Published var value: [T]
//        let controller: NSFetchedResultsController<T>
//
//        init(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
//            self.controller = NSFetchedResultsController(
//                fetchRequest: fetchRequest,
//                managedObjectContext: context,
//                sectionNameKeyPath: nil,
//                cacheName: nil
//            )
//
//            do {
//                try controller.performFetch()
//                self.value = controller.fetchedObjects ?? []
//            } catch {
//                fatalError("Error fetching objects: \(error)")
//            }
//        }
//    }
//    
////    public var value<T: NSManagedObject>: [T] {
////        
////    }
//    
////    @Published var todos: OrderedDictionary<UUID, Todo> = [:]
////    @Published var projects: OrderedDictionary<UUID, Project> = [:]
//    
////    var todosArray: [Todo] {
////        Array(todos.values)
////    }
////    
////    var projectsArray: [Project] {
////        Array(projects.values)
////    }
//    
//    fileprivate var managedObjectContext: NSManagedObjectContext
////    private let todosFRC: NSFetchedResultsController<TodoMO>
////    private let projectsFRC: NSFetchedResultsController<ProjectMO>
//    
//    private init(type: DataManagerType) {
////        switch type {
////        case .normal:
////            let persistentStore = PersistenceController()
//            self.managedObjectContext = NSManagedObjectContext()
////        case .preview:
////            let persistentStore = PersistenceController(inMemory: true)
////            self.managedObjectContext = persistentStore.context
//            // Add Mock Data
////            try? self.managedObjectContext.save()
////        case .testing:
////            let persistentStore = PersistenceController(inMemory: true)
////            self.managedObjectContext = persistentStore.context
////        }
//        
////        var objects = Runtime.subclasses(of: NSManagedObject.self)
//        
////        objects = objects.filter { type in
////            !(type === NSManagedObject.self)
////        }
//        
////        let model = PersistenceController.shared.container.managedObjectModel
////
////        // Extract entity descriptions and their types
////        let entityTypes: [NSManagedObject.Type] = model.entities.compactMap {
////            guard let managedObjectType = $0.managedObjectClassName else { return nil }
////            return NSClassFromString(managedObjectType) as? NSManagedObject.Type
////        }
////
////        // Access entity types
////        for type in entityTypes {
////            print(type) // This will print the actual entity type
////        }
//        
//        
////        let todoFR: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()
////        todoFR.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
////        todosFRC = NSFetchedResultsController(fetchRequest: todoFR,
////                                              managedObjectContext: managedObjectContext,
////                                              sectionNameKeyPath: nil,
////                                              cacheName: nil)
////        
////        let projectFR: NSFetchRequest<ProjectMO> = ProjectMO.fetchRequest()
////        projectFR.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
////        projectsFRC = NSFetchedResultsController(fetchRequest: projectFR,
////                                                 managedObjectContext: managedObjectContext,
////                                                 sectionNameKeyPath: nil,
////                                                 cacheName: nil)
//        
//        super.init()
//        
//        // Initial fetch to populate todos array
////        todosFRC.delegate = self
////        try? todosFRC.performFetch()
////        if let newTodos = todosFRC.fetchedObjects {
////            self.todos = OrderedDictionary(uniqueKeysWithValues: newTodos.map({ ($0.id!, Todo(todoMO: $0)) }))
////        }
////        
////        projectsFRC.delegate = self
////        try? projectsFRC.performFetch()
////        if let newProjects = projectsFRC.fetchedObjects {
////            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
////        }
//    }
//    
//    func saveData() {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch let error as NSError {
//                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
//            }
//        }
//    }
//}
//
//extension DataManager: NSFetchedResultsControllerDelegate {
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        if let newTodos = controller.fetchedObjects as? [TodoMO] {
////            self.todos = OrderedDictionary(uniqueKeysWithValues: newTodos.map({ ($0.id!, Todo(todoMO: $0)) }))
////        } else if let newProjects = controller.fetchedObjects as? [ProjectMO] {
////            print(newProjects)
////            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
////        }
//    }
//}
