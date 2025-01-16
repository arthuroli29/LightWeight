import SwiftUI

protocol ViewFactory {
    func makeView() -> AnyView
}

typealias Routable = ViewFactory & Hashable

struct AnyRoutable: Routable {
    private let base: any Routable
    private let equals: (any Routable) -> Bool
    private let makeViewImpl: () -> AnyView
    private let hashImpl: (inout Hasher) -> Void

    init<T: Routable>(_ routable: T) {
        base = routable
        equals = { other in
            guard let otherBase = other as? T else { return false }
            return routable == otherBase
        }
        makeViewImpl = routable.makeView
        hashImpl = { hasher in
            routable.hash(into: &hasher)
        }
    }

    func makeView() -> AnyView {
        makeViewImpl()
    }

    func hash(into hasher: inout Hasher) {
        hashImpl(&hasher)
    }

    static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.equals(rhs.base)
    }
}