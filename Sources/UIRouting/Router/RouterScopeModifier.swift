import SwiftUI

/// Router と NavigationStack を自己完結で連携させる ViewModifier。
///
/// `RoutingScopeModifier` と異なり `Alertable` 型を必要とせず、
/// Router 単体でのナビゲーション管理を可能にする。
/// `SheetPresenterModifier` と同じ「自己完結型」パターンで、
/// Router の作成・NavigationStack バインディング・環境注入を一括で行う。
///
/// 通常は `.routerScope()` モディファイアを通じて使用する。
///
/// # 使用例
/// ```swift
/// ContentView()
///     .routerScope(for: AppRoute.self)
/// ```
struct RouterScopeModifier<Route: Routable>: ViewModifier {
    @State private var router = Router<Route>()

    func body(content: Content) -> some View {
        @Bindable var bindableRouter = router

        NavigationStack(path: $bindableRouter.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    route.body
                }
        }
        .transformEnvironment(\.self) { env in
            env[router: RouterSpecifier<Route>()] = router
        }
    }
}

public extension View {
    /// NavigationStack と Router を自己完結で連携させるモディファイア。
    ///
    /// `routingScope(for:alert:)` と異なり `Alertable` 型を必要とせず、
    /// Router のみでナビゲーションを管理したい場合に使用する。
    ///
    /// 内部で以下を行う：
    /// - `Router<Route>` の生成と `@State` での保持
    /// - `NavigationStack(path:)` へのバインド
    /// - `.navigationDestination(for:)` の登録
    /// - `transformEnvironment` による Router の環境注入
    ///
    /// # 使用例
    /// ```swift
    /// struct RootView: View {
    ///     var body: some View {
    ///         HomeView()
    ///             .routerScope(for: AppRoute.self)
    ///             .sheetPresenter(for: AppSheet.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: ルーティング対象の型（Routable に準拠）
    /// - Returns: NavigationStack でラップされ、ルーティングが有効化されたビュー
    func routerScope<Route: Routable>(for type: Route.Type) -> some View {
        modifier(RouterScopeModifier<Route>())
    }
}
