import SwiftUI

/// TabView の選択状態を管理する型安全なプレゼンター
///
/// # 使用例
/// ```swift
/// @State private var tabPresenter = TabPresenter(initialTab: AppTab.todoList)
///
/// var body: some View {
///     TabRouting(tabPresenter: tabPresenter, tabs: [.todoList, .settings])
/// }
/// ```
@MainActor
@Observable
public final class TabPresenter<Tab: Tabbable> {
    /// 現在選択されているタブ
    public var selectedTab: Tab

    /// Router を型安全に保持
    private var router: Router<Tab.Route>?

    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }

    // MARK: - Router Registration

    /// Router を登録（TabRoutingModifier から呼ばれる）
    internal func registerRouter(_ router: Router<Tab.Route>) {
        self.router = router
    }

    // MARK: - Tab Selection

    /// 指定したタブを選択（基本版）
    public func select(_ tab: Tab) {
        selectedTab = tab
    }

    /// 指定したタブを選択し、そのタブのコンテキストでコールバックを実行
    ///
    /// # 使用例
    /// ```swift
    /// tabPresenter.select(.todoList) { context in
    ///     context.router.navigate(to: .todoDetail(todo: someTodo))
    /// }
    /// ```
    public func select(_ tab: Tab, then callback: (TabContext<Tab.Route>) -> Void) {
        selectedTab = tab

        guard let router = self.router else {
            assertionFailure("Router not registered")
            return
        }

        let context = TabContext(router: router)
        callback(context)
    }
}
