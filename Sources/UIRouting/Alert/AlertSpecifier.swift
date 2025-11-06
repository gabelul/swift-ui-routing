import SwiftUI

// MARK: - AlertPresenter Specifier

struct AlertPresenterSpecifier<Alert: Alertable>: Hashable {
    let context: PresentationContext

    init(context: PresentationContext) {
        self.context = context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Alert.self))
        hasher.combine(context)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.context == rhs.context
    }
}
