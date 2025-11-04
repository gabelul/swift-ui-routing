import SwiftUI

/// 3カラムSplitView のコンテンツビューに対してルーティング設定を自動化する ViewModifier。
///
/// コンテンツビューに対して Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 自動的に設定します。
///
/// 通常は `.threeColumnContentRouting()` モディファイアを通じて使用します。
public struct ThreeColumnContentRoutingModifier<
    Sidebar: SidebarItem,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable
>: ViewModifier where Sidebar.ContentRoute == Route {

    @Environment private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @Environment private var router: Router<Route>

    // 各Presenterを内部で管理
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
            // Presenterを環境に注入
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet,
                splitViewPresenter: splitViewPresenter
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

/// 3カラムSplitView の詳細ビューに対してルーティング設定を自動化する ViewModifier。
///
/// 詳細ビューに対して Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 自動的に設定します。
///
/// 通常は `.threeColumnDetailRouting()` モディファイアを通じて使用します。
public struct ThreeColumnDetailRoutingModifier<
    Sidebar: SidebarItem,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable
>: ViewModifier where Sidebar.DetailRoute == Route {

    @Environment private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @Environment private var router: Router<Route>

    // 各Presenterを内部で管理
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
            // Presenterを環境に注入
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet,
                splitViewPresenter: splitViewPresenter
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
