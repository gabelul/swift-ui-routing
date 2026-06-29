import SwiftUI

/// TabPresenter用の環境値アクセスキー。
///
/// `@Environment(.tab(AppTab.self))` の形式で TabPresenter にアクセスするために使う。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @Environment(.tab(AppTab.self)) private var tabPresenter
///
///     var body: some View {
///         Button("Switch Tab") {
///             tabPresenter.select(.settings)
///         }
///     }
/// }
/// ```
public struct TabEnvironmentKey<Tab: Tabbable> {
    fileprivate let specifier: TabPresenterSpecifier<Tab>
    fileprivate init() {
        self.specifier = TabPresenterSpecifier<Tab>()
    }
}

public extension TabEnvironmentKey {
    /// TabPresenter の環境値キーを生成する。
    ///
    /// - Parameter type: タブの型
    /// - Returns: TabPresenter用の環境値キー
    static func tab(_ type: Tab.Type) -> TabEnvironmentKey<Tab> {
        TabEnvironmentKey<Tab>()
    }
}

public extension Environment {
    init<Tab: Tabbable>(_ key: TabEnvironmentKey<Tab>) where Value == TabPresenter<Tab> {
        self.init(\.[tabPresenter: key.specifier])
    }
}
