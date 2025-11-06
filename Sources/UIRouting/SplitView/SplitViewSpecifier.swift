import SwiftUI

// MARK: - SplitViewPresenter Specifier

struct SplitViewPresenterSpecifier<Sidebar: SidebarItem>: Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Sidebar.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

// MARK: - SelectedContentBinding Specifier

struct SelectedContentBindingSpecifier<ContentItem: Selectable>: Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(ContentItem.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
