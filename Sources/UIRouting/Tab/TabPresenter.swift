import SwiftUI

/// TabView の選択状態を管理する型安全なプレゼンター
///
/// # 使用例
/// ```swift
/// // 1. タブを定義
/// enum AppTab: Tabbable {
///     case home
///     case search
///     case profile
///
///     var id: String {
///         switch self {
///         case .home: return "home"
///         case .search: return "search"
///         case .profile: return "profile"
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .home: HomeView()
///         case .search: SearchView()
///         case .profile: ProfileView()
///         }
///     }
///
///     @ViewBuilder
///     var tabLabel: some View {
///         switch self {
///         case .home: Label("ホーム", systemImage: "house")
///         case .search: Label("検索", systemImage: "magnifyingglass")
///         case .profile: Label("プロフィール", systemImage: "person")
///         }
///     }
/// }
///
/// // 2. TabPresenterインスタンスを作成してTabViewを構築
/// @State private var tabPresenter = TabPresenter<AppTab>(initialTab: .home)
///
/// var body: some View {
///     TabRouting(
///         tabPresenter: tabPresenter,
///         tabs: [.home, .search, .profile]
///     )
/// }
///
/// // 3. タブを切り替え
/// struct HomeView: View {
///     @Environment(.tab(AppTab.self)) private var tabPresenter
///
///     var body: some View {
///         Button("検索タブへ") {
///             tabPresenter.select(.search)
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class TabPresenter<Tab: Tabbable> {
    /// 現在選択されているタブ
    public var selectedTab: Tab

    /// 保留中のナビゲーションアクション（type-erased）
    private var pendingNavigation: PendingNavigation?

    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }

    /// 指定したタブを選択（基本版）
    public func select(_ tab: Tab) {
        selectedTab = tab
        pendingNavigation = nil // 保留アクションをクリア
    }

    /// 指定したタブを選択し、Router操作を予約
    ///
    /// タブ切り替え後に、そのタブのRouterを使って特定の画面へ遷移できます。
    ///
    /// # 使用例
    /// ```swift
    /// // 設定画面から特定のTodoを開く
    /// tabPresenter.select(.todoList) { (router: Router<AppRoute>) in
    ///     router.navigate(to: .todoDetail(todo: someTodo))
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - tab: 切り替え先のタブ
    ///   - action: Router操作を行うクロージャー（型注釈が必要）
    public func select<R: Routable>(
        _ tab: Tab,
        then action: @escaping (Router<R>) -> Void
    ) {
        pendingNavigation = PendingNavigation(
            tabId: tab.id,
            action: { router in
                guard let typedRouter = router as? Router<R> else {
                    assertionFailure("Router type mismatch. Expected Router<\(R.self)>")
                    return
                }
                action(typedRouter)
            }
        )
        selectedTab = tab
    }

    /// 保留中のナビゲーションを実行
    ///
    /// 各タブのルートビューの `onAppear` で呼び出されます。
    /// 通常、`TabRoutingModifier`が自動的に呼び出すため、手動で呼ぶ必要はありません。
    ///
    /// - Parameters:
    ///   - tab: 現在のタブ
    ///   - router: このタブのRouter
    public func executePendingNavigation<R: Routable>(
        for tab: Tab,
        with router: Router<R>
    ) {
        guard let pending = pendingNavigation,
              pending.tabId == tab.id else {
            return
        }

        // 次のrunloopで実行（タブ切り替えアニメーション完了後）
        DispatchQueue.main.async { [weak self] in
            pending.action(router)
            self?.pendingNavigation = nil
        }
    }

    /// 保留中のナビゲーションの有無を確認
    ///
    /// - Parameter tab: 確認対象のタブ
    /// - Returns: 保留中のナビゲーションがある場合true
    public func hasPendingNavigation(for tab: Tab) -> Bool {
        pendingNavigation?.tabId == tab.id
    }
}

// MARK: - Supporting Types

extension TabPresenter {
    private struct PendingNavigation {
        let tabId: Tab.ID
        let action: (Any) -> Void
    }
}
