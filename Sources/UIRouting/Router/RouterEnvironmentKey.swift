import SwiftUI

/// Router用の環境値アクセスキー。
///
/// `@Environment(.router(Screen.self))` の形式で Router にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.router(Screen.self)) private var router
///
///     var body: some View {
///         Button("Navigate") {
///             router.navigate(to: .detail)
///         }
///     }
/// }
/// ```
public struct RouterEnvironmentKey<Route: Routable> {
    fileprivate let specifier: RouterSpecifier<Route>
    fileprivate init() {
        self.specifier = RouterSpecifier<Route>()
    }
}

public extension RouterEnvironmentKey {
    /// Router の環境値キーを生成します。
    ///
    /// - Parameter type: ルーティング対象の型
    /// - Returns: Router用の環境値キー
    static func router(_ type: Route.Type) -> RouterEnvironmentKey<Route> {
        RouterEnvironmentKey<Route>()
    }
}

public extension Environment {
    init<Route: Routable>(_ key: RouterEnvironmentKey<Route>) where Value == Router<Route> {
        self.init(\.[router: key.specifier])
    }
}
