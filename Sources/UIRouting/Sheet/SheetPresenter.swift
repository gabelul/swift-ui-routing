import SwiftUI

/// モーダルシートの表示を管理する型安全なプレゼンター
///
/// # 使用例
/// ```swift
/// // 1. シート画面を定義
/// enum Sheet: Identifiable, Hashable {
///     case settings
///     case profile(userId: String)
///
///     var id: String {
///         switch self {
///         case .settings: return "settings"
///         case .profile(let userId): return "profile_\(userId)"
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .settings: SettingsView()
///         case .profile(let userId): ProfileView(userId: userId)
///         }
///     }
/// }
///
/// // 2. SheetPresenterインスタンスを作成してEnvironmentに注入
/// ContentView()
///     .routing(
///         router: Router<Screen>(),
///         sheetPresenter: SheetPresenter<Sheet>(),
///         alertPresenterOnNavigation: AlertPresenter<Alert>(),
///         alertPresenterOnSheet: AlertPresenter<Alert>()
///     )
///
/// // 3. .sheet()モディファイアを設定
/// var body: some View {
///     @Bindable var sheet = sheetPresenter
///
///     MainView()
///         .sheet(item: $sheet.presentedSheet) { sheet in
///             sheet.body
///         }
/// }
///
/// // 4. シートを表示
/// struct MainView: View {
///     @Environment(.sheet(Sheet.self)) private var sheetPresenter
///
///     var body: some View {
///         Button("設定") {
///             sheetPresenter.present(.settings)
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class SheetPresenter<Sheet> where Sheet: Identifiable & Hashable {
    public var presentedSheet: Sheet?

    public init() {}

    /// 指定したシートを表示
    public func present(_ sheet: Sheet) {
        presentedSheet = sheet
    }

    /// 表示中のシートを閉じる
    public func dismiss() {
        presentedSheet = nil
    }
}
