import SwiftUI

/// FullScreenCoverPresenter用の環境値アクセスキー。
///
/// `@Environment(.fullScreenCover(Cover.self))` の形式で FullScreenCoverPresenter にアクセスするために使用します。
/// シート内からフルスクリーンカバーを開く場合は `@Environment(.fullScreenCover(Cover.self, context: .sheet))` を使用します。
///
/// # 使用例
/// ```swift
/// // 通常のフルスクリーンカバー表示
/// struct ContentView: View {
///     @Environment(.fullScreenCover(AppCover.self)) private var presenter
///
///     var body: some View {
///         Button("Show Cover") {
///             presenter?.present(.onboarding)
///         }
///     }
/// }
///
/// // シート内からフルスクリーンカバーを開く
/// struct SettingsSheet: View {
///     @Environment(.fullScreenCover(AppCover.self, context: .sheet)) private var presenter
///
///     var body: some View {
///         Button("Show Another Cover") {
///             presenter?.present(.onboarding)
///         }
///         .fullScreenCoverPresenter(for: AppCover.self)
///     }
/// }
/// ```
public struct FullScreenCoverEnvironmentKey<Cover> where Cover: Identifiable & Hashable {
    fileprivate let specifier: FullScreenCoverPresenterSpecifier<Cover>
    fileprivate init(context: PresentationContext = .navigation) {
        self.specifier = FullScreenCoverPresenterSpecifier<Cover>(context: context)
    }
}

public extension FullScreenCoverEnvironmentKey {
    /// FullScreenCoverPresenter の環境値キーを生成します。
    ///
    /// - Parameters:
    ///   - type: フルスクリーンカバーの型
    ///   - context: シートのコンテキスト（.navigation または .sheet）。デフォルトは .navigation
    /// - Returns: FullScreenCoverPresenter用の環境値キー
    static func fullScreenCover(_ type: Cover.Type, context: PresentationContext = .navigation) -> FullScreenCoverEnvironmentKey<Cover> {
        FullScreenCoverEnvironmentKey<Cover>(context: context)
    }
}

public extension Environment {
    init<Cover>(_ key: FullScreenCoverEnvironmentKey<Cover>) where Value == FullScreenCoverPresenter<Cover>, Cover: Identifiable & Hashable {
        self.init(\.[fullScreenCoverPresenter: key.specifier])
    }
}
