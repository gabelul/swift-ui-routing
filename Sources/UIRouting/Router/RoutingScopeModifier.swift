import SwiftUI

/// Router と NavigationStack を連携させる ViewModifier。
///
/// Router の path を NavigationStack にバインドし、
/// 各画面に自動的にアラート機能を適用します。
///
/// 通常は `.routingScope()` モディファイアを通じて使用します。
///
/// # 使用例
/// ```swift
/// ContentView()
///     .routingScope(for: Screen.self, alert: Alert.self)
/// ```
public struct RoutingScopeModifier<Route: Routable, Alert: Alertable>: ViewModifier {
    @Environment private var router: Router<Route>

    public init() {
        self._router = Environment(.router(Route.self))
    }

    public func body(content: Content) -> some View {
        @Bindable var routerBinding = router

        NavigationStack(path: $routerBinding.path) {
            content
                .routingAlert(for: Alert.self)
                .navigationDestination(for: Route.self) { route in
                    route.body
                        .routingAlert(for: Alert.self)
                }
        }
    }
}

public extension View {
    /// NavigationStack と Router を連携させ、ルーティングスコープを設定します。
    ///
    /// このモディファイアは以下を行います：
    /// - Router の path を NavigationStack にバインド
    /// - 各画面に `.routingAlert()` を自動適用
    /// - `.navigationDestination()` で画面遷移先を設定
    ///
    /// # 使用例
    /// ```swift
    /// struct RootView: View {
    ///     var body: some View {
    ///         HomeView()
    ///             .routingScope(for: AppRoute.self, alert: AppAlert.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - for: ルーティング対象の型（Routable に準拠）
    ///   - alert: アラートの型（Alertable に準拠）
    /// - Returns: NavigationStack でラップされ、ルーティングが有効化されたビュー
    func routingScope<Route: Routable, Alert: Alertable>(for: Route.Type, alert: Alert.Type) -> some View {
        modifier(RoutingScopeModifier<Route, Alert>())
    }
}
