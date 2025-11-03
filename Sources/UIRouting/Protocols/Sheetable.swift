import SwiftUI

/// シート表示可能な型を表すプロトコル
///
/// `Sheetable`に準拠した型は、`SheetPresenter`による型安全なシート管理に使用できます。
///
/// # 使用例
/// ```swift
/// enum AppSheet: Sheetable {
///     case filter
///     case addTodo
///
///     var id: String {
///         switch self {
///         case .filter: return "filter"
///         case .addTodo: return "addTodo"
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .filter:
///             FilterSheet()
///         case .addTodo:
///             AddTodoSheet()
///         }
///     }
/// }
/// ```
@MainActor
public protocol Sheetable: Identifiable, Hashable {
    associatedtype Body: View

    /// シートの内容ビュー
    @ViewBuilder var body: Body { get }
}
