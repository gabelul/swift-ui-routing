import SwiftUI

/// Navigation コンテキストでアラートを表示する ViewModifier。
///
/// NavigationStack 内でアラートを表示するために使用します。
/// `.routingScope()` により自動適用されるため、通常は直接使用する必要はありません。
public struct AlertOnNavigationModifier<Alert: Alertable>: ViewModifier {
    @Environment private var alertPresenter: AlertPresenter<Alert>

    public init() {
        self._alertPresenter = Environment(.alert(Alert.self, context: .navigation))
    }

    public func body(content: Content) -> some View {
        content.alert(
            alertPresenter.presentedAlert?.title ?? "",
            isPresented: Binding(
                get: { alertPresenter.isPresented },
                set: { alertPresenter.isPresented = $0 }
            ),
            presenting: alertPresenter.presentedAlert,
            actions: { alert in
                ForEach(Array(alert.actions.enumerated()), id: \.offset) { _, action in
                    Button(role: action.role) {
                        action.action()
                    } label: {
                        Text(action.title)
                    }
                }
            },
            message: { alert in
                if let message = alert.message {
                    Text(message)
                }
            }
        )
    }
}

/// Sheet コンテキストでアラートを表示する ViewModifier。
///
/// シート内でアラートを表示するために使用します。
/// シート内のビューに `.sheetAlert()` を適用することで有効化されます。
public struct AlertOnSheetModifier<Alert: Alertable>: ViewModifier {
    @Environment private var alertPresenter: AlertPresenter<Alert>

    public init() {
        self._alertPresenter = Environment(.alert(Alert.self, context: .sheet))
    }

    public func body(content: Content) -> some View {
        content.alert(
            alertPresenter.presentedAlert?.title ?? "",
            isPresented: Binding(
                get: { alertPresenter.isPresented },
                set: { alertPresenter.isPresented = $0 }
            ),
            presenting: alertPresenter.presentedAlert,
            actions: { alert in
                ForEach(Array(alert.actions.enumerated()), id: \.offset) { _, action in
                    Button(role: action.role) {
                        action.action()
                    } label: {
                        Text(action.title)
                    }
                }
            },
            message: { alert in
                if let message = alert.message {
                    Text(message)
                }
            }
        )
    }
}

public extension View {
    /// Navigation コンテキストでアラートを表示可能にします。
    ///
    /// 通常は `.routingScope()` により自動適用されるため、直接呼ぶ必要はありません。
    /// 独自のNavigationStackを使用する場合など、高度な使い方で明示的に適用する場合に使用します。
    ///
    /// # 使用例
    /// ```swift
    /// // 基本パターン（推奨）
    /// ContentView()
    ///     .routingScope(for: AppRoute.self, alert: AppAlert.self)
    ///
    /// // 高度な使い方: 独自NavigationStackを使う場合
    /// NavigationStack(path: $customPath) {
    ///     ContentView()
    ///         .routingAlert(for: AppAlert.self)
    /// }
    /// ```
    ///
    /// - Parameter for: アラートの型
    /// - Returns: アラート表示が有効化されたビュー
    func routingAlert<Alert: Alertable>(for: Alert.Type) -> some View {
        modifier(AlertOnNavigationModifier<Alert>())
    }

    /// Sheet 内でアラートを表示可能にします。
    ///
    /// シート内のビューでアラートを表示したい場合に使用します。
    ///
    /// # 使用例
    /// ```swift
    /// struct SettingsSheet: View {
    ///     @Environment(\.alert(AppAlert.self, context: .sheet)) private var alertPresenter
    ///
    ///     var body: some View {
    ///         Form {
    ///             Button("削除") {
    ///                 alertPresenter?.present(.confirmDelete)
    ///             }
    ///         }
    ///         .sheetAlert(for: AppAlert.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter for: アラートの型
    /// - Returns: アラート表示が有効化されたビュー
    func sheetAlert<Alert: Alertable>(for: Alert.Type) -> some View {
        modifier(AlertOnSheetModifier<Alert>())
    }
}
