import SwiftUI

/// 3カラムスプリットビューベースのルーティングを簡単に構築するためのビュー。
///
/// SplitViewPresenter を使用してサイドバーとコンテンツの選択状態を管理し、
/// 各ビューに自動的にルーティング機能（Router、SheetPresenter など）を適用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)
///
///     var body: some View {
///         ThreeColumnSplitViewRouting(
///             splitViewPresenter: splitViewPresenter,
///             items: [.inbox, .sent, .archive, .starred]
///         )
///     }
/// }
///
/// enum MailSidebar: SidebarItem {
///     case inbox, sent, archive, starred
///
///     typealias ContentItem = Email
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
///     var contentView: some View {
///         MailListView(sidebarItem: self)
///     }
///
///     var detail: some View {
///         MailDetailWrapperView()
///     }
/// }
/// ```
public struct ThreeColumnSplitViewRouting<Sidebar: SidebarItem, ContentPlaceholder: View, DetailPlaceholder: View>: View {
    @Bindable private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @State private var contentRouter = Router<Sidebar.ContentRoute>()
    @State private var detailRouter = Router<Sidebar.DetailRoute>()
    private let sidebarItems: [Sidebar]
    private let contentPlaceholder: ContentPlaceholder
    private let detailPlaceholder: DetailPlaceholder

    /// 3カラムスプリットビュールーティングを初期化します。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - items: サイドバーに表示する項目の配列
    ///   - contentPlaceholder: サイドバー未選択時に表示するコンテンツプレースホルダー
    ///   - detailPlaceholder: コンテンツ未選択時に表示する詳細プレースホルダー
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder,
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarItems = items
        self.contentPlaceholder = contentPlaceholder()
        self.detailPlaceholder = detailPlaceholder()
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            // サイドバー
            List(sidebarItems, selection: $splitViewPresenter.selectedSidebar) { item in
                NavigationLink(value: item) {
                    item.label
                }
            }
            .navigationTitle("サイドバー")
        } content: {
            // コンテンツ（メールリスト等）
            if let selected = splitViewPresenter.selectedSidebar {
                if Sidebar.ContentRoute.self != Never.self {
                    // ContentRouteがある場合はNavigationStackでラップ
                    NavigationStack(path: $contentRouter.path) {
                        selected.contentView
                            .threeColumnContentRouting(for: Sidebar.self)
                            .navigationDestination(for: Sidebar.ContentRoute.self) { route in
                                route.body
                                    .threeColumnContentRouting(for: Sidebar.self)
                            }
                    }
                    .transformEnvironment(\.self) { environment in
                        environment[router: RouterSpecifier<Sidebar.ContentRoute>()] = contentRouter
                        environment[selectedContentBinding: SelectedContentBindingSpecifier<Sidebar.ContentItem>()] = $splitViewPresenter.selectedContent
                    }
                } else {
                    // ContentRouteがない場合はそのまま表示
                    selected.contentView
                        .threeColumnContentRouting(for: Sidebar.self)
                        .transformEnvironment(\.self) { environment in
                            environment[selectedContentBinding: SelectedContentBindingSpecifier<Sidebar.ContentItem>()] = $splitViewPresenter.selectedContent
                        }
                }
            } else {
                // サイドバー未選択時のプレースホルダー
                contentPlaceholder
            }
        } detail: {
            // 詳細ビュー
            if let selected = splitViewPresenter.selectedSidebar {
                if Sidebar.DetailRoute.self != Never.self {
                    // DetailRouteがある場合はNavigationStackでラップ
                    NavigationStack(path: $detailRouter.path) {
                        selected.detail
                            .threeColumnDetailRouting(for: Sidebar.self)
                            .navigationDestination(for: Sidebar.DetailRoute.self) { route in
                                route.body
                                    .threeColumnDetailRouting(for: Sidebar.self)
                            }
                    }
                    .transformEnvironment(\.self) { environment in
                        environment[router: RouterSpecifier<Sidebar.DetailRoute>()] = detailRouter
                    }
                } else {
                    // DetailRouteがない場合はそのまま表示
                    selected.detail
                        .threeColumnDetailRouting(for: Sidebar.self)
                }
            } else {
                // コンテンツ未選択時のプレースホルダー
                detailPlaceholder
            }
        }
        .transformEnvironment(\.self) { environment in
            environment[splitViewPresenter: SplitViewPresenterSpecifier<Sidebar>()] = splitViewPresenter
        }
    }
}

// MARK: - Convenience Initializers

extension ThreeColumnSplitViewRouting where ContentPlaceholder == Text, DetailPlaceholder == Text {
    /// プレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - items: サイドバーに表示する項目の配列
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        items: [Sidebar]
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            items: items,
            contentPlaceholder: { Text("サイドバーから項目を選択してください") },
            detailPlaceholder: { Text("項目を選択してください") }
        )
    }
}

extension ThreeColumnSplitViewRouting where ContentPlaceholder == Text {
    /// コンテンツプレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - items: サイドバーに表示する項目の配列
    ///   - detailPlaceholder: コンテンツ未選択時に表示する詳細プレースホルダー
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        items: [Sidebar],
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            items: items,
            contentPlaceholder: { Text("サイドバーから項目を選択してください") },
            detailPlaceholder: detailPlaceholder
        )
    }
}

extension ThreeColumnSplitViewRouting where DetailPlaceholder == Text {
    /// 詳細プレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - items: サイドバーに表示する項目の配列
    ///   - contentPlaceholder: サイドバー未選択時に表示するコンテンツプレースホルダー
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            items: items,
            contentPlaceholder: contentPlaceholder,
            detailPlaceholder: { Text("項目を選択してください") }
        )
    }
}
