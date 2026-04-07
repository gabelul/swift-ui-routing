import SwiftUI

/// A view modifier that wires up a `Router` to a `NavigationStack` in a self-contained way.
///
/// Unlike `RoutingScopeModifier`, this does not require an `Alertable` type and enables
/// navigation management using a `Router` alone.
/// It follows the same “self-contained” pattern as `SheetPresenterModifier` by creating the router,
/// binding it to `NavigationStack`, and injecting it into the environment.
///
/// Typically used via the `.routerScope(for:)` modifier.
///
/// # Example
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
    /// A modifier that wires up a `NavigationStack` and `Router` in a self-contained way.
    ///
    /// Unlike `routingScope(for:alert:)`, this does not require an `Alertable` type.
    /// Use it when you want the `Router` to own navigation state on its own.
    ///
    /// Internally this:
    /// - Creates and stores a `Router<Route>` in `@State`
    /// - Binds it to `NavigationStack(path:)`
    /// - Registers `.navigationDestination(for:)`
    /// - Injects the router into the environment via `transformEnvironment`
    ///
    /// # Example
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
    /// - Parameter type: The routable type to manage (conforms to `Routable`)
    /// - Returns: A view wrapped in a `NavigationStack` with routing enabled
    func routerScope<Route: Routable>(for type: Route.Type) -> some View {
        modifier(RouterScopeModifier<Route>())
    }
}
