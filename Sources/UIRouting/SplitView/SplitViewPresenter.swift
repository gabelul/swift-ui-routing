import SwiftUI

/// NavigationSplitView の選択状態を管理する型安全なプレゼンター。
///
/// サイドバーの選択状態を管理し、2カラムおよび3カラムのNavigationSplitViewに対応します。
///
/// # 使用例（2カラム）
/// ```swift
/// struct ContentView: View {
///     @State private var splitViewPresenter = SplitViewPresenter<AppSidebar>()
///
///     var body: some View {
///         ContentView()
///             .splitViewScope(
///                 for: AppSidebar.self,
///                 items: [.inbox, .sent, .archive],
///                 alert: AppAlert.self
///             )
///     }
/// }
///
/// // サイドバー項目を選択
/// struct SomeView: View {
///     @Environment(.splitView(AppSidebar.self)) private var splitViewPresenter
///
///     var body: some View {
///         Button("受信箱を表示") {
///             splitViewPresenter.select(.inbox)
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class SplitViewPresenter<Sidebar: SidebarItem> {
    /// 現在選択されているサイドバー項目
    public var selectedSidebar: Sidebar?

    /// 現在選択されているコンテンツ項目（3カラム用、将来使用）
    public var selectedContent: Sidebar.ContentItem?

    /// SplitViewPresenter を初期化します。
    ///
    /// - Parameter initialSelection: 最初に選択されるサイドバー項目（オプション）
    public init(initialSelection: Sidebar? = nil) {
        self.selectedSidebar = initialSelection
        self.selectedContent = nil
    }

    // MARK: - Sidebar Selection

    /// 指定したサイドバー項目を選択します。
    ///
    /// 3カラムレイアウトの場合、サイドバー選択が変更されると
    /// コンテンツの選択は自動的にリセットされます。
    ///
    /// # 使用例
    /// ```swift
    /// @Environment(.splitView(AppSidebar.self)) private var splitViewPresenter
    ///
    /// Button("受信箱を表示") {
    ///     splitViewPresenter.select(.inbox)
    /// }
    /// ```
    ///
    /// - Parameter item: 選択するサイドバー項目
    public func select(_ item: Sidebar) {
        selectedSidebar = item

        // 3カラムの場合、サイドバー選択変更時にコンテンツ選択をリセット
        if Sidebar.ContentItem.self != Never.self {
            selectedContent = nil
        }
    }

    // MARK: - Content Selection (3-column support, future use)

    /// 指定したコンテンツ項目を選択します（3カラム用、将来使用）。
    ///
    /// このメソッドは3カラムレイアウトでのみ使用されます。
    /// 2カラムレイアウトでは使用しません。
    ///
    /// - Parameter content: 選択するコンテンツ項目
    public func select<Content>(content: Content) where Content == Sidebar.ContentItem {
        selectedContent = content
    }
}
