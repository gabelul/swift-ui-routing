import SwiftUI

/// SplitViewPresenter用の環境値アクセスキー。
///
/// `@Environment(.splitView(AppSidebar.self))` の形式で SplitViewPresenter にアクセスするために使用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.splitView(AppSidebar.self)) private var splitViewPresenter
///
///     var body: some View {
///         Button("Select Inbox") {
///             splitViewPresenter.select(.inbox)
///         }
///     }
/// }
/// ```
public struct SplitViewEnvironmentKey<Sidebar: SidebarItem> {
    fileprivate let specifier: SplitViewPresenterSpecifier<Sidebar>
    fileprivate init() {
        self.specifier = SplitViewPresenterSpecifier<Sidebar>()
    }
}

public extension SplitViewEnvironmentKey {
    /// SplitViewPresenter の環境値キーを生成します。
    ///
    /// - Parameter type: サイドバー項目の型
    /// - Returns: SplitViewPresenter用の環境値キー
    static func splitView(_ type: Sidebar.Type) -> SplitViewEnvironmentKey<Sidebar> {
        SplitViewEnvironmentKey<Sidebar>()
    }
}

public extension Environment {
    init<Sidebar: SidebarItem>(_ key: SplitViewEnvironmentKey<Sidebar>) where Value == SplitViewPresenter<Sidebar> {
        self.init(\.[splitViewPresenter: key.specifier])
    }
}

/// SelectedContentBinding用の環境値アクセスキー。
///
/// 3カラムNavigationSplitViewの中央カラムで選択されたアイテムへのBindingを取得します。
/// `@Environment(.selectedContentBinding(YourContentItem.self))` の形式で使用します。
///
/// # 使用例
/// ```swift
/// // ContentItemの型を定義
/// struct Email: Selectable { /* ... */ }
///
/// // 中央カラムのビューで使用
/// struct MailListView: View {
///     @Environment(.selectedContentBinding(Email.self)) private var selectedContentBinding
///
///     var body: some View {
///         List(selection: selectedContentBinding) {
///             ForEach(emails) { email in
///                 NavigationLink(value: email) {
///                     email.label
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// # 注意
/// - このBindingは`ThreeColumnSplitViewRouting`によって自動的に環境に注入されます
/// - 利用者が手動でBindingを作成する必要はありません
public struct SelectedContentBindingEnvironmentKey<ContentItem: Selectable> {
    fileprivate let specifier: SelectedContentBindingSpecifier<ContentItem>
    fileprivate init() {
        self.specifier = SelectedContentBindingSpecifier<ContentItem>()
    }
}

public extension SelectedContentBindingEnvironmentKey {
    /// SelectedContentBinding の環境値キーを生成します。
    ///
    /// - Parameter type: コンテンツアイテムの型
    /// - Returns: SelectedContentBinding用の環境値キー
    static func selectedContentBinding(_ type: ContentItem.Type) -> SelectedContentBindingEnvironmentKey<ContentItem> {
        SelectedContentBindingEnvironmentKey<ContentItem>()
    }
}

public extension Environment {
    init<ContentItem: Selectable>(_ key: SelectedContentBindingEnvironmentKey<ContentItem>) where Value == Binding<ContentItem?>? {
        self.init(\.[selectedContentBinding: key.specifier])
    }
}
