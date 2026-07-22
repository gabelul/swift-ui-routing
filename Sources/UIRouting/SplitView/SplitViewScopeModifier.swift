import SwiftUI

/// SplitViewPresenter と NavigationSplitView を連携させる ViewModifier。
///
/// SplitViewPresenter の選択状態を NavigationSplitView にバインドし、
/// 各詳細ビューに自動的にアラート機能を適用する。
///
/// 通常は `.splitViewScope()` モディファイアを通じて使う。
///
/// # 使用例
/// ```swift
/// ContentView()
///     .splitViewScope(
///         for: AppSidebar.self,
///         items: [.inbox, .sent, .archive],
///         alert: AppAlert.self
///     )
/// ```
public struct SplitViewScopeModifier<Sidebar: SidebarItem, Sheet: Sheetable, Alert: Alertable>: ViewModifier {
    @Environment private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @Environment private var router: Router<Sidebar.DetailRoute>
    @Environment private var sheetPresenter: SheetPresenter<Sheet>

    private let sidebarItems: [Sidebar]

    public init(sidebarItems: [Sidebar]) {
        self.sidebarItems = sidebarItems
        self._splitViewPresenter = Environment(.splitView(Sidebar.self))
        self._router = Environment(.router(Sidebar.DetailRoute.self))
        self._sheetPresenter = Environment(.sheet(Sheet.self))
    }

    public func body(content: Content) -> some View {
        @Bindable var presenterBinding = splitViewPresenter
        @Bindable var sheetBinding = sheetPresenter

        NavigationSplitView {
            // サイドバー
            List(sidebarItems, selection: $presenterBinding.selectedSidebar) { item in
                NavigationLink(value: item) {
                    item.label
                }
            }
            .navigationTitle("サイドバー")
        } detail: {
            // 詳細ビュー
            if let selected = splitViewPresenter.selectedSidebar {
                // DetailRoute が Never でない場合、NavigationStack でラップ
                if Sidebar.DetailRoute.self != Never.self {
                    @Bindable var routerBinding = router

                    NavigationStack(path: $routerBinding.path) {
                        selected.detail
                            .routingAlert(for: Alert.self)
                            .navigationDestination(for: Sidebar.DetailRoute.self) { route in
                                route.body
                                    .routingAlert(for: Alert.self)
                            }
                    }
                } else {
                    selected.detail
                        .routingAlert(for: Alert.self)
                }
            } else {
                // 未選択時のデフォルトビュー
                content
                    .routingAlert(for: Alert.self)
            }
        }
        .modifier(SheetModifierIfNeeded(presenter: sheetBinding))
    }
}

public extension View {
    /// NavigationSplitView と SplitViewPresenter を連携させ、スプリットビュースコープを設定する。
    ///
    /// このモディファイアは以下を行う：
    /// - SplitViewPresenter の選択状態を NavigationSplitView にバインド
    /// - 各詳細ビューに `.routingAlert()` を自動適用
    /// - DetailRoute が指定されている場合、NavigationStack で詳細ビューをラップ
    ///
    /// # 使用例
    /// ```swift
    /// struct RootView: View {
    ///     var body: some View {
    ///         Text("サイドバーから項目を選択してください")
    ///             .splitViewScope(
    ///                 for: AppSidebar.self,
    ///                 items: [.inbox, .sent, .archive],
    ///                 alert: AppAlert.self
    ///             )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: サイドバー項目の型（SidebarItem に準拠）
    ///   - items: サイドバーに表示する項目の配列
    ///   - sheet: シートの型（Sheetable に準拠、デフォルトは Never）
    ///   - alert: アラートの型（Alertable に準拠）
    /// - Returns: NavigationSplitView でラップされ、スプリットビューが有効化されたビュー
    func splitViewScope<Sidebar: SidebarItem, Sheet: Sheetable, Alert: Alertable>(
        for type: Sidebar.Type,
        items: [Sidebar],
        sheet: Sheet.Type = Never.self,
        alert: Alert.Type
    ) -> some View {
        modifier(SplitViewScopeModifier<Sidebar, Sheet, Alert>(sidebarItems: items))
    }
}
