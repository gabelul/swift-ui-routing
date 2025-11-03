import SwiftUI

/// アラートダイアログを表すプロトコル。
///
/// `Alertable` に準拠した型は、型安全なアラート表示に使用できます。
///
/// # 使用例
/// ```swift
/// enum Alert: Alertable {
///     case delete(itemName: String, onConfirm: () -> Void)
///     case error(message: String)
///     case confirm(title: String, message: String, onConfirm: () -> Void)
///
///     var title: String {
///         switch self {
///         case .delete: return "削除の確認"
///         case .error: return "エラー"
///         case .confirm(let title, _, _): return title
///         }
///     }
///
///     var message: String? {
///         switch self {
///         case .delete(let itemName, _):
///             return "\(itemName)を削除してもよろしいですか？"
///         case .error(let msg):
///             return msg
///         case .confirm(_, let message, _):
///             return message
///         }
///     }
///
///     var actions: [AlertAction] {
///         switch self {
///         case .delete(_, let onConfirm):
///             return [
///                 AlertAction(title: "キャンセル", role: .cancel) {},
///                 AlertAction(title: "削除", role: .destructive, action: onConfirm)
///             ]
///         case .error:
///             return [AlertAction(title: "OK") {}]
///         case .confirm(_, _, let onConfirm):
///             return [
///                 AlertAction(title: "キャンセル", role: .cancel) {},
///                 AlertAction(title: "OK", action: onConfirm)
///             ]
///         }
///     }
/// }
/// ```
@MainActor
public protocol Alertable: Hashable {
    /// アラートのタイトル
    var title: String { get }

    /// アラートの詳細メッセージ
    var message: String? { get }

    /// アラートのアクションボタン
    var actions: [AlertAction] { get }
}

/// アラートのアクションボタン
public struct AlertAction: Hashable {
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void

    public init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }

    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
