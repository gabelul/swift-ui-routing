import SwiftUI

/// タブの定義を表すプロトコル。
///
/// `Tabbable` に準拠した型は、TabView による型安全なタブ管理に使用できます。
/// 各タブは struct として定義し、必要なルーティング型を associatedtype で宣言します。
///
/// # 使用例
/// ```swift
/// struct HomeTab: Tabbable {
///     // ルーティング型を明示的に宣言
///     typealias Route = AppRoute
///     typealias Sheet = AppSheet
///     typealias Alert = AppAlert
///
///     let id = "home"
///
///     var contentView: some View {
///         HomeView()
///     }
///
///     var tabLabel: some View {
///         Label("ホーム", systemImage: "house")
///     }
/// }
///
/// struct SettingsTab: Tabbable {
///     // ルーティング不要な場合は型宣言省略（デフォルトで Never）
///     let id = "settings"
///
///     var contentView: some View {
///         SettingsView()
///     }
///
///     var tabLabel: some View {
///         Label("設定", systemImage: "gearshape")
///     }
/// }
/// ```
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

    /// タブの内容ビュー
    @ViewBuilder var contentView: ContentView { get }

    /// タブアイテムのラベル
    @ViewBuilder var tabLabel: TabLabel { get }
}
