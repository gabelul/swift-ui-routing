import SwiftUI

/// アラートの表示を管理する型安全なプレゼンター
///
/// Navigation と Sheet で独立したアラートを表示できる。
///
/// # 使用例
/// ```swift
/// // 1. Alertインスタンスを作成してEnvironmentに注入
/// ContentView()
///     .routing(
///         router: Router<Screen>(),
///         sheetPresenter: SheetPresenter<Sheet>(),
///         alertPresenterOnNavigation: AlertPresenter<Alert>(),
///         alertPresenterOnSheet: AlertPresenter<Alert>()
///     )
///
/// // 2. .alertOnNavigation() または .alertOnSheet() を設定
/// var body: some View {
///     MainView()
///         .alertOnNavigation(for: Alert.self)
/// }
///
/// // 3. アラートを表示
/// struct MainView: View {
///     @Environment(.alert(Alert.self, context: .navigation)) private var alertPresenter
///
///     var body: some View {
///         Button("削除") {
///             alertPresenter.present(.delete(
///                 itemName: "アイテム",
///                 onConfirm: { /* 削除処理 */ }
///             ))
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class AlertPresenter<Alert: Alertable> {
    public var presentedAlert: Alert?
    public var isPresented: Bool = false

    public init() {}

    /// 指定したアラートを表示
    public func present(_ alert: Alert) {
        presentedAlert = alert
        isPresented = true
    }

    /// 表示中のアラートを閉じる
    public func dismiss() {
        isPresented = false
        presentedAlert = nil
    }
}
