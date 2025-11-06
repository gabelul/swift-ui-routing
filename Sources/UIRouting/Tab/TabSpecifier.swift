import SwiftUI

// MARK: - TabPresenter Specifier

struct TabPresenterSpecifier<Tab: Tabbable>: Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Tab.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
