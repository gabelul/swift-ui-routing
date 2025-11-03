import SwiftUI
import UIRouting

enum AppSheet: Routable {
    case addTodo
    case filter
    case advancedSettings

    var id: String {
        switch self {
        case .addTodo: return "addTodo"
        case .filter: return "filter"
        case .advancedSettings: return "advancedSettings"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .addTodo:
            NavigationStack {
                AddTodoSheet()
            }
        case .filter:
            NavigationStack {
                FilterSheet()
            }
        case .advancedSettings:
            AdvancedSettingsSheet()
        }
    }
}
