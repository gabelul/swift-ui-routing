import SwiftUI

/// Navigation コンテキストでアラートを表示する ViewModifier
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

/// Sheet コンテキストでアラートを表示する ViewModifier
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
    /// UIRoutingのアラートを表示（通常のコンテキスト）
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
    func routingAlert<Alert: Alertable>(for: Alert.Type) -> some View {
        modifier(AlertOnNavigationModifier<Alert>())
    }

    /// Sheet内でアラートを表示
    ///
    /// # 使用例
    /// ```swift
    /// SheetContent()
    ///     .sheetAlert(for: AppAlert.self)
    /// ```
    func sheetAlert<Alert: Alertable>(for: Alert.Type) -> some View {
        modifier(AlertOnSheetModifier<Alert>())
    }
}
