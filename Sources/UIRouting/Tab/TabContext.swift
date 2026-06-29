import SwiftUI

/// タブのルーティングコンテキスト
///
/// タブ切り替え時のコールバックで渡される、タブ固有のルーティング情報を保持する。
///
/// # 使用例
/// ```swift
/// tabPresenter.select(TodoListTab()) { context in
///     // context.router は Router<AppRoute> 型
///     context.router.navigate(to: .todoDetail(todo: someTodo))
/// }
/// ```
@MainActor
public struct TabContext<Route: Routable> {
    /// このタブの Router
    public let router: Router<Route>

    internal init(router: Router<Route>) {
        self.router = router
    }
}
