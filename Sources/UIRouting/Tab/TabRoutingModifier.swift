import SwiftUI

/// タブのルーティング設定を自動化する ViewModifier。
///
/// 各タブに対して Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 自動的に設定し、NavigationStack との連携も行います。
///
/// これにより、タブごとに独立したルーティングスタックを持つことができます。
///
/// 通常は `.tabRouting(tab:)` モディファイアを通じて使用します。
public struct TabRoutingModifier<
    Tab: Tabbable,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable,
    Sidebar: SidebarItem
>: ViewModifier where Tab.Route == Route, Tab.Sidebar == Sidebar {

    @Environment private var tabPresenter: TabPresenter<Tab>

    private let currentTab: Tab

    // 各Presenterを内部で管理
    @State private var router = Router<Route>()
    @State private var sheetPresenter = SheetPresenter<Sheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<Alert>()
    @State private var alertPresenterOnSheet = AlertPresenter<Alert>()
    @State private var fullScreenCoverPresenter = FullScreenCoverPresenter<FullScreen>()
    @State private var customHeightSheetPresenter = CustomHeightSheetPresenter<CustomSheet>()
    @State private var splitViewPresenter = SplitViewPresenter<Sidebar>()

    public init(tab: Tab) {
        self.currentTab = tab
        self._tabPresenter = Environment(.tab(Tab.self))
    }

    public func body(content: Content) -> some View {
        content
            // NavigationStack または NavigationSplitView を条件分岐で適用
            .modifier(NavigationScopeModifierIfNeeded<Tab, Route, Alert, Sidebar>(tab: currentTab))
            // 既存のroutingモディファイアを適用
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
            // TabPresenterとの統合: Routerを登録
            .onAppear {
                tabPresenter.registerRouter(router, for: currentTab)
            }
    }
}

// MARK: - Conditional Modifiers

/// NavigationStack または NavigationSplitView を条件分岐で適用する内部用 Modifier。
///
/// タブの Sidebar 型が Never でない場合は NavigationSplitView を、
/// そうでない場合は NavigationStack を適用します。
private struct NavigationScopeModifierIfNeeded<
    Tab: Tabbable,
    Route: Routable,
    Alert: Alertable,
    Sidebar: SidebarItem
>: ViewModifier where Tab.Route == Route, Tab.Sidebar == Sidebar {
    let tab: Tab

    func body(content: Content) -> some View {
        if Tab.Sidebar.self != Never.self {
            // NavigationSplitView を使用
            content.splitViewScope(for: Sidebar.self, items: tab.sidebarItems, alert: Alert.self)
        } else if Tab.Route.self != Never.self {
            // NavigationStack を使用
            content.routingScope(for: Route.self, alert: Alert.self)
        } else {
            // どちらも使用しない
            content
        }
    }
}
