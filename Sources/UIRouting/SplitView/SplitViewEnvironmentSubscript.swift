import SwiftUI

extension EnvironmentValues {
    subscript<Sidebar: SidebarItem>(splitViewPresenter specifier: SplitViewPresenterSpecifier<Sidebar>) -> SplitViewPresenter<Sidebar> {
        get { self[GenericSplitViewPresenterKey<Sidebar>.self] }
        set { self[GenericSplitViewPresenterKey<Sidebar>.self] = newValue }
    }

    subscript<ContentItem: Selectable>(selectedContentBinding specifier: SelectedContentBindingSpecifier<ContentItem>) -> Binding<ContentItem?>? {
        get { self[GenericSelectedContentBindingKey<ContentItem>.self] }
        set { self[GenericSelectedContentBindingKey<ContentItem>.self] = newValue }
    }
}
