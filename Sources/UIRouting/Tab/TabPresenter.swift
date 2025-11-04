import SwiftUI

/// TabView の選択状態を管理する型安全なプレゼンター。
///
/// タブの選択状態を管理し、各タブごとに独立した Router を保持します。
/// `TabRouting` と組み合わせて使用することで、タブベースのルーティングを実現します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @State private var tabPresenter = TabPresenter(initialTab: AppTab.home)
///
///     var body: some View {
///         TabRouting(tabPresenter: tabPresenter, tabs: [.home, .search, .settings])
///     }
/// }
/// ```
@MainActor
@Observable
public final class TabPresenter<Tab: Tabbable> {
    /// 現在選択されているタブ
    public var selectedTab: Tab

    /// 各タブごとの Router を保持
    private var routers: [Tab.ID: Router<Tab.Route>] = [:]

    /// TabPresenter を初期化します。
    ///
    /// - Parameter initialTab: 最初に選択されるタブ
    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }

    // MARK: - Router Registration

    /// Router を登録します（TabRoutingModifier から内部的に呼ばれます）。
    ///
    /// - Parameters:
    ///   - router: 登録する Router
    ///   - tab: Router を登録するタブ
    internal func registerRouter(_ router: Router<Tab.Route>, for tab: Tab) {
        routers[tab.id] = router
    }

    // MARK: - Tab Selection

    /// 指定したタブを選択します。
    ///
    /// # 使用例
    /// ```swift
    /// @Environment(.tab(AppTab.self)) private var tabPresenter
    ///
    /// Button("設定タブへ移動") {
    ///     tabPresenter.select(.settings)
    /// }
    /// ```
    ///
    /// - Parameter tab: 選択するタブ
    public func select(_ tab: Tab) {
        selectedTab = tab
    }

    /// 指定したタブを選択し、そのタブのコンテキストでコールバックを実行します。
    ///
    /// タブ切り替えと同時に、そのタブの Router を使った画面遷移を行いたい場合に使用します。
    /// コールバックはタブ切り替えのアニメーション完了後に実行されます。
    ///
    /// # 使用例
    /// ```swift
    /// @Environment(.tab(AppTab.self)) private var tabPresenter
    ///
    /// Button("ホームタブで詳細画面を開く") {
    ///     tabPresenter.select(.home) { context in
    ///         context.router.navigate(to: .detail(id: "123"))
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - tab: 選択するタブ
    ///   - callback: タブ選択後に実行されるコールバック（TabContext を受け取る）
    public func select(_ tab: Tab, then callback: @escaping (TabContext<Tab.Route>) -> Void) {
        selectedTab = tab

        // タブ切り替えが完了してからコールバックを実行
        Task { @MainActor in
            // TabViewのアニメーション完了を待つ
            try? await Task.sleep(for: .milliseconds(100))

            guard let router = routers[tab.id] else {
                assertionFailure("Router not registered for tab: \(tab.id)")
                return
            }

            let context = TabContext(router: router)
            callback(context)
        }
    }
}
