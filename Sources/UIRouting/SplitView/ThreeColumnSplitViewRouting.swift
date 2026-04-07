import SwiftUI

/// A routing system for a three-column `NavigationSplitView`.
///
/// It manages selection state and navigation across a three-column layout:
/// Sidebar | Content (center) | Detail (right).
///
/// # Features
/// - **Sidebar selection**: `SplitViewPresenter.selectedSidebar`
/// - **Content selection**: `SplitViewPresenter.selectedContent` (list selection in the center column)
/// - **In-content navigation**: `ContentRoute` (push navigation within the center column)
/// - **In-detail navigation**: `DetailRoute` (push navigation within the right column)
///
/// # Example
/// ```swift
/// @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)
///
/// ThreeColumnSplitViewRouting(
///     splitViewPresenter: splitViewPresenter,
///     items: [.inbox, .sent, .archive, .starred]
/// )
/// ```
///
/// # Example with a sidebar toolbar
/// ```swift
/// ThreeColumnSplitViewRouting(
///     splitViewPresenter: splitViewPresenter,
///     sidebarTitle: "Sessions",
///     items: sessions,
///     contentPlaceholder: { Text("Please select an item") },
///     detailPlaceholder: { Text("Detail") }
/// ) {
///     ToolbarItem(placement: .primaryAction) {
///         Button { } label: { Image(systemName: "plus") }
///     }
/// }
/// ```
///
/// # SidebarItem definition example
/// ```swift
/// enum MailSidebar: SidebarItem {
///     case inbox, sent, archive, starred
///
///     // Type definitions required for three-column routing
///     typealias ContentItem = Email              // item selected in the center column
///     typealias ContentRoute = MailContentRoute  // navigation within the center column
///     typealias DetailRoute = MailRoute          // navigation within the right column
///     typealias Sheet = MailSheet
///     typealias Alert = MailAlert
///
///     var label: some View { /* sidebar label */ }
///     var contentView: some View { MailListView(sidebarItem: self) }  // center column
///     var detail: some View { MailDetailWrapperView() }               // right column
/// }
/// ```
///
/// # Routing hierarchy
/// 1. **Switch sidebar**: `.inbox` → `.sent`, etc.
/// 2. **Select content**: Tap an item → shown in detail
/// 3. **Navigate within content**: Push to filters/search (ContentRoute)
/// 4. **Navigate within detail**: Push to sender/attachments (DetailRoute)
public struct ThreeColumnSplitViewRouting<
    Sidebar: SidebarItem,
    ContentPlaceholder: View,
    DetailPlaceholder: View,
    SidebarToolbar: ToolbarContent
>: View {
    @Bindable private var splitViewPresenter: SplitViewPresenter<Sidebar>
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var contentRouter = Router<Sidebar.ContentRoute>()
    @State private var detailRouter = Router<Sidebar.DetailRoute>()
    private let sidebarTitle: String
    private let sidebarItems: [Sidebar]
    private let contentPlaceholder: ContentPlaceholder
    private let detailPlaceholder: DetailPlaceholder
    private let sidebarToolbar: SidebarToolbar
    private let onDelete: ((Sidebar) -> Void)?

    /// Creates a three-column split view routing container.
    ///
    /// - Parameters:
    ///   - splitViewPresenter: Presenter that manages sidebar/content selection state
    ///   - sidebarTitle: Sidebar navigation title. Defaults to "Sidebar".
    ///   - items: Items shown in the sidebar
    ///   - contentPlaceholder: Placeholder shown when no sidebar item is selected
    ///   - detailPlaceholder: Placeholder shown when no content item is selected
    ///   - sidebarToolbar: Toolbar content shown in the sidebar navigation bar
    ///   - onDelete: Callback for deleting a sidebar item. If nil, swipe-to-delete is disabled.
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "Sidebar",
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder,
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder,
        @ToolbarContentBuilder sidebarToolbar: () -> SidebarToolbar,
        onDelete: ((Sidebar) -> Void)? = nil
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarTitle = sidebarTitle
        self.sidebarItems = items
        self.contentPlaceholder = contentPlaceholder()
        self.detailPlaceholder = detailPlaceholder()
        self.sidebarToolbar = sidebarToolbar()
        self.onDelete = onDelete
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar
            List(sidebarItems, selection: $splitViewPresenter.selectedSidebar) { item in
                NavigationLink(value: item) {
                    item.label
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if let onDelete {
                        Button(role: .destructive) {
                            if splitViewPresenter.selectedSidebar == item {
                                splitViewPresenter.selectedSidebar = nil
                            }
                            onDelete(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle(sidebarTitle)
            .toolbar { sidebarToolbar }
            .navigationSplitViewColumnWidth(min: 200, ideal: 240, max: 300)
        } content: {
            // Content (e.g. mail list)
            Group {
                if let selected = splitViewPresenter.selectedSidebar {
                    if Sidebar.ContentRoute.self != Never.self {
                        // Wrap in a NavigationStack if ContentRoute exists
                        NavigationStack(path: $contentRouter.path) {
                            selected.contentView
                                .threeColumnContentRouting(for: Sidebar.self)
                                .navigationDestination(for: Sidebar.ContentRoute.self) { route in
                                    route.body
                                        .threeColumnContentRouting(for: Sidebar.self)
                                }
                        }
                        .transformEnvironment(\.self) { environment in
                            environment[router: RouterSpecifier<Sidebar.ContentRoute>()] = contentRouter
                            environment[selectedContentBinding: SelectedContentBindingSpecifier<Sidebar.ContentItem>()] = $splitViewPresenter.selectedContent
                        }
                    } else {
                        // Render directly if there is no ContentRoute
                        selected.contentView
                            .threeColumnContentRouting(for: Sidebar.self)
                            .transformEnvironment(\.self) { environment in
                                environment[selectedContentBinding: SelectedContentBindingSpecifier<Sidebar.ContentItem>()] = $splitViewPresenter.selectedContent
                            }
                    }
                } else {
                    // Placeholder when nothing is selected in the sidebar
                    contentPlaceholder
                }
            }
            .navigationSplitViewColumnWidth(min: 400, ideal: 560, max: 720)
        } detail: {
            // Detail
            Group {
                if let selected = splitViewPresenter.selectedSidebar {
                    if Sidebar.DetailRoute.self != Never.self {
                        // Wrap in a NavigationStack if DetailRoute exists
                        NavigationStack(path: $detailRouter.path) {
                            selected.detail
                                .threeColumnDetailRouting(for: Sidebar.self)
                                .navigationDestination(for: Sidebar.DetailRoute.self) { route in
                                    route.body
                                        .threeColumnDetailRouting(for: Sidebar.self)
                                }
                        }
                        .transformEnvironment(\.self) { environment in
                            environment[router: RouterSpecifier<Sidebar.DetailRoute>()] = detailRouter
                        }
                    } else {
                        // Render directly if there is no DetailRoute
                        selected.detail
                            .threeColumnDetailRouting(for: Sidebar.self)
                    }
                } else {
                    // Placeholder when no content item is selected
                    detailPlaceholder
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 260, max: 320)
        }
        .navigationSplitViewStyle(.balanced)
        .transformEnvironment(\.self) { environment in
            environment[splitViewPresenter: SplitViewPresenterSpecifier<Sidebar>()] = splitViewPresenter
        }
    }
}

// MARK: - Empty Sidebar Toolbar

/// A marker type representing “no sidebar toolbar”.
///
/// Used as the default type when the toolbar parameter is omitted.
public struct EmptySidebarToolbar: ToolbarContent {
    public var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            EmptyView()
        }
    }
}

// MARK: - Convenience Initializers (Without Toolbar)

extension ThreeColumnSplitViewRouting where SidebarToolbar == EmptySidebarToolbar {
    /// Creates a three-column split view routing container without a toolbar.
    ///
    /// - Parameters:
    ///   - splitViewPresenter: Presenter that manages sidebar/content selection state
    ///   - sidebarTitle: Sidebar navigation title. Defaults to "Sidebar".
    ///   - items: Items shown in the sidebar
    ///   - contentPlaceholder: Placeholder shown when no sidebar item is selected
    ///   - detailPlaceholder: Placeholder shown when no content item is selected
    ///   - onDelete: Callback for deleting a sidebar item. If nil, swipe-to-delete is disabled.
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "Sidebar",
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder,
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder,
        onDelete: ((Sidebar) -> Void)? = nil
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarTitle = sidebarTitle
        self.sidebarItems = items
        self.contentPlaceholder = contentPlaceholder()
        self.detailPlaceholder = detailPlaceholder()
        self.sidebarToolbar = EmptySidebarToolbar()
        self.onDelete = onDelete
    }
}

extension ThreeColumnSplitViewRouting where ContentPlaceholder == Text, DetailPlaceholder == Text, SidebarToolbar == EmptySidebarToolbar {
    /// Convenience initializer that uses default placeholder text.
    ///
    /// - Parameters:
    ///   - splitViewPresenter: Presenter that manages sidebar/content selection state
    ///   - sidebarTitle: Sidebar navigation title. Defaults to "Sidebar".
    ///   - items: Items shown in the sidebar
    ///   - onDelete: Callback for deleting a sidebar item. If nil, swipe-to-delete is disabled.
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "Sidebar",
        items: [Sidebar],
        onDelete: ((Sidebar) -> Void)? = nil
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarTitle = sidebarTitle
        self.sidebarItems = items
        self.contentPlaceholder = Text("Please select an item from the sidebar")
        self.detailPlaceholder = Text("Please select an item")
        self.sidebarToolbar = EmptySidebarToolbar()
        self.onDelete = onDelete
    }
}

extension ThreeColumnSplitViewRouting where ContentPlaceholder == Text, SidebarToolbar == EmptySidebarToolbar {
    /// Convenience initializer that uses default content placeholder text.
    ///
    /// - Parameters:
    ///   - splitViewPresenter: Presenter that manages sidebar/content selection state
    ///   - sidebarTitle: Sidebar navigation title. Defaults to "Sidebar".
    ///   - items: Items shown in the sidebar
    ///   - detailPlaceholder: Placeholder shown when no content item is selected
    ///   - onDelete: Callback for deleting a sidebar item. If nil, swipe-to-delete is disabled.
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "Sidebar",
        items: [Sidebar],
        @ViewBuilder detailPlaceholder: () -> DetailPlaceholder,
        onDelete: ((Sidebar) -> Void)? = nil
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarTitle = sidebarTitle
        self.sidebarItems = items
        self.contentPlaceholder = Text("Please select an item from the sidebar")
        self.detailPlaceholder = detailPlaceholder()
        self.sidebarToolbar = EmptySidebarToolbar()
        self.onDelete = onDelete
    }
}

extension ThreeColumnSplitViewRouting where DetailPlaceholder == Text, SidebarToolbar == EmptySidebarToolbar {
    /// Convenience initializer that uses default detail placeholder text.
    ///
    /// - Parameters:
    ///   - splitViewPresenter: Presenter that manages sidebar/content selection state
    ///   - sidebarTitle: Sidebar navigation title. Defaults to "Sidebar".
    ///   - items: Items shown in the sidebar
    ///   - contentPlaceholder: Placeholder shown when no sidebar item is selected
    ///   - onDelete: Callback for deleting a sidebar item. If nil, swipe-to-delete is disabled.
    public init(
        splitViewPresenter: SplitViewPresenter<Sidebar>,
        sidebarTitle: String = "Sidebar",
        items: [Sidebar],
        @ViewBuilder contentPlaceholder: () -> ContentPlaceholder,
        onDelete: ((Sidebar) -> Void)? = nil
    ) {
        self.splitViewPresenter = splitViewPresenter
        self.sidebarTitle = sidebarTitle
        self.sidebarItems = items
        self.contentPlaceholder = contentPlaceholder()
        self.detailPlaceholder = Text("Please select an item")
        self.sidebarToolbar = EmptySidebarToolbar()
        self.onDelete = onDelete
    }
}
