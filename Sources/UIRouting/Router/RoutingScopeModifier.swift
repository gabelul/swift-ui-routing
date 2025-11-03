import SwiftUI

/// Router と NavigationStack を連携させる ViewModifier
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
    /// NavigationStack と Router を連携
    ///
    /// - Parameters:
    ///   - for: ルーティング対象の型
    ///   - alert: アラートの型
    func routingScope<Route: Routable, Alert: Alertable>(for: Route.Type, alert: Alert.Type) -> some View {
        modifier(RoutingScopeModifier<Route, Alert>())
    }
}
