import SwiftUI

/// シート表示可能な型を表すプロトコル
///
/// `Sheetable`に準拠した型は、`SheetPresenter`による型安全なシート管理に使用できます。
/// `Identifiable`と`Hashable`の実装は自動的に提供されます。
///
/// # 使用例
/// ```swift
/// enum AppSheet: Sheetable {
///     case filter
///     case addTodo
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
///
/// # 注意
/// - `id`プロパティの実装は不要です（自動生成されます）
/// - `Hashable`の実装も不要です（自動提供されます）
@MainActor
public protocol Sheetable: Identifiable, Hashable {
    associatedtype Body: View

    /// シートの内容ビュー
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementations
public extension Sheetable where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Sheetable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
