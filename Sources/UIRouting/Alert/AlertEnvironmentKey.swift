import SwiftUI

/// AlertPresenter用の環境値アクセスキー。
///
/// `@Environment(.alert(Alert.self, context: .navigation))` の形式で AlertPresenter にアクセスするために使用する。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter
///
///     var body: some View {
///         Button("Show Alert") {
///             alertPresenter.present(.error(message: "エラーが発生しました"))
///         }
///     }
/// }
/// ```
public struct AlertEnvironmentKey<Alert: Alertable> {
    fileprivate let specifier: AlertPresenterSpecifier<Alert>
    fileprivate init(context: PresentationContext) {
        self.specifier = AlertPresenterSpecifier<Alert>(context: context)
    }
}

public extension AlertEnvironmentKey {
    /// AlertPresenter の環境値キーを生成する。
    ///
    /// - Parameters:
    ///   - type: アラートの型
    ///   - context: アラートのコンテキスト（.navigation または .sheet）
    /// - Returns: AlertPresenter用の環境値キー
    static func alert(_ type: Alert.Type, context: PresentationContext) -> AlertEnvironmentKey<Alert> {
        AlertEnvironmentKey<Alert>(context: context)
    }
}

public extension Environment {
    init<Alert: Alertable>(_ key: AlertEnvironmentKey<Alert>) where Value == AlertPresenter<Alert> {
        self.init(\.[alertPresenter: key.specifier])
    }
}
