import SwiftUI

/// タブのルーティング設定を表すプロトコル
///
/// 各Presenter型をassociatedtypeで宣言することで、型安全なルーティング設定を実現します。
///
/// # 使用例
/// ```swift
/// struct TodoListRoutingConfig: RoutingConfiguration {
///     typealias Route = AppRoute
///     typealias Sheet = AppSheet
///     typealias Alert = AppAlert
///     typealias FullScreen = AppFullScreenCover
///     typealias CustomSheet = AppCustomHeightSheet
/// }
/// ```
///
/// # Tabbableでの使用
/// ```swift
/// enum AppTab: Tabbable {
///     case todoList
///     case settings
///
///     var routingConfiguration: (any RoutingConfiguration)? {
///         switch self {
///         case .todoList:
///             TodoListRoutingConfig()
///         case .settings:
///             nil  // ルーティング不要
///         }
///     }
/// }
/// ```
@MainActor
public protocol RoutingConfiguration {
    /// ルート型（Navigation用）
    ///
    /// このタブで使用するルート型を指定します。
    /// NavigationStackでの画面遷移に使用されます。
    associatedtype Route: Routable

    /// シート型（デフォルト: Never）
    ///
    /// このタブで使用するシート型を指定します。
    /// 不要な場合はデフォルトの`Never`のまま使用できます。
    associatedtype Sheet: Sheetable = Never

    /// アラート型（デフォルト: Never）
    ///
    /// このタブで使用するアラート型を指定します。
    /// 不要な場合はデフォルトの`Never`のまま使用できます。
    associatedtype Alert: Alertable = Never

    /// フルスクリーンカバー型（デフォルト: Never）
    ///
    /// このタブで使用するフルスクリーンカバー型を指定します。
    /// 不要な場合はデフォルトの`Never`のまま使用できます。
    associatedtype FullScreen: FullScreenCoverable = Never

    /// カスタム高さシート型（デフォルト: Never）
    ///
    /// このタブで使用するカスタム高さシート型を指定します。
    /// 不要な場合はデフォルトの`Never`のまま使用できます。
    associatedtype CustomSheet: CustomHeightSheetable = Never
}
