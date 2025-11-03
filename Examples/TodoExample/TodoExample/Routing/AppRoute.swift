import SwiftUI
import UIRouting

enum AppRoute: Routable {
    case todoDetail(todo: Todo)
    case settings

    var id: String {
        switch self {
        case .todoDetail(let todo):
            return "todoDetail_\(todo.id)"
        case .settings:
            return "settings"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .todoDetail(let todo):
            TodoDetailView(todo: todo)
        case .settings:
            SettingsView()
        }
    }
}
