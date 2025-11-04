import SwiftUI
import UIRouting

enum AppCustomHeightSheet: CustomHeightSheetable {
    case categoryPicker(onSelect: (Todo.Category) -> Void)
    case quickAdd

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
}
