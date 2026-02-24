import SwiftUI

/// 3カラムNavigationSplitViewのルーティングシステム。
///
/// サイドバー | コンテンツ（中央） | 詳細（右）の3カラムレイアウトで、
/// 各カラムの選択状態とナビゲーションを一元管理します。
///
/// # 機能
/// - **サイドバー選択**: `SplitViewPresenter.selectedSidebar`
/// - **コンテンツ選択**: `SplitViewPresenter.selectedContent`（中央カラムのリスト選択）
/// - **コンテンツ内ナビゲーション**: `ContentRoute`（中央カラム内でのpush遷移）
/// - **詳細内ナビゲーション**: `DetailRoute`（右カラム内でのpush遷移）
///
/// # 使用例
/// ```swift
/// @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)
///
/// ThreeColumnSplitViewRouting(
///     splitViewPresenter: splitViewPresenter,
///     items: [.inbox, .sent, .archive, .starred]
/// )
/// ```
///
/// # サイドバーツールバー付きの使用例
/// ```swift
/// ThreeColumnSplitViewRouting(
///     splitViewPresenter: splitViewPresenter,
///     sidebarTitle: "セッション一覧",
///     items: sessions,
///     contentPlaceholder: { Text("選択してください") },
///     detailPlaceholder: { Text("詳細") }
/// ) {
///     ToolbarItem(placement: .primaryAction) {
///         Button { } label: { Image(systemName: "plus") }
///     }
/// }
/// ```
///
/// # SidebarItem定義例
/// ```swift
/// enum MailSidebar: SidebarItem {
///     case inbox, sent, archive, starred
///
///     // 3カラムに必要な型定義
///     typealias ContentItem = Email           // 中央カラムで選択するアイテム
///     typealias ContentRoute = MailContentRoute // 中央カラム内のナビゲーション
///     typealias DetailRoute = MailRoute       // 右カラム内のナビゲーション
///     typealias Sheet = MailSheet
///     typealias Alert = MailAlert
///
///     var label: some View { /* サイドバーのラベル */ }
///     var contentView: some View { MailListView(sidebarItem: self) }  // 中央カラム
///     var detail: some View { MailDetailWrapperView() }               // 右カラム
/// }
/// ```
///
/// # ルーティング階層
/// 1. **サイドバー切り替え**: `.inbox` → `.sent` など
/// 2. **コンテンツ選択**: メールをタップ → 詳細に表示
/// 3. **コンテンツ内遷移**: フィルタや検索ビューへpush（ContentRoute）
/// 4. **詳細内遷移**: 送信者情報や添付ファイルへpush（DetailRoute）
public struct ThreeColumnSplitViewRouting<
    Sidebar: SidebarItem,
    ContentPlaceholder: View,
    DetailPlaceholder: View,
    SidebarToolbar: ToolbarContent
>: View {
    @Bindable private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @State private var contentRouter = Router<Sidebar.ContentRoute>()
    @State private var detailRouter = Router<Sidebar.DetailRoute>()
    private let sidebarTitle: String
    private let sidebarItems: [Sidebar]
    private let contentPlaceholder: ContentPlaceholder
    private let detailPlaceholder: DetailPlaceholder
    private let sidebarToolbar: SidebarToolbar

    /// 3カラムスプリットビュールーティングを初期化します。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - sidebarTitle: サイドバーのナビゲーションタイトル。デフォルトは「サイドバー」。
    ///   - items: サイドバーに表示する項目の配列
    ///   - contentPlaceholder: サイドバー未選択時に表示するコンテンツプレースホルダー
    ///   - detailPlaceholder: コンテンツ未選択時に表示する詳細プレースホルダー
    ///   - sidebarToolbar: サイドバーのナビゲーションバーに表示するツールバーコンテンツ
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "サイドバー",
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder,
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder,
        @ToolbarContentBuilder sidebarToolbar: () -> SidebarToolbar
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarTitle = sidebarTitle
        self.sidebarItems = items
        self.contentPlaceholder = contentPlaceholder()
        self.detailPlaceholder = detailPlaceholder()
        self.sidebarToolbar = sidebarToolbar()
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            // サイドバー
            List(sidebarItems, selection: $splitViewPresenter.selectedSidebar) { item in
                NavigationLink(value: item) {
                    item.label
                }
            }
            .navigationTitle(sidebarTitle)
            .toolbar { sidebarToolbar }
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

// MARK: - Empty Sidebar Toolbar

/// サイドバーツールバーなしを表す型。
///
/// ツールバーパラメータを省略した場合のデフォルト型として使用されます。
public struct EmptySidebarToolbar: ToolbarContent {
    public var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            EmptyView()
        }
    }
}

// MARK: - Convenience Initializers (Without Toolbar)

extension ThreeColumnSplitViewRouting where SidebarToolbar == EmptySidebarToolbar {
    /// ツールバーなしの3カラムスプリットビュールーティングを初期化します。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - sidebarTitle: サイドバーのナビゲーションタイトル。デフォルトは「サイドバー」。
    ///   - items: サイドバーに表示する項目の配列
    ///   - contentPlaceholder: サイドバー未選択時に表示するコンテンツプレースホルダー
    ///   - detailPlaceholder: コンテンツ未選択時に表示する詳細プレースホルダー
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "サイドバー",
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder,
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            sidebarTitle: sidebarTitle,
            items: items,
            contentPlaceholder: contentPlaceholder,
            detailPlaceholder: detailPlaceholder,
            sidebarToolbar: { EmptySidebarToolbar() }
        )
    }
}

extension ThreeColumnSplitViewRouting where ContentPlaceholder == Text, DetailPlaceholder == Text, SidebarToolbar == EmptySidebarToolbar {
    /// プレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - sidebarTitle: サイドバーのナビゲーションタイトル。デフォルトは「サイドバー」。
    ///   - items: サイドバーに表示する項目の配列
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "サイドバー",
        items: [Sidebar]
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            sidebarTitle: sidebarTitle,
            items: items,
            contentPlaceholder: { Text("サイドバーから項目を選択してください") },
            detailPlaceholder: { Text("項目を選択してください") }
        )
    }
}

extension ThreeColumnSplitViewRouting where ContentPlaceholder == Text, SidebarToolbar == EmptySidebarToolbar {
    /// コンテンツプレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - sidebarTitle: サイドバーのナビゲーションタイトル。デフォルトは「サイドバー」。
    ///   - items: サイドバーに表示する項目の配列
    ///   - detailPlaceholder: コンテンツ未選択時に表示する詳細プレースホルダー
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "サイドバー",
        items: [Sidebar],
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            sidebarTitle: sidebarTitle,
            items: items,
            contentPlaceholder: { Text("サイドバーから項目を選択してください") },
            detailPlaceholder: detailPlaceholder
        )
    }
}

extension ThreeColumnSplitViewRouting where DetailPlaceholder == Text, SidebarToolbar == EmptySidebarToolbar {
    /// 詳細プレースホルダーにデフォルトテキストを使用するイニシャライザ。
    ///
    /// - Parameters:
    ///   - splitViewPresenter: サイドバーとコンテンツの選択状態を管理する SplitViewPresenter
    ///   - sidebarTitle: サイドバーのナビゲーションタイトル。デフォルトは「サイドバー」。
    ///   - items: サイドバーに表示する項目の配列
    ///   - contentPlaceholder: サイドバー未選択時に表示するコンテンツプレースホルダー
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "サイドバー",
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder
    ) {
        self.init(
            splitViewPresenter: splitViewPresenter,
            sidebarTitle: sidebarTitle,
            items: items,
            contentPlaceholder: contentPlaceholder,
            detailPlaceholder: { Text("項目を選択してください") }
        )
    }
}
