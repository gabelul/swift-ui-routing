import SwiftUI

/// ルーティング環境を注入する ViewModifier
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
    /// Router、SheetPresenter、CustomHeightSheetPresenter、FullScreenCoverPresenter、AlertPresenterを環境に注入
    ///
    /// # 使用例
    /// ```swift
    /// ContentView()
    ///     .routing(
    ///         router: Router<Screen>(),
    ///         sheetPresenter: SheetPresenter<Sheet>(),
    ///         customHeightSheetPresenter: CustomHeightSheetPresenter<CustomHeightSheet>(),
    ///         fullScreenCoverPresenter: FullScreenCoverPresenter<FullScreenCover>(),
    ///         alertPresenterOnNavigation: AlertPresenter<Alert>(),
    ///         alertPresenterOnSheet: AlertPresenter<Alert>()
    ///     )
    /// ```
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

    /// 後方互換性のための旧シグネチャ（CustomHeightSheetとFullScreenCoverなし）
    ///
    /// # 使用例
    /// ```swift
    /// ContentView()
    ///     .routing(
    ///         router: Router<Screen>(),
    ///         sheetPresenter: SheetPresenter<Sheet>(),
    ///         alertPresenterOnNavigation: AlertPresenter<Alert>(),
    ///         alertPresenterOnSheet: AlertPresenter<Alert>()
    ///     )
    /// ```
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
