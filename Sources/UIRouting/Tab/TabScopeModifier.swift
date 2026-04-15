import SwiftUI

/// A `ViewModifier` that connects a `TabPresenter` with a `TabView` using the iOS 26 declarative `Tab(value:role:)` API.
///
/// Binds `TabPresenter.selectedTab` to the `TabView` and automatically applies
/// routing to each tab.
///
/// Typically used through the `TabRouting` struct.
///
/// # Usage
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

/// A view for easily building tab-based routing with iOS 26 Liquid Glass support.
///
/// Manages tab selection state using a `TabPresenter` and automatically applies
/// routing features (Router, SheetPresenter, etc.) to each tab.
///
/// Because it is built on the iOS 26 declarative `SwiftUI.Tab(value:role:)` API,
/// Liquid Glass modifiers such as `.tabViewBottomAccessory`,
/// `.tabBarMinimizeBehavior(_:)`, `.tabViewStyle(.sidebarAdaptable)`,
/// `TabSection`, and `.badge(_:)` can be chained directly onto `TabRouting(...)` at the call site.
///
/// # Usage (flat 4-tab layout)
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
/// # Usage (customising each tab's content with a content builder)
/// ```swift
/// TabRouting(tabPresenter: tabPresenter, tabs: AppTab.allCases) { tab in
///     switch tab {
///     case .home: HomeView().environment(\.navigationTheme, .light)
///     default:    tab.contentView
///     }
/// }
/// ```
///
/// Routing configuration (Router / SheetPresenter / AlertPresenter / NavigationStack) is
/// automatically injected inside the content builder, so the call site only needs to
/// handle view composition.
public struct TabRouting<Tab: Tabbable, Content: View>: View {
    @Bindable private var tabPresenter: TabPresenter<Tab>
    private let tabs: [Tab]
    private let content: (Tab) -> Content

    /// Initialises the tab routing.
    ///
    /// - Parameters:
    ///   - tabPresenter: The `TabPresenter` that manages tab selection state.
    ///   - tabs: The array of tabs to display.
    ///   - content: A builder that generates the content for each tab. `.tabRouting(tab:)` is
    ///     automatically applied internally, so Router / Sheet / Alert configuration is not
    ///     needed at the call site.
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
    /// A convenience initialiser that renders each tab's content using `tab.contentView`.
    ///
    /// This is a shortcut for the common case where `Tabbable.contentView` is used as-is.
    init(
        tabPresenter: TabPresenter<Tab>,
        tabs: [Tab]
    ) where Content == Tab.ContentView {
        self.tabPresenter = tabPresenter
        self.tabs = tabs
        self.content = { $0.contentView }
    }
}
