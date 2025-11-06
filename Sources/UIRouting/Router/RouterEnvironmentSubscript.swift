import SwiftUI

extension EnvironmentValues {
    subscript<Route: Routable>(router specifier: RouterSpecifier<Route>) -> Router<Route> {
        get { self[GenericRouterKey<Route>.self] }
        set { self[GenericRouterKey<Route>.self] = newValue }
    }
}
