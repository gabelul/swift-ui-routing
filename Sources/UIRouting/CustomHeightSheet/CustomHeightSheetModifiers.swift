import SwiftUI

// MARK: - Conditional Presentation Modifier

/// CustomHeightSheet が必要な場合のみ適用する内部用 Modifier。
///
/// CustomSheet 型が Never でない場合のみ、カスタム高さシート機能を適用する。
struct CustomHeightSheetModifierIfNeeded<CustomSheet: CustomHeightSheetable>: ViewModifier {
    @Bindable var presenter: CustomHeightSheetPresenter<CustomSheet>
    @Environment(\.self) private var environment

    func body(content: Content) -> some View {
        if CustomSheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
                    .presentationDetents(sheet.detents)
                    .transformEnvironment(\.self) { env in
                        env[customHeightSheetPresenter: CustomHeightSheetPresenterSpecifier<CustomSheet>(context: .navigation)] = presenter
                    }
            }
        } else {
            content
        }
    }
}

// MARK: - Public Custom Height Sheet Presenter Modifier

public extension View {
    /// シート内でカスタム高さシートプレゼンターを有効化するモディファイア
    ///
    /// シート内から別のカスタム高さシートを開く場合に使用する。
    ///
    /// # 使用例
    /// ```swift
    /// struct SettingsSheet: View {
    ///     @Environment(.customHeightSheet(AppCustomSheet.self, context: .sheet)) private var presenter
    ///
    ///     var body: some View {
    ///         Button("Show Filter") {
    ///             presenter.present(.filter)
    ///         }
    ///         .customHeightSheetPresenter(for: AppCustomSheet.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: カスタム高さシートの型
    /// - Returns: カスタム高さシートプレゼンターが有効化されたビュー
    func customHeightSheetPresenter<Sheet: CustomHeightSheetable>(for type: Sheet.Type) -> some View {
        modifier(CustomHeightSheetPresenterModifier<Sheet>())
    }
}

/// シート内でカスタム高さシートプレゼンターを有効化する Modifier
struct CustomHeightSheetPresenterModifier<Sheet: CustomHeightSheetable>: ViewModifier {
    @State private var presenter = CustomHeightSheetPresenter<Sheet>()

    func body(content: Content) -> some View {
        @Bindable var bindablePresenter = presenter

        content
            .environment(\.[customHeightSheetPresenter: CustomHeightSheetPresenterSpecifier<Sheet>(context: .sheet)], presenter)
            .sheet(item: $bindablePresenter.presentedSheet) { sheet in
                sheet.body
                    .presentationDetents(sheet.detents)
                    .transformEnvironment(\.self) { env in
                        env[customHeightSheetPresenter: CustomHeightSheetPresenterSpecifier<Sheet>(context: .sheet)] = presenter
                    }
            }
    }
}
