import SwiftUI

/// TabPresenter と TabView を連携させる ViewModifier
///
/// # 使用例
/// ```swift
/// @State private var tabPresenter = TabPresenter<AppTab>(initialTab: .home)
///
/// ContentView()
///     .tabRouting(
///         tabPresenter: tabPresenter,
///         tabs: [.home, .search, .profile]
///     )
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
                tab.body
                    .tabItem {
                        tab.tabLabel
                    }
                    .tag(tab)
            }
        }
    }
}

/// TabView を直接構築する便利な関数
///
/// TabView の選択状態を管理し、型安全なタブ切り替えを実現します。
///
/// # 使用例
/// ```swift
/// // 1. タブを定義
/// enum AppTab: Tabbable {
///     case home
///     case search
///     case profile
///
///     var id: String { ... }
///
///     @ViewBuilder
///     var body: some View { ... }
///
///     @ViewBuilder
///     var tabLabel: some View { ... }
/// }
///
/// // 2. TabPresenterを作成してTabViewを構築
/// @State private var tabPresenter = TabPresenter<AppTab>(initialTab: .home)
///
/// var body: some View {
///     TabRouting(
///         tabPresenter: tabPresenter,
///         tabs: [.home, .search, .profile]
///     )
/// }
///
/// // 3. 各ビューからタブを切り替え
/// struct HomeView: View {
///     @Environment(.tab(AppTab.self)) private var tabPresenter
///
///     var body: some View {
///         Button("検索タブへ") {
///             tabPresenter.select(.search)
///         }
///     }
/// }
/// ```
public struct TabRouting<Tab: Tabbable>: View {
    @Bindable private var tabPresenter: TabPresenter<Tab>
    private let tabs: [Tab]

    public init(tabPresenter: TabPresenter<Tab>, tabs: [Tab]) {
        self.tabPresenter = tabPresenter
        self.tabs = tabs
    }

    public var body: some View {
        TabView(selection: $tabPresenter.selectedTab) {
            ForEach(tabs) { tab in
                tab.body
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
