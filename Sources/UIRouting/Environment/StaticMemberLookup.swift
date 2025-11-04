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

/// SheetPresenter用の環境値アクセスキー。
///
/// `@Environment(.sheet(Sheet.self))` の形式で SheetPresenter にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.sheet(AppSheet.self)) private var sheetPresenter
///
///     var body: some View {
///         Button("Show Sheet") {
///             sheetPresenter.present(.settings)
///         }
///     }
/// }
/// ```
public struct SheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: SheetPresenterSpecifier<Sheet>
    fileprivate init() {
        self.specifier = SheetPresenterSpecifier<Sheet>()
    }
}

/// AlertPresenter用の環境値アクセスキー。
///
/// `@Environment(.alert(Alert.self, context: .navigation))` の形式で AlertPresenter にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter
///
///     var body: some View {
///         Button("Show Alert") {
///             alertPresenter?.present(.error(message: "エラーが発生しました"))
///         }
///     }
/// }
/// ```
public struct AlertEnvironmentKey<Alert: Alertable> {
    fileprivate let specifier: AlertPresenterSpecifier<Alert>
    fileprivate init(context: AlertPresenterContext) {
        self.specifier = AlertPresenterSpecifier<Alert>(context: context)
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

public extension SheetEnvironmentKey {
    /// SheetPresenter の環境値キーを生成します。
    ///
    /// - Parameter type: シートの型
    /// - Returns: SheetPresenter用の環境値キー
    static func sheet(_ type: Sheet.Type) -> SheetEnvironmentKey<Sheet> {
        SheetEnvironmentKey<Sheet>()
    }
}

public extension AlertEnvironmentKey {
    /// AlertPresenter の環境値キーを生成します。
    ///
    /// - Parameters:
    ///   - type: アラートの型
    ///   - context: アラートのコンテキスト（.navigation または .sheet）
    /// - Returns: AlertPresenter用の環境値キー
    static func alert(_ type: Alert.Type, context: AlertPresenterContext) -> AlertEnvironmentKey<Alert> {
        AlertEnvironmentKey<Alert>(context: context)
    }
}

/// CustomHeightSheetPresenter用の環境値アクセスキー。
///
/// `@Environment(.customHeightSheet(CustomSheet.self))` の形式で CustomHeightSheetPresenter にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.customHeightSheet(AppCustomSheet.self)) private var presenter
///
///     var body: some View {
///         Button("Show Custom Sheet") {
///             presenter?.present(.filter)
///         }
///     }
/// }
/// ```
public struct CustomHeightSheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: CustomHeightSheetPresenterSpecifier<Sheet>
    fileprivate init() {
        self.specifier = CustomHeightSheetPresenterSpecifier<Sheet>()
    }
}

/// FullScreenCoverPresenter用の環境値アクセスキー。
///
/// `@Environment(.fullScreenCover(Cover.self))` の形式で FullScreenCoverPresenter にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.fullScreenCover(AppCover.self)) private var presenter
///
///     var body: some View {
///         Button("Show Cover") {
///             presenter?.present(.onboarding)
///         }
///     }
/// }
/// ```
public struct FullScreenCoverEnvironmentKey<Cover> where Cover: Identifiable & Hashable {
    fileprivate let specifier: FullScreenCoverPresenterSpecifier<Cover>
    fileprivate init() {
        self.specifier = FullScreenCoverPresenterSpecifier<Cover>()
    }
}

public extension CustomHeightSheetEnvironmentKey {
    /// CustomHeightSheetPresenter の環境値キーを生成します。
    ///
    /// - Parameter type: カスタム高さシートの型
    /// - Returns: CustomHeightSheetPresenter用の環境値キー
    static func customHeightSheet(_ type: Sheet.Type) -> CustomHeightSheetEnvironmentKey<Sheet> {
        CustomHeightSheetEnvironmentKey<Sheet>()
    }
}

public extension FullScreenCoverEnvironmentKey {
    /// FullScreenCoverPresenter の環境値キーを生成します。
    ///
    /// - Parameter type: フルスクリーンカバーの型
    /// - Returns: FullScreenCoverPresenter用の環境値キー
    static func fullScreenCover(_ type: Cover.Type) -> FullScreenCoverEnvironmentKey<Cover> {
        FullScreenCoverEnvironmentKey<Cover>()
    }
}

/// TabPresenter用の環境値アクセスキー。
///
/// `@Environment(.tab(AppTab.self))` の形式で TabPresenter にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.tab(AppTab.self)) private var tabPresenter
///
///     var body: some View {
///         Button("Switch Tab") {
///             tabPresenter.select(.settings)
///         }
///     }
/// }
/// ```
public struct TabEnvironmentKey<Tab: Tabbable> {
    fileprivate let specifier: TabPresenterSpecifier<Tab>
    fileprivate init() {
        self.specifier = TabPresenterSpecifier<Tab>()
    }
}

public extension TabEnvironmentKey {
    /// TabPresenter の環境値キーを生成します。
    ///
    /// - Parameter type: タブの型
    /// - Returns: TabPresenter用の環境値キー
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
