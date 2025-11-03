import SwiftUI

/// NavigationStack のパスを管理する型安全なルーター
///
/// # 使用例
/// ```swift
/// // 1. 画面遷移先を定義
/// enum Screen: Routable {
///     case profile(userId: String)
///     case settings
///
///     var id: String {
///         switch self {
///         case .profile(let userId): return "profile_\(userId)"
///         case .settings: return "settings"
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .profile(let userId): ProfileView(userId: userId)
///         case .settings: SettingsView()
///         }
///     }
/// }
///
/// // 2. Routerインスタンスを作成してEnvironmentに注入
/// ContentView()
///     .routing(
///         router: Router<Screen>(),
///         sheetPresenter: SheetPresenter<Sheet>(),
///         alertPresenterOnNavigation: AlertPresenter<Alert>(),
///         alertPresenterOnSheet: AlertPresenter<Alert>()
///     )
///
/// // 3. NavigationStackとroutingScopeを設定
/// var body: some View {
///     HomeView()
///         .routingScope(for: Screen.self)
///         .navigationDestination(for: Screen.self) { screen in
///             screen.body
///         }
/// }
///
/// // 4. 画面遷移を実行
/// struct HomeView: View {
///     @Environment(.router(Screen.self)) private var router
///
///     var body: some View {
///         Button("プロフィールを表示") {
///             router.navigate(to: .profile(userId: "123"))
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class Router<Route: Routable> {
    public var path: [Route] = []

    public init() {}

    /// 指定した画面に遷移
    public func navigate(to route: Route) {
        path.append(route)
    }

    /// 前の画面に戻る
    public func back() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// ルート画面まで戻る
    public func popToRoot() {
        path.removeAll()
    }

    /// 現在の画面を置き換え
    public func replace(with route: Route) {
        if path.isEmpty {
            path.append(route)
        } else {
            path[path.count - 1] = route
        }
    }
}
