import SwiftUI

/// NavigationSplitView のサイドバー項目を表すプロトコル。
///
/// `SidebarItem` に準拠した型は、NavigationSplitView による型安全なサイドバー選択に使用できます。
/// `Identifiable`と`Hashable`の実装は自動的に提供されます。
///
/// # 使用例（2カラム）
/// ```swift
/// enum AppSidebar: SidebarItem {
///     case inbox
///     case sent
///     case archive
///
///     typealias DetailRoute = MailRoute
///
///     var label: some View {
///         switch self {
///         case .inbox:
///             Label("受信箱", systemImage: "tray")
///         case .sent:
///             Label("送信済み", systemImage: "paperplane")
///         case .archive:
///             Label("アーカイブ", systemImage: "archivebox")
///         }
///     }
///
///     var detail: some View {
///         switch self {
///         case .inbox:
///             InboxView()
///         case .sent:
///             SentView()
///         case .archive:
///             ArchiveView()
///         }
///     }
/// }
/// ```
///
/// # 注意
/// - `id`プロパティの実装は不要です（自動生成されます）
/// - `Hashable`の実装も不要です（自動提供されます）
/// - `ContentItem`と`ContentRoute`は3カラム対応用の拡張ポイントです（将来使用）
@MainActor
public protocol SidebarItem: Hashable, Identifiable {
    // View 関連
    associatedtype LabelView: View
    associatedtype Detail: View

    // ルーティング型
    associatedtype DetailRoute: Routable = Never
    associatedtype Sheet: Sheetable = Never
    associatedtype Alert: Alertable = Never
    associatedtype FullScreen: FullScreenCoverable = Never
    associatedtype CustomSheet: CustomHeightSheetable = Never

    // 3カラム用の拡張ポイント
    associatedtype ContentItem: Selectable = Never
    associatedtype ContentRoute: Routable = Never
    associatedtype ContentView: View = EmptyView

    /// サイドバーに表示されるラベル
    @ViewBuilder var label: LabelView { get }

    /// このサイドバー項目が選択されたときに表示される詳細ビュー
    @ViewBuilder var detail: Detail { get }

    /// 3カラムレイアウトのコンテンツビュー（中央カラム）
    @ViewBuilder var contentView: ContentView { get }
}

// MARK: - Default Implementations

/// ContentItem が Never の場合のデフォルト実装（2カラム用）
public extension SidebarItem where ContentItem == Never {
    var contentView: some View { EmptyView() }
}

/// ID が Int の場合の自動実装
public extension SidebarItem where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

/// ID が String の場合の自動実装
public extension SidebarItem where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Selectable Protocol

/// 選択可能なアイテムを表す基底プロトコル（3カラム用）
///
/// 3カラムレイアウトのコンテンツ項目として使用されます。
@MainActor
public protocol Selectable: Hashable, Identifiable {
    associatedtype LabelView: View

    @ViewBuilder var label: LabelView { get }
}

/// ID が Int の場合の自動実装
public extension Selectable where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

/// ID が String の場合の自動実装
public extension Selectable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
