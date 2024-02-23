//
//  Router.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 31/01/24.
//

import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Hashable {
        case routine(RoutineEntity)
    }
    
    public func getViewForDestination(_ destination: Destination) -> some View {
        let view: AnyView
        switch destination {
        case .routine(let routine):
            view = AnyView(Text(routine.name ?? "Unnamed routine"))
        default:
            view = AnyView(Text("Not implemented yet"))
        }
        return view
    }

    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
