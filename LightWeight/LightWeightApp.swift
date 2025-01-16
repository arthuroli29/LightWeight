//
//  LightWeightApp.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 31/01/24.
//

import SwiftUI

@main
struct LightWeightApp: App {
    let dataManager = DataManager.shared
    @StateObject var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appRouter.paths) {
                appRouter.resolveInitialRouter().makeView()
                    .navigationDestination(for: AnyRoutable.self) { router in
                        router.makeView()
                    }
            }
            .environmentObject(dataManager)
        }
    }
}
