import SwiftUI

// MARK: - Conditional Presentation Modifier

/// Sheet が必要な場合のみ適用する内部用 Modifier。
///
/// Sheet 型が Never でない場合のみ、シート表示機能を適用します。
struct SheetModifierIfNeeded<Sheet: Sheetable>: ViewModifier {
    @Bindable var presenter: SheetPresenter<Sheet>
    @Environment(\.self) private var environment

    func body(content: Content) -> some View {
        if Sheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
                    .transformEnvironment(\.self) { env in
                        // シート内にも同じ SheetPresenter を引き継ぐ
                        env[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: .navigation)] = presenter
                    }
            }
        } else {
            content
        }
    }
}

// MARK: - Public Sheet Presenter Modifier

public extension View {
    /// シート内でシートプレゼンターを有効化するモディファイア
    ///
    /// シート内から別のシートを開く場合に使用します。
    ///
    /// # 使用例
    /// ```swift
    /// struct SettingsSheet: View {
    ///     @Environment(.sheet(AppSheet.self, context: .sheet)) private var sheetPresenter
    ///
    ///     var body: some View {
    ///         Button("Show About") {
    ///             sheetPresenter.present(.about)
    ///         }
    ///         .sheetPresenter(for: AppSheet.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: シートの型
    /// - Returns: シートプレゼンターが有効化されたビュー
    func sheetPresenter<Sheet: Sheetable>(for type: Sheet.Type) -> some View {
        modifier(SheetPresenterModifier<Sheet>())
    }
}

/// シート内でシートプレゼンターを有効化する Modifier
struct SheetPresenterModifier<Sheet: Sheetable>: ViewModifier {
    @State private var presenter = SheetPresenter<Sheet>()

    func body(content: Content) -> some View {
        @Bindable var bindablePresenter = presenter

        content
            .environment(\.[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: .sheet)], presenter)
            .sheet(item: $bindablePresenter.presentedSheet) { sheet in
                sheet.body
                    .transformEnvironment(\.self) { env in
                        // シート内にも同じ SheetPresenter を引き継ぐ（context: .sheetの場合）
                        env[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: .sheet)] = presenter
                    }
            }
    }
}
