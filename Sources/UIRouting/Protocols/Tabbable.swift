import SwiftUI

/// タブの定義を表すプロトコル。
///
/// `Tabbable` に準拠した型は、TabView による型安全なタブ管理に使用できます。
/// `Identifiable`と`Hashable`の実装は自動的に提供されます。
///
/// # 使用例
/// ```swift
/// enum AppTab: Tabbable {
///     case home
///     case settings
///
///     typealias Route = AppRoute
///     typealias Sheet = AppSheet
///     typealias Alert = AppAlert
///
///     var contentView: some View {
///         switch self {
///         case .home:
///             HomeView()
///         case .settings:
///             SettingsView()
///         }
///     }
///
///     var tabLabel: some View {
///         switch self {
///         case .home:
///             Label("ホーム", systemImage: "house")
///         case .settings:
///             Label("設定", systemImage: "gearshape")
///         }
///     }
/// }
/// ```
///
/// # 注意
/// - `id`プロパティの実装は不要です（自動生成されます）
/// - `Hashable`の実装も不要です（自動提供されます）
/// - ルーティング不要な場合は型宣言省略可能（デフォルトで`Never`）
@MainActor
public protocol Tabbable<Route>: Hashable, Identifiable {
    // View 関連
    associatedtype ContentView: View
    associatedtype TabLabel: View

    // ルーティング型（Primary Associated Type - デフォルトは Never）
    associatedtype Route: Routable = Never
    associatedtype Sheet: Sheetable = Never
    associatedtype Alert: Alertable = Never
    associatedtype FullScreen: FullScreenCoverable = Never
    associatedtype CustomSheet: CustomHeightSheetable = Never

    // NavigationSplitView 用（デフォルトは Never）
    associatedtype Sidebar: SidebarItem = Never

    /// タブの内容ビュー
    @ViewBuilder var contentView: ContentView { get }

    /// タブアイテムのラベル
    @ViewBuilder var tabLabel: TabLabel { get }

    /// サイドバー項目（Sidebar != Never の場合のみ使用）
    var sidebarItems: [Sidebar] { get }
}

// MARK: - Default Implementations
public extension Tabbable where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Tabbable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// NavigationStack を使用する場合（Sidebar == Never）のデフォルト実装
public extension Tabbable where Sidebar == Never {
    var sidebarItems: [Never] { [] }
}
