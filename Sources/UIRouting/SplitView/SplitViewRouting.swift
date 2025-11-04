import SwiftUI

/// スプリットビューベースのルーティングを簡単に構築するためのビュー。
///
/// SplitViewPresenter を使用してサイドバーの選択状態を管理し、
/// 各詳細ビューに自動的にルーティング機能（Router、SheetPresenter など）を適用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)
///
///     var body: some View {
///         SplitViewRouting(
///             splitViewPresenter: splitViewPresenter,
///             items: [.inbox, .sent, .archive, .starred]
///         )
///     }
/// }
///
/// enum MailSidebar: String, SidebarItem {
///     case inbox, sent, archive, starred
///
///     typealias DetailRoute = MailRoute
///     typealias Sheet = MailSheet
///     typealias Alert = MailAlert
///
///     var label: some View {
///         switch self {
///         case .inbox:
///             Label("受信箱", systemImage: "tray")
///         case .sent:
///             Label("送信済み", systemImage: "paperplane")
///         case .archive:
///             Label("アーカイブ", systemImage: "archivebox")
///         case .starred:
///             Label("スター付き", systemImage: "star")
///         }
///     }
///
///     var detail: some View {
///         switch self {
///         case .inbox:
///             InboxView()
///         case .sent:
///             SentView()
///         case .archive:
///             ArchiveView()
///         case .starred:
///             StarredView()
///         }
///     }
/// }
/// ```
public struct SplitViewRouting<Sidebar: SidebarItem, PlaceholderContent: View>: View {
    @Bindable private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @State private var router = Router<Sidebar.DetailRoute>()
    private let sidebarItems: [Sidebar]
    private let placeholderContent: PlaceholderContent

    /// スプリットビュールーティングを初期化します。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーの選択状態を管理する SplitViewPresenter
    ///   - items: サイドバーに表示する項目の配列
    ///   - placeholder: 未選択時に表示するプレースホルダーコンテンツ
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        items: [Sidebar],
        @ViewBuilder placeholder: () -> PlaceholderContent
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarItems = items
        self.placeholderContent = placeholder()
    }

    public var body: some View {
        NavigationSplitView {
            // サイドバー
            List(sidebarItems, selection: $splitViewPresenter.selectedSidebar) { item in
                NavigationLink(value: item) {
                    item.label
                }
            }
            .navigationTitle("サイドバー")
        } detail: {
            // 詳細ビュー
            if let selected = splitViewPresenter.selectedSidebar {
                if Sidebar.DetailRoute.self != Never.self {
                    // DetailRouteがある場合はNavigationStackでラップ
                    NavigationStack(path: $router.path) {
                        selected.detail
                            .splitViewRouting(for: Sidebar.self)
                            .navigationDestination(for: Sidebar.DetailRoute.self) { route in
                                route.body
                                    .splitViewRouting(for: Sidebar.self)
                            }
                    }
                    .transformEnvironment(\.self) { environment in
                        environment[router: RouterSpecifier<Sidebar.DetailRoute>()] = router
                    }
                } else {
                    // DetailRouteがない場合はそのまま表示
                    selected.detail
                        .splitViewRouting(for: Sidebar.self)
                }
            } else {
                // 未選択時のプレースホルダー
                placeholderContent
            }
        }
        .transformEnvironment(\.self) { environment in
            environment[splitViewPresenter: SplitViewPresenterSpecifier<Sidebar>()] = splitViewPresenter
        }
    }
}

// MARK: - Convenience Initializer

extension SplitViewRouting where PlaceholderContent == Text {
    /// プレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーの選択状態を管理する SplitViewPresenter
    ///   - items: サイドバーに表示する項目の配列
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        items: [Sidebar]
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            items: items,
            placeholder: { Text("サイドバーから項目を選択してください") }
        )
    }
}
