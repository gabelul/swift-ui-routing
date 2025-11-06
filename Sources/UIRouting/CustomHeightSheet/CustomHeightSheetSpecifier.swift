import SwiftUI

// MARK: - CustomHeightSheetPresenter Specifier

struct CustomHeightSheetPresenterSpecifier<Sheet>: Hashable where Sheet: Identifiable & Hashable {
    let context: PresentationContext

    init(context: PresentationContext = .navigation) {
        self.context = context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Sheet.self))
        hasher.combine(context)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.context == rhs.context
    }
}
