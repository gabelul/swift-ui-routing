import SwiftUI

/// タブのルーティング設定を自動化する ViewModifier。
///
/// 各タブに対して Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 自動的に設定し、NavigationStack との連携も行います。
///
/// これにより、タブごとに独立したルーティングスタックを持つことができます。
///
/// 通常は `.tabRouting(tab:)` モディファイアを通じて使用します。
public struct TabRoutingModifier<
    Tab: Tabbable,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable
>: ViewModifier where Tab.Route == Route {

    @Environment private var tabPresenter: TabPresenter<Tab>

    private let currentTab: Tab

    // 各Presenterを内部で管理
    @State private var router = Router<Route>()
    @State private var sheetPresenter = SheetPresenter<Sheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<Alert>()
    @State private var alertPresenterOnSheet = AlertPresenter<Alert>()
    @State private var fullScreenCoverPresenter = FullScreenCoverPresenter<FullScreen>()
    @State private var customHeightSheetPresenter = CustomHeightSheetPresenter<CustomSheet>()

    public init(tab: Tab) {
        self.currentTab = tab
        self._tabPresenter = Environment(.tab(Tab.self))
    }

    public func body(content: Content) -> some View {
        content
            .routingScope(for: Route.self, alert: Alert.self)
            // 既存のroutingモディファイアを適用
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet
            )
            // Sheetの自動適用
            .modifier(SheetModifierIfNeeded(presenter: sheetPresenter))
            // FullScreenCoverの自動適用
            .modifier(FullScreenCoverModifierIfNeeded(presenter: fullScreenCoverPresenter))
            // CustomHeightSheetの自動適用
            .modifier(CustomHeightSheetModifierIfNeeded(presenter: customHeightSheetPresenter))
            // TabPresenterとの統合: Routerを登録
            .onAppear {
                tabPresenter.registerRouter(router, for: currentTab)
            }
    }
}

// MARK: - Conditional Modifiers

/// Sheet が必要な場合のみ適用する内部用 Modifier。
///
/// タブの Sheet 型が Never でない場合のみ、シート表示機能を適用します。
private struct SheetModifierIfNeeded<Sheet: Sheetable>: ViewModifier {
    @Bindable var presenter: SheetPresenter<Sheet>

    func body(content: Content) -> some View {
        if Sheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
            }
        } else {
            content
        }
    }
}

/// FullScreenCover が必要な場合のみ適用する内部用 Modifier。
///
/// タブの FullScreen 型が Never でない場合のみ、フルスクリーンカバー機能を適用します。
/// macOS では fullScreenCover が利用できないため、通常の sheet を使用します。
private struct FullScreenCoverModifierIfNeeded<FullScreen: FullScreenCoverable>: ViewModifier {
    @Bindable var presenter: FullScreenCoverPresenter<FullScreen>

    func body(content: Content) -> some View {
        if FullScreen.self != Never.self {
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            content.fullScreenCover(item: $presenter.presentedCover) { cover in
                cover.body
            }
            #else
            content.sheet(item: $presenter.presentedCover) { cover in
                cover.body
            }
            #endif
        } else {
            content
        }
    }
}

/// CustomHeightSheet が必要な場合のみ適用する内部用 Modifier。
///
/// タブの CustomSheet 型が Never でない場合のみ、カスタム高さシート機能を適用します。
private struct CustomHeightSheetModifierIfNeeded<CustomSheet: CustomHeightSheetable>: ViewModifier {
    @Bindable var presenter: CustomHeightSheetPresenter<CustomSheet>

    func body(content: Content) -> some View {
        if CustomSheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
                    .presentationDetents(sheet.detents)
            }
        } else {
            content
        }
    }
}
