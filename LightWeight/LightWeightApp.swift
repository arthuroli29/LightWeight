//
//  LightWeightApp.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 31/01/24.
//

import SwiftUI

@main
struct LightWeightApp: App {
    let persistenceController = PersistenceController.shared
    let dataManager = DataManager.shared
    
    @ObservedObject var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                RoutinesView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .navigationDestination(for: Router.Destination.self) { destination in
                    router.getViewForDestination(destination)
                }
            }
            .environmentObject(router)
            .environmentObject(dataManager)
        }
    }
}
