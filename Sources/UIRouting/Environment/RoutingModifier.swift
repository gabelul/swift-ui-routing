import SwiftUI

/// ルーティング環境を注入する ViewModifier。
///
/// Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 環境値として注入し、子ビュー全体で利用可能にします。
///
/// 通常は `.routing()` モディファイアを通じて使用します。
public struct RoutingModifier<
    Route: Routable,
    Sheet,
    CustomHeightSheet,
    FullScreenCover,
    Alert: Alertable
>: ViewModifier
    where
    Sheet: Identifiable & Hashable,
    CustomHeightSheet: Identifiable & Hashable,
    FullScreenCover: Identifiable & Hashable
{
    private let router: Router<Route>
    private let sheetPresenter: SheetPresenter<Sheet>
    private let customHeightSheetPresenter: CustomHeightSheetPresenter<CustomHeightSheet>
    private let fullScreenCoverPresenter: FullScreenCoverPresenter<FullScreenCover>
    private let alertPresenterOnNavigation: AlertPresenter<Alert>
    private let alertPresenterOnSheet: AlertPresenter<Alert>

    public init(
        router: Router<Route>,
        sheetPresenter: SheetPresenter<Sheet>,
        customHeightSheetPresenter: CustomHeightSheetPresenter<CustomHeightSheet>,
        fullScreenCoverPresenter: FullScreenCoverPresenter<FullScreenCover>,
        alertPresenterOnNavigation: AlertPresenter<Alert>,
        alertPresenterOnSheet: AlertPresenter<Alert>
    ) {
        self.router = router
        self.sheetPresenter = sheetPresenter
        self.customHeightSheetPresenter = customHeightSheetPresenter
        self.fullScreenCoverPresenter = fullScreenCoverPresenter
        self.alertPresenterOnNavigation = alertPresenterOnNavigation
        self.alertPresenterOnSheet = alertPresenterOnSheet
    }

    public func body(content: Content) -> some View {
        content
            .transformEnvironment(\.self) { environment in
                environment[router: RouterSpecifier<Route>()] = router
                environment[sheetPresenter: SheetPresenterSpecifier<Sheet>()] = sheetPresenter
                environment[customHeightSheetPresenter: CustomHeightSheetPresenterSpecifier<CustomHeightSheet>()] = customHeightSheetPresenter
                environment[fullScreenCoverPresenter: FullScreenCoverPresenterSpecifier<FullScreenCover>()] = fullScreenCoverPresenter
                environment[alertPresenter: AlertPresenterSpecifier<Alert>(context: .navigation)] = alertPresenterOnNavigation
                environment[alertPresenter: AlertPresenterSpecifier<Alert>(context: .sheet)] = alertPresenterOnSheet
            }
    }
}

public extension View {
    /// ルーティングコンポーネント（Router、Presenter類）を環境に注入します。
    ///
    /// すべてのルーティング機能を使用する場合は、このメソッドを使用して
    /// 各Presenterを環境値として設定します。
    ///
    /// # 使用例
    /// ```swift
    /// @State private var router = Router<AppRoute>()
    /// @State private var sheetPresenter = SheetPresenter<AppSheet>()
    /// @State private var alertPresenter = AlertPresenter<AppAlert>()
    ///
    /// ContentView()
    ///     .routing(
    ///         router: router,
    ///         sheetPresenter: sheetPresenter,
    ///         customHeightSheetPresenter: CustomHeightSheetPresenter<AppCustomSheet>(),
    ///         fullScreenCoverPresenter: FullScreenCoverPresenter<AppCover>(),
    ///         alertPresenterOnNavigation: alertPresenter,
    ///         alertPresenterOnSheet: AlertPresenter<AppAlert>()
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - router: NavigationStack のルーター
    ///   - sheetPresenter: シート表示管理
    ///   - customHeightSheetPresenter: カスタム高さシート表示管理
    ///   - fullScreenCoverPresenter: フルスクリーンカバー表示管理
    ///   - alertPresenterOnNavigation: Navigation コンテキストのアラート表示管理
    ///   - alertPresenterOnSheet: Sheet コンテキストのアラート表示管理
    /// - Returns: ルーティング環境が注入されたビュー
    func routing<Route: Routable, Sheet, CustomHeightSheet, FullScreenCover, Alert: Alertable>(
        router: Router<Route>,
        sheetPresenter: SheetPresenter<Sheet>,
        customHeightSheetPresenter: CustomHeightSheetPresenter<CustomHeightSheet>,
        fullScreenCoverPresenter: FullScreenCoverPresenter<FullScreenCover>,
        alertPresenterOnNavigation: AlertPresenter<Alert>,
        alertPresenterOnSheet: AlertPresenter<Alert>
    ) -> some View
        where
        Sheet: Identifiable & Hashable,
        CustomHeightSheet: Identifiable & Hashable,
        FullScreenCover: Identifiable & Hashable
    {
        modifier(RoutingModifier(
            router: router,
            sheetPresenter: sheetPresenter,
            customHeightSheetPresenter: customHeightSheetPresenter,
            fullScreenCoverPresenter: fullScreenCoverPresenter,
            alertPresenterOnNavigation: alertPresenterOnNavigation,
            alertPresenterOnSheet: alertPresenterOnSheet
        ))
    }

    /// ルーティングコンポーネントを環境に注入します（簡易版）。
    ///
    /// CustomHeightSheet と FullScreenCover が不要な場合に使用する簡易版です。
    /// 内部的には CustomHeightSheetPresenter<Never> と FullScreenCoverPresenter<Never> が設定されます。
    ///
    /// # 使用例
    /// ```swift
    /// @State private var router = Router<AppRoute>()
    /// @State private var sheetPresenter = SheetPresenter<AppSheet>()
    /// @State private var alertPresenter = AlertPresenter<AppAlert>()
    ///
    /// ContentView()
    ///     .routing(
    ///         router: router,
    ///         sheetPresenter: sheetPresenter,
    ///         alertPresenterOnNavigation: alertPresenter,
    ///         alertPresenterOnSheet: AlertPresenter<AppAlert>()
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - router: NavigationStack のルーター
    ///   - sheetPresenter: シート表示管理
    ///   - alertPresenterOnNavigation: Navigation コンテキストのアラート表示管理
    ///   - alertPresenterOnSheet: Sheet コンテキストのアラート表示管理
    /// - Returns: ルーティング環境が注入されたビュー
    func routing<Route: Routable, Sheet, Alert: Alertable>(
        router: Router<Route>,
        sheetPresenter: SheetPresenter<Sheet>,
        alertPresenterOnNavigation: AlertPresenter<Alert>,
        alertPresenterOnSheet: AlertPresenter<Alert>
    ) -> some View where Sheet: Identifiable & Hashable {
        routing(
            router: router,
            sheetPresenter: sheetPresenter,
            customHeightSheetPresenter: CustomHeightSheetPresenter<Never>(),
            fullScreenCoverPresenter: FullScreenCoverPresenter<Never>(),
            alertPresenterOnNavigation: alertPresenterOnNavigation,
            alertPresenterOnSheet: alertPresenterOnSheet
        )
    }
}
