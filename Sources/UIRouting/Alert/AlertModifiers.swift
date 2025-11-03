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
    /// Navigation内でアラートを表示
    ///
    /// # 使用例
    /// ```swift
    /// ContentView()
    ///     .alertOnNavigation(for: Alert.self)
    /// ```
    func alertOnNavigation<Alert: Alertable>(for: Alert.Type) -> some View {
        modifier(AlertOnNavigationModifier<Alert>())
    }

    /// Sheet内でアラートを表示
    ///
    /// # 使用例
    /// ```swift
    /// SheetContent()
    ///     .alertOnSheet(for: Alert.self)
    /// ```
    func alertOnSheet<Alert: Alertable>(for: Alert.Type) -> some View {
        modifier(AlertOnSheetModifier<Alert>())
    }
}
