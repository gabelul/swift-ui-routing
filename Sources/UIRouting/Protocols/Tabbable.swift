import SwiftUI

/// タブの定義を表すプロトコル。
///
/// `Tabbable` に準拠した型は、TabView による型安全なタブ管理に使用できます。
///
/// # 自動ルーティング適用
/// `contentView`と`routingConfiguration`を定義すると、
/// `body`が自動的にルーティング設定を適用したビューを返します。
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
///     var contentView: some View {
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
///     var routingConfiguration: (any RoutingConfiguration)? {
///         switch self {
///         case .home:
///             HomeRoutingConfig()
///         case .search, .profile:
///             nil  // ルーティング不要
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
    associatedtype ContentView: View
    associatedtype Body: View
    associatedtype TabLabel: View

    /// タブの内容ビュー（ルーティング設定前）
    @ViewBuilder var contentView: ContentView { get }

    /// このタブの最終的なビュー（自動生成、実装不要）
    ///
    /// `routingConfiguration`に基づいて、自動的にルーティングが適用されます。
    @ViewBuilder var body: Body { get }

    /// ルーティング設定（オプショナル）
    ///
    /// nilを返すとルーティングは適用されません。
    var routingConfiguration: (any RoutingConfiguration)? { get }

    /// このタブのタブアイテムラベル
    @ViewBuilder var tabLabel: TabLabel { get }
}

// MARK: - Default Implementations

extension Tabbable {
    /// デフォルト実装: ルーティング設定なし
    public var routingConfiguration: (any RoutingConfiguration)? {
        nil
    }

    /// デフォルト実装: ルーティング設定に基づいて自動適用
    ///
    /// `routingConfiguration`がnilでない場合、自動的に`.tabRouting()`を適用します。
    public var body: some View {
        if let config = routingConfiguration {
            return AnyView(contentView.applyRoutingConfig(config, tab: self))
        } else {
            return AnyView(contentView)
        }
    }
}
