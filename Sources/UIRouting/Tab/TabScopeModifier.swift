import SwiftUI

/// TabPresenter と TabView を連携させる ViewModifier。
///
/// TabPresenter の selectedTab を TabView にバインドし、
/// 各タブに自動的にルーティング機能を適用します。
///
/// 通常は `TabRouting` 構造体を通じて使用します。
///
/// # 使用例
/// ```swift
/// @State private var tabPresenter = TabPresenter(initialTab: AppTab.home)
///
/// var body: some View {
///     TabRouting(tabPresenter: tabPresenter, tabs: [.home, .search, .profile])
/// }
/// ```
public struct TabScopeModifier<Tab: Tabbable>: ViewModifier {
    @Environment private var tabPresenter: TabPresenter<Tab>
    private let tabs: [Tab]

    public init(tabs: [Tab]) {
        self.tabs = tabs
        self._tabPresenter = Environment(.tab(Tab.self))
    }

    public func body(content: Content) -> some View {
        @Bindable var binding = tabPresenter

        TabView(selection: $binding.selectedTab) {
            ForEach(tabs) { tab in
                tab.contentView
                    .tabRouting(tab: tab)
                    .tabItem {
                        tab.tabLabel
                    }
                    .tag(tab)
            }
        }
    }
}

/// タブベースのルーティングを簡単に構築するためのビュー。
///
/// TabPresenter を使用してタブの選択状態を管理し、
/// 各タブに自動的にルーティング機能（Router、SheetPresenter など）を適用します。
///
/// # 使用例
/// ```swift
/// struct ContentView: View {
///     @State private var tabPresenter = TabPresenter(initialTab: AppTab.home)
///
///     var body: some View {
///         TabRouting(tabPresenter: tabPresenter, tabs: [.home, .search, .settings])
///     }
/// }
///
/// struct HomeTab: Tabbable {
///     typealias Route = AppRoute
///     typealias Sheet = AppSheet
///     typealias Alert = AppAlert
///
///     let id = "home"
///
///     var contentView: some View {
///         HomeView()
///     }
///
///     var tabLabel: some View {
///         Label("ホーム", systemImage: "house")
///     }
/// }
/// ```
public struct TabRouting<Tab: Tabbable>: View {
    @Bindable private var tabPresenter: TabPresenter<Tab>
    private let tabs: [Tab]

    /// タブルーティングを初期化します。
    ///
    /// - Parameters:
    ///   - tabPresenter: タブの選択状態を管理する TabPresenter
    ///   - tabs: 表示するタブの配列
    public init(tabPresenter: TabPresenter<Tab>, tabs: [Tab]) {
        self.tabPresenter = tabPresenter
        self.tabs = tabs
    }

    public var body: some View {
        TabView(selection: $tabPresenter.selectedTab) {
            ForEach(tabs) { tab in
                tab.contentView
                    .tabRouting(tab: tab)
                    .tabItem {
                        tab.tabLabel
                    }
                    .tag(tab)
            }
        }
        .transformEnvironment(\.self) { environment in
            environment[tabPresenter: TabPresenterSpecifier<Tab>()] = tabPresenter
        }
    }
}
