import SwiftUI
import UIRouting

enum AppRoute: Routable {
    case todoDetail(todo: Todo)

    var id: String {
        switch self {
        case .todoDetail(let todo):
            return "todoDetail_\(todo.id)"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .todoDetail(let todo):
            TodoDetailView(todo: todo)
        }
    }
}
