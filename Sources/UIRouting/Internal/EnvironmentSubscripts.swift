import SwiftUI

extension EnvironmentValues {
    subscript<Route: Routable>(router specifier: RouterSpecifier<Route>) -> Router<Route> {
        get { self[GenericRouterKey<Route>.self] }
        set { self[GenericRouterKey<Route>.self] = newValue }
    }

    subscript<Sheet>(sheetPresenter specifier: SheetPresenterSpecifier<Sheet>) -> SheetPresenter<Sheet> where Sheet: Sheetable {
        get { self[GenericSheetPresenterKey<Sheet>.self] }
        set { self[GenericSheetPresenterKey<Sheet>.self] = newValue }
    }

    subscript<Alert: Alertable>(alertPresenter specifier: AlertPresenterSpecifier<Alert>) -> AlertPresenter<Alert> {
        get {
            switch specifier.context {
            case .navigation:
                return self[GenericAlertPresenterOnNavigationKey<Alert>.self]
            case .sheet:
                return self[GenericAlertPresenterOnSheetKey<Alert>.self]
            }
        }
        set {
            switch specifier.context {
            case .navigation:
                self[GenericAlertPresenterOnNavigationKey<Alert>.self] = newValue
            case .sheet:
                self[GenericAlertPresenterOnSheetKey<Alert>.self] = newValue
            }
        }
    }

    subscript<Sheet>(customHeightSheetPresenter specifier: CustomHeightSheetPresenterSpecifier<Sheet>) -> CustomHeightSheetPresenter<Sheet> where Sheet: CustomHeightSheetable {
        get { self[GenericCustomHeightSheetPresenterKey<Sheet>.self] }
        set { self[GenericCustomHeightSheetPresenterKey<Sheet>.self] = newValue }
    }

    subscript<Cover>(fullScreenCoverPresenter specifier: FullScreenCoverPresenterSpecifier<Cover>) -> FullScreenCoverPresenter<Cover> where Cover: Identifiable & Hashable {
        get { self[GenericFullScreenCoverPresenterKey<Cover>.self] }
        set { self[GenericFullScreenCoverPresenterKey<Cover>.self] = newValue }
    }

    subscript<Tab: Tabbable>(tabPresenter specifier: TabPresenterSpecifier<Tab>) -> TabPresenter<Tab> {
        get { self[GenericTabPresenterKey<Tab>.self] }
        set { self[GenericTabPresenterKey<Tab>.self] = newValue }
    }

    subscript<Sidebar: SidebarItem>(splitViewPresenter specifier: SplitViewPresenterSpecifier<Sidebar>) -> SplitViewPresenter<Sidebar> {
        get { self[GenericSplitViewPresenterKey<Sidebar>.self] }
        set { self[GenericSplitViewPresenterKey<Sidebar>.self] = newValue }
    }
}

