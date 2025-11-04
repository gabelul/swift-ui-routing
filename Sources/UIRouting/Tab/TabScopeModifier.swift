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

/// TabView を直接構築する便利な関数
///
/// # 使用例
/// ```swift
/// @State private var tabPresenter = TabPresenter(initialTab: AppTab.todoList)
///
/// var body: some View {
///     TabRouting(tabPresenter: tabPresenter, tabs: [.todoList, .settings])
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
