import SwiftUI

/// TabView の選択状態を管理する型安全なプレゼンター
///
/// # 使用例
/// ```swift
/// // 1. タブを定義
/// enum AppTab: Tabbable {
///     case home
///     case search
///     case profile
///
///     var id: String {
///         switch self {
///         case .home: return "home"
///         case .search: return "search"
///         case .profile: return "profile"
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .home: HomeView()
///         case .search: SearchView()
///         case .profile: ProfileView()
///         }
///     }
///
///     @ViewBuilder
///     var tabLabel: some View {
///         switch self {
///         case .home: Label("ホーム", systemImage: "house")
///         case .search: Label("検索", systemImage: "magnifyingglass")
///         case .profile: Label("プロフィール", systemImage: "person")
///         }
///     }
/// }
///
/// // 2. TabPresenterインスタンスを作成してTabViewを構築
/// @State private var tabPresenter = TabPresenter<AppTab>(initialTab: .home)
///
/// var body: some View {
///     TabRouting(
///         tabPresenter: tabPresenter,
///         tabs: [.home, .search, .profile]
///     )
/// }
///
/// // 3. タブを切り替え
/// struct HomeView: View {
///     @Environment(.tab(AppTab.self)) private var tabPresenter
///
///     var body: some View {
///         Button("検索タブへ") {
///             tabPresenter.select(.search)
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class TabPresenter<Tab: Tabbable> {
    /// 現在選択されているタブ
    public var selectedTab: Tab

    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }

    /// 指定したタブを選択
    public func select(_ tab: Tab) {
        selectedTab = tab
    }
}
