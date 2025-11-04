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

/// アラートのアクションボタンを表す構造体。
///
/// アラートダイアログに表示するボタンの情報を保持します。
/// タイトル、役割（キャンセル、破壊的操作など）、実行するアクションを指定できます。
///
/// # 使用例
/// ```swift
/// // 通常のボタン
/// AlertAction(title: "OK") { print("OK tapped") }
///
/// // キャンセルボタン
/// AlertAction(title: "キャンセル", role: .cancel) {}
///
/// // 破壊的操作ボタン
/// AlertAction(title: "削除", role: .destructive) {
///     deleteItem()
/// }
/// ```
public struct AlertAction: Hashable {
    /// ボタンのタイトル
    public let title: String

    /// ボタンの役割（.cancel、.destructive など）
    public let role: ButtonRole?

    /// ボタンがタップされたときに実行されるアクション
    public let action: () -> Void

    /// アラートアクションを初期化します。
    ///
    /// - Parameters:
    ///   - title: ボタンのタイトル
    ///   - role: ボタンの役割（省略可）
    ///   - action: ボタンがタップされたときに実行されるクロージャ
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
