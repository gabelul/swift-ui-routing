import SwiftUI
import UIRouting

enum AppRoute: Routable {
    case todoDetail(todo: Todo)

    @ViewBuilder
    var body: some View {
        switch self {
        case .todoDetail(let todo):
            TodoDetailView(todo: todo)
        }
    }
}
