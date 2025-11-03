import SwiftUI

/// カスタム高さシートの表示を管理する型安全なプレゼンター
///
/// # 使用例
/// ```swift
/// // 1. カスタム高さシートを定義
/// enum CustomHeightSheet: Identifiable, Hashable {
///     case filter
///     case quickSettings
///
///     var id: String {
///         switch self {
///         case .filter: return "filter"
///         case .quickSettings: return "quickSettings"
///         }
///     }
///
///     var detents: Set<PresentationDetent> {
///         switch self {
///         case .filter: return [.medium, .large]
///         case .quickSettings: return [.height(200), .medium]
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .filter: FilterView()
///         case .quickSettings: QuickSettingsView()
///         }
///     }
/// }
///
/// // 2. CustomHeightSheetPresenterインスタンスを作成してEnvironmentに注入
/// ContentView()
///     .routing(
///         router: Router<Screen>(),
///         sheetPresenter: SheetPresenter<Sheet>(),
///         customHeightSheetPresenter: CustomHeightSheetPresenter<CustomHeightSheet>(),
///         fullScreenCoverPresenter: FullScreenCoverPresenter<FullScreenCover>(),
///         alertPresenterOnNavigation: AlertPresenter<Alert>(),
///         alertPresenterOnSheet: AlertPresenter<Alert>()
///     )
///
/// // 3. .sheet()モディファイアを設定（detents付き）
/// var body: some View {
///     MainView()
///         .sheet(item: Binding(
///             get: { customHeightSheetPresenter?.presentedSheet },
///             set: { customHeightSheetPresenter?.presentedSheet = $0 }
///         )) { sheet in
///             sheet.body
///                 .presentationDetents(sheet.detents)
///         }
/// }
///
/// // 4. カスタム高さシートを表示
/// struct MainView: View {
///     @Environment(\.customHeightSheet(CustomHeightSheet.self)) private var customHeightSheetPresenter
///
///     var body: some View {
///         Button("フィルターを表示") {
///             customHeightSheetPresenter?.present(.filter)
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class CustomHeightSheetPresenter<Sheet> where Sheet: Identifiable & Hashable {
    public var presentedSheet: Sheet?

    public init() {}

    /// 指定したカスタム高さシートを表示
    public func present(_ sheet: Sheet) {
        presentedSheet = sheet
    }

    /// 表示中のカスタム高さシートを閉じる
    public func dismiss() {
        presentedSheet = nil
    }
}
