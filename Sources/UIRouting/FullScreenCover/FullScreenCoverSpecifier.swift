import SwiftUI

// MARK: - FullScreenCoverPresenter Specifier

struct FullScreenCoverPresenterSpecifier<Cover>: Hashable where Cover: Identifiable & Hashable {
    let context: PresentationContext

    init(context: PresentationContext = .navigation) {
        self.context = context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Cover.self))
        hasher.combine(context)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.context == rhs.context
    }
}
