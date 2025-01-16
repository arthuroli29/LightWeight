import SwiftUI

protocol NavigationCoordinator {
    func push(_ router: any Routable)
    func popLast()
    func popToRoot()
}