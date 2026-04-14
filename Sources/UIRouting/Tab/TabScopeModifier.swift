import SwiftUI

/// TabPresenter と TabView を連携させる ViewModifier（iOS 26 宣言型 `Tab(value:role:)` API）。
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
                SwiftUI.Tab(value: tab, role: tab.tabRole) {
                    tab.contentView
                        .tabRouting(tab: tab)
                } label: {
                    tab.tabLabel
                }
            }
        }
    }
}

/// タブベースのルーティングを簡単に構築するためのビュー（iOS 26 Liquid Glass 対応）。
///
/// TabPresenter を使用してタブの選択状態を管理し、
/// 各タブに自動的にルーティング機能（Router、SheetPresenter など）を適用します。
///
/// 内部では iOS 26 宣言型 `SwiftUI.Tab(value:role:)` API を使用して構築するため、
/// `.tabViewBottomAccessory` / `.tabBarMinimizeBehavior(_:)` / `.tabViewStyle(.sidebarAdaptable)` /
/// `TabSection` / `.badge(_:)` などの Liquid Glass 系モディファイアを
/// そのまま呼び出し側で `TabRouting(...)` にチェーンできます。
///
/// # 使用例（フラットな 4 タブ）
/// ```swift
/// struct ContentView: View {
///     @State private var tabPresenter = TabPresenter(initialTab: AppTab.home)
///
///     var body: some View {
///         TabRouting(tabPresenter: tabPresenter, tabs: [.home, .library, .insights, .me])
///             .tabBarMinimizeBehavior(.onScrollDown)
///             .tabViewBottomAccessory {
///                 InterventionAccessoryBar()
///             }
///     }
/// }
/// ```
///
/// # 使用例（content ビルダーで各タブの描画をカスタマイズ）
/// ```swift
/// TabRouting(tabPresenter: tabPresenter, tabs: AppTab.allCases) { tab in
///     switch tab {
///     case .home: HomeView().environment(\.navigationTheme, .light)
///     default:    tab.contentView
///     }
/// }
/// ```
///
/// ルーティング設定 (Router / SheetPresenter / AlertPresenter / NavigationStack) は
/// content ビルダー内部で自動付与されるため、呼び出し側は純粋にビュー組み立てだけを記述できます。
public struct TabRouting<Tab: Tabbable, Content: View>: View {
    @Bindable private var tabPresenter: TabPresenter<Tab>
    private let tabs: [Tab]
    private let content: (Tab) -> Content

    /// タブルーティングを初期化します。
    ///
    /// - Parameters:
    ///   - tabPresenter: タブの選択状態を管理する TabPresenter
    ///   - tabs: 表示するタブの配列
    ///   - content: 各タブのコンテンツを生成するビルダー。内部で `.tabRouting(tab:)` が
    ///     自動適用されるため、Router / Sheet / Alert の設定は呼び出し側で記述不要。
    public init(
        tabPresenter: TabPresenter<Tab>,
        tabs: [Tab],
        @ViewBuilder content: @escaping (Tab) -> Content
    ) {
        self.tabPresenter = tabPresenter
        self.tabs = tabs
        self.content = content
    }

    public var body: some View {
        TabView(selection: $tabPresenter.selectedTab) {
            ForEach(tabs) { tab in
                SwiftUI.Tab(value: tab, role: tab.tabRole) {
                    content(tab)
                        .tabRouting(tab: tab)
                } label: {
                    tab.tabLabel
                }
            }
        }
        .transformEnvironment(\.self) { environment in
            environment[tabPresenter: TabPresenterSpecifier<Tab>()] = tabPresenter
        }
    }
}

// MARK: - Convenience init (default content: tab.contentView)

public extension TabRouting {
    /// 各タブのコンテンツを `tab.contentView` で描画する簡易イニシャライザ。
    ///
    /// `Tabbable.contentView` をそのまま使う典型ケース向けのショートカットです。
    init(
        tabPresenter: TabPresenter<Tab>,
        tabs: [Tab]
    ) where Content == Tab.ContentView {
        self.tabPresenter = tabPresenter
        self.tabs = tabs
        self.content = { $0.contentView }
    }
}
