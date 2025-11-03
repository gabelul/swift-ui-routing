import SwiftUI

extension View {
    /// タブのルーティング設定を適用（完全版）
    ///
    /// すべてのPresenter型を指定できます。不要な型は`Never`（デフォルト）を指定してください。
    ///
    /// # 使用例
    /// ```swift
    /// TodoListView()
    ///     .tabRouting(
    ///         tab: .todoList,
    ///         route: AppRoute.self,
    ///         sheet: AppSheet.self,
    ///         alert: AppAlert.self,
    ///         fullScreenCover: AppFullScreenCover.self,
    ///         customHeightSheet: AppCustomHeightSheet.self
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - tab: 現在のタブ
    ///   - route: ルート型（必須）
    ///   - sheet: シート型（デフォルト: Never）
    ///   - alert: アラート型（デフォルト: Never）
    ///   - fullScreenCover: フルスクリーンカバー型（デフォルト: Never）
    ///   - customHeightSheet: カスタム高さシート型（デフォルト: Never）
    public func tabRouting<Tab, Route, Sheet, Alert, FullScreen, CustomSheet>(
        tab: Tab,
        route: Route.Type,
        sheet: Sheet.Type = Never.self,
        alert: Alert.Type = Never.self,
        fullScreenCover: FullScreen.Type = Never.self,
        customHeightSheet: CustomSheet.Type = Never.self
    ) -> some View where
        Tab: Tabbable,
        Route: Routable,
        Sheet: Sheetable,
        Alert: Alertable,
        FullScreen: FullScreenCoverable,
        CustomSheet: CustomHeightSheetable
    {
        modifier(
            TabRoutingModifier<Tab, Route, Sheet, Alert, FullScreen, CustomSheet>(
                tab: tab
            )
        )
    }

    /// タブのルーティング設定を適用（Route + Sheet + Alert）
    ///
    /// 最も一般的な組み合わせのための便利メソッド。
    ///
    /// # 使用例
    /// ```swift
    /// TodoListView()
    ///     .tabRouting(
    ///         tab: .todoList,
    ///         route: AppRoute.self,
    ///         sheet: AppSheet.self,
    ///         alert: AppAlert.self
    ///     )
    /// ```
    public func tabRouting<Tab, Route, Sheet, Alert>(
        tab: Tab,
        route: Route.Type,
        sheet: Sheet.Type,
        alert: Alert.Type
    ) -> some View where
        Tab: Tabbable,
        Route: Routable,
        Sheet: Sheetable,
        Alert: Alertable
    {
        tabRouting(
            tab: tab,
            route: route,
            sheet: sheet,
            alert: alert,
            fullScreenCover: Never.self,
            customHeightSheet: Never.self
        )
    }

    /// タブのルーティング設定を適用（Routeのみ）
    ///
    /// ナビゲーションのみが必要な場合の最もシンプルな形式。
    ///
    /// # 使用例
    /// ```swift
    /// TodoListView()
    ///     .tabRouting(
    ///         tab: .todoList,
    ///         route: AppRoute.self
    ///     )
    /// ```
    public func tabRouting<Tab, Route>(
        tab: Tab,
        route: Route.Type
    ) -> some View where
        Tab: Tabbable,
        Route: Routable
    {
        tabRouting(
            tab: tab,
            route: route,
            sheet: Never.self,
            alert: Never.self,
            fullScreenCover: Never.self,
            customHeightSheet: Never.self
        )
    }
}
