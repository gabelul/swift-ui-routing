import SwiftUI

/// SplitView の詳細ビューに対してルーティング設定を自動化する ViewModifier。
///
/// 各詳細ビューに対して Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 自動的に設定し、NavigationStack との連携も行います。
///
/// 通常は `.splitViewRouting()` モディファイアを通じて使用します。
public struct SplitViewRoutingModifier<
    Sidebar: SidebarItem,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable
>: ViewModifier where Sidebar.DetailRoute == Route {

    @Environment private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @Environment private var router: Router<Route>

    // 各Presenterを内部で管理（RouterはEnvironmentから取得）
    @State private var sheetPresenter = SheetPresenter<Sheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<Alert>()
    @State private var alertPresenterOnSheet = AlertPresenter<Alert>()
    @State private var fullScreenCoverPresenter = FullScreenCoverPresenter<FullScreen>()
    @State private var customHeightSheetPresenter = CustomHeightSheetPresenter<CustomSheet>()

    public init() {
        self._splitViewPresenter = Environment(.splitView(Sidebar.self))
        self._router = Environment(.router(Route.self))
    }

    public func body(content: Content) -> some View {
        content
            // Presenterを環境に注入（RouterはすでにEnvironmentにあるのでそのまま使う）
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet,
                splitViewPresenter: SplitViewPresenter<Never>()
            )
            // Sheetの自動適用
            .modifier(SheetModifierIfNeeded(presenter: sheetPresenter))
            // FullScreenCoverの自動適用
            .modifier(FullScreenCoverModifierIfNeeded(presenter: fullScreenCoverPresenter))
            // CustomHeightSheetの自動適用
            .modifier(CustomHeightSheetModifierIfNeeded(presenter: customHeightSheetPresenter))
            // Alertの自動適用
            .modifier(AlertModifierIfNeeded(presenter: alertPresenterOnNavigation))
    }
}
