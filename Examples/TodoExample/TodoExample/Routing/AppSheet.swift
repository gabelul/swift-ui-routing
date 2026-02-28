import SwiftUI
import UIRouting

enum AppSheet: Sheetable {
    case addTodo
    case filter
    case advancedSettings
    case categoryPicker(onSelect: (Todo.Category) -> Void)

    @ViewBuilder
    var body: some View {
        switch self {
        case .addTodo:
            NavigationStack {
                AddTodoSheet()
            }
            .sheetPresenter(for: AppSheet.self, context: .sheet)
        case .filter:
            NavigationStack {
                FilterSheet()
            }
        case .advancedSettings:
            AdvancedSettingsSheet()
        case .categoryPicker(let onSelect):
            NavigationStack {
                CategoryPickerSheetViewWithClosure(onSelect: onSelect)
            }
        }
    }
}
