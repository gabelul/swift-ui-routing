import SwiftUI

// MARK: - Conditional Presentation Modifiers

/// Sheet が必要な場合のみ適用する内部用 Modifier。
///
/// Sheet 型が Never でない場合のみ、シート表示機能を適用します。
struct SheetModifierIfNeeded<Sheet: Sheetable>: ViewModifier {
    @Bindable var presenter: SheetPresenter<Sheet>

    func body(content: Content) -> some View {
        if Sheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
            }
        } else {
            content
        }
    }
}

/// FullScreenCover が必要な場合のみ適用する内部用 Modifier。
///
/// FullScreen 型が Never でない場合のみ、フルスクリーンカバー機能を適用します。
/// macOS では fullScreenCover が利用できないため、通常の sheet を使用します。
struct FullScreenCoverModifierIfNeeded<FullScreen: FullScreenCoverable>: ViewModifier {
    @Bindable var presenter: FullScreenCoverPresenter<FullScreen>

    func body(content: Content) -> some View {
        if FullScreen.self != Never.self {
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            content.fullScreenCover(item: $presenter.presentedCover) { cover in
                cover.body
            }
            #else
            content.sheet(item: $presenter.presentedCover) { cover in
                cover.body
            }
            #endif
        } else {
            content
        }
    }
}

/// CustomHeightSheet が必要な場合のみ適用する内部用 Modifier。
///
/// CustomSheet 型が Never でない場合のみ、カスタム高さシート機能を適用します。
struct CustomHeightSheetModifierIfNeeded<CustomSheet: CustomHeightSheetable>: ViewModifier {
    @Bindable var presenter: CustomHeightSheetPresenter<CustomSheet>

    func body(content: Content) -> some View {
        if CustomSheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
                    .presentationDetents(sheet.detents)
            }
        } else {
            content
        }
    }
}

/// Alert が必要な場合のみ適用する内部用 Modifier。
///
/// Alert 型が Never でない場合のみ、アラート表示機能を適用します。
struct AlertModifierIfNeeded<Alert: Alertable>: ViewModifier {
    @Bindable var presenter: AlertPresenter<Alert>

    func body(content: Content) -> some View {
        if Alert.self != Never.self {
            content.alert(
                presenter.presentedAlert?.title ?? "",
                isPresented: Binding(
                    get: { presenter.isPresented },
                    set: { presenter.isPresented = $0 }
                ),
                presenting: presenter.presentedAlert,
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
        } else {
            content
        }
    }
}
