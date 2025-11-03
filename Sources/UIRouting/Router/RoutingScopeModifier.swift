import SwiftUI

/// Router と NavigationStack を連携させる ViewModifier
///
/// # 使用例
/// ```swift
/// ContentView()
///     .routingScope(for: Screen.self)
///     .navigationDestination(for: Screen.self) { screen in
///         screen.body
///     }
/// ```
public struct RoutingScopeModifier<Route: Routable>: ViewModifier {
    @Environment private var router: Router<Route>

    public init() {
        self._router = Environment(.router(Route.self))
    }

    public func body(content: Content) -> some View {
        @Bindable var routerBinding = router

        NavigationStack(path: $routerBinding.path) {
            content
        }
    }
}

public extension View {
    /// NavigationStack と Router を連携
    ///
    /// - Parameter for: ルーティング対象の型
    func routingScope<Route: Routable>(for: Route.Type) -> some View {
        modifier(RoutingScopeModifier<Route>())
    }
}
