import SwiftUI

struct GenericTabPresenterKey<Tab: Tabbable>: EnvironmentKey {
    static var defaultValue: TabPresenter<Tab> {
        fatalError("TabPresenter must be explicitly provided via .tabRouting()")
    }
}
