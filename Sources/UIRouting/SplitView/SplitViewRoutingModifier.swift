import SwiftUI

/// SplitView の詳細ビューに対してルーティング設定を自動化する ViewModifier。
///
/// 各詳細ビューに対して Router、SheetPresenter、AlertPresenter などのルーティングコンポーネントを
/// 自動的に設定し、NavigationStack との連携も行います。
///
/// 通常は `.splitViewRouting()` モディファイアを通じて使用します。
public struct SplitViewRoutingModifier<
    Sidebar: SidebarItem,
    Route: Routable,
    Sheet: Sheetable,
    Alert: Alertable,
    FullScreen: FullScreenCoverable,
    CustomSheet: CustomHeightSheetable
>: ViewModifier where Sidebar.DetailRoute == Route {

    @Environment private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @Environment private var router: Router<Route>

    // 各Presenterを内部で管理（RouterはEnvironmentから取得）
    @State private var sheetPresenter = SheetPresenter<Sheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<Alert>()
    @State private var alertPresenterOnSheet = AlertPresenter<Alert>()
    @State private var fullScreenCoverPresenter = FullScreenCoverPresenter<FullScreen>()
    @State private var customHeightSheetPresenter = CustomHeightSheetPresenter<CustomSheet>()

    public init() {
        self._splitViewPresenter = Environment(.splitView(Sidebar.self))
        self._router = Environment(.router(Route.self))
    }

    public func body(content: Content) -> some View {
        content
            // Presenterを環境に注入（RouterはすでにEnvironmentにあるのでそのまま使う）
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: customHeightSheetPresenter,
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet,
                splitViewPresenter: SplitViewPresenter<Never>()
            )
            // Sheetの自動適用
            .modifier(SheetModifierIfNeeded(presenter: sheetPresenter))
            // FullScreenCoverの自動適用
            .modifier(FullScreenCoverModifierIfNeeded(presenter: fullScreenCoverPresenter))
            // CustomHeightSheetの自動適用
            .modifier(CustomHeightSheetModifierIfNeeded(presenter: customHeightSheetPresenter))
            // Alertの自動適用
            .modifier(AlertModifierIfNeeded(presenter: alertPresenterOnNavigation))
    }
}

// MARK: - Conditional Modifiers

/// Sheet が必要な場合のみ適用する内部用 Modifier。
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

/// Alert が必要な場合のみ適用する内部用 Modifier。
private struct AlertModifierIfNeeded<Alert: Alertable>: ViewModifier {
    @Bindable var presenter: AlertPresenter<Alert>

    func body(content: Content) -> some View {
        if Alert.self != Never.self {
            content.alert(
                presenter.presentedAlert?.title ?? "",
                isPresented: Binding(
                    get: { presenter.isPresented },
                    set: { presenter.isPresented = $0 }
                ),
                presenting: presenter.presentedAlert,
                actions: { alert in
                    ForEach(Array(alert.actions.enumerated()), id: \.offset) { _, action in
                        Button(role: action.role) {
                            action.action()
                        } label: {
                            Text(action.title)
                        }
                    }
                },
                message: { alert in
                    if let message = alert.message {
                        Text(message)
                    }
                }
            )
        } else {
            content
        }
    }
}
