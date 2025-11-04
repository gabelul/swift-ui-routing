import SwiftUI

extension View {
    /// タブのルーティング設定を自動適用
    ///
    /// タブの型から自動的にルーティング型を推論して適用します。
    ///
    /// # 使用例
    /// ```swift
    /// struct TodoListTab: Tabbable {
    ///     typealias Route = AppRoute
    ///     typealias Sheet = AppSheet
    ///     typealias Alert = AppAlert
    ///
    ///     var contentView: some View {
    ///         TodoListView()
    ///     }
    /// }
    ///
    /// // ルーティング設定が自動適用される
    /// TodoListTab().contentView.tabRouting(tab: TodoListTab())
    /// ```
    ///
    /// - Parameter tab: 現在のタブ
    public func tabRouting<Tab>(
        tab: Tab
    ) -> some View where Tab: Tabbable {
        modifier(
            TabRoutingModifier<Tab, Tab.Route, Tab.Sheet, Tab.Alert, Tab.FullScreen, Tab.CustomSheet>(
                tab: tab
            )
        )
    }
}
