import SwiftUI

/// SheetPresenter用の環境値アクセスキー。
///
/// `@Environment(.sheet(Sheet.self))` の形式で SheetPresenter にアクセスするために使う。
/// シート内からシートを開く場合は `@Environment(.sheet(Sheet.self, context: .sheet))` を使う。
///
/// # 使用例
/// ```swift
/// // 通常のシート表示
/// struct ContentView: View {
///     @Environment(.sheet(AppSheet.self)) private var sheetPresenter
///
///     var body: some View {
///         Button("Show Sheet") {
///             sheetPresenter.present(.settings)
///         }
///     }
/// }
///
/// // シート内からシートを開く
/// struct SettingsSheet: View {
///     @Environment(.sheet(AppSheet.self, context: .sheet)) private var sheetPresenter
///
///     var body: some View {
///         Button("Show Another Sheet") {
///             sheetPresenter.present(.about)
///         }
///         .sheetPresenter(for: AppSheet.self, context: .sheet)
///     }
/// }
/// ```
public struct SheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: SheetPresenterSpecifier<Sheet>
    fileprivate init(context: PresentationContext = .navigation) {
        self.specifier = SheetPresenterSpecifier<Sheet>(context: context)
    }
}

public extension SheetEnvironmentKey {
    /// SheetPresenter の環境値キーを生成する。
    ///
    /// - Parameters:
    ///   - type: シートの型
    ///   - context: シートのコンテキスト（.navigation または .sheet）。デフォルトは .navigation
    /// - Returns: SheetPresenter用の環境値キー
    static func sheet(_ type: Sheet.Type, context: PresentationContext = .navigation) -> SheetEnvironmentKey<Sheet> {
        SheetEnvironmentKey<Sheet>(context: context)
    }
}

public extension Environment {
    init<Sheet>(_ key: SheetEnvironmentKey<Sheet>) where Value == SheetPresenter<Sheet>, Sheet: Identifiable & Hashable {
        self.init(\.[sheetPresenter: key.specifier])
    }
}
