import SwiftUI

extension View {
    /// スプリットビューの詳細ビューにルーティング設定を自動適用します。
    ///
    /// SidebarItem の型から自動的にルーティング型を推論して適用します。
    /// Router、SheetPresenter、AlertPresenter などが内部で自動生成されます。
    ///
    /// # 使用例
    /// ```swift
    /// enum MailSidebar: SidebarItem {
    ///     case inbox
    ///
    ///     typealias DetailRoute = MailRoute
    ///     typealias Sheet = MailSheet
    ///     typealias Alert = MailAlert
    ///
    ///     var detail: some View {
    ///         InboxView()
    ///             .splitViewRouting(for: MailSidebar.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: SidebarItem の型
    /// - Returns: ルーティング機能が自動適用されたビュー
    public func splitViewRouting<Sidebar>(for type: Sidebar.Type) -> some View where Sidebar: SidebarItem {
        modifier(
            SplitViewRoutingModifier<
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
