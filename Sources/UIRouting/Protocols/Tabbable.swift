import SwiftUI

/// タブの定義を表すプロトコル。
///
/// `Tabbable` に準拠した型は、TabView による型安全なタブ管理に使用できます。
///
/// # 使用例
/// ```swift
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
///         case .home:
///             HomeView()
///         case .search:
///             SearchView()
///         case .profile:
///             ProfileView()
///         }
///     }
///
///     @ViewBuilder
///     var tabLabel: some View {
///         switch self {
///         case .home:
///             Label("ホーム", systemImage: "house")
///         case .search:
///             Label("検索", systemImage: "magnifyingglass")
///         case .profile:
///             Label("プロフィール", systemImage: "person")
///         }
///     }
/// }
/// ```
@MainActor
public protocol Tabbable: Hashable, Identifiable {
    associatedtype Body: View
    associatedtype TabLabel: View

    /// このタブの内容ビュー
    @ViewBuilder var body: Body { get }

    /// このタブのタブアイテムラベル
    @ViewBuilder var tabLabel: TabLabel { get }
}
