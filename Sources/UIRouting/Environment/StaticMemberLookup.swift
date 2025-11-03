import SwiftUI

/// Router用の環境値アクセス
public struct RouterEnvironmentKey<Route: Routable> {
    fileprivate let specifier: RouterSpecifier<Route>
    fileprivate init() {
        self.specifier = RouterSpecifier<Route>()
    }
}

/// SheetPresenter用の環境値アクセス
public struct SheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: SheetPresenterSpecifier<Sheet>
    fileprivate init() {
        self.specifier = SheetPresenterSpecifier<Sheet>()
    }
}

/// AlertPresenter用の環境値アクセス
public struct AlertEnvironmentKey<Alert: Alertable> {
    fileprivate let specifier: AlertPresenterSpecifier<Alert>
    fileprivate init(context: AlertPresenterContext) {
        self.specifier = AlertPresenterSpecifier<Alert>(context: context)
    }
}

public extension RouterEnvironmentKey {
    static func router(_ type: Route.Type) -> RouterEnvironmentKey<Route> {
        RouterEnvironmentKey<Route>()
    }
}

public extension SheetEnvironmentKey {
    static func sheet(_ type: Sheet.Type) -> SheetEnvironmentKey<Sheet> {
        SheetEnvironmentKey<Sheet>()
    }
}

public extension AlertEnvironmentKey {
    static func alert(_ type: Alert.Type, context: AlertPresenterContext) -> AlertEnvironmentKey<Alert> {
        AlertEnvironmentKey<Alert>(context: context)
    }
}

/// CustomHeightSheetPresenter用の環境値アクセス
public struct CustomHeightSheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: CustomHeightSheetPresenterSpecifier<Sheet>
    fileprivate init() {
        self.specifier = CustomHeightSheetPresenterSpecifier<Sheet>()
    }
}

/// FullScreenCoverPresenter用の環境値アクセス
public struct FullScreenCoverEnvironmentKey<Cover> where Cover: Identifiable & Hashable {
    fileprivate let specifier: FullScreenCoverPresenterSpecifier<Cover>
    fileprivate init() {
        self.specifier = FullScreenCoverPresenterSpecifier<Cover>()
    }
}

public extension CustomHeightSheetEnvironmentKey {
    static func customHeightSheet(_ type: Sheet.Type) -> CustomHeightSheetEnvironmentKey<Sheet> {
        CustomHeightSheetEnvironmentKey<Sheet>()
    }
}

public extension FullScreenCoverEnvironmentKey {
    static func fullScreenCover(_ type: Cover.Type) -> FullScreenCoverEnvironmentKey<Cover> {
        FullScreenCoverEnvironmentKey<Cover>()
    }
}

/// TabPresenter用の環境値アクセス
public struct TabEnvironmentKey<Tab: Tabbable> {
    fileprivate let specifier: TabPresenterSpecifier<Tab>
    fileprivate init() {
        self.specifier = TabPresenterSpecifier<Tab>()
    }
}

public extension TabEnvironmentKey {
    static func tab(_ type: Tab.Type) -> TabEnvironmentKey<Tab> {
        TabEnvironmentKey<Tab>()
    }
}

public extension Environment {
    init<Route: Routable>(_ key: RouterEnvironmentKey<Route>) where Value == Router<Route> {
        self.init(\.[router: key.specifier])
    }

    init<Sheet>(_ key: SheetEnvironmentKey<Sheet>) where Value == SheetPresenter<Sheet>, Sheet: Identifiable & Hashable {
        self.init(\.[sheetPresenter: key.specifier])
    }

    init<Alert: Alertable>(_ key: AlertEnvironmentKey<Alert>) where Value == AlertPresenter<Alert> {
        self.init(\.[alertPresenter: key.specifier])
    }

    init<Sheet>(_ key: CustomHeightSheetEnvironmentKey<Sheet>) where Value == CustomHeightSheetPresenter<Sheet>, Sheet: Identifiable & Hashable {
        self.init(\.[customHeightSheetPresenter: key.specifier])
    }

    init<Cover>(_ key: FullScreenCoverEnvironmentKey<Cover>) where Value == FullScreenCoverPresenter<Cover>, Cover: Identifiable & Hashable {
        self.init(\.[fullScreenCoverPresenter: key.specifier])
    }

    init<Tab: Tabbable>(_ key: TabEnvironmentKey<Tab>) where Value == TabPresenter<Tab> {
        self.init(\.[tabPresenter: key.specifier])
    }
}
