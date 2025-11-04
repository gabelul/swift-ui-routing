import SwiftUI
import UIRouting

struct RootView: View {
    @State private var tabPresenter = TabPresenter(
        initialTab: AppTab.todoList
    )

    var body: some View {
        TabRouting(
            tabPresenter: tabPresenter,
            tabs: [.todoList, .settings]
        )
    }
}

#Preview {
    RootView()
}
