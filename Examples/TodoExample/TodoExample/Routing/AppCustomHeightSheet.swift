import SwiftUI
import UIRouting

enum AppCustomHeightSheet: Routable {
    case categoryPicker(onSelect: (Todo.Category) -> Void)
    case quickAdd

    var id: String {
        switch self {
        case .categoryPicker: return "categoryPicker"
        case .quickAdd: return "quickAdd"
        }
    }

    var detents: Set<PresentationDetent> {
        switch self {
        case .categoryPicker:
            return [.height(250)]
        case .quickAdd:
            return [.medium, .large]
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .categoryPicker(let onSelect):
            CategoryPickerSheet(onSelect: onSelect)
        case .quickAdd:
            QuickAddSheet()
        }
    }

    // MARK: - Equatable
    static func == (lhs: AppCustomHeightSheet, rhs: AppCustomHeightSheet) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
