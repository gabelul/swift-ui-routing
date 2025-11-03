import SwiftUI
import UIRouting

struct RootView: View {
    @State private var router = Router<AppRoute>()
    @State private var sheetPresenter = SheetPresenter<AppSheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<AppAlert>()
    @State private var alertPresenterOnSheet = AlertPresenter<AppAlert>()

    var body: some View {
        TodoListView()
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet
            )
            .sheet(item: $sheetPresenter.presentedSheet) { sheet in
                sheet.body
            }
    }
}

#Preview {
    RootView()
}
