import UIRouting

/// Todoリストタブのルーティング設定
///
/// このタブで使用するすべてのPresenter型を宣言します。
struct TodoListRoutingConfig: RoutingConfiguration {
    typealias Route = AppRoute
    typealias Sheet = AppSheet
    typealias Alert = AppAlert
    typealias FullScreen = AppFullScreenCover
    typealias CustomSheet = AppCustomHeightSheet
}
