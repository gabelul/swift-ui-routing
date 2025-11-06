import SwiftUI

/// CustomHeightSheetPresenter用の環境値アクセスキー。
///
/// `@Environment(.customHeightSheet(CustomSheet.self))` の形式で CustomHeightSheetPresenter にアクセスするために使用します。
/// シート内からカスタム高さシートを開く場合は `@Environment(.customHeightSheet(CustomSheet.self, context: .sheet))` を使用します。
///
/// # 使用例
/// ```swift
/// // 通常のカスタム高さシート表示
/// struct ContentView: View {
///     @Environment(.customHeightSheet(AppCustomSheet.self)) private var presenter
///
///     var body: some View {
///         Button("Show Custom Sheet") {
///             presenter?.present(.filter)
///         }
///     }
/// }
///
/// // シート内からカスタム高さシートを開く
/// struct SettingsSheet: View {
///     @Environment(.customHeightSheet(AppCustomSheet.self, context: .sheet)) private var presenter
///
///     var body: some View {
///         Button("Show Another Custom Sheet") {
///             presenter?.present(.filter)
///         }
///         .customHeightSheetPresenter(for: AppCustomSheet.self)
///     }
/// }
/// ```
public struct CustomHeightSheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: CustomHeightSheetPresenterSpecifier<Sheet>
    fileprivate init(context: PresentationContext = .navigation) {
        self.specifier = CustomHeightSheetPresenterSpecifier<Sheet>(context: context)
    }
}

public extension CustomHeightSheetEnvironmentKey {
    /// CustomHeightSheetPresenter の環境値キーを生成します。
    ///
    /// - Parameters:
    ///   - type: カスタム高さシートの型
    ///   - context: シートのコンテキスト（.navigation または .sheet）。デフォルトは .navigation
    /// - Returns: CustomHeightSheetPresenter用の環境値キー
    static func customHeightSheet(_ type: Sheet.Type, context: PresentationContext = .navigation) -> CustomHeightSheetEnvironmentKey<Sheet> {
        CustomHeightSheetEnvironmentKey<Sheet>(context: context)
    }
}

public extension Environment {
    init<Sheet>(_ key: CustomHeightSheetEnvironmentKey<Sheet>) where Value == CustomHeightSheetPresenter<Sheet>, Sheet: Identifiable & Hashable {
        self.init(\.[customHeightSheetPresenter: key.specifier])
    }
}
