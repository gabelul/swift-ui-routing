import SwiftUI

/// A protocol that defines a tab.
///
/// Types conforming to `Tabbable` can be used for type-safe tab management with TabView.
/// Implementations of `Identifiable` and `Hashable` are automatically provided.
///
/// # Usage
/// ```swift
/// enum AppTab: Tabbable {
///     case home
///     case settings
///
///     typealias Route = AppRoute
///     typealias Sheet = AppSheet
///     typealias Alert = AppAlert
///
///     var contentView: some View {
///         switch self {
///         case .home:
///             HomeView()
///         case .settings:
///             SettingsView()
///         }
///     }
///
///     var tabLabel: some View {
///         switch self {
///         case .home:
///             Label("Home", systemImage: "house")
///         case .settings:
///             Label("Settings", systemImage: "gearshape")
///         }
///     }
/// }
/// ```
///
/// # Notes
/// - You do not need to implement the `id` property (it is auto-generated)
/// - You do not need to implement `Hashable` (it is automatically provided)
/// - If routing is not required, type declarations can be omitted (defaults to `Never`)
@MainActor
public protocol Tabbable<Route>: Hashable, Identifiable {
    // View types
    associatedtype ContentView: View
    associatedtype TabLabel: View

    // Routing types (Primary Associated Types - defaults to Never)
    associatedtype Route: Routable = Never
    associatedtype Sheet: Sheetable = Never
    associatedtype Alert: Alertable = Never
    associatedtype FullScreen: FullScreenCoverable = Never
    associatedtype CustomSheet: CustomHeightSheetable = Never

    /// The content view for this tab.
    @ViewBuilder var contentView: ContentView { get }

    /// The label for this tab item.
    @ViewBuilder var tabLabel: TabLabel { get }

    /// The tab role for iOS 26 Liquid Glass (e.g. `.search`).
    ///
    /// Defaults to `nil` (standard tab). Returning `.search` for a search-dedicated tab
    /// causes the system to automatically apply role-specific UI behaviour — pinning the
    /// search tab, optimising the Liquid Glass effect, and classifying the tab's role when
    /// adapting to a sidebar layout.
    var tabRole: TabRole? { get }
}

// MARK: - Default Implementations
public extension Tabbable where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Tabbable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - tabRole default

public extension Tabbable {
    /// Defaults to a standard tab (no role). Override to return `.search` for a search tab only.
    var tabRole: TabRole? { nil }
}
