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
    /// シートプレゼンターを有効化するモディファイア
    ///
    /// 指定した `context` に応じて SheetPresenter を環境に注入し、
    /// `.sheet(item:)` による表示を自動設定します。
    ///
    /// # コンテキストの使い分け
    /// - `.navigation`（デフォルト）: NavigationStack のルートなど、
    ///   ThreeColumnSplitViewRouting を使わない画面で独立したシート管理を行う場合。
    ///   `@Environment(.sheet(AppSheet.self))` でアクセス。
    /// - `.sheet`: シート内から別のシートを開く場合。
    ///   `@Environment(.sheet(AppSheet.self, context: .sheet))` でアクセス。
    ///
    /// # 使用例
    /// ```swift
    /// // iPhone の NavigationStack ルートで使用
    /// NavigationStack {
    ///     ContentView()
    /// }
    /// .sheetPresenter(for: AppSheet.self)
    ///
    /// // シート内から別シートを表示
    /// SettingsSheet()
    ///     .sheetPresenter(for: AppSheet.self, context: .sheet)
    /// ```
    ///
    /// - Parameters:
    ///   - type: シートの型
    ///   - context: プレゼンテーションコンテキスト。デフォルトは `.navigation`
    /// - Returns: シートプレゼンターが有効化されたビュー
    func sheetPresenter<Sheet: Sheetable>(
        for type: Sheet.Type,
        context: PresentationContext = .navigation
    ) -> some View {
        modifier(SheetPresenterModifier<Sheet>(context: context))
    }
}

/// シートプレゼンターを有効化する Modifier
struct SheetPresenterModifier<Sheet: Sheetable>: ViewModifier {
    let context: PresentationContext
    @State private var presenter = SheetPresenter<Sheet>()

    func body(content: Content) -> some View {
        @Bindable var bindablePresenter = presenter

        content
            .environment(\.[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: context)], presenter)
            .sheet(item: $bindablePresenter.presentedSheet) { sheet in
                sheet.body
                    .transformEnvironment(\.self) { env in
                        // シート内にも同じ SheetPresenter を引き継ぐ
                        env[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: context)] = presenter
                    }
            }
    }
}
