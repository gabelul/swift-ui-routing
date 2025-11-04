import SwiftUI

/// NavigationSplitView の選択状態を管理する型安全なプレゼンター。
///
/// 2カラムおよび3カラムのNavigationSplitViewに対応し、
/// サイドバーとコンテンツの選択状態を一元管理します。
///
/// # 2カラムレイアウト
/// ```swift
/// @State private var splitViewPresenter = SplitViewPresenter<AppSidebar>()
///
/// SplitViewRouting(
///     splitViewPresenter: splitViewPresenter,
///     items: [.inbox, .sent, .archive]
/// )
/// ```
///
/// # 3カラムレイアウト
/// ```swift
/// @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)
///
/// ThreeColumnSplitViewRouting(
///     splitViewPresenter: splitViewPresenter,
///     items: [.inbox, .sent, .archive, .starred]
/// )
/// ```
///
/// # プログラムからの選択操作
/// ```swift
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
    /// 現在選択されているサイドバー項目（左カラム）
    public var selectedSidebar: Sidebar?

    /// 現在選択されているコンテンツ項目（中央カラム、3カラムレイアウト用）
    ///
    /// 3カラムレイアウトでは、中央カラムのリストで選択されたアイテムを保持します。
    /// 2カラムレイアウトでは使用されません（常にnil）。
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
