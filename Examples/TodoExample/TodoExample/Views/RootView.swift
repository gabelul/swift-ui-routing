import SwiftUI
import UIRouting

struct RootView: View {
    @State private var router = Router<AppRoute>()
    @State private var sheetPresenter = SheetPresenter<AppSheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<AppAlert>()
    @State private var alertPresenterOnSheet = AlertPresenter<AppAlert>()
    @State private var fullScreenCoverPresenter = FullScreenCoverPresenter<AppFullScreenCover>()
    @State private var customHeightSheetPresenter = CustomHeightSheetPresenter<AppCustomHeightSheet>()

    var body: some View {
        TodoListView()
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet
            )
            .sheet(item: $sheetPresenter.presentedSheet) { sheet in
                sheet.body
            }
            .fullScreenCover(item: $fullScreenCoverPresenter.presentedCover) { cover in
                cover.body
            }
            .sheet(item: $customHeightSheetPresenter.presentedSheet) { sheet in
                sheet.body
                    .presentationDetents(sheet.detents)
            }
    }
}

#Preview {
    RootView()
}
