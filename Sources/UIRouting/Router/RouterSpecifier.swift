import SwiftUI

// MARK: - Router Specifier

struct RouterSpecifier<Route: Routable>: Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Route.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
