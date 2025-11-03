import SwiftUI

/// フルスクリーンカバーの表示を管理する型安全なプレゼンター
///
/// # 使用例
/// ```swift
/// // 1. カバー画面を定義
/// enum FullScreenCover: Identifiable, Hashable {
///     case onboarding
///     case camera
///
///     var id: String {
///         switch self {
///         case .onboarding: return "onboarding"
///         case .camera: return "camera"
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .onboarding: OnboardingView()
///         case .camera: CameraView()
///         }
///     }
/// }
///
/// // 2. FullScreenCoverPresenterインスタンスを作成してEnvironmentに注入
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
/// // 3. .fullScreenCover()モディファイアを設定
/// var body: some View {
///     MainView()
///         .fullScreenCover(item: Binding(
///             get: { fullScreenCoverPresenter?.presentedCover },
///             set: { fullScreenCoverPresenter?.presentedCover = $0 }
///         )) { cover in
///             cover.body
///         }
/// }
///
/// // 4. カバーを表示
/// struct MainView: View {
///     @Environment(\.fullScreenCover(FullScreenCover.self)) private var fullScreenCoverPresenter
///
///     var body: some View {
///         Button("オンボーディングを表示") {
///             fullScreenCoverPresenter?.present(.onboarding)
///         }
///     }
/// }
/// ```
@MainActor
@Observable
public final class FullScreenCoverPresenter<Cover> where Cover: Identifiable & Hashable {
    public var presentedCover: Cover?

    public init() {}

    /// 指定したフルスクリーンカバーを表示
    public func present(_ cover: Cover) {
        presentedCover = cover
    }

    /// 表示中のフルスクリーンカバーを閉じる
    public func dismiss() {
        presentedCover = nil
    }
}
