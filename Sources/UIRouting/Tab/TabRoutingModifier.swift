import SwiftUI

/// タブのルーティング設定を自動化するViewModifier
///
/// TodoTabRootのようなボイラープレートを削減し、
/// タブ定義内で直接ルーティング設定を行えるようにします。
public struct TabRoutingModifier<
    Tab: Tabbable,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable
>: ViewModifier {

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
            // 既存のroutingモディファイアを適用
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet
            )
            .routingScope(for: Route.self, alert: Alert.self)
            // Sheetの自動適用
            .modifier(SheetModifierIfNeeded(presenter: sheetPresenter))
            // FullScreenCoverの自動適用
            .modifier(FullScreenCoverModifierIfNeeded(presenter: fullScreenCoverPresenter))
            // CustomHeightSheetの自動適用
            .modifier(CustomHeightSheetModifierIfNeeded(presenter: customHeightSheetPresenter))
            // TabPresenterとの統合
            .onAppear {
                tabPresenter.executePendingNavigation(for: currentTab, with: router)
            }
    }
}

// MARK: - Conditional Modifiers

/// Sheetが必要な場合のみ適用するModifier
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

/// FullScreenCoverが必要な場合のみ適用するModifier
private struct FullScreenCoverModifierIfNeeded<FullScreen: FullScreenCoverable>: ViewModifier {
    @Bindable var presenter: FullScreenCoverPresenter<FullScreen>

    func body(content: Content) -> some View {
        if FullScreen.self != Never.self {
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            content.fullScreenCover(item: $presenter.presentedCover) { cover in
                cover.body
            }
            #else
            // macOSではfullScreenCoverが利用できないため、通常のsheetを使用
            content.sheet(item: $presenter.presentedCover) { cover in
                cover.body
            }
            #endif
        } else {
            content
        }
    }
}

/// CustomHeightSheetが必要な場合のみ適用するModifier
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
