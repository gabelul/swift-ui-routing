import SwiftUI

extension Router {
    @MainActor
    static func createDefault() -> Router<Route> {
        Router<Route>()
    }
}

extension SheetPresenter {
    @MainActor
    static func createDefault() -> SheetPresenter<Sheet> {
        SheetPresenter<Sheet>()
    }
}

extension CustomHeightSheetPresenter {
    @MainActor
    static func createDefault() -> CustomHeightSheetPresenter<Sheet> {
        CustomHeightSheetPresenter<Sheet>()
    }
}

extension FullScreenCoverPresenter {
    @MainActor
    static func createDefault() -> FullScreenCoverPresenter<Cover> {
        FullScreenCoverPresenter<Cover>()
    }
}

extension AlertPresenter {
    @MainActor
    static func createDefault() -> AlertPresenter<Alert> {
        AlertPresenter<Alert>()
    }
}

struct GenericRouterKey<Route: Routable>: EnvironmentKey {
    static var defaultValue: Router<Route> {
        MainActor.assumeIsolated {
            Router<Route>.createDefault()
        }
    }
}

struct GenericSheetPresenterKey<Sheet>: EnvironmentKey where Sheet: Sheetable {
    static var defaultValue: SheetPresenter<Sheet> {
        MainActor.assumeIsolated {
            SheetPresenter<Sheet>.createDefault()
        }
    }
}

struct GenericCustomHeightSheetPresenterKey<Sheet>: EnvironmentKey where Sheet: CustomHeightSheetable {
    static var defaultValue: CustomHeightSheetPresenter<Sheet> {
        MainActor.assumeIsolated {
            CustomHeightSheetPresenter<Sheet>.createDefault()
        }
    }
}

struct GenericFullScreenCoverPresenterKey<Cover>: EnvironmentKey where Cover: Identifiable & Hashable {
    static var defaultValue: FullScreenCoverPresenter<Cover> {
        MainActor.assumeIsolated {
            FullScreenCoverPresenter<Cover>.createDefault()
        }
    }
}

struct GenericAlertPresenterOnNavigationKey<Alert: Alertable>: EnvironmentKey {
    static var defaultValue: AlertPresenter<Alert> {
        MainActor.assumeIsolated {
            AlertPresenter<Alert>.createDefault()
        }
    }
}

struct GenericAlertPresenterOnSheetKey<Alert: Alertable>: EnvironmentKey {
    static var defaultValue: AlertPresenter<Alert> {
        MainActor.assumeIsolated {
            AlertPresenter<Alert>.createDefault()
        }
    }
}

struct GenericTabPresenterKey<Tab: Tabbable>: EnvironmentKey {
    static var defaultValue: TabPresenter<Tab> {
        fatalError("TabPresenter must be explicitly provided via .tabRouting()")
    }
}
