import SwiftUI

extension View {
    /// 3カラムスプリットビューのコンテンツビューにルーティング設定を自動適用します。
    ///
    /// SidebarItem の型から自動的にルーティング型を推論して適用します。
    /// Router、SheetPresenter、AlertPresenter などが内部で自動生成されます。
    ///
    /// # 使用例
    /// ```swift
    /// enum MailSidebar: SidebarItem {
    ///     case inbox
    ///
    ///     typealias ContentItem = Email
    ///     typealias ContentRoute = Never
    ///     typealias Sheet = MailSheet
    ///     typealias Alert = MailAlert
    ///
    ///     var contentView: some View {
    ///         MailListView()
    ///             .threeColumnContentRouting(for: MailSidebar.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: SidebarItem の型
    /// - Returns: ルーティング機能が自動適用されたビュー
    public func threeColumnContentRouting<Sidebar>(for type: Sidebar.Type) -> some View where Sidebar: SidebarItem {
        modifier(
            ThreeColumnContentRoutingModifier<
                Sidebar,
                Sidebar.ContentRoute,
                Sidebar.Sheet,
                Sidebar.Alert,
                Sidebar.FullScreen,
                Sidebar.CustomSheet
            >()
        )
    }

    /// 3カラムスプリットビューの詳細ビューにルーティング設定を自動適用します。
    ///
    /// SidebarItem の型から自動的にルーティング型を推論して適用します。
    /// Router、SheetPresenter、AlertPresenter などが内部で自動生成されます。
    ///
    /// # 使用例
    /// ```swift
    /// enum MailSidebar: SidebarItem {
    ///     case inbox
    ///
    ///     typealias ContentItem = Email
    ///     typealias DetailRoute = MailRoute
    ///     typealias Sheet = MailSheet
    ///     typealias Alert = MailAlert
    ///
    ///     var detail: some View {
    ///         EmailDetailView()
    ///             .threeColumnDetailRouting(for: MailSidebar.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: SidebarItem の型
    /// - Returns: ルーティング機能が自動適用されたビュー
    public func threeColumnDetailRouting<Sidebar>(for type: Sidebar.Type) -> some View where Sidebar: SidebarItem {
        modifier(
            ThreeColumnDetailRoutingModifier<
                Sidebar,
                Sidebar.DetailRoute,
                Sidebar.Sheet,
                Sidebar.Alert,
                Sidebar.FullScreen,
                Sidebar.CustomSheet
            >()
        )
    }
}
